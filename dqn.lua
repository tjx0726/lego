--[[

DQN LEGO
by Yannis Assael

]]--

-- Configuration
cmd = torch.CmdLine()
cmd:text()
cmd:text('DQN LEGO')
cmd:text()
cmd:text('Options')

-- general options:
cmd:option('-seed', 1, 'initial random seed')
cmd:option('-threads', 4, 'number of threads')

-- gpu
cmd:option('-cuda', true, 'cuda')

-- model
cmd:option('-gamma', 0.99, 'discount factor')
cmd:option('-eps', 0.2, 'epsilon-greedy policy')
cmd:option('-replay_memory', 1e+5, 'experience replay memory')
cmd:option('-action_gap', false, 'increase the action gap')
cmd:option('-action_gap_alpha', 0.9, 'action gap alpha parameter')

-- training
cmd:option('-dim', 128, 'image size')
cmd:option('-bs', 32, 'bitch size')
cmd:option('-nepisodes', 1000, 'number of episodes')
cmd:option('-nsteps', 100, 'number of steps')
-- cmd:option('-target_gamma', 1e-2, 'target network updates')
cmd:option('-target_step', 100, 'target network updates')

cmd:option('-step', 1, 'print every episodes')
cmd:option('-step_test', 10, 'print every episodes')

cmd:option('-plot', false, 'plot q values')

cmd:option('-load', false, 'load pretrained model')
cmd:text()

opt = cmd:parse(arg)

opt.bs = math.min(opt.bs, opt.replay_memory)

-- Requirements
require 'nn'
require 'optim'
local kwargs = require 'include.kwargs'
local log = require 'include.log'
log.level = "info"
local lego = {}

-- Reward
function lego.reward(cur, target)
    local reward = 0
    local terminal = 0
    for i = 1, #target.bricks do
        reward = reward + torch.dist(cur.bricks[i]:get_pos():float(), target.bricks[i]:get_pos():float())
    end
    if reward == 0 then
        terminal = 1
    end
    return -reward / #target.bricks, terminal
end

-- Move
function lego.action(cur, a)
    local brickId = math.floor((a - 1) / (3*4) + 1) -- which of the 12
    local brickXYZ = math.floor(((a - 1) % (3*4)) / 4 + 1) -- which axis 3
    local brickAction = ((a - 1) % (3*4)) % 4 + 1 -- which action 4
    -- print('brickId', brickId)
    -- print('brickXYZ', brickXYZ)
    -- print('brickAction', brickAction)

    local a_t = 0
    if brickAction == 1 then
        a_t = -2
    elseif brickAction == 2 then
        a_t = -1
    elseif brickAction == 3 then
        a_t = 1
    else
        a_t = 2
    end

    local x = 0
    local y = 0
    local z = 0
    if brickXYZ == 1 then
        x = a_t
    elseif brickXYZ == 2 then
        y = a_t
    elseif brickXYZ == 3 then
        z = a_t
    end

    cur.bricks[brickId]:move_pos(x, y, z)
end

-- Target design
lego.target = require('lego')({input='IMAGE100.LXFML', output="out/target.png", dim=opt.dim})
lego.target.bricks[1]:set_pos(5, 0, 0)
lego.target.bricks[2]:set_pos(-5, 0, 0)
lego.target.bricks[3]:set_pos(0, 0, 5)
lego.target.bricks[4]:set_pos(0, 0, -5)
lego.target:save_lxfml('target.lxfml')
lego.target:render('target.lxfml')
lego.target.image_batch = lego.target.image:view(1, 3, opt.dim, opt.dim):expand(opt.bs, 3, opt.dim, opt.dim)

-- Set float as default type
torch.manualSeed(opt.seed)
torch.setnumthreads(opt.threads)
torch.setdefaulttensortype('torch.FloatTensor')

-- Cuda initialisation
if opt.cuda then
    require 'cutorch'
    require 'cunn'
    cutorch.setDevice(1)
	opt.dtype = 'torch.CudaTensor'
    print(cutorch.getDeviceProperties(1))
else
	opt.dtype = 'torch.FloatTensor'
end

-- Initialise game
local a_space = #lego.target.bricks*3*4
-- local env = require 'rlenvs.GridWorld'()
-- local a_space = env:getActionSpec()[3]
-- local r_space = { env:getRewardSpec() }
-- local s_space = env:getStateSpec()

-- Initialise model
local exp = (require 'model') {
    a_size = a_space,
    s_size = opt.dim,
    dtype = opt.dtype
}

local model = exp.model
local model_target = exp.model:clone()
local params, gradParams = model:getParameters()
local params_target, _ = model_target:getParameters()

log.infof('Model params = %d', params:size(1))

-- Initialise criterion
local criterion = nn.MSECriterion():type(opt.dtype)
criterion.sizeAverage = false

-- Optimisation function
local optim_func, optim_config = exp.optim()
local optim_state = {}

-- Initialise aux vectors
local delta_q = torch.Tensor(opt.bs, a_space):type(opt.dtype)

local train_r_episode = torch.zeros(opt.nsteps)
local train_q_episode = torch.zeros(opt.nsteps)

local train_r = 0
local train_r_avg = 0

local train_q = 0
local train_q_avg = 0

local test_r = 0
local test_r_avg = 0
local test_r_all = torch.zeros(opt.nepisodes)

local step_count = 0
local replay = {}

-- Episode and training values storage
local episode = {}

local train = {
    s_t = torch.Tensor(opt.bs, 3, opt.dim, opt.dim):type(opt.dtype),
    s_t1 = torch.Tensor(opt.bs, 3, opt.dim, opt.dim):type(opt.dtype),
    r_t = torch.Tensor(opt.bs):type(opt.dtype),
    a_t = torch.Tensor(opt.bs):type(opt.dtype),
    terminal = torch.Tensor(opt.bs):type(opt.dtype)
}

-- start time
local beginning_time = torch.tic()

for e = 1, opt.nepisodes do

    -- Initial state
    lego.cur = require('lego')({input='IMAGE100.LXFML', output="out/train_0.png", dim=opt.dim})
 	lego.cur:save_lxfml('tmp.lxfml')
    episode.s_t = lego.cur:render('tmp.lxfml', 'out/train_0.png'):clone()
    episode.terminal = 0

    -- Initialise clock
    local time = sys.clock()

    -- Run for N steps
    local step = 1
    while step <= opt.nsteps and episode.terminal == 0 do

        -- Compute Q values
        local q = model:forward(episode.s_t:type(opt.dtype))

        -- Pick an action (epsilon-greedy)
        if torch.uniform() < opt.eps then
            episode.a_t = torch.random(a_space)
        else
            local max_q, max_a = torch.max(q, 2)
            episode.a_t = max_a:squeeze()
        end

        --compute reward for current state-action pair
        lego.action(lego.cur, episode.a_t)
	 	lego.cur:save_lxfml('tmp.lxfml')
	    episode.s_t1 = lego.cur:render('tmp.lxfml', 'out/train_' .. step .. '.png'):clone()
        episode.r_t, episode.terminal = lego.reward(lego.cur, lego.target)

        -- If terminal reward=1
        if episode.terminal == 1 then
            episode.r_t = 1
        end

        -- Store rewards
        train_r_episode[step] = episode.r_t

        -- Store current step
        local r_id = (step_count % opt.replay_memory) + 1
        replay[r_id] = {
            r_t = episode.r_t,
            a_t = episode.a_t,
            s_t = episode.s_t,
            s_t1 = episode.s_t1,
            terminal = episode.terminal and 1 or 0
        }

        -- Fetch from experiences
        local q_next, q_next_max
        if #replay >= opt.bs then

            for b = 1, opt.bs do
                local exp_id = torch.random(#replay)
                train.r_t[b] = replay[exp_id].r_t
                train.a_t[b] = replay[exp_id].a_t
                train.s_t[b] = replay[exp_id].s_t
                train.s_t1[b] = replay[exp_id].s_t1
                train.terminal[b] = replay[exp_id].terminal
            end

            -- Compute Q
            q = model:forward(train.s_t)

            -- Use target network to predict q_max
            q_next = model_target:forward(train.s_t1)
            q_next_max = q_next:max(2):squeeze(2)

            -- Check if terminal state
            for b = 1, opt.bs do
                if train.terminal[b] == 1 then
                    q_next[b] = 0
                    q_next_max[b] = 0
                end
            end

            -- Q learnt value
            delta_q:copy(q)
            for b = 1, opt.bs do
                delta_q[{ { b }, { train.a_t[b] } }] = train.r_t[b] + opt.gamma * q_next_max[b]
            end

            -- Increase the action gap
            if opt.action_gap then
                local q_target = model_target:forward({train.s_t, lego.target.image_batch})
                -- local V_s = q_target:max(2):squeeze()
                -- local V_s_1 = q_next:max(2):squeeze()
                for b = 1, opt.bs do
                    -- Advantage Learning (AL) operator
                    local V_s = q_target[b]:max()
                    local Q_s_a = q_target[b][train.a_t[b]]
                    local AL = - opt.action_gap_alpha * (V_s - Q_s_a)

                    -- Persistent Advantage Learning (PAL) operator
                    local V_s_1 = q_next[b]:max()
                    local Q_s_1_a = q_next[b][train.a_t[b]]
                    local PAL = - opt.action_gap_alpha * (V_s_1 - Q_s_1_a)

                    delta_q[{ { b }, { train.a_t[b] } }]:add(math.max(AL, PAL))
                end
            end

            -- Backward pass
            local feval = function(x)

                -- Reset parameters
                gradParams:zero()

                -- Backprop
                train_q_episode[step] = criterion:forward(q, delta_q)
                model:backward(train.s_t, criterion:backward(q, delta_q))

                -- Clip Gradients
                gradParams:clamp(-5, 5)

                return 0, gradParams
            end

            optim_func(feval, params, optim_config, optim_state)

            -- Update target network
            -- params_target:mul(1 - opt.target_gamma):add(opt.target_gamma, params)
            if step_count % opt.target_step == 0 then
            	params_target:copy(params)
            end
        end

        -- next state
        episode.s_t = episode.s_t1:clone()
        step = step + 1

        -- Total steps
        step_count = step_count + 1
    end

    -- Compute statistics
    train_q = train_q_episode:narrow(1, 1, step - 1):mean()
    train_r = train_r_episode:narrow(1, 1, step - 1):sum()
    if e == 1 or e % opt.step_test == 0 then
    	test_r = exp.test(opt, lego, model)
    	if e == 1 then
        	test_r_avg = test_r
        else
        	test_r_avg = 0.99 * test_r_avg + 0.01 * test_r
        end
    end

    -- Compute moving averages
    if e == 1 then
        train_q_avg = train_q
        train_r_avg = train_r
    else
        train_q_avg = 0.99 * train_q_avg + 0.01 * train_q
        train_r_avg = 0.99 * train_r_avg + 0.01 * train_r
    end
    -- test_r_all[e] = test_r

    -- Print statistics
    if e == 1 or e % opt.step == 0 then
        log.infof('e=%d, train_q=%.3f, train_q_avg=%.3f, train_r=%.3f, train_r_avg=%.3f, test_r=%.3f, test_r_avg=%.3f, t/e=%.2f sec, t=%d min.',
            e, train_q, train_q_avg, train_r, train_r_avg, test_r, test_r_avg,
            sys.clock() - time, torch.toc(beginning_time) / 60)
    end

    -- Save model every 10 episodes
    -- if #train_q % 10 == 0 then
    --     save_model()
    -- end
end

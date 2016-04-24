require 'nn'
require 'nngraph'
require 'optim'
local kwargs = require 'include.kwargs'
local log = require 'include.log'

return function(opt)
    local opt = kwargs(opt, {
        { 'a_size', type = 'int-pos' },
        { 's_size', type = 'int-pos' },
        { 'dtype', type = 'string', default = 'torch.FloatTensor' },
        { 'lr', type = 'number', default = 1e-3 }
    })

    local exp = {}

    function exp.optim(iter)
        local optimfunc = optim.adam
        local lr = opt.lr
        local optimconfig = { learningRate = lr }
        return optimfunc, optimconfig
    end

    function exp.test(opt, lego, model)

        -- Run for N steps
        local s_t, s_t1, a_t, r_t
        local terminal = 0

        -- Initial state
        -- lego.cur = lego.cur or require('lego')({input='IMAGE100.LXFML', output="out/cur.png", dim=opt.dim})
        lego.cur:load_lxfml('IMAGE100.LXFML')
	 	lego.cur:save_lxfml('tmp.lxfml')
	    s_t = lego.cur:render('tmp.lxfml', 'out/test_0.png'):clone()

        local step = 1
        local r = 0
        while step <= opt.nsteps and terminal == 0 do

            -- get argmax_u Q from DQN
            local q = model:forward(lego.cur.image:type(opt.dtype))

            -- Pick an action
            local max_q, max_a = torch.max(q, 2)
            a_t = max_a:squeeze()

             --compute reward for current state-action pair
            lego.action(lego.cur, a_t)
		 	lego.cur:save_lxfml('tmp.lxfml')
		    s_t1 = lego.cur:render('tmp.lxfml', 'out/test_' .. step .. '.png'):clone()
            r_t, terminal = lego.reward(lego.cur, lego.target)
            
            -- If terminal reward=1
            if terminal == 1 then
                r_t = 1
            end

            r = r + r_t

            -- next state
            s_t = s_t1:clone()

            step = step + 1
        end

        return r
    end

    local function create_model(opt)
        local opt = kwargs(opt, {
            { 'a_size', type = 'int-pos' },
            { 's_size', type = 'int-pos' },
            { 'dtype', type = 'string', default = 'torch.FloatTensor' }
        })

        local model = nn.Sequential()
        -- model:add(nn.JoinTable(2))
        model:add(nn.View(-1, 3, opt.s_size, opt.s_size))
        model:add(nn.AddConstant(-0.5))
        model:add(nn.SpatialConvolutionMM(3, 32, 8, 8, 4, 4))
        -- model:add(nn.SpatialBatchNormalization(32))
        model:add(nn.ReLU(true))
        model:add(nn.SpatialConvolutionMM(32, 64, 5, 5, 3, 3))
        -- model:add(nn.SpatialBatchNormalization(64))
        model:add(nn.ReLU(true))
        model:add(nn.SpatialConvolutionMM(64, 64, 4, 4, 2, 2))
        -- model:add(nn.SpatialBatchNormalization(64))
        model:add(nn.ReLU(true))
        model:add(nn.View(-1, 64*3*3))
        model:add(nn.Linear(64*3*3, 512))
        -- model:add(nn.BatchNormalization(512))
        model:add(nn.ReLU(true))
        model:add(nn.Linear(512, opt.a_size))

        -- print(model:forward(torch.Tensor(20,3,opt.s_size,opt.s_size)):size())

        return model:type(opt.dtype)
    end

    -- Create model
    exp.model = create_model {
        a_size = opt.a_size,
        s_size = opt.s_size,
        dtype = opt.dtype
    }

    return exp
end
local class = require 'class'
local xml = require 'xml'
local image = require 'image'
local log = require 'include/log'
local kwargs = require 'include/kwargs'

-- @TODO handle rotation

local Lego = class('Lego')

function Lego:__init(opt)
    self.opt = kwargs(opt, {
        { 'input', type = 'string', default = 'input.lxf' },
        { 'output', type = 'string', default = 'out/output.png' },
        { 'wireframe', type = 'string', default = 'N' },
        { 'rotation', type = 'int-nonneg', default = 0 },
        { 'path', type = 'string', default = paths.cwd() },
        { 'dim', type = 'int-pos', default = 224 },
    })

    -- initialise configuration file
    self:init_config()

    -- initialise scene resolution
    self:init_resolution()

    -- output image tensor
    self.image = torch.Tensor(3, self.opt.dim, self.opt.dim):zero()
end

-- initialise config file for bluerender
function Lego:init_config()
    local file = torch.DiskFile(os.getenv("HOME") .. '/.bluerender.ini', 'w')
    file:writeString('db.location=' .. self.opt.path .. '/db/db.lif\n' .. 'last.db.version=1x1564.2\n')
    file:close()
end

-- initialise scene resolution
function Lego:init_resolution()
    local command = "sed -i.bak 's/  resolution.*/  resolution " ..
            self.opt.dim .. " " .. self.opt.dim ..
            "/g' scene.sc && rm scene.sc.bak"
    local handle = io.popen(command)
    handle:close()
end

-- render input file
function Lego:render()
    log.infof('Rendering %s -> %s', self.opt.input, self.opt.output)

    -- call bluerender
    local command = 'java -cp "bluerender/bin/*" bluerender.CmdLineRenderer ' ..
            self.opt.wireframe .. ' ' .. self.opt.rotation .. ' ' ..
            self.opt.input .. ' ' .. self.opt.output
    local handle = io.popen(command)
    handle:close()

    -- read image
    local img = image.load(self.opt.output)
    self.image:copy(img)

    return self.image
end


local l = Lego({})
l:render()
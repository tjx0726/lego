--require("luaXml")
local xml = require 'xml'
local class = require 'class'
local lub = require 'lub'
local image = require 'image'

local util = require 'include/util'
local log = require 'include/log'
local kwargs = require 'include/kwargs'

local Brick = require 'obj/brick'

-- @TODO handle rotation

local Lego = class('Lego')

function Lego:__init(opt)
    self.opt = kwargs(opt, {
        { 'input', type = 'string', default = 'input.lxf' },
        { 'output', type = 'string', default = 'out/output.png' },
        { 'wireframe', type = 'boolean', default = false },
        { 'rotation', type = 'int-nonneg', default = 0 },
        { 'path', type = 'string', default = paths.cwd() },
        { 'dim', type = 'int-pos', default = 256 },
    })

    -- initialise configuration file
    self:init_config()

    -- initialise scene resolution
    self:init_resolution()

    -- current lxf
    self.lxfml = nil
    self.lxfml_k = nil

    -- output image tensor
    self.image = torch.Tensor(3, self.opt.dim, self.opt.dim)

    -- bricks table
    self.bricks = {}
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
    log.infof('Render %s -> %s', self.opt.input, self.opt.output)

    local wireframe
    if self.opt.wireframe then
        wireframe = 'Y'
    else
        wireframe = 'N'
    end

    -- call bluerender
    local command = 'java -cp "bluerender/bin/*" bluerender.CmdLineRenderer ' ..
            wireframe .. ' ' .. self.opt.rotation .. ' ' ..
            self.opt.input .. ' ' .. self.opt.output
    local handle = io.popen(command)
    handle:close()

    -- read image
    self.image:set(image.load(self.opt.output))

    log.info('Render completed')

    return self.image
end

-- load lxf file data
function Lego:load_lxf()
    -- unzip lxfml from lxf
    local command = 'unzip -p ' .. self.opt.input .. ' IMAGE100.LXFML'
    local handle = io.popen(command)
    local lxfml_data = handle:read("*a")
    handle:close()

    -- parse lxfml
    self.lxfml = xml.load(lxfml_data)
end

-- save lxf file
function Lego:save_lxf()
    assert(self.lxfml, 'input LXF file not loaded')

    -- update bricks
    for i = 1, #self.bricks do
        self.lxfml[self.lxfml_k['Bricks']][i] = self.bricks[i]:totable()
    end

    -- dump xml
    local xml_string = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>\n' ..
            xml.dump(self.lxfml):gsub("'", "\"")

    -- write temp lxfml file
    local file = torch.DiskFile('IMAGE100.LXFML', 'w')
    file:writeString(xml_string)
    file:close()

    -- zip lxfml file
    local command = 'zip -r -0 ' .. self.opt.input .. ' IMAGE100.LXFML' -- && rm IMAGE100.LXFML'
    local handle = io.popen(command)
    print(handle:read("*a"))
    handle:close()
end


-- parse lxfml file
function Lego:parse_lxfml()

    -- parse keys
    self.lxfml_k = {}
    for k, v in pairs(self.lxfml) do
        if self.lxfml[k].xml ~= nil then
            self.lxfml_k[self.lxfml[k].xml] = k
        end
    end

    -- cleanup unnecessary keys
    self.lxfml[self.lxfml_k['RigidSystems']] = { xml = 'RigidSystems' }
    self.lxfml[self.lxfml_k['GroupSystems']] = { xml = 'GroupSystems', [1] = { xml = 'GroupSystem' } }
    self.lxfml[self.lxfml_k['BuildingInstructions']] = { xml = 'BuildingInstructions' }

    -- parse bricks
    self.bricks = {}
    for k, v in pairs(self.lxfml[self.lxfml_k['Bricks']]) do
        if self.lxfml[self.lxfml_k['Bricks']][k].xml ~= nil then
            -- create new brick
            local b = Brick({
                xml = self.lxfml[self.lxfml_k['Bricks']][k]
            })
            table.insert(self.bricks, b)
        end
    end
end


local l = Lego()
l:load_lxf()
l:parse_lxfml()
l:save_lxf()
l:render()

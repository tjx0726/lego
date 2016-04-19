require 'torch'
torch.setdefaulttensortype('torch.FloatTensor')

local xml = require 'xml'
local class = require 'class'
local image = require 'image'

local util = require 'include/util'
local log = require 'include/log'
local kwargs = require 'include/kwargs'

local Brick = require 'obj/brick'

-- @TODO handle rotation

local Lego = class('Lego')

function Lego:__init(opt)
    self.opt = kwargs(opt, {
        { 'input', type = 'string', default = 'IMAGE100.LXFML' },
        { 'output', type = 'string', default = 'out/output.png' },
        { 'rotation', type = 'int-nonneg', default = 0 },
        { 'path', type = 'string', default = paths.cwd() },
        { 'dim', type = 'int-pos', default = 1024 },
    })

    -- current lxf
    self.lxfml = nil
    self.lxfml_k = nil

    -- output image tensor
    self.image = torch.Tensor(3, self.opt.dim, self.opt.dim)

    -- bricks table
    self.bricks = {}
end

-- render input file
function Lego:render(input, output)
    if input == nil then input = self.opt.input end
    if output == nil then output = self.opt.output end

    log.infof('Render %s -> %s', input, output)

    -- update bricks
    self:update_bricks()

    -- call blender
    local command = 'blender scene.blend -b -f 1 -P render.py ' ..
            self.opt.dim .. ' ' ..
            input .. ' ' .. output
    util.execute(command)

    -- read image
    self.image:set(image.load(output))

    log.info('Render completed')

    return self.image
end

-- load lxf file data
function Lego:load_lxfml(filename)

    if not filename then
        filename = self.opt.input
    end

    -- load file
    local f = io.open(filename, "rb")
    local lxfml_data = f:read("*all")
    f:close()

    -- parse lxfml
    self.lxfml = xml.load(lxfml_data)
end

-- load lxfml file data
function Lego:load_lxf()
    -- delete image
    local command = 'zip -d ' .. self.opt.input .. ' IMAGE100.PNG'
    util.execute(command)

    -- delete image and unzip lxfml from lxf
    local command = 'unzip -p ' .. self.opt.input .. ' IMAGE100.LXFML'
    local lxfml_data = util.execute(command)

    -- parse lxfml
    self.lxfml = xml.load(lxfml_data)
end

-- update bricks
function Lego:update_bricks()
    for i = 1, #self.bricks do
        self.lxfml[self.lxfml_k['Bricks']][i] = self.bricks[i]:totable()
    end
end

-- save lxf file
function Lego:save_lxf(filename)
    assert(self.lxfml, 'input LXF file not loaded')

    -- update bricks
    self:update_bricks()

    -- dump xml
    local xml_string = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>\n' ..
            xml.dump(self.lxfml):gsub("'", "\"")

    -- write temp lxfml file
    if not filename then
        filename = 'IMAGE100.LXF'
    end
    local file = torch.DiskFile(filename, 'w')
    file:writeString(xml_string)
    file:close()

    -- zip lxfml file
    if filename == nil then filename = self.opt.input end
    local command = 'zip -r -0 ' .. filename .. ' IMAGE100.LXFML' -- && rm IMAGE100.LXFML'
    util.execute(command)
end

-- save lxfml file
function Lego:save_lxfml(filename)
    assert(self.lxfml, 'input LXF file not loaded')

    -- update bricks
    self:update_bricks()

    -- dump xml
    local xml_string = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>\n' ..
            xml.dump(self.lxfml):gsub("'", "\"")

    -- write temp lxfml file
    if not filename then
        filename = self.opt.input
    end
    local file = torch.DiskFile(filename, 'w')
    file:writeString(xml_string)
    file:close()
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
l:load_lxfml()
l:parse_lxfml()
l.bricks[1]:set_pos(0, 0, 0)
l:render()
-- print(l.bricks[1]:get_pos())
l.bricks[1]:move_pos(-4, 0, 0)
-- print(l.bricks[1]:get_pos())
l:save_lxfml('tmp.lxfml')
l:render('tmp.lxfml', 'out/tmp.png')

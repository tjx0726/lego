require 'torch'
torch.setdefaulttensortype('torch.FloatTensor')

local xml = require 'xml'
local class = require 'class'
local image = require 'image'

local util = require 'include.util'
local log = require 'include.log'
local kwargs = require 'include.kwargs'

local Brick = require 'obj.brick'

local socket = require("socket")

-- @TODO handle rotation

local Lego = class('Lego')

function Lego:__init(opt)
    self.opt = kwargs(opt, {
        { 'input', type = 'string', default = 'IMAGE100.LXFML' },
        { 'output', type = 'string', default = 'out/output.png' },
        { 'rotation', type = 'int-nonneg', default = 0 },
        { 'path', type = 'string', default = paths.cwd() },
        { 'dim', type = 'int-pos', default = 1024 },
        { 'socket', type = 'boolean', default = true },
    })

    -- current lxf
    self.lxfml = nil
    self.lxfml_k = nil

    -- output image tensor
    self.image = torch.Tensor(3, self.opt.dim, self.opt.dim)

    -- bricks table
    self.bricks = {}

    -- load file
    self:load_lxfml()
    self:parse_lxfml()

    -- socket
    if self.opt.socket then
        log.debugf('[LEGO] Starting blender socket')

        os.execute('killall blender 2>/dev/null')
        
        local command = 'blender -b scene.blend -noaudio -f 1 -t 4 -P render.py -- 1 ' .. self.opt.dim .. ' 2>&1 1>/dev/null &'
        -- print(command)
        os.execute(command)
        
        os.execute("sleep 3")

        local host = "127.0.0.1"
        local port = 5346
        log.debugf('[LEGO] Connecting blender socket')
        self.s = assert(socket.tcp())
        assert(self.s:connect(host, port))
        -- self.s:settimeout(0)
    end
end

function Lego:close()
    log.debugf('[LEGO] Closing Blender')
    assert(self.s:send('exit'))
    self.s:close()
end

-- render input file
function Lego:render(input, output)
    if input == nil then input = self.opt.input end
    if output == nil then output = self.opt.output end

    log.debugf('[LEGO] Render %s -> %s', input, output)

    -- update bricks
    self:update_bricks()

    -- call blender
    if not self.opt.socket then
        local command = 'blender -b scene.blend -noaudio -f 1 -t 4 -P render.py -- 0 ' ..
                self.opt.dim .. ' ' ..
                input .. ' ' .. output
        -- print(command)
        util.execute(command)
    else
        log.debugf('[LEGO] Sending to blender socket')
        assert(self.s:send(input .. ',' .. output))
        log.debugf('[LEGO] Receiving to blender socket')
        local data, emsg, partial = self.s:receive('*l')
        log.debugf('[LEGO] Received ' .. data)

        -- log.debugf('[LEGO] Closing blender socket')
        -- self.s:close()
    end

    -- read image
    self.image:set(image.load(output))

    log.debug('[LEGO] Render completed')

    return self.image
end

-- load lxf file data
function Lego:load_lxfml(filename)

    if not filename then
        filename = self.opt.input
    end

    log.debugf('[LEGO] Load LXFML %s', filename)

    -- load file
    local f = io.open(filename, "rb")
    local lxfml_data = f:read("*all")
    f:close()

    -- parse lxfml
    self.lxfml = xml.load(lxfml_data)
    self:parse_lxfml()
end

-- load lxfml file data
function Lego:load_lxf(filename)

    if not filename then
        filename = self.opt.input
    end
    
    log.debugf('[LEGO] Load LXF %s', filename)

    -- delete image
    local command = 'zip -d ' .. filename .. ' IMAGE100.PNG'
    util.execute(command)

    -- delete image and unzip lxfml from lxf
    local command = 'unzip -p ' .. filename .. ' IMAGE100.LXFML'
    local lxfml_data = util.execute(command)

    -- parse lxfml
    self.lxfml = xml.load(lxfml_data)
    self:parse_lxfml()
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

    log.debugf('[LEGO] Saving LXF %s', filename)

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
    assert(self.lxfml, 'input LXFML file not loaded')

    -- update bricks
    self:update_bricks()

    -- dump xml
    local xml_string = '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>\n' ..
            xml.dump(self.lxfml):gsub("'", "\"")

    -- write temp lxfml file
    if not filename then
        filename = self.opt.input
    end

    log.debugf('[LEGO] Saving LXFML %s', filename)

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


-- local l = Lego()
-- l:load_lxfml()
-- l:parse_lxfml()
-- l.bricks[1]:set_pos(0, 0, 0)
-- l:render()
-- -- print(l.bricks[1]:get_pos())
-- l.bricks[1]:move_pos(-4, 0, 0)
-- l.bricks[2]:move_pos(1, 0, 0)
-- l.bricks[3]:move_pos(1, 0, 2)
-- l:save_lxfml('tmp.lxfml')
-- l:render('tmp.lxfml', 'out/tmp.png')

-- l.bricks[1]:move_pos(-4, 0, 0)
-- l.bricks[2]:move_pos(1, 0, 0)
-- l.bricks[3]:move_pos(1, 0, 2)
-- l.bricks[4]:move_pos(1, 0, 2)
-- l:save_lxfml('tmp2.lxfml')
-- l:render('tmp2.lxfml', 'out/tmp2.png')

return Lego
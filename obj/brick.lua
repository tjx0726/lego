require 'torch'
torch.setdefaulttensortype('torch.FloatTensor')

local class = require 'class'

local kwargs = require '../include/kwargs'
local util = require '../include/util'

local Brick = class('Brick')

function Brick:__init(opt)
    self.opt = kwargs(opt, {
        { 'xml', type = 'table', optional = true },
        { 'refID', type = 'int-nonneg', optional = true },
        { 'designID', type = 'int', optional = true },
        { 'materials', type = 'int', optional = true },
        { 'transformation', type = 'tensor', optional = true },
        { 'position', type = 'tensor', optional = true },
    })

    assert(self.opt.xml ~= nil or (self.opt.refID ~= nil and self.opt.designID ~= nil and
            self.opt.materials ~= nil and self.opt.transformation ~= nil),
        '[Brick] No XML or input provided')

    -- If xml provided parse it else create new table
    if self.opt.xml then

        -- refID, designID
        self.opt.refID = tonumber(self.opt.xml.refID)
        self.opt.designID = tonumber(self.opt.xml.designID)

        -- materials
        local materials = self.opt.xml[1].materials
        local idx = string.find(materials, ",")
        if idx ~= nil then
            materials = string.sub(materials, 1, idx - 1)
        end
        self.opt.materials = tonumber(materials)

        -- transformation
        local trans_table = util.split(self.opt.xml[1][1].transformation, ",")
        for i = 1, #trans_table do
            trans_table[i] = tonumber(trans_table[i])
        end
        -- round 2 decimals
        self.opt.transformation = torch.Tensor(trans_table):reshape(4, 3):mul(100):round():div(100)
    else
        -- convert position to transformation
        if self.opt.position then
            self.opt.transformation = torch.Tensor(4, 3):zero()
            self.opt.transformation[{ { 1 }, { 1 } }] = 1
            self.opt.transformation[{ { 2 }, { 2 } }] = 1
            self.opt.transformation[{ { 3 }, { 3 } }] = 1
            self.opt.transformation[{ { 4 }, {} }] = self:pos2trans(self.opt.position)
        end

        -- update table
        self:update_values()
    end

    -- default unit
    self.unit = 0.8
end

-- get brick dimensions
-- returns width, height, depth
function Brick:size(d)
    assert(d == nil or (d >= 1 and d <= 3), 'Wrong size dimension')

    -- 3005,  # 1x1
    -- 3004,  # 1x2
    -- 3003,  # 2x2
    -- 3622,  # 1x3
    -- 3010,  # 1x4

    local height_brick = 0.96
    local height_plate = 0.32

    local size
    if self.opt.designID == 3005 then
        size = { 0.8, height_brick, 0.8 }
    elseif self.opt.designID == 3004 then
        size = { 0.8, height_brick, 0.8 * 2 }
    elseif self.opt.designID == 3003 then
        size = { 0.8 * 2, height_brick, 0.8 * 2 }
    elseif self.opt.designID == 3622 then
        size = { 0.8, height_brick, 0.8 * 3 }
    elseif self.opt.designID == 3010 then
        size = { 0.8, height_brick, 0.8 * 4 }
    end

    if d == nil then
        return size
    else
        return size[d]
    end
end

-- update brick table
function Brick:update_values()
    self.opt.xml = {
        xml = "Brick",
        designID = tostring(self.opt.designID),
        refID = tostring(self.opt.refID),
        itemNos = tostring(self.opt.designID) .. tostring(self.opt.materials),
        [1] = {
            xml = "Part",
            designID = tostring(self.opt.designID),
            decoration = "0",
            materials = tostring(self.opt.materials) .. ",0",
            refID = tostring(self.opt.refID),
            [1] = {
                xml = "Bone",
                refID = tostring(self.opt.refID),
                transformation = table.concat(self.opt.transformation:view(12):mul(100):round():div(100):totable(), ",")
            }
        }
    }
end

-- @TODO finish writing it
function Brick:get_occupied()
    if self.opt.designID == '3005' then
        return get_pos():totable()
    elseif self.opt.designID == '3003' then
        local x, y, z = get_pos():totable()
        --        return {
        --            { x, y, z },
        --            { x, y, z }
        --        }
    end
end

function Brick:get_rotation()
    --  Those 0.707 values are 45 degree rotations, they correspond to the sin or cosine of 45 degrees
    -- (or PI/4 in radians) and are part of the transformation.
    return self.opt.transformation:narrow(1, 1, 3)
end

function Brick:get_trans()
    -- x, y, z
    return self.opt.transformation:narrow(1, 4, 1):view(3)
end


function Brick:trans2pos(x, y, z)
    assert((x ~= nil and y == nil and z == nil) or
            (x ~= nil and y ~= nil and z ~= nil),
        'Wrong input pos')

    -- p = (int(t) - 0.8 / 2) / 0.8
    if x ~= nil and y == nil and z == nil then
        local pos = x:clone()
        pos[{ { 1 } }] = (x[1] - self.unit / 2) / self.unit
        pos[{ { 2 } }] = x[2] / self:size(2)
        pos[{ { 3 } }] = (x[3] - self.unit / 2) / self.unit
        return pos:round():long()
    else
        return {
            util.round((x - self.unit / 2) / self.unit),
            util.round(y / self:size(2)),
            util.round((z - self.unit / 2) / self.unit)
        }
    end
end

function Brick:pos2trans(x, y, z)
    assert((x ~= nil and y == nil and z == nil) or
            (x ~= nil and y ~= nil and z ~= nil),
        'Wrong input pos')

    if x ~= nil and y == nil and z == nil then
        local trans = x:clone():float()
        trans[{ { 1 } }]:mul(self.unit):add(self.unit / 2)
        trans[{ { 2 } }]:mul(self:size(2))
        trans[{ { 3 } }]:mul(self.unit):add(self.unit / 2)
        return trans:mul(100):round():div(100)
    else
        return { x * self.unit + self.unit / 2, y * self:size(2), z * self.unit + self.unit / 2 }
    end
end


function Brick:get_pos(totable)
    local pos = self:trans2pos(self:get_trans())
    if totable then
        return pos:totable()
    else
        return pos
    end
end

function Brick:move_pos(x, y, z)
    self:set_pos(x, y, z, true)
end

function Brick:set_pos(x, y, z, relative)
    assert((x ~= nil and y == nil and z == nil) or
            (x ~= nil and y ~= nil and z ~= nil),
        'Wrong input pos')

    if x ~= nil and y ~= nil and z ~= nil then
        x = torch.LongTensor({ x, y, z })
    end

    if relative then
        self.opt.transformation[{ { 4 }, {} }] = self:pos2trans(x + self:get_pos())
    else
        self.opt.transformation[{ { 4 }, {} }] = self:pos2trans(x)
    end
end

function Brick:totable()
    self:update_values()
    return self.opt.xml
end

function Brick:toxml()
    self:update_values()
    return xml.dump(self.opt.xml)
end

return Brick


--local b = Brick()
--print(b:toxml())

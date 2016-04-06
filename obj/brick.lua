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
        self.opt.transformation = torch.Tensor(trans_table):reshape(4, 3)
    else
        self:update_values()
    end
end

--
function Brick:update_values()
    self.opt.xml = {
        xml = "Brick",
        designID = tostring(self.opt.designID),
        refID = tostring(self.opt.refID),
        itemNos = tostring(self.opt.refID) .. tostring(self.opt.materials),
        [1] = {
            xml = "Part",
            designID = tostring(self.opt.designID),
            decoration = "0",
            materials = tostring(self.opt.materials) .. ",0",
            refID = tostring(self.opt.refID),
            [1] = {
                xml = "Bone",
                refID = tostring(self.opt.refID),
                transformation = table.concat(self.opt.transformation:view(12):totable(), ",")
            }
        }
    }
end

function Brick:get_rotation()
    return self.opt.transformation:narrow(1, 1, 3)
end

function Brick:get_translation()
    return self.opt.transformation:narrow(1, 4, 1)
end

function Brick:totable()
    self:update_values()
    return self.opt.xml
end

function Brick:toxml()
    self:update_values()
    return xml.dump(self.opt.xml)
end


-- Brick width is 0.8, brick height is 0.96 and plate height 0.32.": These are dimensions of bricks in centimeters..
--  Those 0.707 values are 45 degree rotations, they correspond to the sin or cosine of 45 degrees (or PI/4 in radians) and are part of the transformation.

--local b = Brick()
--print(b:toxml())

return Brick
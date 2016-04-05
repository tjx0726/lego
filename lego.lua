local class = require 'class'

-- define some dummy A class
local lego = class('lego')

function lego:__init(file)
    self.file = 'lddcreation.lxf'
end

function lego:run()
    print(self.stuff)
end

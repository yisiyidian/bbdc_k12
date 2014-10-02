require("Cocos2d")
require("Cocos2dConstants")

local DataExample = class("DataExample", function()
    return {}
end)

function DataExample.create()
    local data = DataExample.new()
    
    return data
end

return DataExample

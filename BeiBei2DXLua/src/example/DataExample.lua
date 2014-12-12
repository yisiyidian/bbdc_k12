require("cocos.init")

local DataExample = class("DataExample", function()
    return {}
end)

function DataExample.create()
    local data = DataExample.new()
    data.des = 'DataExample des'
    return data
end

return DataExample

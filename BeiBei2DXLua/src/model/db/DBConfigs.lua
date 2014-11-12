
local DBConfigs = class("DBConfigs", function()
    return {}
end)

function DBConfigs.create()
    local data = DBConfigs.new()
    return data
end

function DBConfigs:ctor()
    self.className = 'DBConfigs'
end

return DBConfigs

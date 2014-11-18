
local DataConfigs = class("DataConfigs", function()
    return {}
end)

function DataConfigs.create()
    local data = DataConfigs.new()
    return data
end

function DataConfigs:ctor()
    self.className = 'DataConfigs'
end

return DataConfigs

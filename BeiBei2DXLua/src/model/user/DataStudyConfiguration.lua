local DataClassBase = require('model.user.DataClassBase')

-- 保存学习状态中的弹窗状态

local DataStudyConfiguration = class("DataStudyConfiguration", function()
    return DataClassBase.new()
end)

function DataStudyConfiguration.create()
    local data = DataStudyConfiguration.new()
    return data
end

function DataStudyConfiguration:ctor()
    self.className = 'DataStudyConfiguration'
    
    self.isAlterOn = 0
    self.slideNum = 0
    self.lastUpdate = 0
end

return DataStudyConfiguration
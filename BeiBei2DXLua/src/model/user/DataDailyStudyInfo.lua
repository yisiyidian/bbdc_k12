-- 记录每天的学习信息

local DataClassBase = require('model.user.DataClassBase')

local DataDailyStudyInfo = class("DataDailyStudyInfo", function()
    return DataClassBase.new()
end)

function DataDailyStudyInfo.create()
    local data = DataDailyStudyInfo.new()
    return data
end

function DataDailyStudyInfo:ctor()
    self.className = 'DataDailyStudyInfo'
    
    self.bookKey = ''
    self.dayString = ''
    self.studyNum = 0
    self.graspNum = 0
    self.lastUpdate = 0
    self.ordinalNum = 0
    
end

return DataDailyStudyInfo

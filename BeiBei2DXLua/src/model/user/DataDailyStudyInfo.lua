-- 记录每天的学习信息

local DataClassBase = require('model.user.DataClassBase')

local DataDailyStudyInfo = class("DataDailyStudyInfo", function()
    return DataClassBase.new()
end)

function DataDailyStudyInfo.createData(bookKey, dayString, studyNum, graspNum, lastUpdate)
    local data = DataDailyStudyInfo.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.dayString = dayString
    data.studyNum = studyNum
    data.graspNum = graspNum
    data.lastUpdate = lastUpdate

    return data
end

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
    
end

function DataDailyStudyInfo.getNoObjectIdAndTodayDatasFromLocalDB(todayString)
    local noObjectIdDatas = {}
    local today = nil
    s_LocalDatabaseManager.getDatas('DataDailyStudyInfo', s_CURRENT_USER.objectId, s_CURRENT_USER.username, function (row)
        if row.bookKey ~= '' and row.bookKey ~= nil and row.bookKey == s_CURRENT_USER.bookKey then
            local data = DataDailyStudyInfo.createData(row.bookKey, row.dayString, row.studyNum, row.graspNum, row.lastUpdate)
            data.className = row.className
            data.objectId = row.objectId
            data.userId = row.userId
            data.username = row.username
            data.createdAt = row.createdAt
            data.updatedAt = row.updatedAt
            
            if row.dayString == todayString then
                today = data
            elseif row.objectId == '' or row.objectId == nil then
                table.insert(noObjectIdDatas, data)
            end
        end
    end)
    return {['noObjectIdDatas']=noObjectIdDatas, ['today']=today}
end

return DataDailyStudyInfo

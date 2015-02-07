-- just for personal info

local DataDailyStudyInfo = require('model.user.DataDailyStudyInfo')
local Manager = s_LocalDatabaseManager

local M = {}

function M.getRandomWord()
    return "apple"
end

function M.addStudyWordsNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = getDayStringForDailyStudyInfo(time)

    local data = M.getDataDailyStudyInfo(today)
    if data == nil then
        data = DataDailyStudyInfo.createData(bookKey, today, 1, 0, time, 0)
        Manager.saveData(data, userId, username, 0)
    else
        data.studyNum = data.studyNum + 1
        Manager.saveData(data, userId, username, 1, " and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;")
    end
    saveDailyStudyInfoToServer(data)
    return data
end

function M.addTodayGetReward()-- influence beibei bean
    local userId = s_CURRENT_USER.objectId
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = getDayStringForDailyStudyInfo(time)
    for i=1, #g_BOOKKEYS do
        local data = M.getAllDataDailyStudyInfo(g_BOOKKEYS[i], today)
        if data == nil then
            data = DataDailyStudyInfo.createData(g_BOOKKEYS[i], today, 0, 0, time, 1)
            Manager.saveData(data, userId, username, 0)
        else
            data.todayGetReward =  1
            Manager.saveData(data, userId, username, 1, " and bookKey = '"..g_BOOKKEYS[i].."' and dayString = '"..today.."' ;")
        end
    end

    return nil
end

function M.getAllDataDailyStudyInfo(bookKey,dayString)
    local userId = s_CURRENT_USER.objectId
    local username = s_CURRENT_USER.username

    local dbData = nil
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            dbData = row
        end
    end
    if dbData == nil and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            dbData = row
        end
    end

    if dbData ~= nil then
        local data = DataDailyStudyInfo.createData(dbData.bookKey, dbData.dayString, dbData.studyNum, dbData.graspNum, dbData.lastUpdate)
        parseLocalDBDataToClientData(dbData, data)
        return data
    end
    return nil
end

function M.getTodayGetReward()-- influence beibei bean    
    local todayGetReward = 0
    
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = getDayStringForDailyStudyInfo(time)

    local data = M.getDataDailyStudyInfo(today)
    if data ~= nil then
        todayGetReward = data.todayGetReward
    end

    return todayGetReward
end


function M.addGraspWordsNum(addNum)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = getDayStringForDailyStudyInfo(time)

    local data = M.getDataDailyStudyInfo(today)
    if data == nil then
        data = DataDailyStudyInfo.createData(bookKey, today, addNum, addNum, time, 0)
        Manager.saveData(data, userId, username, 0)
    else
        data.graspNum = data.graspNum + addNum
        Manager.saveData(data, userId, username, 1, " and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;")
    end
    saveDailyStudyInfoToServer(data)
    return data
end

function M.getStudyDayNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username
    
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
            num = num + 1
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            num = num + 1
        end
    end

    return num
end

function M.getStudyWordsNum(dayString) -- day must be a string like "11/16/14", as month + day + year
    local studyNum = 0
    local data = M.getDataDailyStudyInfo(dayString)
    if data ~= nil then
        studyNum = data.studyNum
    end

    return studyNum
end

function M.getGraspWordsNum(dayString) -- day must be a string like "11/16/14", as month + day + year
    local graspNum = 0
    local data = M.getDataDailyStudyInfo(dayString)
    if data ~= nil then
        graspNum = data.graspNum
    end

    return graspNum
end

function M.getDataDailyStudyInfo(dayString)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local dbData = nil
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            dbData = row
        end
    end
    if dbData == nil and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            dbData = row
        end
    end

    if dbData ~= nil then
        local data = DataDailyStudyInfo.createData(dbData.bookKey, dbData.dayString, dbData.studyNum, dbData.graspNum, dbData.lastUpdate)
        parseLocalDBDataToClientData(dbData, data)
        return data
    end
    return nil
end

function M.saveDataDailyStudyInfo(data)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username
    local dayString = data.dayString
    
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            num = num + 1
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            num = num + 1
        end
    end
    
    Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;")
    saveDailyStudyInfoToServer(data)
end

return M
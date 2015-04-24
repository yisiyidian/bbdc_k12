-- just for personal info

local DataDailyStudyInfo = require('model.user.DataDailyStudyInfo')
local Manager = s_LocalDatabaseManager

local M = {}

function M.getRandomWord()
    return "apple"
end

function M.addStudyWordsNum(addNum)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = getDayStringForDailyStudyInfo(time)

    local data = M.getDataDailyStudyInfo(today)
    if data == nil then
        data = DataDailyStudyInfo.createData(bookKey, today, addNum, 0, time, 0)
        Manager.saveData(data, userId, username, 0)
    else
        data.studyNum = data.studyNum + addNum
        Manager.saveData(data, userId, username, addNum, " and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;")
    end
    s_CURRENT_USER.wordsCount = s_CURRENT_USER.wordsCount + addNum
    saveUserToServer({['wordsCount']=s_CURRENT_USER.wordsCount})
    saveDailyStudyInfoToServer(data)
    return data
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

function M.getTotalStudyWordsNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
            num = num + row.studyNum
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            num = num + row.studyNum
        end
    end

    -- if dbData ~= nil then
    --     local data = DataDailyStudyInfo.createData(dbData.bookKey, dbData.dayString, dbData.studyNum, dbData.graspNum, dbData.lastUpdate)
    --     parseLocalDBDataToClientData(dbData, data)
    --     return data
    -- end
    return num
end

function M.getTotalStudyWordsNumByBookKey(bookKey)
    local userId = s_CURRENT_USER.objectId
    local username = s_CURRENT_USER.username

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
            num = num + row.studyNum
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            num = num + row.studyNum
        end
    end

    -- if dbData ~= nil then
    --     local data = DataDailyStudyInfo.createData(dbData.bookKey, dbData.dayString, dbData.studyNum, dbData.graspNum, dbData.lastUpdate)
    --     parseLocalDBDataToClientData(dbData, data)
    --     return data
    -- end
    return num
end

function M.getTotalGraspWordsNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
            num = num + row.graspNum
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' ;") do
            num = num + row.graspNum
        end
    end

    -- if dbData ~= nil then
    --     local data = DataDailyStudyInfo.createData(dbData.bookKey, dbData.dayString, dbData.studyNum, dbData.graspNum, dbData.lastUpdate)
    --     parseLocalDBDataToClientData(dbData, data)
    --     return data
    -- end
    return num
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
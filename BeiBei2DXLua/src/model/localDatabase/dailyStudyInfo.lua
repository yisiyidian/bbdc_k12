-- just for personal info

local DataDailyStudyInfo = require('model.user.DataDailyStudyInfo')
local Manager = s_LocalDatabaseManager

local M = {}

function M.getRandomWord()
    return "apple"
end

local function createData()
    local data = DataDailyStudyInfo.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.dayString = dayString
    data.studyNum = studyNum
    data.graspNum = graspNum
    data.lastUpdate = lastUpdate

    return data
end

function M.addStudyWordsNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    local today = os.date("%x", time)

    local num = 0
    local oldStudyNum = nil
    local oldGraspNum = nil
    for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;") do
        num = num + 1
        oldStudyNum = row.studyNum
        oldGraspNum = row.graspNum
    end
    
    if num == 0 then
        local studyNum = 1
        local graspNum = 0
        local query = "INSERT INTO DataDailyStudyInfo VALUES ('"..userId.."', '"..bookKey.."', '"..today.."', "..studyNum..", "..graspNum..", "..time..");"
        Manager.database:exec(query)
        s_UserBaseServer.saveDataDailyStudyInfoOfCurrentUser(bookKey, today, studyNum, graspNum)
    else
        local newStudyNum = oldStudyNum + 1
        local query = "UPDATE DataDailyStudyInfo SET studyNum = "..newStudyNum..", lastUpdate = "..time.." WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;"    
        Manager.database:exec(query)
        s_UserBaseServer.saveDataDailyStudyInfoOfCurrentUser(bookKey, today, newStudyNum, oldGraspNum)
    end
end

function M.addGraspWordsNum(addNum)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local time = os.time()
    local today = os.date("%x", time)

    local num = 0
    local oldStudyNum = nil
    local oldGraspNum = nil
    for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;") do
        num = num + 1
        oldStudyNum = row.studyNum
        oldGraspNum = row.graspNum
    end

    if num == 0 then
        local studyNum = 0
        local graspNum = addNum
        local query = "INSERT INTO DataDailyStudyInfo VALUES ('"..userId.."', '"..bookKey.."', '"..today.."', "..studyNum..", "..graspNum..", "..time..");"
        Manager.database:exec(query)
        s_UserBaseServer.saveDataDailyStudyInfoOfCurrentUser(bookKey, today, studyNum, graspNum)
    else
        local newGraspNum = oldGraspNum + addNum
        local query = "UPDATE DataDailyStudyInfo SET graspNum = "..newGraspNum..", lastUpdate = "..time.." WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;"    
        Manager.database:exec(query)
        s_UserBaseServer.saveDataDailyStudyInfoOfCurrentUser(bookKey, today, oldStudyNum, newGraspNum)
    end
end

function M.getStudyDayNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    
    local num = 0
    for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' ;") do
        num = num + 1
    end
    
    return num
end

function M.getStudyWordsNum(dayString) -- day must be a string like "11/16/14", as month + day + year
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    
    local studyNum = 0
    for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
        studyNum = row.studyNum
    end
    
    return studyNum
end

function M.getGraspWordsNum(dayString) -- day must be a string like "11/16/14", as month + day + year
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    local graspNum = 0
    for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
        graspNum = row.graspNum
    end

    return graspNum
end

return M
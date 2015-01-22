-- just for personal info

local DataDailyStudyInfo = require('model.user.DataDailyStudyInfo')
local Manager = s_LocalDatabaseManager

local M = {}

function M.getRandomWord()
    return "apple"
end

local function createData(bookKey, dayString, studyNum, graspNum, lastUpdate ,ordinalNum)
    local data = DataDailyStudyInfo.create()
    updateDataFromUser(data, s_CURRENT_USER)

    data.bookKey = bookKey
    data.dayString = dayString
    data.studyNum = studyNum
    data.graspNum = graspNum
    data.lastUpdate = lastUpdate
    data.ordinalNum = ordinalNum  

    return data
end

function M.addStudyWordsNum()
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = os.date("%x", time)

    local num = 0
    local oldStudyNum = nil
    local oldGraspNum = nil
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;") do
            num = num + 1
            oldStudyNum = row.studyNum
            oldGraspNum = row.graspNum
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;") do
            num = num + 1
            oldStudyNum = row.studyNum
            oldGraspNum = row.graspNum
        end
    end
    
    if num == 0 then
        local studyNum = 1
        local graspNum = 0
        local data = createData(bookKey, today, studyNum, graspNum, time)
        Manager.saveData(data, userId, username, num)
    else
        local newStudyNum = oldStudyNum + 1
        local data = createData(bookKey, today, newStudyNum, oldGraspNum, time)
        Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;")
    end
end

function M.addOrdinalNum(init)-- influence beibei bean
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username
    
    local time = os.time()
    local today = os.date("%x", time)
    
    local num = 0
    local oldStudyNum = nil
    local oldGraspNum = nil
    local ordinalNum  = 0 

    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;") do
            num = num + 1
            oldStudyNum = row.studyNum
            oldGraspNum = row.graspNum
            ordinalNum  = row.ordinalNum 
        end
    end

    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;") do
            num = num + 1
            oldStudyNum = row.studyNum
            oldGraspNum = row.graspNum
            ordinalNum  = row.ordinalNum 
        end
    end

    if num == 0 then
        local studyNum = 0
        local graspNum = 0
        local data = createData(bookKey, today, studyNum, graspNum, time, num)
        Manager.saveData(data, userId, username, num)
    else
        local data = createData(bookKey, today, oldStudyNum, oldGraspNum, time ,ordinalNum + init)
        Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."' and dayString = '"..today.."';")
    end
    
end

function M.getOrdinalNum()-- influence beibei bean
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username
    
    local time = os.time()
    local today = os.date("%x", time)
    
    local ordinalNum
    
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."';") do
            ordinalNum = row.ordinalNum
            num = num + 1
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."';") do
            ordinalNum = row.ordinalNum
        end
    end

    return ordinalNum
end


function M.addGraspWordsNum(addNum)
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username

    local time = os.time()
    local today = os.date("%x", time)

    local num = 0
    local oldStudyNum = nil
    local oldGraspNum = nil

    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;") do
            num = num + 1
            oldStudyNum = row.studyNum
            oldGraspNum = row.graspNum
        end
    end

    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;") do
            num = num + 1
            oldStudyNum = row.studyNum
            oldGraspNum = row.graspNum
        end
    end

    if num == 0 then
        local studyNum = 0
        local graspNum = addNum
        local data = createData(bookKey, today, studyNum, graspNum, time)
        Manager.saveData(data, userId, username, num)
    else
        local newGraspNum = oldGraspNum + addNum
        local data = createData(bookKey, today, oldStudyNum, newGraspNum, time)
        Manager.saveData(data, userId, username, num, " and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;")
    end
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
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey
    local username = s_CURRENT_USER.username
    
    local studyNum = 0
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            studyNum = row.studyNum
            num = num + 1
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            studyNum = row.studyNum
            num = num + 1
        end
    end
    
    return studyNum
end

function M.getGraspWordsNum(dayString) -- day must be a string like "11/16/14", as month + day + year
    local userId = s_CURRENT_USER.objectId
    local bookKey = s_CURRENT_USER.bookKey

    local graspNum = 0
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE userId = '"..userId.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            graspNum = row.graspNum
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataDailyStudyInfo WHERE username = '"..username.."' and bookKey = '"..bookKey.."' and dayString = '"..dayString.."' ;") do
            graspNum = row.graspNum
        end
    end

    return graspNum
end

return M
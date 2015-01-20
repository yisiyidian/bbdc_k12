local DataStudyConfiguration = require('model.user.DataStudyConfiguration')
local Manager = s_LocalDatabaseManager

local M = {}

function M.getIsAlterOn()
    local userId = s_CURRENT_USER.objectId
    local username = s_CURRENT_USER.username

    local isAlterOn = 1 -- default value is 1 which means on
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE userId = '"..userId.."' ;") do
            num = num + 1
            isAlterOn = row.isAlterOn
        end
    end

    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE username = '"..username.."' ;") do
            num = num + 1
            isAlterOn = row.isAlterOn
        end
    end
    
    return isAlterOn
end

-- lastUpdate : nil means now
function M.setIsAlterOn(isAlterOn, lastUpdate)
    lastUpdate = lastUpdate or os.time()

    local userId = s_CURRENT_USER.objectId
    local username = s_CURRENT_USER.username
    
    local num = 0
    local slideNum = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE userId = '"..userId.."' ;") do
            num = num + 1
            slideNum = row.slideNum
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE username = '"..username.."' ;") do
            num = num + 1
            slideNum = row.slideNum
        end
    end

    local data = DataStudyConfiguration.createData(isAlterOn, slideNum, lastUpdate)
    Manager.saveData(data, userId, username, num)
end

function M.getSlideNum()
    local userId = s_CURRENT_USER.objectId
    local username = s_CURRENT_USER.username

    local slideNum = 0 -- default value is 0
    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE userId = '"..userId.."' ;") do
            slideNum = row.slideNum
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE username = '"..username.."' ;") do
            slideNum = row.slideNum
        end
    end

    return slideNum
end

-- lastUpdate : nil means now
function M.updateSlideNum(lastUpdate)
    lastUpdate = lastUpdate or os.time()

    local userId = s_CURRENT_USER.objectId
    local username = s_CURRENT_USER.username

    local num = 0
    local slideNum = 0
    local isAlterOn = 1
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE userId = '"..userId.."' ;") do
            num = num + 1
            slideNum = row.slideNum
            isAlterOn = row.isAlterOn
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE username = '"..username.."' ;") do
            num = num + 1
            slideNum = row.slideNum
            isAlterOn = row.isAlterOn
        end
    end

     local data = DataStudyConfiguration.createData(isAlterOn, slideNum, lastUpdate)
    Manager.saveData(data, userId, username, num)
end

-- lastUpdate : nil means now
function M.saveDataStudyConfiguration(isAlterOn, slideNum, lastUpdate)
    lastUpdate = lastUpdate or os.time()

    local userId = s_CURRENT_USER.objectId
    local username = s_CURRENT_USER.username

    local num = 0
    if userId ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE userId = '"..userId.."' ;") do
            num = num + 1
        end
    end
    if num == 0 and username ~= '' then
        for row in Manager.database:nrows("SELECT * FROM DataStudyConfiguration WHERE username = '"..username.."' ;") do
            num = num + 1
        end
    end

     local data = DataStudyConfiguration.createData(isAlterOn, slideNum, lastUpdate)
    Manager.saveData(data, userId, username, num)
end

return M
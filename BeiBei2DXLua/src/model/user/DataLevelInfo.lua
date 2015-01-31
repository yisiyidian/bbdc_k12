require("cocos.init")
require("common.global")

local DataClassBase = require('model.user.DataClassBase')

local DataLevelInfo = class("DataLevelInfo", function()
    return DataClassBase.new()
end)

function DataLevelInfo.create()
    local data = DataLevelInfo.new()
    return data
end

DataLevelInfo.BOOKKEY          = 'K'
DataLevelInfo.CurrentWordIndex = 'I'
DataLevelInfo.BossList         = 'B'
DataLevelInfo.UpdateBossTime   = 'T'

function DataLevelInfo:ctor()
    self.className = 'DataLevelInfo'

    for i, v in ipairs(g_BOOKS) do
        self[DataLevelInfo.BOOKKEY          .. v] = 0
        self[DataLevelInfo.CurrentWordIndex .. v] = 1
        self[DataLevelInfo.BossList         .. v] = ''
        self[DataLevelInfo.UpdateBossTime   .. v] = 0
    end
end

function DataLevelInfo:getCurrentWordIndex()
    for i, v in ipairs(g_BOOKKEYS) do
        if v == s_CURRENT_USER.bookKey then
            return self[DataLevelInfo.CurrentWordIndex .. g_BOOKS[i]]
        end
    end
    return 0
end

function DataLevelInfo:setCurrentWordIndex(idx)
    for i, v in ipairs(g_BOOKKEYS) do
        if v == s_CURRENT_USER.bookKey then
            self[DataLevelInfo.CurrentWordIndex .. g_BOOKS[i]] = idx
        end
    end
end

function DataLevelInfo:getBookCurrentLevelIndex()
    local progress = self:getLevelInfo(s_CURRENT_USER.bookKey)
--    local levelIndex = progress[]
--    local levelIndex = string.sub(progress['level'],6)+0
--    local chapterIndex = string.sub(progress['chapter'],8)+0
----    if progress['chapter'] == 'chapter1' then
----        levelIndex = levelIndex + 10
----    elseif progress['chapter'] == 'chapter2' then
----        levelIndex = levelIndex + 30
----    elseif progress['chapter'] == 'chapter3' then
----        levelIndex = levelIndex + 60
----    end
--    levelIndex = levelIndex + 10 * chapterIndex
    return progress
end

function DataLevelInfo:getBossList(bookKey)
    for i, v in ipairs(g_BOOKKEYS) do
        if v == bookKey then
            return self[DataLevelInfo.BossList .. g_BOOKS[i]]
        end
    end

    return ''
end

function DataLevelInfo:getUpdateBossTime(bookKey)
    for i, v in ipairs(g_BOOKKEYS) do
        if v == bookKey then
            return self[DataLevelInfo.UpdateBossTime .. g_BOOKS[i]]
        end
    end

    return 0
end


function DataLevelInfo:updateBossList(bookKey, bossList)
    for i, v in ipairs(g_BOOKKEYS) do
        if v == bookKey then
            self[DataLevelInfo.BossList .. g_BOOKS[i]] = bossList
        end
    end
end

function DataLevelInfo:updateTime(bookKey, updateTime)
    for i, v in ipairs(g_BOOKKEYS) do
        if v == bookKey then
            self[DataLevelInfo.UpdateBossTime .. g_BOOKS[i]] = updateTime
        end
    end
end

function DataLevelInfo:getLevelInfo(bookKey)
    for i, v in ipairs(g_BOOKKEYS) do
        if v == bookKey then
            return self[DataLevelInfo.BOOKKEY .. g_BOOKS[i]]
        end
    end
    return 0
end

function DataLevelInfo:computeCurrentProgress()

--    return 4
     return s_LocalDatabaseManager.getMaxBossID()
end

function DataLevelInfo:getDataFromLocalDB()
    updateDataFromUser(self, s_CURRENT_USER)
    s_LocalDatabaseManager.getDatas(self.className, s_CURRENT_USER.objectId, s_CURRENT_USER.username, function (row)
        parseLocalDBDataToClientData(row, self)
    end)
end

function DataLevelInfo:updateDataToServer()
    local currentProgress = self:computeCurrentProgress() 
    local oldProgress = self:getLevelInfo(s_CURRENT_USER.bookKey) 
    local increments = (currentProgress - oldProgress) * 2   -- add beans count
    s_CURRENT_USER:addBeans(increments)
    saveUserToServer({[DataUser.BEANSKEY]=s_CURRENT_USER[DataUser.BEANSKEY]})
    -----------------------------
    bookKey = s_CURRENT_USER.bookKey
    for i, v in ipairs(g_BOOKKEYS) do
        if v == bookKey then
            self[DataLevelInfo.BOOKKEY .. g_BOOKS[i]] = currentProgress
        end
    end
    self:sysData()

end

function DataLevelInfo:sysData()
    sysLevelInfo(self, function (serverData, error)
        if serverData ~= nil then parseServerDataToClientData(serverData, self) end
        s_LocalDatabaseManager.saveDataClassObject(self, s_CURRENT_USER.userId, s_CURRENT_USER.username)
    end)
end

return DataLevelInfo

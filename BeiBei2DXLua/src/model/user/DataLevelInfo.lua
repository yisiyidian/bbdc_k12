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
        if v == bookKey then
            return self[DataLevelInfo.CurrentWordIndex .. g_BOOKS[i]]
        end
    end
    return 0
end

function DataLevelInfo:setCurrentWordIndex(idx)
    for i, v in ipairs(g_BOOKKEYS) do
        if v == bookKey then
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
--    local bookWordTotalCount = s_DataManager.books[s_CURRENT_USER.bookKey].words
--    local avgWordCount = math.floor(s_DataManager.books[s_CURRENT_USER.bookKey].words / 100)
--    local bookWordCurrentCount =  s_LocalDatabaseManager.getCurrentIndex()-1
--    local currentLevelIndex = math.floor(bookWordCurrentCount/avgWordCount)
--    local currentChapterIndex = math.floor(currentLevelIndex/10)
--    currentLevelIndex =  9--test
--    local progress = {}
--    if currentLevelIndex < 10 then
--        progress['chapter'] = 'chapter0'
--        progress['level'] = 'level'..currentLevelIndex
----        progress['']
--    elseif currentLevelIndex < 30 then 
--        progress['chapter'] = 'chapter1'
--        progress['level'] = 'level'..(currentLevelIndex-10)
--    elseif currentLevelIndex < 60 then
--        progress['chapter'] = 'chapter2'
--        progress['level'] = 'level'..(currentLevelIndex-30)
--    else
--        progress['chapter'] = 'chapter3'
--        progress['level'] = 'level'..(currentLevelIndex-60)
--    end
--   local progress = {}
--   progress['chapter'] = 'chapter'..(currentChapterIndex)
--   progress['level'] = 'level'..(currentLevelIndex - 10*currentChapterIndex)   
--    return progress 
--    
    -- TODO test
--    return 10
     return s_LocalDatabaseManager.getMaxBossID()
end

function DataLevelInfo:getDataFromLocalDB()
    updateDataFromUser(self, s_CURRENT_USER)
    s_LocalDatabaseManager.getDatas(self.className, s_CURRENT_USER.objectId, s_CURRENT_USER.username, function (row)
        parseLocalDBDataToClientData(row, self)
    end)
end

function DataLevelInfo:updateDataToServer()
--    local currentProgress = self:computeCurrentProgress()
--    local oldProgress = self:getLevelInfo(s_CURRENT_USER.bookKey)
--    -- compute add beans count --
--    local increments = 0
--    local oldLevelIndex = string.sub(oldProgress['level'],  6)
--    local currentLevelIndex = string.sub(currentProgress['level'],6)
----    local current
--    if oldProgress['chapter'] == currentProgress['chapter'] then
--        increments = currentLevelIndex - oldLevelIndex
--    else
----        if oldProgress['chapter'] == 'chapter0' then
----            increments = 10 - oldLevelIndex + currentLevelIndex
----        elseif oldProgress['chapter'] == 'chapter1' then
----            increments = 20 - oldLevelIndex + currentLevelIndex
----        elseif oldProgress['chapter'] == 'chapter2' then
----            increments = 30 - oldLevelIndex + currentLevelIndex
----        elseif oldProgress['chapter'] == 'chapter3' then
----            increments = 40 - oldLevelIndex + currentLevelIndex
----        end
--        increments = 10 - oldLevelIndex + currentLevelIndex
--    end
    local currentProgress = self:computeCurrentProgress() 
    local oldProgress = self:getLevelInfo(s_CURRENT_USER.bookKey) 
    local increments = (currentProgress - oldProgress) * 2   -- add beans count
    s_CURRENT_USER:addBeans(increments)
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

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

function DataLevelInfo:ctor()
    self.className = 'DataLevelInfo'
    self.CET4 = 0    -- level index
    self.CET6 = 0
    self.GMAT = 0
    self.GRE = 0
    self.GSE = 0
    self.IELTS = 0
    self.MIDDLE = 0
    self.NCEE = 0
    self.PRIMARY = 0
    self.PRO4 = 0
    self.PRO8 = 0
    self.SAT = 0
    self.TOEFL = 0

    self.CET4BossList = ''
    self.CET6BossList = ''
    self.GMATBossList = ''
    self.GREBossList = ''
    self.GSEBossList = ''
    self.IELTSBossList = ''
    self.MIDDLEBossList = ''
    self.NCEEBossList = ''
    self.PRIMARYBossList = ''
    self.PRO4BossList = ''
    self.PRO8BossList = ''
    self.SATBossList = ''
    self.TOEFLBossList = ''

    self.CET4UpdateBossTime = 0
    self.CET6UpdateBossTime = 0
    self.GMATUpdateBossTime = 0
    self.GREUpdateBossTime = 0
    self.GSEUpdateBossTime = 0
    self.IELTSUpdateBossTime = 0
    self.MIDDLEUpdateBossTime = 0
    self.NCEEUpdateBossTime = 0
    self.PRIMARYUpdateBossTime = 0
    self.PRO4UpdateBossTime = 0
    self.PRO8UpdateBossTime = 0
    self.SATUpdateBossTime = 0
    self.TOEFLUpdateBossTime = 0    
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
    if bookKey == s_BOOK_KEY_CET4 then
        return self.CET4BossList
    elseif bookKey == s_BOOK_KEY_CET6 then
        return self.CET6BossList
    elseif bookKey == s_BOOK_KEY_GMAT then
        return self.GMATBossList
    elseif bookKey == s_BOOK_KEY_GRE then
        return self.GREBossList
    elseif bookKey == s_BOOK_KEY_GSE then
        return self.GSEBossList
    elseif bookKey == s_BOOK_KEY_IELTS then
        return self.IELTSBossList
    elseif bookKey == s_BOOK_KEY_MIDDLE then
        return self.MIDDLEBossList
    elseif bookKey == s_BOOK_KEY_NCEE then
        return self.NCEEBossList    
    elseif bookKey == s_BOOK_KEY_PRIMARY then
        return self.PRIMARYBossList 
    elseif bookKey == s_BOOK_KEY_PRO4 then
        return self.PRO4BossList
    elseif bookKey == s_BOOK_KEY_PRO8 then
        return self.PRO8BossList
    elseif bookKey == s_BOOK_KEY_SAT then
        return self.SATBossList
    elseif bookKey == s_BOOK_KEY_TOEFL then
        return self.TOEFLBossList
    end
end

function DataLevelInfo:getUpdateBossTime(bookKey)
    if bookKey == s_BOOK_KEY_CET4 then
        return self.CET4UpdateBossTime
    elseif bookKey == s_BOOK_KEY_CET6 then
        return self.CET6UpdateBossTime
    elseif bookKey == s_BOOK_KEY_GMAT then
        return self.GMATUpdateBossTime
    elseif bookKey == s_BOOK_KEY_GRE then
        return self.GREUpdateBossTime
    elseif bookKey == s_BOOK_KEY_GSE then
        return self.GSEUpdateBossTime
    elseif bookKey == s_BOOK_KEY_IELTS then
        return self.IELTSUpdateBossTime
    elseif bookKey == s_BOOK_KEY_MIDDLE then
        return self.MIDDLEUpdateBossTime
    elseif bookKey == s_BOOK_KEY_NCEE then
        return self.NCEEUpdateBossTime 
    elseif bookKey == s_BOOK_KEY_PRIMARY then
        return self.PRIMARYUpdateBossTime
    elseif bookKey == s_BOOK_KEY_PRO4 then
        return self.PRO4UpdateBossTime
    elseif bookKey == s_BOOK_KEY_PRO8 then
        return self.PRO8UpdateBossTime
    elseif bookKey == s_BOOK_KEY_SAT then
        return self.SATUpdateBossTime
    elseif bookKey == s_BOOK_KEY_TOEFL then
        return self.TOEFLUpdateBossTime
    end
end


function DataLevelInfo:updateBossList(bookKey,bossList)
    if bookKey == s_BOOK_KEY_CET4 then
        self.CET4BossList = bossList
    elseif bookKey == s_BOOK_KEY_CET6 then
        self.CET6BossList = bossList
    elseif bookKey == s_BOOK_KEY_GMAT then
        self.GMATBossList = bossList
    elseif bookKey == s_BOOK_KEY_GRE then
        self.GREBossList = bossList
    elseif bookKey == s_BOOK_KEY_GSE then
        self.GSEBossList = bossList
    elseif bookKey == s_BOOK_KEY_IELTS then
        self.IELTSBossList = bossList
    elseif bookKey == s_BOOK_KEY_MIDDLE then
        self.MIDDLEBossList = bossList
    elseif bookKey == s_BOOK_KEY_NCEE then
        self.NCEEBossList = bossList 
    elseif bookKey == s_BOOK_KEY_PRIMARY then
        self.PRIMARYBossList = bossList
    elseif bookKey == s_BOOK_KEY_PRO4 then
        self.PRO4BossList = bossList
    elseif bookKey == s_BOOK_KEY_PRO8 then
        self.PRO8BossList = bossList
    elseif bookKey == s_BOOK_KEY_SAT then
        self.SATBossList = bossList
    elseif bookKey == s_BOOK_KEY_TOEFL then
        self.TOEFLBossList = bossList
    end
    s_UserBaseServer.saveDataObjectOfCurrentUser(self) 
    s_LocalDatabaseManager.saveDataClassObject(self, self.userId, self.username)
end

function DataLevelInfo:updateTime(bookKey,updateTime)
    if bookKey == s_BOOK_KEY_CET4 then
        self.CET4UpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_CET6 then
        self.CET6UpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_GMAT then
        self.GMATUpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_GRE then
        self.GREUpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_GSE then
        self.GSEUpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_IELTS then
        self.IELTSUpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_MIDDLE then
        self.MIDDLEUpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_NCEE then
        self.NCEEUpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_PRIMARY then
        self.PRIMARYUpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_PRO4 then
        self.PRO4UpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_PRO8 then
        self.PRO8UpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_SAT then
        self.SATUpdateBossTime = updateTime
    elseif bookKey == s_BOOK_KEY_TOEFL then
        self.TOEFLUpdateBossTime = updateTime
    end
    s_UserBaseServer.saveDataObjectOfCurrentUser(self) 
    s_LocalDatabaseManager.saveDataClassObject(self, self.userId, self.username)
end

function DataLevelInfo:getLevelInfo(bookKey)
--    local progressData = {}

--    return 9
    if bookKey == s_BOOK_KEY_CET4 then
--        local data = split(self.CET4,'|')
--        progressData['book'] = data[1]
--        progressData['chapter'] = data[2]
--        progressData['level'] = data[3]
--        return progressData
        return self.CET4 + 0
    elseif bookKey == s_BOOK_KEY_CET6 then
        return self.CET6 + 0
    elseif bookKey == s_BOOK_KEY_GMAT then
        return self.GMAT + 0
    elseif bookKey == s_BOOK_KEY_GRE then
        return self.GRE + 0
    elseif bookKey == s_BOOK_KEY_GSE then
        return self.GSE + 0
    elseif bookKey == s_BOOK_KEY_IELTS then
        return self.IELTS + 0
    elseif bookKey == s_BOOK_KEY_MIDDLE then
        return self.MIDDLE + 0
    elseif bookKey == s_BOOK_KEY_NCEE then
        return self.NCEE + 0 
    elseif bookKey == s_BOOK_KEY_PRIMARY then
        return self.PRIMARY + 0
    elseif bookKey == s_BOOK_KEY_PRO4 then
        return self.PRO4 + 0
    elseif bookKey == s_BOOK_KEY_PRO8 then
        return self.PRO8 + 0
    elseif bookKey == s_BOOK_KEY_SAT then
        return self.SAT + 0 
    elseif bookKey == s_BOOK_KEY_TOEFL then
        return self.TOEFL + 0
    end
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
    if bookKey == s_BOOK_KEY_CET4 then
--        self.CET4 = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
        self.CET4 = currentProgress
    elseif bookKey == s_BOOK_KEY_CET6 then
        self.CET6 = currentProgress
    elseif bookKey == s_BOOK_KEY_GMAT then
        self.GMAT = currentProgress
    elseif bookKey == s_BOOK_KEY_GRE then
        self.GRE = currentProgress
    elseif bookKey == s_BOOK_KEY_GSE then
        self.GSE = currentProgress
    elseif bookKey == s_BOOK_KEY_IELTS then
        self.IELTS = currentProgress
    elseif bookKey == s_BOOK_KEY_MIDDLE then
        self.MIDDLE = currentProgress
    elseif bookKey == s_BOOK_KEY_NCEE then
        self.NCEE = currentProgress   
    elseif bookKey == s_BOOK_KEY_PRIMARY then
        self.PRIMARY = currentProgress
    elseif bookKey == s_BOOK_KEY_PRO4 then
        self.PRO4 = currentProgress
    elseif bookKey == s_BOOK_KEY_PRO8 then
        self.PRO8 = currentProgress
    elseif bookKey == s_BOOK_KEY_SAT then
        self.SAT = currentProgress
    elseif bookKey == s_BOOK_KEY_TOEFL then
        self.TOEFL = currentProgress
    end
    s_UserBaseServer.saveDataObjectOfCurrentUser(self) 
    s_LocalDatabaseManager.saveDataClassObject(self, self.userId, self.username)
end

return DataLevelInfo

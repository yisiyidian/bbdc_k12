require("cocos.init")
require("common.global")
local DataClassBase = require('model/user/DataClassBase')

local DataBookProgress = class("DataBookProgress", function()
    return DataClassBase.new()
end)
function DataBookProgress.create()
    local data = DataBookProgress.new()
    return data
end

function DataBookProgress:ctor()
    self.className = 'DataBookProgress'
    self.CET4 = 'cet4|chapter0|level0'
    self.CET6 = 'cet6|chapter0|level0'
    self.GMAT = 'gmat|chapter0|level0'
    self.GRE = 'gre|chapter0|level0'
    self.GSE = 'gse|chapter0|level0'
    self.IELTS = 'ielts|chapter0|level0'
    self.MIDDLE = 'middle|chapter0|level0'
    self.NCEE = 'ncee|chapter0|level0'
    self.PRIMARY = 'primary|chapter0|level0'
    self.PRO4 = 'pro4|chapter0|level0'
    self.PRO8 = 'pro8|chapter0|level0'
    self.SAT = 'sat|chapter0|level0'
    self.TOEFL = 'toefl|chapter0|level0'

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

function DataBookProgress:getBookCurrentLevelIndex()
    local progress = self:getBookProgress(s_CURRENT_USER.bookKey)
    local levelIndex = string.sub(progress['level'],6)+0
    if progress['chapter'] == 'chapter1' then
        levelIndex = levelIndex + 10
    elseif progress['chapter'] == 'chapter2' then
        levelIndex = levelIndex + 30
    elseif progress['chapter'] == 'chapter3' then
        levelIndex = levelIndex + 60
    end
    return levelIndex
end

function DataBookProgress:getBossList(bookKey)
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

function DataBookProgress:getUpdateBossTime(bookKey)
    print('bookKey'..bookKey)
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


function DataBookProgress:updateBossList(bookKey,bossList)
    print('update boss List:'..bookKey..','..bossList)
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
    s_UserBaseServer.saveDataObjectOfCurrentUser(self,
        function(api,result)
        end,
        function(api, code, message, description)
        end) 
end

function DataBookProgress:updateTime(bookKey,updateTime)
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
    s_UserBaseServer.saveDataObjectOfCurrentUser(self,
        function(api,result)
        end,
        function(api, code, message, description)
        end) 
end

function DataBookProgress:getBookProgress(bookKey)
    local progressData = {}
    if bookKey == s_BOOK_KEY_CET4 then
        local data = split(self.CET4,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_CET6 then
        local data = split(self.CET6,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_GMAT then
        local data = split(self.GMAT,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_GRE then
        local data = split(self.GRE,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_GSE then
        local data = split(self.GSE,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_IELTS then
        local data = split(self.IELTS,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_MIDDLE then
        local data = split(self.MIDDLE,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_NCEE then
        local data = split(self.NCEE,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData    
    elseif bookKey == s_BOOK_KEY_PRIMARY then
        local data = split(self.PRIMARY,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData 
    elseif bookKey == s_BOOK_KEY_PRO4 then
        local data = split(self.PRO4,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_PRO8 then
        local data = split(self.PRO8,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_SAT then
        local data = split(self.SAT,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    elseif bookKey == s_BOOK_KEY_TOEFL then
        local data = split(self.TOEFL,'|')
        progressData['book'] = data[1]
        progressData['chapter'] = data[2]
        progressData['level'] = data[3]
        return progressData
    end
end

function DataBookProgress:computeCurrentProgress()
    local bookWordTotalCount = s_DATA_MANAGER.books[s_CURRENT_USER.bookKey].words
    local avgWordCount = math.floor(s_DATA_MANAGER.books[s_CURRENT_USER.bookKey].words / 100)
    local bookWordCurrentCount =  s_DATABASE_MGR.getCurrentIndex()-1
    local currentLevelIndex = math.floor(bookWordCurrentCount/avgWordCount)
--    currentLevelIndex =10
    local progress = {}
    if currentLevelIndex < 10 then
        progress['chapter'] = 'chapter0'
        progress['level'] = 'level'..currentLevelIndex
--        progress['']
    elseif currentLevelIndex < 30 then 
        progress['chapter'] = 'chapter1'
        progress['level'] = 'level'..(currentLevelIndex-10)
    elseif currentLevelIndex < 60 then
        progress['chapter'] = 'chapter2'
        progress['level'] = 'level'..(currentLevelIndex-30)
    else
        progress['chapter'] = 'chapter3'
        progress['level'] = 'level'..(currentLevelIndex-60)
    end
    
    -- avoid complete state
    if progress['chapter'] == 'chapter3' and string.sub(progress['level'],6)-39 > 0 then
        progress['level'] = 'level39'
    end
    
    return progress 
end

function DataBookProgress:updateDataToServer()
    local currentProgress = self:computeCurrentProgress()
    local oldProgress = self:getBookProgress(s_CURRENT_USER.bookKey)
    -- compute add beans count --
    local increments = 0
    local oldLevelIndex = string.sub(oldProgress['level'],  6)
    local currentLevelIndex = string.sub(currentProgress['level'],6)
    if oldProgress['chapter'] == currentProgress['chapter'] then
        increments = currentLevelIndex - oldLevelIndex
    else
        if oldProgress['chapter'] == 'chapter0' then
            increments = 10 - oldLevelIndex + currentLevelIndex
        elseif oldProgress['chapter'] == 'chapter1' then
            increments = 20 - oldLevelIndex + currentLevelIndex
        elseif oldProgress['chapter'] == 'chapter2' then
            increments = 30 - oldLevelIndex + currentLevelIndex
        elseif oldProgress['chapter'] == 'chapter3' then
            increments = 40 - oldLevelIndex + currentLevelIndex
        end
    end
    s_CURRENT_USER:addBeans(increments)
    -----------------------------
    bookKey = s_CURRENT_USER.bookKey
    if bookKey == s_BOOK_KEY_CET4 then
        self.CET4 = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_CET6 then
        self.CET6 = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
        return progressData
    elseif bookKey == s_BOOK_KEY_GMAT then
        self.GMAT = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_GRE then
        self.GRE = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_GSE then
        self.GSE = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_IELTS then
        self.IELTS = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_MIDDLE then
        self.MIDDLE = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_NCEE then
        self.NCEE = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']    
    elseif bookKey == s_BOOK_KEY_PRIMARY then
        self.PRIMARY = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_PRO4 then
        self.PRO4 = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_PRO8 then
        self.PRO8 = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_SAT then
        self.SAT = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    elseif bookKey == s_BOOK_KEY_TOEFL then
        self.TOEFL = bookKey..'|'..currentProgress['chapter']..'|'..currentProgress['level']
    end
    s_UserBaseServer.saveDataObjectOfCurrentUser(self,
        function(api,result)
        end,
        function(api, code, message, description)
        end) 
end

return DataBookProgress

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
    self.CET4 = 'cet4|chapter0|level3'
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
end

function DataBookProgress:getBookCurrentLevelIndex()
    local progress = self:getBookProgress(s_CURRENT_USER.bookKey)
    local levelIndex = progress['level']+0
    if progress['chapter'] == 'chapter1' then
        levelIndex = levelIndex + 10
    elseif progress['chapter'] == 'chapter2' then
        levelIndex = levelIndex + 30
    elseif progress['chapter'] == 'chapter3' then
        levelIndex = levelIndex + 60
    end
    return levelIndex
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
    currentLevelIndex = 6
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
    return progress 
end

function DataBookProgress:updateDataToServer(bookKey)
    local currentProgress = self:computeCurrentProgress()
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

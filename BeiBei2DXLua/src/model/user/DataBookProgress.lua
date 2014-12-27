require("cocos.init")
require("common.global")
local DataClassBase = require('model/user/DataClassBase')

local DataBookProgress = class("DataBookProgress", function()
    return DataClassBase.new()
end)
s_BOOK_KEY_CET4     = 'cet4'
s_BOOK_KEY_CET6     = 'cet6'
s_BOOK_KEY_GMAT     = 'gmat'
s_BOOK_KEY_GRE      = 'gre'
s_BOOK_KEY_GSE      = 'gse'
s_BOOK_KEY_IELTS    = 'ielts'
s_BOOK_KEY_MIDDLE   = 'middle'
s_BOOK_KEY_NCEE     = 'ncee'
s_BOOK_KEY_PRIMARY  = 'primary'
s_BOOK_KEY_PRO4     = 'pro4'
s_BOOK_KEY_PRO8     = 'pro8'
s_BOOK_KEY_SAT      = 'sat'
s_BOOK_KEY_TOEFL    = 'toefl'
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
end

function DataBookProgress:getBookProgress(bookKey)
    local progressData = {}
    if bookKey == s_BOOK_KEY_CET4 then
        local data = string.split(self.CET4,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_CET6 then
        local data = string.split(self.CET6,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_GMAT then
        local data = string.split(self.GMAT,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_GRE then
        local data = string.split(self.GRE,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_GSE then
        local data = string.split(self.GSE,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_IELTS then
        local data = string.split(self.IELTS,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_MIDDLE then
        local data = string.split(self.MIDDLE,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_NCEE then
        local data = string.split(self.NCEE,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData    
    elseif bookKey == s_BOOK_KEY_PRIMARY then
        local data = string.split(self.PRIMARY,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData 
    elseif bookKey == s_BOOK_KEY_PRO4 then
        local data = string.split(self.PRO4,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_PRO8 then
        local data = string.split(self.PRO8,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_SAT then
        local data = string.split(self.SAT,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    elseif bookKey == s_BOOK_KEY_TOEFL then
        local data = string.split(self.TOEFL,'|')
        progressData['book'] = data[0]
        progressData['chapter'] = data[1]
        progressData['level'] = data[2]
        return progressData
    end
end

return DataBookProgress

local DataClassBase = require('model.user.DataClassBase')

-- record count == book count
-- 保存复习BOSS数据

local DataWord = class("DataWord", function()
    return DataClassBase.new()
end)

function DataWord.create()
    local data = DataWord.new()
    return data
end

function DataWord:ctor()
    self.className          = 'DataWord'
    
    self.wordName           =   ''
    self.wordSoundMarkEn    =   ''
    self.wordSoundMarkAm    =   ''
    self.wordMeaningSmall   =   ''
    self.wordMeaning        =   ''
    self.sentenceEn         =   ''
    self.sentenceCn         =   ''
    self.sentenceEn2        =   ''
    self.sentenceCn2        =   ''
end

return DataWord

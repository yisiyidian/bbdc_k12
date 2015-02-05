local DataWord = require('model.user.DataWord')
local Manager = s_LocalDatabaseManager

local M = {}

local function createData(wordName, wordSoundMarkEn, wordSoundMarkAm, wordMeaningSmall, wordMeaning, sentenceEn, sentenceCn, sentenceEn2, sentenceCn2)
    local data = DataWord.create()

    data.wordName           =   wordName
    data.wordSoundMarkEn    =   wordSoundMarkEn
    data.wordSoundMarkAm    =   wordSoundMarkAm
    data.wordMeaningSmall   =   wordMeaningSmall
    data.wordMeaning        =   wordMeaning
    data.sentenceEn         =   sentenceEn
    data.sentenceCn         =   sentenceCn
    data.sentenceEn2        =   sentenceEn2
    data.sentenceCn2        =   sentenceCn2

    return data
end


function M.getWordInfoFromWordName(wordName)
    local word = {}
    for row in Manager.database:nrows("SELECT * FROM DataWord WHERE wordName = '"..wordName.."' ;") do
        word.wordName           =   row.wordName
        word.wordSoundMarkEn    =   string.gsub(row.wordSoundMarkEn, '"', "'")
        word.wordSoundMarkAm    =   string.gsub(row.wordSoundMarkAm, '"', "'")
        word.wordMeaningSmall   =   row.wordMeaningSmall
        word.wordMeaning        =   row.wordMeaning
        word.sentenceEn         =   string.gsub(row.sentenceEn, '"', "'")
        word.sentenceCn         =   row.sentenceCn
        word.sentenceEn2        =   string.gsub(row.sentenceEn2, '"', "'")
        word.sentenceCn2        =   row.sentenceCn2
    end
    return word
end








return M
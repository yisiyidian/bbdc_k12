require("Cocos2d")
require("Cocos2dConstants")

local Word = class("Word", function()
    return {}
end)

function Word.create(wordName, wordSoundMarkAm, wordSoundMarkEn, wordMeaning, wordMeaningSmall, sentenceEn, sentenceCn)
    local main = Word.new()
    main.wordName = wordName
    main.wordSoundMarkAm = wordSoundMarkAm
    main.wordSoundMarkEn = wordSoundMarkEn
    main.wordMeaning = wordMeaning
    main.wordMeaningSmall = wordMeaningSmall
    main.sentenceEn = sentenceEn
    main.sentenceCn = sentenceCn
    return main
end

return Word


local Word = class("Word", function()
    return {}
end)

function Word.create(wordName, wordSoundMarkEn, wordSoundMarkAm, wordMeaning, wordMeaningSmall, sentenceEn, sentenceCn)
    local main = Word.new()
    main.wordName = wordName
    main.wordSoundMarkEn = wordSoundMarkEn
    main.wordSoundMarkAm = wordSoundMarkAm
    main.wordMeaning = wordMeaning
    main.wordMeaningSmall = wordMeaningSmall
    main.sentenceEn = sentenceEn
    main.sentenceCn = sentenceCn
    return main
end

return Word

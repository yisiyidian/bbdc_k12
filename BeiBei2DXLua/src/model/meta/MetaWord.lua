
local MetaWord = class("MetaWord", function()
    return {}
end)

function MetaWord.create(wordName, wordSoundMarkEn, wordSoundMarkAm, wordMeaning, wordMeaningSmall, sentenceEn, sentenceCn)
    local main = MetaWord.new()
    main.wordName = wordName
    main.wordSoundMarkEn = wordSoundMarkEn
    main.wordSoundMarkAm = wordSoundMarkAm
    main.wordMeaning = wordMeaning
    main.wordMeaningSmall = wordMeaningSmall
    main.sentenceEn = sentenceEn
    main.sentenceCn = sentenceCn
    return main
end

return MetaWord

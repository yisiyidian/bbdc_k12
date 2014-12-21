
local MetaWord = class("MetaWord", function()
    return {}
end)

function MetaWord.create(wordName, wordSoundMarkEn, wordSoundMarkAm, wordMeaningSmall, wordMeaning, sentenceEn, sentenceCn, sentenceEn2, sentenceCn2)
    local main              =   MetaWord.new()
    main.wordName           =   wordName
    main.wordSoundMarkEn    =   wordSoundMarkEn
    main.wordSoundMarkAm    =   wordSoundMarkAm
    main.wordMeaningSmall   =   wordMeaningSmall
    main.wordMeaning        =   wordMeaning
    main.sentenceEn         =   sentenceEn
    main.sentenceCn         =   sentenceCn
    main.sentenceEn2        =   sentenceEn2
    main.sentenceCn2        =   sentenceCn2
    return main
end

return MetaWord

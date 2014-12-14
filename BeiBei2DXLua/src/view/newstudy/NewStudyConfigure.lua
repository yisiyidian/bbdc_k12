NewStudyLayer_State_Choose = 1
NewStudyLayer_State_True = 2
NewStudyLayer_State_Wrong = 3
NewStudyLayer_State_Slide = 4
NewStudyLayer_State_Mission = 5
NewStudyLayer_State_Reward = 6
NewStudyLayer_State = 1

-- s_CURRENT_USER.isSoundAm = 0
Pronounce_Mark_US = 1
currentIndex_unjudge = 1
currentIndex_unreview = 1

--judge or review
current_state_judge = 1

NewStudyLayer_wordList_currentWord = ''

if NewStudyLayer_wordList_currentWord ~= nil then
    NewStudyLayer_wordList_wordName              =   NewStudyLayer_wordList_currentWord.wordName
    NewStudyLayer_wordList_wordSoundMarkEn       =   NewStudyLayer_wordList_currentWord.wordSoundMarkEn
    NewStudyLayer_wordList_wordSoundMarkAm       =   NewStudyLayer_wordList_currentWord.wordSoundMarkAm
    NewStudyLayer_wordList_wordMeaning           =   NewStudyLayer_wordList_currentWord.wordMeaning
    NewStudyLayer_wordList_wordMeaningSmall      =   NewStudyLayer_wordList_currentWord.wordMeaningSmall
    NewStudyLayer_wordList_sentenceEn            =   NewStudyLayer_wordList_currentWord.sentenceEn
    NewStudyLayer_wordList_sentenceCn            =   NewStudyLayer_wordList_currentWord.sentenceCn
end

--rightWordList         = {}
wrongWordList         = {}
wrongWordList_success_review = {}
maxWrongWordCount     = 20

SilverFont = cc.c4b(134,167,218,255)
LightBlueFont = cc.c4b(39,127,182,255)
DeepBlueFont = cc.c4b(31,70,102,255)
BlueInButtonFont = cc.c4b(22,116,173,255)
DeepRedFont = cc.c4b(243,27,26,255)
LightRedFont = cc.c4b(255,72,76,255)
WhiteFont = cc.c4b(255,255,255,255)
BlackFont = cc.c4b(0,0,0,255)
YellowFont = cc.c4b(227,236,82,255)
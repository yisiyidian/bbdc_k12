require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local NewStudyLayer = class("NewStudyLayer", function ()
    return cc.Layer:create()
end)

NewStudyLayer_State_Choose = 1
NewStudyLayer_State_True = 2
NewStudyLayer_State_Wrong = 3
NewStudyLayer_State_Slide = 4
NewStudyLayer_State_Mission = 5
NewStudyLayer_State_Reward = 6

-- s_CURRENT_USER.isSoundAm = 0
Pronounce_Mark_US = 1
currentIndex_unjudge = 1
currentIndex_unreview = 1

--judge or review
current_state_judge = 1

s_WordPool = s_DATA_MANAGER.loadAllWords()
NewStudyLayer_wordList  =   {"happy", "many", "where", "yellow", "shamble", "sad", "narcotic", "sunlit", "lord", "moon",
    "mirage", "woody", "centimeter", "aggression", "regularize", "electricity", "unanswered", "hormone", "gush", "ornamental",
    "preface", "postpone", "relax", "pursue", "therefore", "damage", "estimate", "undeveloped", "underlie", "hypothetical",
"pulse", "conversational", "successful", "travel", "vast", "scholar", "restriction", "instruct", "underfoot", "subduction",
"elegant", "criticism", "numerical", "classify", "admirable", "volcano", "chlorine", "clarity", "architect", "crawl",
"sterile", "paperwork", "hurl", "modulation", "glorify", "telescope", "piecemeal", "basketball", "bitter", "predictable",
"inanimate", "topography", "blade", "despondent", "songwriter", "abuse", "purpose", "service", "listen", "wisdom",
"blouse", "psychological", "artillery", "modest", "enrich", "ameliorate", "shopper", "engagement", "dozen", "trek",
"elaborate", "strike", "example", "keelboat", "slate", "ring", "wasp", "fabrication", "runner", "collapse",
"ruthless", "handedness", "validity", "foodstuff", "commemorate", "misfortune", "subtlety", "Incur", "entail", "fibrous",
"numeral", "cocaine", "absolute", "unforeseen", "silver", "sensory", "wash", "escalator", "icicle", "convention",}

if current_state_judge == 1 then
    NewStudyLayer_wordList_currentWord           =   s_WordPool[NewStudyLayer_wordList[currentIndex_unjudge]]

else 
    NewStudyLayer_wordList_currentWord           =   s_WordPool[wrongWordList[currentIndex_unreview]]
end

if NewStudyLayer_wordList_currentWord ~= nil then
    NewStudyLayer_wordList_wordName              =   NewStudyLayer_wordList_currentWord.wordName
    NewStudyLayer_wordList_wordSoundMarkEn       =   NewStudyLayer_wordList_currentWord.wordSoundMarkEn
    NewStudyLayer_wordList_wordSoundMarkAm       =   NewStudyLayer_wordList_currentWord.wordSoundMarkAm
    NewStudyLayer_wordList_wordMeaning           =   NewStudyLayer_wordList_currentWord.wordMeaning
    NewStudyLayer_wordList_wordMeaningSmall      =   NewStudyLayer_wordList_currentWord.wordMeaningSmall
    NewStudyLayer_wordList_sentenceEn            =   NewStudyLayer_wordList_currentWord.sentenceEn
    NewStudyLayer_wordList_sentenceCn            =   NewStudyLayer_wordList_currentWord.sentenceCn
end

rightWordList         = {}
wrongWordList         = {}
wrongWordList_success_review = {}
maxWrongWordCount     = 8



function NewStudyLayer.create(viewstate)
    local layer = NewStudyLayer.new(viewstate)
    
    s_DATABASE_MGR:initNewStudyLayerSufferTables()
    s_DATABASE_MGR:initNewStudyLayerFamiliarTables()
    s_DATABASE_MGR:initNewStudyLayerUnfamiliarTables()
    s_DATABASE_MGR:initNewStudyLayerTestTables()
    
    local lastFamiliarWord = s_DATABASE_MGR:selectLastNewStudyLayerFamiliarTables()
    if lastFamiliarWord == 0 then
    else
    end
    print("lastFamiliarWord is"..lastFamiliarWord)
    
    local lastUnfamiliarWord = s_DATABASE_MGR:selectLastNewStudyLayerUnfamiliarTables()
    if lastUnfamiliarWord == 0 then
    else
    end
    print("lastUnfamiliarWord is"..lastUnfamiliarWord)
    
    local lastSufferWord = s_DATABASE_MGR:selectLastNewStudyLayerSufferTables()
    if lastUnfamiliarWord == 0 then
    else
    end
    print("lastSufferWord is"..lastSufferWord)
    
    local lastFamiliarIndex = table.foreachi(NewStudyLayer_wordList, function(i, v)  if v == lastFamiliarWord then return i end  end)
    local lastUnfamiliarIndex = table.foreachi(NewStudyLayer_wordList, function(i, v)  if v == lastUnfamiliarWord then return i end  end)
    local lastSufferIndex = table.foreachi(NewStudyLayer_wordList, function(i, v)  if v == lastSufferWord then return i end  end)
    
    local lastIndex = lastFamiliarIndex
    
    if lastIndex < lastUnfamiliarIndex then
        lastIndex = lastUnfamiliarIndex
    end
    
    if lastIndex < lastSufferIndex then
        lastIndex = lastSufferIndex
    end
    
    print("lastIndex is "..lastIndex)
    
    local nowIndex = lastIndex + 1
    
--    if current_state_judge == 1 then
--        NewStudyLayer_wordList_currentWord           =   s_WordPool[NewStudyLayer_wordList[nowIndex]]
--
--    else 
--        NewStudyLayer_wordList_currentWord           =   s_WordPool[wrongWordList[currentIndex_unreview]]
--    end
--
--    if NewStudyLayer_wordList_currentWord ~= nil then
--        NewStudyLayer_wordList_wordName              =   NewStudyLayer_wordList_currentWord.wordName
--        NewStudyLayer_wordList_wordSoundMarkEn       =   NewStudyLayer_wordList_currentWord.wordSoundMarkEn
--        NewStudyLayer_wordList_wordSoundMarkAm       =   NewStudyLayer_wordList_currentWord.wordSoundMarkAm
--        NewStudyLayer_wordList_wordMeaning           =   NewStudyLayer_wordList_currentWord.wordMeaning
--        NewStudyLayer_wordList_wordMeaningSmall      =   NewStudyLayer_wordList_currentWord.wordMeaningSmall
--        NewStudyLayer_wordList_sentenceEn            =   NewStudyLayer_wordList_currentWord.sentenceEn
--        NewStudyLayer_wordList_sentenceCn            =   NewStudyLayer_wordList_currentWord.sentenceCn
--    end
    
    
    s_CURRENT_USER:getUserBookWord()


--    print("table.concat(rightWordList")
--
--    print(table.concat(rightWordList, ", "))
--
--    print("table.concat(wrongWordList")
--
--    print(table.concat(wrongWordList, ", "))
--
--    print("table.concat(wrongWordList_success_review")
--
--    print(table.concat(wrongWordList_success_review, ", "))
    

    -- fake data, you can add if not enough
    
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH


    
    local backColor = cc.LayerColor:create(cc.c4b(255,255,255,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)

    --TODO for houqi:
    -- code about new study layer
    -- record right word list and wrong word list
    -- end if 20 wrong words have been generate
   
    
    --NewStudyLayer_State_Choose
    if viewstate == NewStudyLayer_State_Choose then
    
        local NewStudyChooseLayer = require("view.newstudy.NewStudyChooseLayer")
        local newStudyChooseLayer = NewStudyChooseLayer.create()
        backColor:addChild(newStudyChooseLayer)
        
    --NewStudyLayer_State_True
    elseif viewstate == NewStudyLayer_State_True then
        
        local NewStudyTrueLayer = require("view.newstudy.NewStudyTrueLayer")
        local newStudyTrueLayer = NewStudyTrueLayer.create()
        backColor:addChild(newStudyTrueLayer)
        
    --NewStudyLayer_State_Wrong
    elseif viewstate == NewStudyLayer_State_Wrong then
    
        local NewStudyWrongLayer = require("view.newstudy.NewStudyWrongLayer")
        local newStudyWrongLayer = NewStudyWrongLayer.create()
        backColor:addChild(newStudyWrongLayer)
   
    --NewStudyLayer_State_Slide
    elseif viewstate == NewStudyLayer_State_Slide then 
    
        local NewStudySlideLayer = require("view.newstudy.NewStudySlideLayer")
        local newStudySlideLayer = NewStudySlideLayer.create()
        backColor:addChild(newStudySlideLayer)

    --NewStudyLayer_State_Mission
    elseif viewstate == NewStudyLayer_State_Mission then
    
        local NewStudyMissionLayer = require("view.newstudy.NewStudyMissionLayer")
        local newStudyMissionLayer = NewStudyMissionLayer.create()
        backColor:addChild(newStudyMissionLayer)
        
    --NewStudyLayer_State_Reward
    elseif viewstate == NewStudyLayer_State_Reward then
    
        local NewStudyRewardLayer = require("view.newstudy.NewStudyRewardLayer")
        local newStudyRewardLayer = NewStudyRewardLayer.create()
        backColor:addChild(newStudyRewardLayer)
        
    end
 
    
    return layer
end



return NewStudyLayer

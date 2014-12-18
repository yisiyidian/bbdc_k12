require("cocos.init")

require("common.global")

require("view.newreviewboss.NewReviewBossConfigue")

local NewReviewBossLayer = class("NewReviewBossLayer", function ()
    return cc.Layer:create()
end)

s_WordPool = s_DATA_MANAGER.loadAllWords()
currentIndex = 1

NewReviewBossLayer_wordList  =   {"happy", "many", "where", "yellow", "shamble", "sad", "narcotic", "sunlit", "lord", "moon",
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


NewStudyLayer_wordList_currentWord           =   s_WordPool[NewReviewBossLayer_wordList[currentIndex]]
NewStudyLayer_wordList_wordName              =   NewStudyLayer_wordList_currentWord.wordName
NewStudyLayer_wordList_wordSoundMarkEn       =   NewStudyLayer_wordList_currentWord.wordSoundMarkEn
NewStudyLayer_wordList_wordSoundMarkAm       =   NewStudyLayer_wordList_currentWord.wordSoundMarkAm
NewStudyLayer_wordList_wordMeaning           =   NewStudyLayer_wordList_currentWord.wordMeaning
NewStudyLayer_wordList_wordMeaningSmall      =   NewStudyLayer_wordList_currentWord.wordMeaningSmall
NewStudyLayer_wordList_sentenceEn            =   NewStudyLayer_wordList_currentWord.sentenceEn
NewStudyLayer_wordList_sentenceCn            =   NewStudyLayer_wordList_currentWord.sentenceCn



function NewReviewBossLayer.create(NewReviewBossLayer_State)
    local layer = NewReviewBossLayer.new(NewReviewBossLayer_State)

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(255,255,255,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
    
    if NewReviewBossLayer_State == NewReviewBossLayer_State_Main then

        local NewReviewBossLayerChange = require("view.newreviewboss.NewReviewBossLayerMain")
        local newReviewBossLayerChange = NewReviewBossLayerChange.create()
        backColor:addChild(newReviewBossLayerChange)
    

        

    end


    return layer
end



return NewReviewBossLayer

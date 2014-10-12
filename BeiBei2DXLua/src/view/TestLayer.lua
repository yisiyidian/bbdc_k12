require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local ProgressBar = require("view.ProgressBar")
local FlipMat = require("view.FlipMat")


local TestLayer = class("TestLayer", function ()
    return cc.Layer:create()
end)


function TestLayer.create()
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()

    local layer = TestLayer.new()

    local word = s_CorePlayManager.currentWord
    local wordName = word.wordName
    local wordSoundMarkEn = word.wordSoundMarkEn
    local wordSoundMarkAm = word.wordSoundMarkAm
    local wordMeaning = word.wordMeaning
    local wordMeaningSmall = word.wordMeaningSmall
    local sentenceEn = word.sentenceEn
    local sentenceCn = word.sentenceCn

    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local backColor = cc.LayerColor:create(cc.c4b(61,191,243,255), size.width, size.height)    
    layer:addChild(backColor)

    local button_changeview
    local button_changeview_clicked
    local button_detail
    local button_detail_clicked

    local cloud_up = cc.Sprite:create("image/studyscene/studyscene_cloud_white_top.png")
    cloud_up:ignoreAnchorPointForPosition(false)
    cloud_up:setAnchorPoint(0.5, 1)
    cloud_up:setPosition(size.width/2, size.height)
    layer:addChild(cloud_up)

    local cloud_down = cc.Sprite:create("image/studyscene/studyscene_cloud_white_down.png")
    cloud_down:ignoreAnchorPointForPosition(false)
    cloud_down:setAnchorPoint(0.5, 0)
    cloud_down:setPosition(size.width/2, 0)
    layer:addChild(cloud_down)

    local beach = cc.Sprite:create("image/studyscene/studyscene_beach_down.png")
    beach:ignoreAnchorPointForPosition(false)
    beach:setAnchorPoint(0.5, 0)
    beach:setPosition(size.width/2, 0)
    layer:addChild(beach)

    local size_big = cloud_down:getContentSize()

    local progressBar = ProgressBar.create(#s_CorePlayManager.wordList,s_CorePlayManager.currentWordIndex)
    progressBar:setPositionY(1038)
    layer:addChild(progressBar)
    
    local label_wordmeaningSmall = cc.Label:createWithSystemFont(word.wordMeaningSmall,"",48)
    label_wordmeaningSmall:setColor(cc.c4b(0,0,0,255))
    label_wordmeaningSmall:setPosition(size.width/2, 896)
    layer:addChild(label_wordmeaningSmall)

    local success = function()
        local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_right_back.png")
        showAnswerStateBack:setPosition(size.width/2, 768)
        layer:addChild(showAnswerStateBack)

        local sign = cc.Sprite:create("image/testscene/testscene_right_v.png")
        sign:setPosition(showAnswerStateBack:getContentSize().width*0.9, showAnswerStateBack:getContentSize().height*0.45)
        showAnswerStateBack:addChild(sign)

        local right_wordname = cc.Label:createWithSystemFont(word.wordName,"",60)
        right_wordname:setColor(cc.c4b(130,186,47,255))
        right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
        right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
        showAnswerStateBack:addChild(right_wordname)
    
        if s_CorePlayManager.currentWordIndex < #s_CorePlayManager.wordList then
            s_CorePlayManager.currentWordIndex = s_CorePlayManager.currentWordIndex + 1
            s_CorePlayManager.enterTestLayer()
        else
            print("pass all word in this level")
        end
    end

    local fail = function()
        local showAnswerStateBack = cc.Sprite:create("image/testscene/testscene_wrong_back.png")
        showAnswerStateBack:setPosition(size.width/2, 768)
        layer:addChild(showAnswerStateBack)
        
        local sign = cc.Sprite:create("image/testscene/testscene_wrong_x.png")
        sign:setPosition(showAnswerStateBack:getContentSize().width*0.1, showAnswerStateBack:getContentSize().height*0.45)
        showAnswerStateBack:addChild(sign)
        
        local right_wordname = cc.Label:createWithSystemFont(word.wordName,"",60)
        right_wordname:setColor(cc.c4b(202,66,64,255))
        right_wordname:setPosition(showAnswerStateBack:getContentSize().width*0.5, showAnswerStateBack:getContentSize().height*0.45)
        right_wordname:setScale(math.min(300/right_wordname:getContentSize().width,1))
        showAnswerStateBack:addChild(right_wordname)
    end

    local mat = FlipMat.create(wordName,4,4)
    mat:setPosition(size_big.width/2, 100)
    cloud_down:addChild(mat)

    mat.success = success
    mat.fail = fail
    mat.rightLock = true
    mat.wrongLock = true

    local progress_back = cc.Sprite:create("image/progress/progressB1.png")
    progress_back:setPosition(size.width/2, 100)
    layer:addChild(progress_back)
    
    local progress = cc.ProgressTimer:create(cc.Sprite:create("image/progress/progressF1.png"))
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setPosition(progress_back:getPosition())
    progress:setPercentage(80)
    layer:addChild(progress)
    
    local aaa = function()
        local current_percentage = progress:getPercentage()
        current_percentage = current_percentage - 0.1
        if current_percentage >= 0 then
            progress:setPercentage(current_percentage)
        else
            progress:setPercentage(0)
            
            -- time out
            mat.globalLock = true
        end
    end
    
    local scheduler = cc.Director:getInstance():getScheduler()
    local schedulerEntry = scheduler:scheduleScriptFunc(aaa, 0.01, false)
    
    return layer
end

return TestLayer
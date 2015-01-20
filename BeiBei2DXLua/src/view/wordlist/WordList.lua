--New word list, added in version 1.8.0.0
require("cocos.init")
require("common.global")

local WordList = class("WordList", function ()
    return cc.Layer:create()
end)

function WordList.create()
    
    local worldList = WordList.new()
    worldList:createBackground()

    return worldList
end

local function getWords(type)

    local words

    if type[1] == "ALL" then

        if type[2] == "GRASP" then
            words = s_LocalDatabaseManager.getGraspWords()
        elseif type[2] == "WRONG" then

        elseif type[2] == "ALL" then

        end
    elseif type[1] == "STAGE"
        if type[2] == "GRASP" then
        elseif type[2] == "WRONG" then
        elseif type[2] == "ALL" then
        end       
    end

    words.small_meaning = {}
    words.meaning       = {}
    words.sentenceEn    = {}
    words.sentenceCn    = {}
    
    for i = 1,#word  do
        print("s_WordPool[words[i]].wordMeaningSmall is"..s_WordPool[words[i]].wordMeaningSmall)
        print("string.gsub(s_WordPool[words[i]].wordMeaning is" ..string.gsub(s_WordPool[words[i]].wordMeaning,"|||"," "))
        print("s_WordPool[words[i]].sentenceEn is "..s_WordPool[words[i]].sentenceEn)
        print("s_WordPool[words[i]].sentenceCn is "..s_WordPool[words[i]].sentenceCn)
        
        words.small_meaning[i] = s_WordPool[words[i]].wordMeaningSmall
        words.meaning[i]       = string.gsub(s_WordPool[words[i]].wordMeaning,"|||"," ")
        words.sentenceEn[i]    = s_WordPool[words[i]].sentenceEn
        words.sentenceCn[i]    = s_WordPool[words[i]].sentenceCn
    end

    return words
end

local function createWordListview()

end

local function createButtons()

    local buttons={}

    local familiarWords = ccui.ImageView:create("image/word_list/button_pressed_ciku_left.png",ccui.TextureResType.localType)
    familiarWords:setEnabled(true)
    familiarWords:setTouchEnabled(true)
    familiarWords:setAnchorPoint(cc.p(1,0.5))
    familiarWords.status = "PRESSED"
    local familiarWordsLabel = cc.Label:create()
    familiarWordsLabel:setString("熟词")
    familiarWordsLabel:setPosition(familiarWords:getContentSize().width/2,familiarWords:getContentSize().height/2)
    familiarWordsLabel:setAnchorPoint(cc.p(0.5,0.5))
    familiarWordsLabel:setSystemFontSize(24)
    familiarWords:addChild(familiarWordsLabel)

    local newWords = ccui.ImageView:create("image/word_list/button_unpressed_ciku_right.png",ccui.TextureResType.localType)
    newWords:setEnabled(true)
    newWords:setTouchEnabled(true)
    newWords:setAnchorPoint(cc.p(0,0.5))
    newWords.status = "NORMAL"
    local newWordsLabel = cc.Label:create()
    newWordsLabel:setString("生词")
    newWordsLabel:setPosition(newWords:getContentSize().width/2,newWords:getContentSize().height/2)
    newWordsLabel:setAnchorPoint(cc.p(0.5,0.5))
    newWordsLabel:setSystemFontSize(24)
    newWords:addChild(newWordsLabel)

    local familiarWordsTouchEventEnded = function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if familiarWords.status == "NORMAL" then
                print("familiarWords touched" )
                familiarWords.status = "PRESSED"
                newWords.status = "NORMAL"
                familiarWords:loadTexture("image/word_list/button_pressed_ciku_left.png",ccui.TextureResType.localType)
                newWords:loadTexture("image/word_list/button_unpressed_ciku_right.png",ccui.TextureResType.localType)
            end
        end
    end 

    local newWordsTouchEventEnded = function(touch,eventType)
        if eventType == ccui.TouchEventType.ended then
            if newWords.status == "NORMAL" then
                print("newWords touched" )
                newWords.status = "PRESSED"
                familiarWords.status = "NORMAL"
                familiarWords:loadTexture("image/word_list/button_unpressed_ciku_left.png",ccui.TextureResType.localType)
                newWords:loadTexture("image/word_list/button_pressed_ciku_right.png",ccui.TextureResType.localType)
            end
        end
    end 
    
    familiarWords:addTouchEventListener(familiarWordsTouchEventEnded)     
    newWords:addTouchEventListener(newWordsTouchEventEnded)

    buttons["familiarWords"] = familiarWords
    buttons["newWords"] = newWords

    return buttons
end

function WordList:createBackground()

    local header = cc.Sprite:create("image/word_list/frontground_ciku.png")
    header:setAnchorPoint(cc.p(0.5,0.5))
    header:setPosition(s_LEFT_X + s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT-header:getContentSize().height/2)

    local buttons = createButtons()
    local familiarWords = buttons["familiarWords"]
    familiarWords:setPosition(header:getContentSize().width/2,header:getContentSize().height/2)
    local newWords = buttons["newWords"]
     newWords:setPosition(header:getContentSize().width/2,header:getContentSize().height/2)
   
    self:addChild(header)
    header:addChild(familiarWords)
    header:addChild(newWords)
end

return WordList

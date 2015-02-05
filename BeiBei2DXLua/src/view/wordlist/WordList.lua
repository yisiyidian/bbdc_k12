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

local function createDetailInfo(detailInfo)

    local wordDetailMeaning = cc.Label:create()
    wordDetailMeaning:setString(detailInfo)
    wordDetailMeaning:setAnchorPoint(0,1)
    wordDetailMeaning:setSystemFontSize(25)
    wordDetailMeaning:setColor(cc.c4b(0,0,0))
    wordDetailMeaning:setDimensions(500,0)
    wordDetailMeaning:setAlignment(0)
    return wordDetailMeaning
end

local function getWords(type)

    local words
    if type[1] == "ALL" then

        if type[2] == "GRASP" then
            words = s_LocalDatabaseManager.getGraspWords()
        elseif type[2] == "WRONG" then
            words = s_LocalDatabaseManager.getWrongWords()
            print("the length of wrong words is "..#words)
        end
    elseif type[1] == "STAGE" then
        if type[2] == "GRASP" then
        elseif type[2] == "WRONG" then
        end       
    end

    words.wordName      = {}
    words.smallMeaning  = {}
    words.meaning       = {}
    words.sentenceEn    = {}
    words.sentenceCn    = {}
    
    for i = 1,#words  do
        
        --words.wordName[i]      = s_WordPool[words[i]].wordName
        --words.smallMeaning[i]  = s_WordPool[words[i]].wordMeaningSmall
        --words.meaning[i]       = split(s_WordPool[words[i]].wordMeaning, "|||")
        --words.sentenceEn[i]    = s_WordPool[words[i]].sentenceEn
        --words.sentenceCn[i]    = s_WordPool[words[i]].sentenceCn

        local currentWord       = s_LocalDatabaseManager.getWordInfoFromWordName(words[i])
        words.wordName[i]      = currentWord.wordName
        words.smallMeaning[i]  = currentWord.wordMeaningSmall
        words.meaning[i]       = split(currentWord.wordMeaning, "|||")
        words.sentenceEn[i]    = currentWord.sentenceEn
        words.sentenceCn[i]    = currentWord.sentenceCn

        words.meaning[i].meaningArray = {}
        
        for temp = 1,#words.meaning[i] do
            words.meaning[i].meaningArray[temp] = createDetailInfo(words.meaning[i][temp])
        end

    end
    return words
end

local function createWordListview(type, headerHeight)
    local words = getWords(type)
    local listview = ccui.ListView:create()
    listview:setDirection(ccui.ListViewDirection.vertical)
    listview:setBounceEnabled(false)
    listview:setAnchorPoint(cc.p(0,1))
    listview:setContentSize(cc.size(854,s_DESIGN_HEIGHT-headerHeight))
    
    for i=1, #words do

        --init the custom item
        local customItem = ccui.Layout:create()
        customItem:setTouchEnabled(true)
        customItem:setAnchorPoint(cc.p(0,1))
        local customItemHeight = 0

        --init word name
        local wordNameLabel = cc.Label:create()
        wordNameLabel:setString(words.wordName[i])
        wordNameLabel:setAnchorPoint(cc.p(0,1))
        wordNameLabel:setSystemFontSize(25)
        wordNameLabel:setColor(cc.c3b(0,0,0))
        wordNameLabel:setWidth(854)

        local leftBlankOffset = 50
        local wordNameAndUpBoardOffset = 10
        local wordNameAndMeaningOffset = wordNameLabel:getContentSize().height + wordNameAndUpBoardOffset + 20
        customItemHeight = customItemHeight + wordNameLabel:getContentSize().height + wordNameAndUpBoardOffset + 20

        -- init the item line
        local itemLine = cc.Sprite:create("image/word_list/fenge_gray_ciku.png")
        customItemHeight = customItemHeight+itemLine:getContentSize().height

        --init word detail meaning
        for temp=1,#words.meaning[i].meaningArray do
            local labelHeight  = words.meaning[i].meaningArray[temp]:getContentSize().height
            customItemHeight   = customItemHeight + labelHeight
        end

        --set the content size of custom item
        customItem:setContentSize(cc.size(854,customItemHeight))

        --set the position of all the detail meanings
        local tempHeight = 0
        for temp=1,#words.meaning[i].meaningArray do
            words.meaning[i].meaningArray[temp]:setPosition(leftBlankOffset,customItem:getContentSize().height-wordNameAndMeaningOffset-tempHeight)
            customItem:addChild(words.meaning[i].meaningArray[temp])
            tempHeight = tempHeight + words.meaning[i].meaningArray[temp]:getContentSize().height
        end

        --set the position of item line        
        itemLine:setAnchorPoint(cc.p(0,1))
        itemLine:setPosition(0,0)
        customItem:addChild(itemLine)

        wordNameLabel:setPosition(leftBlankOffset,customItem:getContentSize().height-wordNameAndUpBoardOffset)
        customItem:addChild(wordNameLabel)
        
        listview:pushBackCustomItem(customItem)
    end

    return listview
end

function WordList:createButtons(headerHeight)

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
                familiarWords.status = "PRESSED"
                newWords.status = "NORMAL"
                familiarWords:loadTexture("image/word_list/button_pressed_ciku_left.png",ccui.TextureResType.localType)
                newWords:loadTexture("image/word_list/button_unpressed_ciku_right.png",ccui.TextureResType.localType)
                local type ={"ALL","GRASP"}
                if self.listview ~=nil then
                    self.listview:removeFromParent()
                    self.listview = nil
                    local listview = createWordListview(type,headerHeight)
                    listview:setPosition(s_LEFT_X,s_DESIGN_HEIGHT-headerHeight)
                    self:addChild(listview)
                    self.listview = listview
                end
            end
        end
    end 

    local newWordsTouchEventEnded = function(touch,eventType)
        if eventType == ccui.TouchEventType.ended then
            if newWords.status == "NORMAL" then
                newWords.status = "PRESSED"
                familiarWords.status = "NORMAL"
                familiarWords:loadTexture("image/word_list/button_unpressed_ciku_left.png",ccui.TextureResType.localType)
                newWords:loadTexture("image/word_list/button_pressed_ciku_right.png",ccui.TextureResType.localType)
                local type ={"ALL","WRONG"}                
                if self.listview ~=nil then
                    self.listview:removeFromParent()
                    self.listview = nil
                    local listview = createWordListview(type,headerHeight)
                    listview:setPosition(s_LEFT_X,s_DESIGN_HEIGHT-headerHeight)
                    self:addChild(listview,2)
                    self.listview = listview
                end
            end
        end
    end 
    
    familiarWords:addTouchEventListener(familiarWordsTouchEventEnded)     
    newWords:addTouchEventListener(newWordsTouchEventEnded)

    buttons["familiarWords"] = familiarWords
    buttons["newWords"] = newWords

    return buttons
end

function WordList:createBackButton(type)
    local backButton = ccui.Button:create("image/word_list/button_wordbook_back.png")
    backButton:setAnchorPoint(cc.p(0,0.5))
    local backButtonEvent = function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            if type[1] == "ALL" then
                s_CorePlayManager.enterHomeLayer()
            else
                s_CorePlayManager.enterLevelLayer()
            end
        end
    end

    backButton:addTouchEventListener(backButtonEvent)
    return backButton
end

function WordList:createBackground()

    --init background layer
    local backLayerColor = cc.LayerColor:create(cc.c4b(245,247,248,255),854,s_DESIGN_HEIGHT)
    backLayerColor:setAnchorPoint(0,0)
    backLayerColor:setPosition(s_LEFT_X,0)
    self:addChild(backLayerColor,0)

    --init header
    local header = cc.Sprite:create("image/word_list/frontground_ciku.png")
    header:setAnchorPoint(cc.p(0,0))
    header:setPosition(s_LEFT_X,s_DESIGN_HEIGHT-header:getContentSize().height)
    self:addChild(header,1)

    --init two buttons
    local buttons = self:createButtons(header:getContentSize().height)
    local familiarWords = buttons["familiarWords"]
    familiarWords:setPosition(s_DESIGN_WIDTH/2,header:getContentSize().height/2)
    local newWords = buttons["newWords"]
    newWords:setPosition(s_DESIGN_WIDTH/2,header:getContentSize().height/2)

    --init listview
    local type ={"ALL","GRASP"}
    local listview = createWordListview(type,header:getContentSize().height)
    listview:setPosition(s_LEFT_X,s_DESIGN_HEIGHT-header:getContentSize().height)
    self:addChild(listview,2)
    self.listview = listview
 
    --init back button
    local backBtn = self:createBackButton(type)
    backBtn:setPosition(50,header:getContentSize().height-backBtn:getContentSize().height-10)

    header:addChild(backBtn)
    header:addChild(familiarWords)
    header:addChild(newWords)
end

return WordList

--Old wordlist, deprecated on version 1.8.0.1

require("cocos.init")
require("common.global")

local LearnedWordList = class('LearnedWordList', function()
    return cc.Layer:create()
end)

local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
local scale = (s_RIGHT_X - s_LEFT_X) / s_DESIGN_WIDTH
local mid = (s_RIGHT_X - s_LEFT_X) /2 + s_LEFT_X
local width = (s_RIGHT_X - s_LEFT_X) /2

function LearnedWordList.create()
    local layer = LearnedWordList.new()
    return layer
end


function LearnedWordList:removeItemByName(listView, name)
    local items = listView:getItems()
    for i = 1, #items do
        --print('items:'..items[i]:getName())
        if items[i]:getName() == name then
            listView:removeItem(listView:getIndex(items[i]))
        end
    end
end

function LearnedWordList:getItemByName(listView, name)
    local items = listView:getItems()
    for i = 1, #items do
        if items[i]:getName() == name then
            return items[i]
        end
    end
    return nil
end

function LearnedWordList:addMasteredPlots(button, proficiency)
    local sprite1, sprite2, sprite3, sprite4
    if proficiency >= 4 then
        sprite1 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite2 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite3 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite4 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
    elseif proficiency == 3 then
        sprite1 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite2 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite3 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite4 = cc.Sprite:create('image/word_list/libruary_quan1.png')
    elseif proficiency == 2 then
        sprite1 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite2 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite3 = cc.Sprite:create('image/word_list/libruary_quan1.png')
        sprite4 = cc.Sprite:create('image/word_list/libruary_quan1.png')
    elseif proficiency == 1 then
        sprite1 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite2 = cc.Sprite:create('image/word_list/libruary_quan1.png')
        sprite3 = cc.Sprite:create('image/word_list/libruary_quan1.png')
        sprite4 = cc.Sprite:create('image/word_list/libruary_quan1.png')
    else  -- 
        sprite1 = cc.Sprite:create('image/word_list/libruary_quan1.png')
        sprite2 = cc.Sprite:create('image/word_list/libruary_quan1.png')
        sprite3 = cc.Sprite:create('image/word_list/libruary_quan1.png')
        sprite4 = cc.Sprite:create('image/word_list/libruary_quan1.png')
    end
    sprite1:setPosition(cc.p(0.9 * button:getContentSize().width,0.6 * button:getContentSize().height))
    sprite2:setPosition(cc.p(0.85 * button:getContentSize().width,0.6 * button:getContentSize().height))
    sprite3:setPosition(cc.p(0.8 * button:getContentSize().width,0.6 * button:getContentSize().height))
    sprite4:setPosition(cc.p(0.75 * button:getContentSize().width,0.6 * button:getContentSize().height))
    button:addChild(sprite1)
    button:addChild(sprite2)
    button:addChild(sprite3)
    button:addChild(sprite4)
end

function LearnedWordList:ctor()

    local back = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,162 * 6)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0,0.5)
    back:setPosition(s_LEFT_X,162 * 3)
    self:addChild(back)
    
    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
--            print("select child index = ",sender:getCurSelectedIndex())
        end
    end
    
    -- add chapter list view
    local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,162 * 6))  -- TODO set dynamic
    listView:setPosition(0,0)
    listView:addEventListener(listViewEvent)
    listView:setName('listView')
    listView:ignoreAnchorPointForPosition(false)
    self:addChild(listView, 0)
    
    --set model
    local default_item = ccui.Layout:create()
    default_item:setTouchEnabled(true)
    local default_button = ccui.Button:create('image/friend/friendRankButton.png', 'image/friend/friendRankButton.png')

    default_item:setContentSize(default_button:getContentSize())
    default_button:setPosition(default_item:getContentSize().width / 2.0, default_item:getContentSize().height / 2.0)
    default_button:ignoreAnchorPointForPosition(false)
    default_item:addChild(default_button)
    listView:setItemModel(default_item)
    listView:removeAllChildren()
    -- get data
    local word = s_LocalDatabaseManager:getStudyWords()
    local small_meaning = {}
    local meaning = {}
    local sentenceEn = {}
    local sentenceCn = {}
    for i = 1,#word  do
        small_meaning[i]     = s_WordPool[word[i]].wordMeaningSmall
        meaning[i]           = string.gsub(s_WordPool[word[i]].wordMeaning,"|||"," ")
        sentenceEn[i]        = s_WordPool[word[i]].sentenceEn
        sentenceCn[i]        = s_WordPool[word[i]].sentenceCn
    end

    
    local function touchEvent(sender,eventType)
        for i = 1,#word  do
            if eventType == ccui.TouchEventType.ended then
                local control = sender:getName()
                if control == 'button'..i then  -- insert a item of word info
                    local more_info_back = self:getItemByName(listView,'moreWordInfo'..i)
                    if more_info_back == nil  then
                        local back_blue = cc.LayerColor:create(cc.c4b(52,177,241,255),s_DESIGN_WIDTH,200)
                        back_blue:ignoreAnchorPointForPosition(false)
                        back_blue:setAnchorPoint(0.5,0.5)
                        
                        local wordContainer = ccui.Layout:create()
                        wordContainer:setContentSize(cc.size(s_DESIGN_WIDTH, 200))
                        back_blue:setPosition(wordContainer:getContentSize().width/2, wordContainer:getContentSize().height/2)
                        
                        local richText = ccui.RichText:create()
                        richText:ignoreContentAdaptWithSize(false)
                        richText:ignoreAnchorPointForPosition(false)
                        richText:setAnchorPoint(cc.p(0.5,0.5))
                        richText:setContentSize(cc.size(sender:getContentSize().width * 0.95, -600))  

                        local label_word = cc.LabelTTF:create (meaning[i] ..'\n'..sentenceEn[i]..'\n'..sentenceCn[i],
                            "Helvetica",28, cc.size(sender:getContentSize().width * 0.95, 200), cc.TEXT_ALIGNMENT_LEFT)

                        label_word:setColor(cc.c3b(0, 0, 0))

                        local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,label_word)                           
                        richText:pushBackElement(richElement1)                   
                        richText:setPosition(wordContainer:getContentSize().width/2, back:getContentSize().height*0.5)
                        richText:setLocalZOrder(10)

                        wordContainer:addChild(back_blue)                  
                        wordContainer:addChild(richText,2)                   
                        wordContainer:setName('moreWordInfo'..i)

                        local wordItem = self:getItemByName(listView,"word"..i)
                        local index = listView:getIndex(wordItem)
                        listView:insertCustomItem(wordContainer,index+1)
                        local action = cc.RotateTo:create(0.5,180)
                        local arrow = sender:getChildByName('arrow'..i)
                        arrow:runAction(action)
                    else
                        self:removeItemByName(listView,'moreWordInfo'..i)
                        local action = cc.RotateTo:create(0.5,360)
                        local arrow = sender:getChildByName('arrow'..i)
                        arrow:runAction(action)
                    end
                end
            end
        end
    end
    -- add word list
    for i = 1,#word  do
        local custom_button = ccui.Button:create('image/friend/friendRankButton.png','image/friend/friendRankButton.png','')
        custom_button:setScale9Enabled(true)
        custom_button:setContentSize(default_button:getContentSize())

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_button:getContentSize())
        custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(custom_button)
        custom_item:setName("word"..i)

        listView:addChild(custom_item)

        local word_name = cc.Label:createWithSystemFont(word[i],'',32)
        word_name:setColor(cc.c3b(0,0,0))
        word_name:ignoreAnchorPointForPosition(false)
        word_name:setAnchorPoint(0,0)
        word_name:setPosition(0.12 * custom_button:getContentSize().width,0.52 * custom_button:getContentSize().height)
        custom_button:addChild(word_name)

        local word_meaning = cc.Label:createWithSystemFont(small_meaning[i],'',24)
        word_meaning:setColor(cc.c3b(0,0,0))
        word_meaning:ignoreAnchorPointForPosition(false)
        word_meaning:setAnchorPoint(0,1)
        word_meaning:setPosition(0.12 * custom_button:getContentSize().width,0.3 * custom_button:getContentSize().height)
        word_meaning:setName('clickToCheck')
        custom_button:addChild(word_meaning, 0)

        local arrow = cc.Sprite:create('image/friend/fri_jiantouxia.png')
        arrow:setPosition(0.85 * custom_button:getContentSize().width,0.25 * custom_button:getContentSize().height)
        arrow:setName('arrow'..i)

        local more_label = cc.Label:createWithSystemFont('更多','',24)
        more_label:setPosition(0.78 * custom_button:getContentSize().width,0.25 * custom_button:getContentSize().height)
        more_label:setColor(cc.c3b(0,0,0))
        custom_button:addChild(more_label)

        custom_button:setName("button"..i)
        custom_button:addTouchEventListener(touchEvent)
        custom_button:addChild(arrow)        
    end
    listView:setItemsMargin(2.0)

--    local levelConfig = s_DataManager.getLevels(s_CURRENT_USER.bookKey)
--    self.levelArray = {}
--    self.levelKey = {}
--    
--    local indexConfig = 1
--    local level_count = 0
--    while indexConfig <= #levelConfig do
--        local levelKey = levelConfig[indexConfig]['level_key']
--        local chapterKey = levelConfig[indexConfig]['chapter_key']
--        local levelData = s_CURRENT_USER:getUserLevelData(chapterKey,levelKey)
--        if levelData ~= nil and levelConfig[indexConfig]['type'] ~= 1 then   
--            level_count = level_count + 1
--            self.levelKey[level_count] = chapterKey..levelKey
--            self.levelArray[level_count] = split(levelConfig[indexConfig]['word_content'],'|')
--        end
--        indexConfig = indexConfig + 1 
--    end
--    --print('levelCount:'..level_count)
--
--    indexConfig = 1
--    while indexConfig <= level_count do
--        -- add title
--        local levelNum = split(self.levelKey[indexConfig],'level')
--        local levelIndex        = levelNum[2] + 1
--        local chapterNum = split(levelNum[1],'chapter')
--        local chapterIndex = chapterNum[2]+1
--        local chapterName       = s_DataManager.chapters[chapterIndex]["Name"]
--        local levelName         = "第"..chapterIndex.."章 "..chapterName.." 第"..levelIndex.."关"
--        local title = cc.Label:createWithSystemFont(levelName, '' ,28)
--        title:setColor(cc.c3b(45,176,244))
--        title:setPosition(cc.p((s_RIGHT_X-s_LEFT_X)/2, 20))
--        local titleContainner = ccui.Layout:create()
--        titleContainner:setContentSize(cc.size(s_DESIGN_WIDTH, 40))
--        titleContainner:addChild(title)
--        listView:addChild(titleContainner)
--        -- define more info button clicked event
--        local function testEvent(sender, eventType)
--            if eventType == ccui.TouchEventType.ended then
--                print('button clicked of custom')
--            end
--        end
--        
--        local function touchEvent(sender,eventType)
--            if eventType == ccui.TouchEventType.ended then
--                local control = split(sender:getName(),'|')
--                local wordInfo = s_WordPool[control[2]]
--                local arrow = sender:getChildByName('arrow'..control[2])
--                --print_lua_table(wordInfo)
--                if control[3] == '0' then  -- insert a item of word info
--                    
--                    local wordTitle = cc.Label:createWithSystemFont(wordInfo['wordMeaning']..'\n'..wordInfo['sentenceEn']..'\n'..wordInfo['sentenceCn'], '' ,28)
--                    wordTitle:setColor(cc.c3b(0,0,0))
----                    wordTitle:setScaleX(1/scale)
--
--                    local richText = ccui.RichText:create()
--
--                    richText:ignoreContentAdaptWithSize(false)
--                    richText:ignoreAnchorPointForPosition(false)
--                    richText:setAnchorPoint(cc.p(0.5,0.5))
--
--                    richText:setContentSize(cc.size(width, -600))  
----                    richText:setScaleX(1/scale)
--
--
--                    local label_word = cc.LabelTTF:create (wordInfo['wordMeaning']..wordInfo['sentenceEn']..wordInfo['sentenceCn'],
--                        "Helvetica",28, cc.size(600, 200), cc.TEXT_ALIGNMENT_LEFT)
--
--                    label_word:setColor(cc.c3b(0, 0, 0))
--
--                    local back_blue = cc.LayerColor:create(cc.c4b(52,177,241,255),s_DESIGN_WIDTH,200)
--                    back_blue:ignoreAnchorPointForPosition(false)
--                    back_blue:setAnchorPoint(0.5,0.5)
--
--
--                    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,label_word)                           
--                    richText:pushBackElement(richElement1)                   
--                    richText:setPosition(width * 0.53, back:getContentSize().height*0.5)
--                    richText:setLocalZOrder(10)
--                    
--                    local wordContainer = ccui.Layout:create()
--                    wordContainer:setContentSize(cc.size(s_DESIGN_WIDTH, 200))
--                    back_blue:setPosition(wordContainer:getContentSize().width/2, wordContainer:getContentSize().height/2)
--
--                    wordContainer:addChild(back_blue)                  
--                    wordContainer:addChild(richText,2)                   
--                    wordContainer:setName('moreWordInfo'..control[1]..control[2])
--  
--                    local wordItem = self:getItemByName(listView,control[1]..'|'..control[2])
--                    local index = listView:getIndex(wordItem)
--                    listView:insertCustomItem(wordContainer,index+1)
--                    sender:setName(control[1]..'|'..control[2]..'|1')
--                    local action = cc.RotateTo:create(0.5,180)
--                    arrow:runAction(action)
--                else -- remove a item
--                    self:removeItemByName(listView,'moreWordInfo'..control[1]..control[2])
--                    sender:setName(control[1]..'|'..control[2]..'|0')
--                    local action = cc.RotateTo:create(0.5,360)
--                    arrow:runAction(action)
--                end
--            end
--        end
--        -- add word list
--        local studyWords = s_LocalDatabaseManager.getStudyWords(s_CURRENT_USER.bookKey)
--        for i = 1, #self.levelArray[indexConfig] do
--            local word = self.levelArray[indexConfig][i]
--            local wordKey = self.levelKey[indexConfig]..'|'..word
--            local wordInfo = s_WordPool[word]
--            --print('wordInfo..'..word..',')
--            if studyWords[word] ~= nil then
--                local custom_button = ccui.Button:create('image/friend/friendRankButton.png','image/friend/friendRankButton.png','')
--                custom_button:setName("custom_button")
--                custom_button:setTitleText('123')
--                custom_button:setScale9Enabled(true)
--                custom_button:setContentSize(default_button:getContentSize())
--
--    
--                local custom_item = ccui.Layout:create()
--                custom_item:setContentSize(custom_button:getContentSize())
--                custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
--                custom_item:addChild(custom_button)
--                custom_item:setName(wordKey)
--                listView:addChild(custom_item)
--                local word_name = cc.Label:createWithSystemFont(word,'',32)
--                word_name:setColor(cc.c3b(0,0,0))
--                word_name:ignoreAnchorPointForPosition(false)
--                word_name:setAnchorPoint(0,0)
--                word_name:setPosition(0.12 * custom_button:getContentSize().width,0.52 * custom_button:getContentSize().height)
--                custom_button:addChild(word_name)
--    
--                local word_meaning = cc.Label:createWithSystemFont(wordInfo['wordMeaningSmall'],'',24)
--                word_meaning:setColor(cc.c3b(0,0,0))
--                word_meaning:ignoreAnchorPointForPosition(false)
--                word_meaning:setAnchorPoint(0,1)
--                word_meaning:setPosition(0.12 * custom_button:getContentSize().width,0.3 * custom_button:getContentSize().height)
--                word_meaning:setName('clickToCheck')
--                custom_button:addChild(word_meaning, 0)
--    
--                -- local arrow = ccui.Button:create('image/friend/fri_jiantouxia.png','image/friend/fri_jiantouxia.png','image/friend/fri_jiantouxia.png')
--                local arrow = cc.Sprite:create('image/friend/fri_jiantouxia.png')
--                arrow:setPosition(0.85 * custom_button:getContentSize().width,0.25 * custom_button:getContentSize().height)
--                arrow:setName('arrow'..word)
--                
--                local more_label = cc.Label:createWithSystemFont('更多','',24)
--                more_label:setPosition(0.78 * custom_button:getContentSize().width,0.25 * custom_button:getContentSize().height)
--                more_label:setColor(cc.c3b(0,0,0))
--                custom_button:addChild(more_label)
--
--               
--                --print('arrow:'..arrow:getName())
--                custom_button:setName(wordKey..'|0')
--                custom_button:addTouchEventListener(touchEvent)
--                custom_button:addChild(arrow)        
--                -- add mastered count
--                --print('study:'..studyWords[word])
--                self:addMasteredPlots(custom_button, studyWords[word])
--            end
--        end
--        indexConfig = indexConfig + 1
--    end
end

return LearnedWordList
require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local MasteredWordList = class('MasteredWordList', function()
    return cc.Layer:create()
end)

function MasteredWordList.create()
    local layer = MasteredWordList.new()
    return layer
end


function MasteredWordList:removeItemByName(listView, name)
    local items = listView:getItems()
    for i = 1, #items do
        --print('items:'..items[i]:getName())
        if items[i]:getName() == name then
            listView:removeItem(listView:getIndex(items[i]))
        end
    end
end

function MasteredWordList:getItemByName(listView, name)
    local items = listView:getItems()
    for i = 1, #items do
        if items[i]:getName() == name then
            return items[i]
        end
    end
    return nil
end

function MasteredWordList:addMasteredPlots(button, proficiency)
    local sprite1, sprite2, sprite3, sprite4
    if proficiency >= 4 then
        sprite1 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
        sprite2 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
        sprite3 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
        sprite4 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
    elseif proficiency == 3 then
        sprite1 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
        sprite2 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
        sprite3 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
        sprite4 = cc.Sprite:create('image/word_list/libruary_quan1.png')
    elseif proficiency == 2 then
        sprite1 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
        sprite2 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
        sprite3 = cc.Sprite:create('image/word_list/libruary_quan1.png')
        sprite4 = cc.Sprite:create('image/word_list/libruary_quan1.png')
    elseif proficiency == 1 then
        sprite1 = cc.Sprite:create('image/word_list/button_wordbook_green.png')
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

function MasteredWordList:ctor()

    local back = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,162 * 6)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    back:setPosition(0.5 * s_DESIGN_WIDTH,162 * 3)
    self:addChild(back)

    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
            print("select child index = ",sender:getCurSelectedIndex())
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
    self:addChild(listView,0,'listView')

    --set model
    local default_item = ccui.Layout:create()
    default_item:setTouchEnabled(true)
    local default_button = ccui.Button:create('image/friend/friendRankButton.png', 'image/friend/friendRankButton.png')
    --default_button:setScale(1.0,0.)
    default_item:setContentSize(default_button:getContentSize())
    default_button:setPosition(cc.p(default_item:getContentSize().width / 2.0, default_item:getContentSize().height / 2.0))
    default_item:addChild(default_button)
    listView:setItemModel(default_item)
    listView:removeAllChildren()
    -- get data
    local levelConfig = s_DATA_MANAGER.getLevels(s_CURRENT_USER.bookKey)
    self.levelArray = {}
    self.levelKey = {}

    local indexConfig = 1
    local level_count = 0
    while indexConfig <= #levelConfig do
        local levelKey = levelConfig[indexConfig]['level_key']
        local chapterKey = levelConfig[indexConfig]['chapter_key']
        local levelData = s_CURRENT_USER:getUserLevelData(chapterKey,levelKey)
        if levelData ~= nil and levelConfig[indexConfig]['type'] ~= 1 then   
            level_count = level_count + 1
            self.levelKey[level_count] = chapterKey..levelKey
            self.levelArray[level_count] = split(levelConfig[indexConfig]['word_content'],'|')
            --print_lua_table(self.levelArray[key])
        end
        indexConfig = indexConfig + 1 
    end
    
    indexConfig = 1
    while indexConfig <= level_count do
        -- add title
        local levelNum = split(self.levelKey[indexConfig],'level')
        local title = cc.Label:createWithSystemFont('关卡'..(levelNum[2]+1), '' ,28)
        title:setColor(cc.c3b(45,176,244))
        title:setPosition(cc.p(100, 20))
        local titleContainner = ccui.Layout:create()
        titleContainner:setContentSize(cc.size(s_DESIGN_WIDTH, 40))
        titleContainner:addChild(title)
        listView:addChild(titleContainner)
        --        listView:
        -- define more info button clicked event
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                local control = split(sender:getName(),'|')
                local wordInfo = s_WordPool[control[2]]
                if control[3] == '0' then  -- insert a item of word info
                    local wordTitle = cc.Label:createWithSystemFont(wordInfo['wordMeaning']..'\n'..wordInfo['sentenceEn']..'\n'..wordInfo['sentenceCn'], '' ,28)
                    wordTitle:setColor(cc.c3b(0,0,0))
                    --                    print('wordInfo:'..wordInfo['wordMeaning'])
                    --                    local splita = string.gsub(wordInfo['wordMeaning'],'[a-zA-Z]','')
                    --                    print('----split')
                    --                    print(splita)
                    --                    print_lua_table(splita)
                    
--                    local richText = ccui.RichText:create()
--                    richText:ignoreContentAdaptWithSize(false)
--                    richText:setContentSize(cc.size(550, -600))
--
--                    local re1 = ccui.RichElementText:create(1, cc.c3b(0, 0, 0), 255, wordInfo['wordMeaning'], "Helvetica", 28)
--                    local re2 = ccui.RichElementText:create(2, cc.c3b(0, 0, 0), 255, wordInfo['sentenceEn'] , "Helvetica", 28)
--                    local re3 = ccui.RichElementText:create(3, cc.c3b(0, 0, 0), 255, wordInfo['sentenceCn'], "Helvetica", 28)
--
--                    richText:pushBackElement(re1)
--                    richText:pushBackElement(re2)
--                    richText:pushBackElement(re3)
--
--                    richText:setPosition(back:getContentSize().width/2,back:getContentSize().height*0.5)
--                    richText:setLocalZOrder(10)
                  
--                    local richText = ccui.RichText:create()
--                    richText:ignoreContentAdaptWithSize(false)
--                    richText:setContentSize(cc.size(550, -600))  
--                    
--                    local label_wordMeaning = cc.Label:createWithTTF(wordInfo['wordMeaning'],"Helvetica",28)
--                    label_wordMeaning:setColor(cc.c3b(0, 0, 0))
--                    local richElement1 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,label_wordMeaning)
--                    
--                    local label_sentenceEn = cc.Label:createWithTTF(wordInfo['sentenceEn'],"Helvetica",28)
--                    label_sentenceEn:setColor(cc.c3b(0, 0, 0))
--                    local richElement2 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,label_sentenceEn)
--                    
--                    local label_sentenceCn = cc.Label:createWithTTF(wordInfo['wordMeaning'],"Helvetica",28)
--                    label_sentenceCn:setColor(cc.c3b(0, 0, 0))                    
--                    local richElement3 = ccui.RichElementCustomNode:create(1,cc.c3b(0, 0, 0),255,label_sentenceCn)
--                    
--                    richText:pushBackElement(richElement1)
--                    richText:pushBackElement(richElement2)
--                    richText:pushBackElement(richElement3)
                    
                    local back = cc.LayerColor:create(cc.c4b(52,177,241,255),s_DESIGN_WIDTH,200)
                    back:ignoreAnchorPointForPosition(false)
                    back:setAnchorPoint(0.5,0.5)

                    local wordContainer = ccui.Layout:create()
                    wordContainer:setContentSize(cc.size(s_DESIGN_WIDTH, 200))
                    back:setPosition(wordContainer:getContentSize().width/2, wordContainer:getContentSize().height/2)
                    wordContainer:addChild(back)
                    wordTitle:setPosition(back:getContentSize().width/2,back:getContentSize().height*0.5)
--                    wordContainer:addChild(wordTitle,2)
                    
--                    wordContainer:addChild(richText,2)
                    wordContainer:setName('moreWordInfo'..control[1]..control[2])
                    
                    local wordItem = self:getItemByName(listView,control[1]..'|'..control[2])
                    local index = listView:getIndex(wordItem)
                    listView:insertCustomItem(wordContainer,index+1)
                    sender:setName(control[1]..'|'..control[2]..'|1')
                else -- remove a item
                    self:removeItemByName(listView,'moreWordInfo'..control[1]..control[2])
                    sender:setName(control[1]..'|'..control[2]..'|0')
                end
            end
        end
        -- add word list
        local masterWords = s_DATABASE_MGR.getGraspWords(s_CURRENT_USER.bookKey)
        for i = 1, #self.levelArray[indexConfig] do
            local word = self.levelArray[indexConfig][i]
            local wordKey = self.levelKey[indexConfig]..'|'..word
            local wordInfo = s_WordPool[word]
            --print('grasp word is '..word)
            print_lua_table(masterWords)
            --print('masterWords:'..masterWords[word])
            for i, v in pairs(masterWords) do 
                if i == word then
                    --print_lua_table(wordInfo)
                    local custom_button = ccui.Button:create('image/friend/friendRankButton.png','image/friend/friendRankButton.png','')
                    custom_button:setName("custom_button")
                    custom_button:setTitleText('123')
                    custom_button:setScale9Enabled(true)
                    custom_button:setContentSize(default_button:getContentSize())

                    local custom_item = ccui.Layout:create()
                    custom_item:setContentSize(custom_button:getContentSize())
                    custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
                    custom_item:addChild(custom_button)
                    custom_item:setName(wordKey)
                    listView:addChild(custom_item)
                    local word_name = cc.Label:createWithSystemFont(word,'',32)
                    word_name:setColor(cc.c3b(0,0,0))
                    word_name:ignoreAnchorPointForPosition(false)
                    word_name:setAnchorPoint(0,0)
                    word_name:setPosition(0.12 * custom_button:getContentSize().width,0.52 * custom_button:getContentSize().height)
                    custom_button:addChild(word_name)

                    local word_meaning = cc.Label:createWithSystemFont(wordInfo['wordMeaningSmall'],'',24)
                    word_meaning:setColor(cc.c3b(0,0,0))
                    word_meaning:ignoreAnchorPointForPosition(false)
                    word_meaning:setAnchorPoint(0,1)
                    word_meaning:setPosition(0.12 * custom_button:getContentSize().width,0.3 * custom_button:getContentSize().height)
                    custom_button:addChild(word_meaning, 0,'clickToCheck')

                    local arrow = ccui.Button:create('image/friend/fri_jiantouxia.png','image/friend/fri_jiantouxia.png','image/friend/fri_jiantouxia.png')
                    arrow:setScale9Enabled(true)
                    arrow:setPosition(0.85 * custom_button:getContentSize().width,0.25 * custom_button:getContentSize().height)
                    local more_label = cc.Label:createWithSystemFont('更多','',24)
                    more_label:setPosition(-arrow:getContentSize().width, more_label:getContentSize().height/2)
                    more_label:setColor(cc.c3b(0,0,0))
                    arrow:addChild(more_label)
                    arrow:setName(wordKey..'|0')

                    --print('arrow:'..arrow:getName())
                    arrow:addTouchEventListener(touchEvent)
                    custom_button:addChild(arrow)        
                    -- add mastered count
                    --print('study:'..studyWords[word])
                    self:addMasteredPlots(custom_button, masterWords[word])
                end
            end
        end
        indexConfig = indexConfig + 1
    end

    listView:setItemsMargin(2.0)
end

return MasteredWordList
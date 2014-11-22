require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local StudyedWordList = class('StudyedWordList', function()
    return cc.Layer:create()
end)

function StudyedWordList.create()
    local layer = StudyedWordList.new()
    return layer
end

function StudyedWordList:addMasteredPlots(button, proficiency)
    local sprite1, sprite2, sprite3, sprite4
    if proficiency >= 4 then
        sprite1 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite2 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite3 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
        sprite4 = cc.Sprite:create('image/word_list/button_wordbook_blue.png')
    elseif proficiency == 3 then
    
    elseif proficiency == 2 then
    
    elseif profiency == 1 then
    
    else  -- 
    
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

function StudyedWordList:ctor()

    local back = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,162 * 6.5)
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
    listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,162 * 6.5))  -- TODO set dynamic
    listView:setPosition(0,0)
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
    
    -- get data
    --local levelConfig = s_DATA_MANAGER.getLevelConfig('ncee','chapter0','level0')
    self.array = {'word', 'sunny', 'test', 'hard','nice','best','hello','world','well'}
    --

    print('array count:'..#self.array)
    local count = #self.array
    for i = 1,count do
        listView:pushBackDefaultItem()
    end
    --insert default item
    for i = 1,count do
        listView:insertDefaultItem(0)
    end
    listView:removeAllChildren()
    
--    local title = cc.Label:createWithSystemFont('好友列表','',28)
--    title:setPosition(cc.p(50,15))
--    local tem = ccui.Layout:create()
--    tem:setContentSize(cc.size(100,30))
--    
--    --custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
--    tem:addChild(title)
--    listView:addChild(tem)
    
    for i = 1,count do
        if i ~= count then   -- add split item
            
        end
        local custom_button = ccui.Button:create('image/friend/friendRankButton.png','image/friend/friendRankButton.png','')
        custom_button:setName("custom_button")
        custom_button:setTitleText('123')
        custom_button:setScale9Enabled(true)
        custom_button:setContentSize(default_button:getContentSize())
        
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_button:getContentSize())
        custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(custom_button)
        custom_item:setName('item'..i)
        listView:addChild(custom_item)
    end
    
    local items_count = table.getn(listView:getItems())
    for i = 1,count do
        local item = listView:getItem(i - 1)
        local button = item:getChildByName("custom_button")
        local index = listView:getIndex(item)

        local word_name = cc.Label:createWithSystemFont('test','',32)
        word_name:setColor(cc.c3b(0,0,0))
        word_name:ignoreAnchorPointForPosition(false)
        word_name:setAnchorPoint(0,0)
        word_name:setPosition(0.12 * button:getContentSize().width,0.52 * button:getContentSize().height)
        button:addChild(word_name)

        local word_meaning = cc.Label:createWithSystemFont('点击查看单词意思','',24)
        word_meaning:setColor(cc.c3b(0,0,0))
        word_meaning:ignoreAnchorPointForPosition(false)
        word_meaning:setAnchorPoint(0,1)
        word_meaning:setPosition(0.12 * button:getContentSize().width,0.3 * button:getContentSize().height)
        button:addChild(word_meaning, 0,'clickToCheck')

        local arrow = cc.Sprite:create('image/friend/fri_jiantouxia.png')
        arrow:setPosition(0.85 * button:getContentSize().width,0.25 * button:getContentSize().height)
        local more_label = cc.Label:createWithSystemFont('更多','',24)
        more_label:setPosition(-arrow:getContentSize().width, more_label:getContentSize().height/2)
        more_label:setColor(cc.c3b(0,0,0))
        arrow:addChild(more_label)
        button:addChild(arrow,0,'arrow')
        
        -- add mastered count
        self:addMasteredPlots(button, 4)
    end
    listView:setItemsMargin(2.0)
end

return StudyedWordList
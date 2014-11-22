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

function StudyedWordList:addMasteredPlots(proficiency)
    if proficiency >= 4 then
    
    elseif proficiency == 3 then
    
    elseif proficiency == 2 then
    
    elseif profiency == 1 then
    
    else  -- 
    
    end
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
        custom_button:setName("Title")
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
        local button = item:getChildByName("Title")
        local index = listView:getIndex(item)
        button.index = i
--        local str = 'n'
--
--        if i < 4 then
--            str = string.format('%d',i)
--        end
--        local rankIcon = cc.Sprite:create(string.format('image/friend/fri_rank_%s.png',str))
--        rankIcon:setPosition(0.08 * button:getContentSize().width,0.5 * button:getContentSize().height)
--        button:addChild(rankIcon)
--        rankIcon:setName('rankIcon')
--
--        local rankLabel = cc.Label:createWithSystemFont(string.format('%d',i),'',36)
--        rankLabel:setPosition(rankIcon:getContentSize().width / 2,rankIcon:getContentSize().width / 2)
--        rankIcon:addChild(rankLabel)
--        rankLabel:setName('rankLabel')

--        local head = cc.Sprite:create('image/PersonalInfo/hj_personal_avatar.png')
--        head:setScale(0.8)
--        head:setPosition(0.26 * button:getContentSize().width,0.5 * button:getContentSize().height)
--        button:addChild(head)

        local fri_name = cc.Label:createWithSystemFont('test','',32)
        fri_name:setColor(cc.c3b(0,0,0))
        fri_name:ignoreAnchorPointForPosition(false)
        fri_name:setAnchorPoint(0,0)
        fri_name:setPosition(0.12 * button:getContentSize().width,0.52 * button:getContentSize().height)
        button:addChild(fri_name)

        local fri_word = cc.Label:createWithSystemFont('点击查看单词意思','',24)
        fri_word:setColor(cc.c3b(0,0,0))
        fri_word:ignoreAnchorPointForPosition(false)
        fri_word:setAnchorPoint(0,1)
        fri_word:setPosition(0.12 * button:getContentSize().width,0.35 * button:getContentSize().height)
        button:addChild(fri_word)
        local str = 'image/friend/fri_jiantouxia.png'
        local arrow = cc.Sprite:create(str)
        arrow:setPosition(0.9 * button:getContentSize().width,0.5 * button:getContentSize().height)
        button:addChild(arrow,0,'arrow')
        
        -- add mastered count
        
    end
    listView:setItemsMargin(2.0)
end

return StudyedWordList
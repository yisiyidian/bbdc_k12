require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local FriendList = class("FriendList", function()
    return cc.Layer:create()
end)

function FriendList.create()
    local layer = FriendList.new()
    --layer.friend = friend
    return layer 
end

function FriendList:ctor()
    --local friendCount = #self.friend
    
    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
            print("select child index = ",sender:getCurSelectedIndex())
        end
    end
    
    local array = {}
    for i = 1,20 do
        array[i] = string.format("ListView_item_%d",i - 1)
    end

    local listView = ccui.ListView:create()
    -- set list view ex direction
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,162 * 6))
    listView:setPosition(0,0)
    listView:addEventListener(listViewEvent)
    self:addChild(listView)


    -- create model
    local default_button = ccui.Button:create('image/friend/friendRankButton.png', 'image/friend/friendRankButton.png')
    default_button:setName("Title Button")

    local default_item = ccui.Layout:create()
    default_item:setTouchEnabled(true)
    default_item:setContentSize(default_button:getContentSize())
    default_button:setPosition(cc.p(default_item:getContentSize().width / 2.0, default_item:getContentSize().height / 2.0))
    default_item:addChild(default_button)

    --set model
    listView:setItemModel(default_item)

    --add default item
    local count = table.getn(array)
    for i = 1,math.floor(count / 4) do
        listView:pushBackDefaultItem()
    end
    --insert default item
    for i = 1,math.floor(count / 4) do
        listView:insertDefaultItem(0)
    end

    listView:removeAllChildren()

    --add custom item
    for i = 1,math.floor(count / 4) do
        local custom_button = ccui.Button:create("image/friend/friendRankButton.png", "image/friend/friendRankButton.png")
        custom_button:setName("Title Button")
        custom_button:setScale9Enabled(true)
        custom_button:setContentSize(default_button:getContentSize())

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_button:getContentSize())
        custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(custom_button)

        listView:addChild(custom_item) 
    end

    --insert custom item
    local items = listView:getItems()
    local items_count = table.getn(items)
    for i = 1, math.floor(count / 4) do
        local custom_button = ccui.Button:create("image/friend/friendRankButton.png", "image/friend/friendRankButton.png")
        custom_button:setName("Title Button")
        custom_button:setScale9Enabled(true)
        custom_button:setContentSize(default_button:getContentSize())

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_button:getContentSize())
        custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(custom_button)
        custom_item:setTag(1)

        listView:insertCustomItem(custom_item, items_count)
    end

    -- set item data
    items_count = table.getn(listView:getItems())
    for i = 1,items_count do
        local item = listView:getItem(i - 1)
        local button = item:getChildByName("Title Button")
        local index = listView:getIndex(item)
        local str = 'n'
        if index < 3 then
            str = string.format('%d',index + 1)
        end
        local rankIcon = cc.Sprite:create(string.format('image/friend/fri_rank_%s.png',str))
        rankIcon:setPosition(0.08 * button:getContentSize().width,0.5 * button:getContentSize().height)
        button:addChild(rankIcon)
        
        local rankLabel = cc.Label:createWithSystemFont(string.format('%d',index + 1),'',36)
        rankLabel:setPosition(rankIcon:getContentSize().width / 2,rankIcon:getContentSize().width / 2)
        rankIcon:addChild(rankLabel)
        
        local head = cc.Sprite:create('image/PersonalInfo/hj_personal_avatar.png')
        head:setScale(0.8)
        head:setPosition(0.26 * button:getContentSize().width,0.5 * button:getContentSize().height)
        button:addChild(head)
        
        local fri_name = cc.Label:createWithSystemFont('Name','',32)
        fri_name:setColor(cc.c3b(0,0,0))
        fri_name:ignoreAnchorPointForPosition(false)
        fri_name:setAnchorPoint(0,0)
        fri_name:setPosition(0.42 * button:getContentSize().width,0.52 * button:getContentSize().height)
        button:addChild(fri_name)
        
        local fri_word = cc.Label:createWithSystemFont('已学单词总数：300','',24)
        fri_word:setColor(cc.c3b(0,0,0))
        fri_word:ignoreAnchorPointForPosition(false)
        fri_word:setAnchorPoint(0,1)
        fri_word:setPosition(0.42 * button:getContentSize().width,0.48 * button:getContentSize().height)
        button:addChild(fri_word)
        
        local arrow = cc.Sprite:create('image/friend/fri_jiantouxia.png')
        arrow:setPosition(0.9 * button:getContentSize().width,0.5 * button:getContentSize().height)
        button:addChild(arrow)
        
        button:setTitleText(array[index + 1])
    end

    -- remove last item
    listView:removeChildByTag(1)

    -- remove item by index
    items_count = table.getn(listView:getItems())
    listView:removeItem(items_count - 1)

    -- set all items layout gravity
    listView:setGravity(ccui.ListViewGravity.centerVertical)

    --set items margin
    listView:setItemsMargin(2.0)

    
--    for i = 1,friendCount do
--        
--    end
end

return FriendList

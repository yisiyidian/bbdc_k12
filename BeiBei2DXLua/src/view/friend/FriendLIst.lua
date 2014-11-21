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
    
    self.array = s_CURRENT_USER.friends
    self.array[#self.array + 1] = s_CURRENT_USER
    self.selectIndex = -2
    for i = 1,#self.array do
        for j = i, #self.array do
            if self.array[i].wordsCount < self.array[j].wordsCount or (self.array[i].wordsCount == self.array[j].wordsCount and self.array[i].masterCount < self.array[j].masterCount) then
                local temp = self.array[i]
                self.array[i] = self.array[j]
                self.array[j] = temp
            end
        end
    end
    
    self.array = {1,2,3,4,5}
    
    local back = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,162 * 6)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    back:setPosition(0.5 * s_DESIGN_WIDTH,162 * 3)
    self:addChild(back)
    
    self:addList()
    
end

function FriendList:addList()
    self:removeChildByName('listView',true)
    local listView = ccui.ListView:create()
    -- set list view ex direction
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,162 * 6))
    listView:setPosition(0,0)
    self:addChild(listView,0,'listView')
    
    --listView:add
    
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
    --local array = {}
    --add default item
    local count = #self.array
    s_logd("count = %d",count)
    for i = 1,count do
        listView:pushBackDefaultItem()
    end
    --insert default item
    for i = 1,count do
        listView:insertDefaultItem(0)
    end

    listView:removeAllChildren()

    --add custom item
    for i = 1,count do
        local custom_button = ccui.Button:create("image/friend/friendRankButton.png", "image/friend/friendRankButton.png")
        custom_button:setName("Title Button")
        custom_button:setScale9Enabled(true)
        custom_button:setContentSize(default_button:getContentSize())
        
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_button:getContentSize())
        custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(custom_button)

        listView:addChild(custom_item)
        --array[i] = listView:getIndex(custom_item)
        
--        if(i == index_list + 1) then
--            local custom_button = ccui.Button:create("image/friend/delete_friend_back.png", "image/friend/delete_friend_back.png")
--            custom_button:setName("Title Button")
--            custom_button:setScale9Enabled(true)
--            custom_button:setContentSize(default_button:getContentSize())
--
--            local custom_item = ccui.Layout:create()
--            custom_item:setContentSize(custom_button:getContentSize())
--            custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
--            custom_item:addChild(custom_button)
--            listView:addChild(custom_item)
--            local delete = cc.Sprite:create('image/friend/fri_delete.png')
--            delete:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
--            custom_button:addChild(delete)
--            local function touchEvent(sender,eventType)
--                if eventType == ccui.TouchEventType.ended then
--                
--                end
--            end
--
--            custom_button:addTouchEventListener(touchEvent)
--            
--        end
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                if self.selectIndex ~= listView:getCurSelectedIndex() and self.selectIndex ~= listView:getCurSelectedIndex() - 1 then
                    if self.selectIndex > -1 then
                        listView:removeItem(self.selectIndex + 1)
                    end
                    local custom_button = ccui.Button:create("image/friend/delete_friend_back.png", "image/friend/delete_friend_back.png")
                    custom_button:setName("Title Button")
                    custom_button:setScale9Enabled(true)
                    custom_button:setContentSize(default_button:getContentSize())
        
                    local custom_item = ccui.Layout:create()
                    custom_item:setContentSize(custom_button:getContentSize())
                    custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
                    custom_item:addChild(custom_button)
                    listView:insertCustomItem(custom_item,listView:getCurSelectedIndex() + 1)
                    local delete = cc.Sprite:create('image/friend/fri_delete.png')
                    delete:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
                    custom_button:addChild(delete)
                    self.selectIndex = listView:getCurSelectedIndex()
                elseif self.selectIndex == listView:getCurSelectedIndex() - 1 then
                    listView:removeItem(listView:getCurSelectedIndex())
                    listView:removeItem(self.selectIndex)
                    self.selectIndex = -2
                else
                    listView:removeItem(listView:getCurSelectedIndex() + 1)
                    self.selectIndex = -2
                end
                
            end
        end
    
        custom_button:addTouchEventListener(touchEvent)
            
    end

--    -- set item data
    local items_count = table.getn(listView:getItems())
    for i = 1,items_count do
        local item = listView:getItem(i - 1)
        local button = item:getChildByName("Title Button")
        local index = listView:getIndex(item)
        
        local str = 'n'
        
        if i < 4 then
            str = string.format('%d',i)
        end
        local rankIcon = cc.Sprite:create(string.format('image/friend/fri_rank_%s.png',str))
        rankIcon:setPosition(0.08 * button:getContentSize().width,0.5 * button:getContentSize().height)
        button:addChild(rankIcon)
        
        local rankLabel = cc.Label:createWithSystemFont(string.format('%d',i),'',36)
        rankLabel:setPosition(rankIcon:getContentSize().width / 2,rankIcon:getContentSize().width / 2)
        rankIcon:addChild(rankLabel)
        
        local head = cc.Sprite:create('image/PersonalInfo/hj_personal_avatar.png')
        head:setScale(0.8)
        head:setPosition(0.26 * button:getContentSize().width,0.5 * button:getContentSize().height)
        button:addChild(head)
        
        local fri_name = cc.Label:createWithSystemFont('name','',32)
        fri_name:setColor(cc.c3b(0,0,0))
        fri_name:ignoreAnchorPointForPosition(false)
        fri_name:setAnchorPoint(0,0)
        fri_name:setPosition(0.42 * button:getContentSize().width,0.52 * button:getContentSize().height)
        button:addChild(fri_name)
        
        local fri_word = cc.Label:createWithSystemFont(string.format('已学单词总数：%d',self.array[i]),'',24)
        fri_word:setColor(cc.c3b(0,0,0))
        fri_word:ignoreAnchorPointForPosition(false)
        fri_word:setAnchorPoint(0,1)
        fri_word:setPosition(0.42 * button:getContentSize().width,0.48 * button:getContentSize().height)
        button:addChild(fri_word)
        local str = 'image/friend/fri_jiantouxia.png'
        local arrow = cc.Sprite:create(str)
        arrow:setPosition(0.9 * button:getContentSize().width,0.5 * button:getContentSize().height)
        button:addChild(arrow)
        
    end
    
    
    listView:setItemsMargin(2.0)
end

return FriendList

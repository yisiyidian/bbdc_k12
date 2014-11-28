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
    
    self.array = {}
    for i,f in ipairs(s_CURRENT_USER.friends) do
        self.array[#self.array + 1] = f
    end
    s_logd('friend = %d',#s_CURRENT_USER.friends)
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
    
    --self.array = {1,2,3,4,5}
    
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
    listView:setPosition(s_LEFT_X,0)
    listView:setName('listView')
    self:addChild(listView)
    local scale = (s_RIGHT_X - s_LEFT_X) / s_DESIGN_WIDTH
    --listView:add
    
    -- create model
    local default_button = ccui.Button:create('image/friend/friendRankButton.png', 'image/friend/friendRankButton.png')
    default_button:setName("Title Button")

    local default_item = ccui.Layout:create()
    default_item:setTouchEnabled(true)
    default_item:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X, default_button:getContentSize().height))
    default_button:setPosition(cc.p((s_RIGHT_X - s_LEFT_X) / 2.0, default_item:getContentSize().height / 2.0))
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
        local nameStr = "image/friend/friendRankButton.png"
        if self.array[i].username == s_CURRENT_USER.username then
            nameStr = "image/friend/friendRankSelfButton.png"
        end
        local custom_button = ccui.Button:create(nameStr,nameStr,'')
        custom_button:setScaleX(scale)
        custom_button:ignoreAnchorPointForPosition(false)
        custom_button:setAnchorPoint(0,0)
        custom_button:setName("Title Button")
        custom_button:setScale9Enabled(true)
        custom_button:setContentSize(default_button:getContentSize())
        custom_button.index = i
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,custom_button:getContentSize().height))
        custom_button:setPosition(cc.p((s_RIGHT_X - s_LEFT_X) * 0, custom_item:getContentSize().height * 0))
        custom_item:addChild(custom_button)

        listView:addChild(custom_item)
        
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                s_logd(sender.index)
                if self.selectIndex ~= sender.index and sender.index ~= 0 then
                    local arrow = sender:getChildByName('arrow')
                    arrow:setTexture('image/friend/fri_jiantoushang.png')
                    if self.selectIndex > -1 then
                        local item = listView:getItem(self.selectIndex - 1)
                        local btn = item:getChildByName("Title Button")
                        local arr = sender:getChildByName('arrow')
                        arr:setTexture('image/friend/fri_jiantouxia.png')
                    end
                     
                    local custom_button = ccui.Button:create("image/friend/delete_friend_back.png", "image/friend/delete_friend_back.png")
                    custom_button:setName("Title Button")
                    custom_button:setScale9Enabled(true)
                    custom_button:setContentSize(default_button:getContentSize())
                    custom_button:setScaleX(scale)
                    custom_button.index = 0
                    custom_button:addTouchEventListener(touchEvent)
                    local custom_item = ccui.Layout:create()
                    custom_item:setContentSize(custom_button:getContentSize())
                    custom_button:setPosition(cc.p((s_RIGHT_X - s_LEFT_X) / 2.0, custom_item:getContentSize().height / 2.0))
                    custom_item:addChild(custom_button)
                    listView:insertCustomItem(custom_item,listView:getCurSelectedIndex() + 1)
                    local delete = cc.Sprite:create('image/friend/fri_delete.png')
                    delete:setScaleX(1 / scale)
                    delete:setPosition(cc.p(custom_button:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
                    custom_button:addChild(delete)
                    if self.selectIndex > -1 then
                        if self.selectIndex > sender.index then
                            listView:removeItem(self.selectIndex + 1)
                        else
                            listView:removeItem(self.selectIndex)
                        end
                    end
                    self.selectIndex = sender.index
                elseif sender.index == 0 then --delete friend
                    s_UserBaseServer.unfollow(self.array[self.selectIndex],
                        function(api,result)
                            s_UserBaseServer.removeFan(self.array[self.selectIndex],
                                function(api,result)
                                    for i = 1,#s_CURRENT_USER.friends do
                                        if friends[i].username == self.array[self.selectIndex] then
                                            table.remove(s_CURRENT_USER.friends,i)
                                            break
                                        end
                                    end
                                    
                                    listView:removeItem(listView:getCurSelectedIndex())
                                    listView:removeItem(self.selectIndex - 1)

                                    for i = 1,table.getn(listView:getItems()) do
                                        local item = listView:getItem(i - 1)
                                        local button = item:getChildByName("Title Button")
                                        button.index = i   
                                        local str = 'n'

                                        if i < 4 then
                                            str = string.format('%d',i)
                                        end
                                        local rankIcon = button:getChildByName('rankIcon')
                                        rankIcon:setTexture(string.format('image/friend/fri_rank_%s.png',str))

                                        local rankLabel = rankIcon:getChildByName('rankLabel')
                                        rankLabel:setString(string.format('%d',i))
                                        --                        
                                    end

                                    self.selectIndex = -2
                                end,
                                function(api, code, message, description)

                                end)
                        end,
                        function(api, code, message, description)
                            
                        end)
                    
                else
                    local arrow = sender:getChildByName('arrow')
                    arrow:setTexture('image/friend/fri_jiantouxia.png')
                    listView:removeItem(sender.index)
                    self.selectIndex = -2
                end
                
            end
        end
        if self.array[custom_button.index].username ~= s_CURRENT_USER.username then
            custom_button:addTouchEventListener(touchEvent) 
        end
            
    end

--    -- set item data
    local items_count = table.getn(listView:getItems())
    for i = 1,items_count do
        local item = listView:getItem(i - 1)
        local button = item:getChildByName("Title Button")
        local index = listView:getIndex(item)
        --button.index = i
        local str = 'n'
        
        if i < 4 then
            str = string.format('%d',i)
        end
        local rankIcon = cc.Sprite:create(string.format('image/friend/fri_rank_%s.png',str))
        rankIcon:setScaleX(1 / scale)
        rankIcon:setPosition(0.08 * button:getContentSize().width,0.5 * button:getContentSize().height)
        button:addChild(rankIcon)
        rankIcon:setName('rankIcon')
        
        local rankLabel = cc.Label:createWithSystemFont(string.format('%d',i),'',36)
        --rankLabel:setScaleX(scale)
        rankLabel:setPosition(rankIcon:getContentSize().width / 2,rankIcon:getContentSize().width / 2)
        rankIcon:addChild(rankLabel)
        rankLabel:setName('rankLabel')
        
        local head = cc.Sprite:create('image/PersonalInfo/hj_personal_avatar.png')
        head:setScaleX(1 / scale * 0.8)
        head:setScaleY(0.8)
        head:setPosition(0.26 * button:getContentSize().width,0.5 * button:getContentSize().height)
        button:addChild(head)
        
        local fri_name = cc.Label:createWithSystemFont(self.array[i].username,'',32)
        fri_name:setScaleX(1 / scale)
        fri_name:setColor(cc.c3b(0,0,0))
        fri_name:ignoreAnchorPointForPosition(false)
        fri_name:setAnchorPoint(0,0)
        fri_name:setPosition(0.42 * button:getContentSize().width,0.52 * button:getContentSize().height)
        button:addChild(fri_name)
        
        local fri_word = cc.Label:createWithSystemFont(string.format('已学单词总数：%d',self.array[i].wordsCount),'',24)
        fri_word:setScaleX(1 / scale)
        fri_word:setColor(cc.c3b(0,0,0))
        fri_word:ignoreAnchorPointForPosition(false)
        fri_word:setAnchorPoint(0,1)
        fri_word:setPosition(0.42 * button:getContentSize().width,0.48 * button:getContentSize().height)
        button:addChild(fri_word)
        if self.array[i].username ~= s_CURRENT_USER.username then
            local str = 'image/friend/fri_jiantouxia.png'
            local arrow = cc.Sprite:create(str)
            arrow:setScaleX(1 / scale)
            arrow:setPosition(0.9 * button:getContentSize().width,0.5 * button:getContentSize().height)
            button:addChild(arrow,0,'arrow')
        end
        
    end
    
    
    listView:setItemsMargin(2.0)
end

return FriendList

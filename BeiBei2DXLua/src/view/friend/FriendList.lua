--好友列表界面

local FriendRender = require("view.friend.ui.FriendRender") --好友渲染器

local FriendList = class("FriendList", function()
    return cc.Layer:create()
end)

function FriendList.create()
    local layer = FriendList.new()
    return layer 
end

function FriendList:ctor()
    local back = cc.LayerColor:create(cc.c4b(255,255,255,255),s_RIGHT_X - s_LEFT_X,162 * 6)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    back:setPosition(0.5 * s_DESIGN_WIDTH,162 * 3)
    self:addChild(back)
    showProgressHUD('正在加载好友列表',true)

    s_UserBaseServer.getFolloweesOfCurrentUser(
        function(api, result)
            s_UserBaseServer.getFollowersOfCurrentUser(
            function (api, result)
                s_CURRENT_USER:getFriendsInfo() 

                self.array = {}
                --把自己的好友 筛选出来
                for i,f in ipairs(s_CURRENT_USER.friends) do
                    self.array[#self.array + 1] = f
                end
                self.array[#self.array + 1] = s_CURRENT_USER
                self.selectIndex = -2
                --对好友排序 TODO 用sort实现
                for i = 1,#self.array do
                    for j = i, #self.array do
                        if self.array[i].wordsCount < self.array[j].wordsCount or (self.array[i].wordsCount == self.array[j].wordsCount and self.array[i].masterCount < self.array[j].masterCount) then
                            local temp = self.array[i]
                            self.array[i] = self.array[j]
                            self.array[j] = temp
                        end
                    end
                end
                --构造列表
                self:addList()
                
                hideProgressHUD(true)
            end,
            function (api, code, message, description)
                hideProgressHUD(true)
            end
            )
        end,
        function (api, code, message, description)
            hideProgressHUD(true)
        end)
end

--构造列表
function FriendList:addList()
    -- dump(self.array,"好友数据列表")
    self:removeChildByName('listView',true)
    local listView = ccui.ListView:create()
    --set list view ex direction
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,162 * 6))
    listView:setPosition(s_LEFT_X,0)
    listView:setName('listView')
    self:addChild(listView)
    local scale = (s_RIGHT_X - s_LEFT_X) / s_DESIGN_WIDTH
    --add default item
    local count = #self.array
    --add custom item
    for i = 1,count do
        local custom_item = FriendRender.new()
        custom_item:setData(self.array[i],i)
        -- custom_item:setData(self.array[i],i,handler(self, self.onRenderTouch)) --暂时移除删除好友功能
        listView:addChild(custom_item)
    end

    listView:setItemsMargin(2.0)
    self.listView = listView
end

--[[
--暂时注释删除好友的功能
--格子触摸事件
function FriendList:onRenderTouch(sender)
    local listView = self.listView
    local scale = (s_RIGHT_X - s_LEFT_X) / s_DESIGN_WIDTH
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
        custom_button:setContentSize(cc.size(640,160))
        custom_button:setScaleX(scale)
        custom_button.index = 0
        custom_button:addTouchEventListener(handler(self, self.onRenderTouch))
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(custom_button:getContentSize())
        custom_button:setPosition(cc.p((s_RIGHT_X - s_LEFT_X) / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(custom_button,1)

        local back = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,custom_button:getContentSize().height + 2)
        back:ignoreAnchorPointForPosition(false)
        back:setAnchorPoint(0.5,0.5)
        back:setPosition((s_RIGHT_X - s_LEFT_X) * 0.5, custom_item:getContentSize().height * 0.5)
        custom_item:addChild(back,0)

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
        local back = cc.Sprite:create("image/alter/tanchu_board_small_white.png")
        back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2*3)
        s_SCENE.popupLayer:addChild(back)
        s_SCENE.popupLayer.listener:setSwallowTouches(true)
        back:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2))))
    
        local label_info = cc.Label:createWithSystemFont('确认删除好友？',"",28)
        label_info:setColor(cc.c4b(0,0,0,255))
        label_info:setDimensions(back:getContentSize().width*4/5,0)
        label_info:setPosition(back:getContentSize().width/2, back:getContentSize().height/2+50)
        back:addChild(label_info)
            
        local button_left = ccui.Button:create("image/button/studyscene_blue_button.png","image/button/studyscene_blue_button.png","")
        button_left:setPosition(back:getContentSize().width/2-120, back:getContentSize().height/2-70)
        button_left:setTitleText("确定")
        button_left:setTitleFontSize(30)
        button_left:addTouchEventListener(handler(self, self.delBtnTouch))
        back:addChild(button_left)
        
        local button_right = ccui.Button:create("image/button/studyscene_blue_button.png","image/button/studyscene_blue_button.png","")
        button_right:setPosition(back:getContentSize().width/2+120, back:getContentSize().height/2-70)
        button_right:setTitleText("取消")
        button_right:setTitleFontSize(30)
        button_right:addTouchEventListener(handler(self, self.cancelDel))
        back:addChild(button_right)

        self.back = back
    else
        local arrow = sender:getChildByName('arrow')
        arrow:setTexture('image/friend/fri_jiantouxia.png')
        listView:removeItem(sender.index)
        self.selectIndex = -2
    end
end



--删除按钮点击
function FriendList:delBtnTouch(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        playSound(s_sound_buttonEffect)
    elseif eventType == ccui.TouchEventType.ended then
        s_SCENE.popupLayer.listener:setSwallowTouches(false)
        self:deleteFriend()
        self.back:removeFromParent()
    end
end

--删除好友
function FriendList:deleteFriend()
    listView = self.listView
    showProgressHUD('正在删除好友', true)
    s_UserBaseServer.unfollow(self.array[self.selectIndex],
        function(api, result, err)
            if err == nil then
                s_UserBaseServer.removeFan(self.array[self.selectIndex],
                    function(api,result)
                        local SmallAlter = require('view.friend.HintAlter')
                        local smallAlter = SmallAlter.create('已删除该好友')
                        smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                        s_SCENE.popupLayer:addChild(smallAlter)
                        for i = 1,#s_CURRENT_USER.friends do
                            if s_CURRENT_USER.friends[i].username == self.array[self.selectIndex].username then
                                table.remove(s_CURRENT_USER.friends,i)
                                break
                            end
                        end

                        s_CURRENT_USER:parseServerUnFollowData(self.array[self.selectIndex])
                        s_CURRENT_USER:parseServerRemoveFanData(self.array[self.selectIndex])
                        s_CURRENT_USER.friendsCount = #s_CURRENT_USER.friends
                        s_CURRENT_USER.fansCount = #s_CURRENT_USER.fans
                        saveUserToServer({['friendsCount']=s_CURRENT_USER.friendsCount, ['fansCount']=s_CURRENT_USER.fansCount})

                        listView:removeItem(listView:getCurSelectedIndex())
                        listView:removeItem(self.selectIndex - 1)

                        for i = 1,table.getn(listView:getItems()) do
                            local item = listView:getItem(i - 1)
                            local button = item:getChildByName("Title Button")
                            button.index = i   
                            local str = 'n'
                            if i < 4 then str = string.format('%d',i) end
                            local rankIcon = button:getChildByName('rankIcon')
                            rankIcon:setTexture(string.format('image/friend/fri_rank_%s.png',str))

                            local rankLabel = rankIcon:getChildByName('rankLabel')
                            rankLabel:setString(string.format('%d',i))               
                        end

                        self.selectIndex = -2
                        hideProgressHUD(true)
                    end,
                    function(api, code, message, description) hideProgressHUD(true) end)
            else
                hideProgressHUD(true)
            end
        end)
end

function FriendList:cancelDel(sender, eventType)
    if eventType == ccui.TouchEventType.began then
        playSound(s_sound_buttonEffect)
    elseif eventType == ccui.TouchEventType.ended then
        s_SCENE.popupLayer.listener:setSwallowTouches(false)
        local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT*3/2)))
        local remove = cc.CallFunc:create(function() 
            self.back:removeFromParent() 
        end,{})
        self.back:runAction(cc.Sequence:create(move,remove))
    end
end
]]

return FriendList

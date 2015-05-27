-- require("cocos.init")
-- require("common.global")

local FriendSearch = class("FriendSearch", function()
    return cc.Layer:create()
end)

function FriendSearch.create()
    local layer = FriendSearch.new()
    --layer.friend = friend
    return layer 
end

function FriendSearch:ctor()

    local inputBack = cc.Sprite:create('image/friend/fri_inputback.png')
    inputBack:setPosition(0.5 * s_DESIGN_WIDTH,0.805 * s_DESIGN_HEIGHT)
    self:addChild(inputBack)
    
    local searchButton = ccui.Button:create('image/friend/fri_button_search.png','','')
    searchButton:setPosition(0.9 * inputBack:getContentSize().width,0.5 * inputBack:getContentSize().height)
    searchButton:setScale9Enabled(true)
    inputBack:addChild(searchButton,10)

    local cursor
    
    local function textFieldEvent(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then
            local textField = sender
            cursor:setVisible(true)
            textField:setPlaceHolder("")
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            local textField = sender
            textField:setPlaceHolder("请输入好友名字")
            cursor:setVisible(false)
        elseif eventType == ccui.TextFiledEventType.insert_text then
            local textField = sender
            cursor:setVisible(true)
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            local textField = sender
            cursor:setVisible(true)
        end
    end

    local textField = ccui.TextField:create()
    textField:setMaxLengthEnabled(true)
    textField:setMaxLength(16)
    textField:setTouchEnabled(true)
    textField:setFontSize(34)
    textField:setTextColor(cc.c3b(0,0,0))
    textField:setPlaceHolder("请输入好友名字")
    textField:setPlaceHolderColor(cc.c3b(150,150,150))
    textField:ignoreAnchorPointForPosition(false)
    textField:setAnchorPoint(0,0.5)
    textField:setPosition(cc.p(30, inputBack:getContentSize().height / 2.0))
    textField:addEventListener(textFieldEvent) 
    inputBack:addChild(textField) 
    textField:setTouchSize(inputBack:getContentSize())
    textField:setTouchAreaEnabled(true)

    cursor = cc.Label:createWithSystemFont("|","",34)
    cursor:setColor(cc.c4b(0,0,0,255))
    cursor:setVisible(false)
    cursor:setPosition(textField:getContentSize().width,34)
    cursor:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5))))
    inputBack:addChild(cursor)
    
    local update = function(dt)
        cursor:setPosition(34+textField:getContentSize().width, inputBack:getContentSize().height/2)
    end
    inputBack:scheduleUpdateWithPriorityLua(update, 0)
    
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            print('touchEvent')
            self:removeChildByName('searchResult',true)
            local username = textField:getString()
            --判断昵称不是自己
            --[[
                if username == s_CURRENT_USER.username or username == s_CURRENT_USER.nickName then
                    local SmallAlter = require('view.friend.HintAlter')
                    local smallAlter = SmallAlter.create('请不要搜索自己哦亲~')
                    smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    s_SCENE.popupLayer:addChild(smallAlter)
                    return
                end
            ]]
            if  username == "" then
                local SmallAlter = require('view.friend.HintAlter')
                local smallAlter = SmallAlter.create('无名氏什么的才没有的说~')
                smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                s_SCENE.popupLayer:addChild(smallAlter)
                return
            end
            local scale = (s_RIGHT_X - s_LEFT_X) / s_DESIGN_WIDTH
            showProgressHUD('正在搜索相应用户', true)

            local request = cx.CXAVCloud:create()
            -- request:searchUser(username, nickName, callback)
            request:searchUser(username, username, function (results, err)

                            hideProgressHUD(true)
                            local f_user = {}
                            print('request:searchUser:', tostring(results))
                            if err == nil and results ~= nil and type(results) == 'string' and string.len(results) > 0 then
                                local data = s_JSON.decode(results)
                                dump(data,"搜素好友列表返回",99)
                                for i, user in ipairs(data.results) do
                                    if user.nickName~="" and user.nickName~= username and user.username == username then
                                        --do nothing
                                    else
                                        if user.username ~= s_CURRENT_USER.username then
                                            f_user[#f_user + 1] = user
                                        end
                                    end
                                end
                            end
                            dump(f_user,"搜素好友列表返回",99)
                            if #f_user > 0 then
                                s_CURRENT_USER:getFriendsInfo() 
                                local listView = ccui.ListView:create()
                                -- set list view ex direction
                                listView:setDirection(ccui.ScrollViewDir.vertical)
                                listView:setBounceEnabled(true)
                                listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,0.7 * s_DESIGN_HEIGHT))
                                listView:setPosition(s_LEFT_X,0)
                                self:addChild(listView)
                                listView:setName('searchResult')
                                for i, fuser in ipairs(f_user) do
                                    local user = DataUser.create()
                                    parseServerDataToClientData(fuser,user)
                                    local button = cc.Sprite:create("image/friend/friendRankButton.png")
                                    local custom_item = ccui.Layout:create()
                                    custom_item:setTouchEnabled(true)
                                    custom_item:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,button:getContentSize().height + 4))
                                    button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2))
                                    custom_item:addChild(button,0,'button')
                
                                    local line = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,button:getContentSize().height + 4)
                                    line:ignoreAnchorPointForPosition(false)
                                    line:setAnchorPoint(0.5,0.5)
                                    line:setPosition(button:getContentSize().width / 2 , button:getContentSize().height / 2)
                                    button:addChild(line,-1)
                
                                    local head = cc.Sprite:create('image/PersonalInfo/hj_personal_avatar.png')
                                    head:setScale(0.8)
                                    head:setPosition(0.26 * button:getContentSize().width,0.5 * button:getContentSize().height)
                                    button:addChild(head)
                                    
                                    local tname = user.username
                                    if user.nickName ~= "" then
                                        tname = user.nickName
                                    end
                                    local fri_name = cc.Label:createWithSystemFont(tname,'',32)
                                    fri_name:setColor(cc.c3b(0,0,0))
                                    fri_name:ignoreAnchorPointForPosition(false)
                                    fri_name:setAnchorPoint(0,0)
                                    fri_name:setPosition(0.42 * button:getContentSize().width,0.52 * button:getContentSize().height)
                                    button:addChild(fri_name)
                                    local fri_word = cc.Label:createWithSystemFont(string.format('已学单词总数：%d',user.wordsCount),'',24)
                                    fri_word:setColor(cc.c3b(0,0,0))
                                    fri_word:ignoreAnchorPointForPosition(false)
                                    fri_word:setAnchorPoint(0,1)
                                    fri_word:setPosition(0.42 * button:getContentSize().width,0.48 * button:getContentSize().height)
                                    button:addChild(fri_word)
                                    button:setScaleX(scale)
                                    head:setScaleX(0.8 / scale)
                                    fri_name:setScaleX(1 / scale)
                                    fri_word:setScaleX(1 / scale)
                                    
                                    local isFriend = 0
                                    self.array = {}
                                    for i = 1,#s_CURRENT_USER.friends do
                                        self.array[i] = s_CURRENT_USER.friends[i]
                                    end
                                    self.array[#self.array + 1] = s_CURRENT_USER
                                    --如果这个玩家在自己的好友列表里 则计算出他的排名
                                    for i = 1,#self.array do
                                        for j = i, #self.array do
                                            if self.array[i].wordsCount < self.array[j].wordsCount or (self.array[i].wordsCount == self.array[j].wordsCount and self.array[i].masterCount < self.array[j].masterCount) then
                                                local temp = self.array[i]
                                                self.array[i] = self.array[j]
                                                self.array[j] = temp
                                            end
                                        end
                                    end
                                    for i = 1, #self.array do
                                        if self.array[i].username == user.username then
                                            isFriend = i
                                            break
                                        end
                                    end

                                    if isFriend then
                                        listView:insertCustomItem(custom_item,0)
                                    else
                                        listView:addChild(custom_item)
                                    end

                                    local arrow = cc.Sprite:create('image/friend/fri_button_gou.png')
                                    arrow:setPosition(0.9 * button:getContentSize().width,0.5 * button:getContentSize().height)
                                    button:addChild(arrow)
                                    arrow:setScaleX(1 / scale)
                                    if isFriend > 0 then
                                        arrow:setVisible(true)
                                        local str = 'n'
                                        if isFriend < 4 then
                                            str = string.format('%d',isFriend)
                                        end
                                        local rankIcon = cc.Sprite:create(string.format('image/friend/fri_rank_%s.png',str))
                                        rankIcon:setPosition(0.08 * button:getContentSize().width,0.5 * button:getContentSize().height)
                                        button:addChild(rankIcon)
                                        rankIcon:setScaleX(1 / scale)
                                        local rankLabel = cc.Label:createWithSystemFont(string.format('%d',isFriend),'',36)
                                        rankLabel:setPosition(rankIcon:getContentSize().width / 2,rankIcon:getContentSize().width / 2)
                                        rankIcon:addChild(rankLabel)
                                    else 
                                        arrow:setVisible(false)
                                        local add = ccui.Button:create('image/friend/fri_button_add.png','image/friend/fri_button_add.png','')
                                        add:setPosition(0.9 * button:getContentSize().width,0.5 * button:getContentSize().height)
                                        button:addChild(add)
                                        add:setScaleX(1 / scale)
                                        local function onAdd(sender,eventType)
                                            if eventType == ccui.TouchEventType.ended then
                                                if s_CURRENT_USER.friendsCount >= s_friend_max_count then
                                                    local SmallAlter = require('view.friend.HintAlter')
                                                    local smallAlter = SmallAlter.create('您的好友数已达上限')
                                                    smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                                                    s_SCENE.popupLayer:addChild(smallAlter)
                                                    return
                                                end
                                                showProgressHUD('正在发送好友请求', true)
                                                AnalyticsFriendRequest()
                                                s_UserBaseServer.unfollow(user,
                                                    function(api, result, err)
                                                        if err == nil then
                                                            s_CURRENT_USER:parseServerUnFollowData(self.array[self.selectIndex])
                                                            s_UserBaseServer.follow(user,
                                                                function (api, result, err)
                                                                    if err == nil then
                                                                        local fan = nil
                                                                        local key = 0
                                                                        for i,f in ipairs(s_CURRENT_USER.fans) do
                                                                            if f.username == user.username then
                                                                                fan = f
                                                                                key = i
                                                                                break
                                                                            end
                                                                        end

                                                                        if fan then
                                                                            s_CURRENT_USER.friends[#s_CURRENT_USER.friends + 1] = user
                                                                            s_CURRENT_USER:parseServerFollowData(user)
                                                                            table.remove(s_CURRENT_USER.fans, key)
                                                                        end
                                                                        arrow:setVisible(true)
                                                                        add:setVisible(false)

                                                                        local SmallAlter = require('view.friend.HintAlter')
                                                                        local smallAlter = SmallAlter.create('好友请求发送成功')
                                                                        smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                                                                        s_SCENE.popupLayer:addChild(smallAlter) 
                                                                    else
                                                                        local SmallAlter = require('view.friend.HintAlter')
                                                                        local smallAlter = SmallAlter.create('好友请求发送失败')
                                                                        smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                                                                        s_SCENE.popupLayer:addChild(smallAlter) 
                                                                    end
                                                                    hideProgressHUD(true)
                                                                end)
                                                        else
                                                            hideProgressHUD(true)
                                                        end
                                                    end)
                                                
                                            end
                                        end
                                        add:addTouchEventListener(onAdd)
                                    end
                                end
                            else --not find user
                                local SmallAlter = require('view.friend.HintAlter')
                                local smallAlter = SmallAlter.create('未找到相应用户')
                                smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                                s_SCENE.popupLayer:addChild(smallAlter) 
                            end
            end)
            
            
            
        end
    end      
    searchButton:addTouchEventListener(touchEvent)
end

return FriendSearch
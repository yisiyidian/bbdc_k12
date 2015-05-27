-- 处理好友请求
-- require("cocos.init")
-- require("common.global")

local FriendRequest = class("FriendRequest", function()
    return cc.Layer:create()
end)

function FriendRequest.create()
    local layer = FriendRequest.new()
    return layer 
end

function FriendRequest:ctor()
    showProgressHUD('正在加载好友请求',true)

    local back = cc.LayerColor:create(cc.c4b(255,255,255,255),s_RIGHT_X - s_LEFT_X,162 * 6)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    back:setPosition(0.5 * s_DESIGN_WIDTH,162 * 3)
    self:addChild(back)

    s_UserBaseServer.getFolloweesOfCurrentUser(
        function (api, result)
            s_UserBaseServer.getFollowersOfCurrentUser(
            function (api, result)
                self:main()
                hideProgressHUD(true)
            end,
            function (api, code, message, description)
                hideProgressHUD(true)
            end)
        end,
        function (api, code, message, description)
            hideProgressHUD(true)
        end)

    
end

function FriendRequest:main()
    
    s_CURRENT_USER:getFriendsInfo() 
    s_CURRENT_USER.seenFansCount = s_CURRENT_USER.fansCount
    saveUserToServer({['seenFansCount']=s_CURRENT_USER.seenFansCount})
    local array = s_CURRENT_USER.fans
    -- for i = 1,#array do
        --array[i] = string.format("ListView_item_%d",i - 1)
    -- end


    local listView = ccui.ListView:create()
    -- set list view ex direction
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setBackGroundImageScale9Enabled(true)
    listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,162 * 6))
    listView:setPosition(s_LEFT_X,0)
    self:addChild(listView)


    -- create model
    local default_button = cc.LayerColor:create(cc.c4b(255,255,255,255),s_RIGHT_X - s_LEFT_X,280)
    default_button:ignoreAnchorPointForPosition(false)
    default_button:setAnchorPoint(0.5,0.5)
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
    for i = 1,math.floor(count) do
        listView:pushBackDefaultItem()
    end
    --insert default item
    for i = 1,math.floor(count) do
        listView:insertDefaultItem(0)
    end

    listView:removeAllChildren()

    --add custom item
    for i = 1,count do
        local custom_button = cc.LayerColor:create(cc.c4b(255,255,255,255),s_RIGHT_X - s_LEFT_X,280)
        custom_button:ignoreAnchorPointForPosition(false)
        custom_button:setAnchorPoint(0.5,0.5)
        custom_button:setName("Title Button")
        custom_button:setContentSize(default_button:getContentSize())

        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,280 + 2))
        custom_button:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(custom_button,1)

        local back = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,282)
        back:ignoreAnchorPointForPosition(false)
        back:setAnchorPoint(0.5,0.5)
        back:setPosition(cc.p(custom_item:getContentSize().width / 2.0, custom_item:getContentSize().height / 2.0))
        custom_item:addChild(back,0)

        listView:addChild(custom_item) 
    end


    -- set item data
    local items_count = table.getn(listView:getItems())
    for i = 1,items_count do
        local j = items_count + 1 - i
        local item = listView:getItem(i - 1)
        local button = item:getChildByName("Title Button")
        local index = listView:getIndex(item)
        
        local head = cc.Sprite:create('image/PersonalInfo/hj_personal_avatar.png')
        head:setScale(0.8)
        head:setPosition(0.26 * button:getContentSize().width,0.6 * button:getContentSize().height)
        button:addChild(head)

        local name = s_CURRENT_USER.fans[i].username
        if s_CURRENT_USER.fans[i].userType == USER_TYPE_QQ or s_CURRENT_USER.fans[i].nickName ~= "" then
            name = s_CURRENT_USER.fans[i].nickName
        end

        local fri_name = cc.Label:createWithSystemFont(name,'',28)
        fri_name:setColor(cc.c3b(0,0,0))
        fri_name:ignoreAnchorPointForPosition(false)
        fri_name:setAnchorPoint(0,0)
        fri_name:setPosition(0.42 * button:getContentSize().width,0.62 * button:getContentSize().height)
        button:addChild(fri_name)
        
        local request_label = cc.Label:createWithSystemFont(' 请求添加您为好友','',20)
        request_label:setColor(cc.c3b(0,0,0))
        request_label:ignoreAnchorPointForPosition(false)
        request_label:setAnchorPoint(0,0)
        request_label:setPosition(fri_name:getPositionX() + fri_name:getContentSize().width,fri_name:getPositionY() + 2)
        button:addChild(request_label)
        local fri_word = cc.Label:createWithSystemFont(string.format('已学单词总数：%d',s_CURRENT_USER.fans[i].wordsCount),'',20)
        fri_word:setColor(cc.c3b(0,0,0))
        fri_word:ignoreAnchorPointForPosition(false)
        fri_word:setAnchorPoint(0,1)
        fri_word:setPosition(0.42 * button:getContentSize().width,0.58 * button:getContentSize().height)
        button:addChild(fri_word)
        
        local agree = ccui.Button:create("image/friend/fri_button_blue.png","image/friend/fri_button_blue.png","image/friend/fri_button_blue.png")
        agree:setPosition(0.3 * button:getContentSize().width,0.2 * button:getContentSize().height)
        button:addChild(agree)
        local agree_label = cc.Label:createWithSystemFont("同意",'',24)
        agree_label:setPosition(0.5 * agree:getContentSize().width,0.5 * agree:getContentSize().height)
        agree:addChild(agree_label)
        
        local function onAgree(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                if s_CURRENT_USER.fans[listView:getCurSelectedIndex() + 1].friendsCount >= s_friend_max_count then
                    local SmallAlter = require('view.friend.HintAlter')
                    local smallAlter = SmallAlter.create('对方好友数已达上限')
                    smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    s_SCENE.popupLayer:addChild(smallAlter)
                    return
                end
                if s_CURRENT_USER.friendsCount >= s_friend_max_count then
                    local SmallAlter = require('view.friend.HintAlter')
                    local smallAlter = SmallAlter.create('您的好友数已达上限')
                    smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    s_SCENE.popupLayer:addChild(smallAlter)
                    return
                end
                
                AnalyticsFriendAccept()

                s_UserBaseServer.follow(s_CURRENT_USER.fans[listView:getCurSelectedIndex() + 1],
                    function (api, result, err)
                        if err == nil then
                            s_CURRENT_USER:parseServerFollowData(s_CURRENT_USER.fans[listView:getCurSelectedIndex() + 1])
                            s_CURRENT_USER.friends[#s_CURRENT_USER.friends + 1] = s_CURRENT_USER.fans[listView:getCurSelectedIndex() + 1]
                            table.remove(s_CURRENT_USER.fans,listView:getCurSelectedIndex() + 1)
                            listView:removeItem(listView:getIndex(item))
                            local SmallAlter = require('view.friend.HintAlter')
                            local smallAlter = SmallAlter.create('已同意好友请求')
                            smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                            s_SCENE.popupLayer:addChild(smallAlter) 
                            s_CURRENT_USER.friendsCount = #s_CURRENT_USER.friends
                            s_CURRENT_USER.fansCount = #s_CURRENT_USER.fans
                            s_CURRENT_USER.seenFansCount = s_CURRENT_USER.fansCount
                            saveUserToServer({['friendsCount']=s_CURRENT_USER.friendsCount, 
                                              ['fansCount']=s_CURRENT_USER.fansCount, 
                                              ['seenFansCount']=s_CURRENT_USER.seenFansCount})
                        end
                    end
                )
            end
        end
        agree:addTouchEventListener(onAgree)
        
        local refuse = ccui.Button:create("image/friend/fri_button_grey.png","image/friend/fri_button_grey.png","image/friend/fri_button_grey.png")
        refuse:setPosition(0.7 * button:getContentSize().width,0.2 * button:getContentSize().height)
        button:addChild(refuse)
        local refuse_label = cc.Label:createWithSystemFont("拒绝",'',24)
        refuse_label:setPosition(0.5 * refuse:getContentSize().width,0.5 * refuse:getContentSize().height)
        refuse:addChild(refuse_label)
        
        local function onRefuse(sender,eventType)
            if eventType == ccui.TouchEventType.ended then
                
                s_UserBaseServer.removeFan(s_CURRENT_USER.fans[listView:getCurSelectedIndex() + 1],
                    function(api,result)
                        s_CURRENT_USER:parseServerRemoveFanData(s_CURRENT_USER.fans[listView:getCurSelectedIndex() + 1])
                        listView:removeItem(listView:getIndex(item))
                        table.remove(s_CURRENT_USER.fans,listView:getCurSelectedIndex() + 1)
                        local SmallAlter = require('view.friend.HintAlter')
                        local smallAlter = SmallAlter.create('已拒绝好友请求')
                        smallAlter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                        s_SCENE.popupLayer:addChild(smallAlter) 
                        s_CURRENT_USER.friendsCount = #s_CURRENT_USER.friends
                        s_CURRENT_USER.fansCount = #s_CURRENT_USER.fans
                        s_CURRENT_USER.seenFansCount = s_CURRENT_USER.fansCount
                        saveUserToServer({['friendsCount']=s_CURRENT_USER.friendsCount, 
                                          ['fansCount']=s_CURRENT_USER.fansCount, 
                                          ['seenFansCount']=s_CURRENT_USER.seenFansCount})
                    end,
                    function(api, code, message, description)
                    end
                )
            end
        end
        refuse:addTouchEventListener(onRefuse)
    end

    listView:setItemsMargin(2.0)
end

return FriendRequest
require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

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
    
    local searchButton = ccui.Button:create('image/friend/fri_button_search.png','image/friend/fri_button_search.png','')
    searchButton:setPosition(0.9 * inputBack:getContentSize().width,0.5 * inputBack:getContentSize().height)
    inputBack:addChild(searchButton)
    
    local function textFieldEvent(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then
            local textField = sender
            textField:setPlaceHolder("")
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            local textField = sender
            textField:setPlaceHolder("请输入好友名字")
        elseif eventType == ccui.TextFiledEventType.insert_text then
            local textField = sender
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            local textField = sender
        end
    end

    local textField = ccui.TextField:create()
    textField:setMaxLengthEnabled(true)
    textField:setMaxLength(16)
    textField:setTouchEnabled(true)
    textField:setFontSize(30)
    textField:setColor(cc.c3b(0,0,0))
    textField:setPlaceHolder("请输入好友名字")
    textField:setPosition(cc.p(inputBack:getContentSize().width / 2.0, inputBack:getContentSize().height / 2.0))
    textField:addEventListener(textFieldEvent) 
    inputBack:addChild(textField) 
    
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            self:removeChildByName('searchResult',true)
            local username = textField:getStringValue()
            s_UserBaseServer.searchUserByUserName(username,
                function(api,result)
                    if #result.results > 0 then
                        for i, user in ipairs(result.results) do
                            local button = ccui.Button:create("image/friend/friendRankButton.png", "image/friend/friendRankButton.png")
                            button:setPosition(0.5 * s_DESIGN_WIDTH, 0.65 * s_DESIGN_HEIGHT)
                            button:setScale9Enabled(true)
                            self:addChild(button,0,'searchResult')
        
                            local line = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,button:getContentSize().height + 4)
                            line:ignoreAnchorPointForPosition(false)
                            line:setAnchorPoint(0.5,0.5)
                            line:setPosition(button:getContentSize().width / 2 , button:getContentSize().height / 2)
                            button:addChild(line,-1)
        
                            local head = cc.Sprite:create('image/PersonalInfo/hj_personal_avatar.png')
                            head:setScale(0.8)
                            head:setPosition(0.26 * button:getContentSize().width,0.5 * button:getContentSize().height)
                            button:addChild(head)
        
                            local fri_name = cc.Label:createWithSystemFont(user.username,'',32)
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
                            local isFriend = 0
                            self.array = s_CURRENT_USER.friends
                            self.array[#self.array + 1] = s_CURRENT_USER
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
                            local arrow = cc.Sprite:create('image/friend/fri_button_gou.png','image/friend/fri_button_gou.png','')
                            arrow:setPosition(0.9 * button:getContentSize().width,0.5 * button:getContentSize().height)
                            button:addChild(arrow)
                            if i > 0 then
                                arrow:setVisible(true)
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

                            else 
                                arrow:setVisible(false)
                                local add = ccui.Button:create('image/friend/fri_button_add.png','image/friend/fri_button_add.png','')
                                add:setPosition(0.9 * button:getContentSize().width,0.5 * button:getContentSize().height)
                                button:addChild(add)
                                
                                local function onAdd(sender,eventType)
                                    if eventType == ccui.TouchEventType.ended then

                                        s_UserBaseServer.follow(user,
                                            function(api,result)
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
                                                table.remove(s_CURRENT_USER.fans,key)
                                                s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER,
                                                    function(api,result)
                                                    end,
                                                    function(api, code, message, description)
                                                    end)
                                                end
                                                arrow:setVisible(true)
                                                add:setVisible(false)
                                            end,
                                            function(api, code, message, description)
                                            end
                                        )
                                    end
                                end
                                button:addTouchEventListener(onAdd)
                            end
                            
                            break
                        end
                    else --not find user
                        
                    end
                end,
                function(api, code, message, description)
                end)
            
            
        end
    end      
    searchButton:addTouchEventListener(touchEvent)
end

return FriendSearch
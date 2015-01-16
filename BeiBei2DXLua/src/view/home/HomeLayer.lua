require("cocos.init")
require("common.global")

local AlterI = require("view.alter.AlterI")
local ImproveInfo = require("view.home.ImproveInfo")
local MissionProgress = require("view.home.MissionProgressLayer")
local OfflineTipHome = require("view.offlinetip.OffLineTipForHome")
local OfflineTipFriend = require("view.offlinetip.OffLineTipForFriend")

local HomeLayer = class("HomeLayer", function ()
    return cc.Layer:create()
end)

function HomeLayer.create()
    -- data begin
    local bookName          = s_DataManager.books[s_CURRENT_USER.bookKey].name
    local bookWordCount     = s_DataManager.books[s_CURRENT_USER.bookKey].words
    
    local bookProgress = s_CURRENT_USER.bookProgress:getBookProgress(s_CURRENT_USER.bookKey)
    local currentChapterKey = bookProgress['chapter']
    local currentLevelKey   = bookProgress['level']
    
    local chapterIndex      = string.sub(currentChapterKey, 8)+1
    local levelIndex        = string.sub(currentLevelKey, 6)+1
    local levelName         = "第"..chapterIndex.."章  第"..levelIndex.."关"

    local studyWordNum      = s_LocalDatabaseManager.getTotalStudyWordsNum()
    local graspWordNum      = s_LocalDatabaseManager.getTotalGraspWordsNum()

    local redHint = nil
    -- data end
    
    local list = {}
    local username = "游客"
    local logo_name = {"head","book","feedback","information","logout"}
    local label_name = {username,"选择书籍","用户反馈","完善个人信息","登出游戏"}

    s_SCENE.touchEventBlockLayer.unlockTouch()
    local layer = HomeLayer.new()
    
    local offset = 500
    local viewIndex = 1
   
    
    local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH

    local backColor = cc.LayerColor:create(cc.c4b(211,239,254,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
    
    local setting_back
    
    --add offline

    local onLine = s_SERVER.isNetworkConnnectedWhenInited() 
--    onLine = false
    local offLineTipHome = OfflineTipHome.create()
    local offLineTipFriend = OfflineTipFriend.create()

    if onLine == false then
        layer:addChild(offLineTipHome,2)
        layer:addChild(offLineTipFriend,2) 
    end

    local mission_progress = MissionProgress.create()
    backColor:addChild(mission_progress,1)
    local downloadSoundButton = require("view.home.DownloadSoundButton").create(mission_progress)
   
    local name = cc.Sprite:create("image/homescene/title_shouye_name.png")
    name:setPosition(bigWidth/2, s_DESIGN_HEIGHT-120)
    backColor:addChild(name)
    
    local currentBook = cc.Label:createWithSystemFont("正在学习："..s_CURRENT_USER.bookKey,"",40)
    currentBook:setPosition(bigWidth/2, s_DESIGN_HEIGHT-180)
    currentBook:setColor(cc.c4b(61,191,244,255))
    backColor:addChild(currentBook)
    
    local button_left_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            -- button sound
            playSound(s_sound_buttonEffect)
            
        elseif eventType == ccui.TouchEventType.ended then
        
            if onLine == false then
                offLineTipHome.setFalse()
                offLineTipFriend.setFalse()
            end
            
            if viewIndex == 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
       
                mission_progress.stopListener = true
            
                viewIndex = 2
            
                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2+offset,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X+offset,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
                
                --offline tip
                
            else
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                
                mission_progress.stopListener = false
                
                viewIndex = 1

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        end
    end

    local button_main = ccui.Button:create("image/homescene/main_set.png","image/homescene/main_set.png","")
    button_main:setPosition((bigWidth-s_DESIGN_WIDTH)/2+50, s_DESIGN_HEIGHT-120)
    button_main:addTouchEventListener(button_left_clicked)
    backColor:addChild(button_main)
    
   
    local button_right_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            AnalyticsFriendBtn()

            -- button sound
            playSound(s_sound_buttonEffect)
            
            elseif eventType == ccui.TouchEventType.ended then
            
            if  onLine == false then
                offLineTipFriend.setTrue()
            else
                if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
                    s_CorePlayManager.enterFriendLayer()
                else

                    if s_CURRENT_USER.usertype == USER_TYPE_GUEST then
                        local Item_popup = require("popup/PopupModel")
                        local item_popup = Item_popup.create(Site_From_Friend_Guest)  

                        item_popup.update = function()
                            if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
                                list[1].label:setString(s_CURRENT_USER.username)
                                list[5].button_back:setPosition(0, s_DESIGN_HEIGHT - list[5].button_back:getContentSize().height * (4 - 1) - 20)
                                if list[4].button_back ~= nil then list[4].button_back:removeFromParent() end
                            end
                        end

                        s_SCENE:popup(item_popup)
                    else
                        local Item_popup = require("popup/PopupModel")
                        local item_popup = Item_popup.create(Site_From_Friend_Not_Enough_Level)  

                        s_SCENE:popup(item_popup)
                    end              

                end   
            end

       
        end
    end
    
    local button_friend = ccui.Button:create("image/homescene/main_friends.png","image/homescene/main_friends.png","")
    button_friend:setPosition((bigWidth-s_DESIGN_WIDTH)/2+s_DESIGN_WIDTH-50, s_DESIGN_HEIGHT-120)
    button_friend:addTouchEventListener(button_right_clicked)
    backColor:addChild(button_friend)   
    s_UserBaseServer.getFollowersAndFolloweesOfCurrentUser( 
        function (api, result)
            print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)
            s_CURRENT_USER:getFriendsInfo()
            print("seenFansCount = %d, fansCount = %d",s_CURRENT_USER.seenFansCount,s_CURRENT_USER.fansCount)

            if s_CURRENT_USER.seenFansCount < s_CURRENT_USER.fansCount then
                redHint = cc.Sprite:create('image/friend/fri_infor.png')
                redHint:setPosition(button_friend:getContentSize().width * 0.8,button_friend:getContentSize().height * 0.9)
                button_friend:addChild(redHint)
               
                local num = cc.Label:createWithSystemFont(string.format('%d',s_CURRENT_USER.fansCount - s_CURRENT_USER.seenFansCount),'',28)
                num:setPosition(redHint:getContentSize().width / 2,redHint:getContentSize().height / 2)
                redHint:addChild(num)
            end
        end,
        function (api, code, message, description)
        end
    )

--


    
    local button_play_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended and viewIndex == 1 then
--            s_CorePlayManager.initTotalPlay()
            -- generate random list
            s_CURRENT_USER:generateSummaryBossList()
            s_CURRENT_USER:generateChestList()
            s_CURRENT_USER:updateDataToServer()
            
            AnalyticsEnterLevelLayerBtn()
            AnalyticsFirst(ANALYTICS_FIRST_LEVEL, 'TOUCH')

            showProgressHUD()
            -- button sound
            playSound(s_sound_buttonEffect)  
            s_CorePlayManager.enterLevelLayer()  
            hideProgressHUD()
            

--            s_UserBaseServer.saveDataObjectOfCurrentUser(self,
--                function(api,result)
--                    s_CorePlayManager.initTotalPlay()
--                end,
--                function(api, code, message, description)
--                    s_CorePlayManager.initTotalPlay()
--                end)
            
        end
    end
    -- local ACCUMULATING_WORD = 2
    -- local LEARNING_WORD = 3
    -- local REVIEWING_WORD = 1
    -- local COMPLETE_MISSION = 4
    local state = s_LocalDatabaseManager.getGameState()

    local playImg = 'image/homescene/bigbutton.png'
    if state == s_gamestate_overmodel then
        playImg = 'image/homescene/buttonfinish.png'
    end
    local state_str
    if state == s_gamestate_studymodel then
        state_str = '积累生词'
    elseif state == s_gamestate_reviewmodel then
        state_str = '趁热打铁'
    elseif state == s_gamestate_reviewbossmodel then
        state_str = '复习旧词'
    else
        state_str = '  完成  '
    end

    local button_play = ccui.Button:create(playImg,'','')
    button_play:setScale9Enabled(true)
    button_play:setPosition(bigWidth/2, 200)
    button_play:addTouchEventListener(button_play_clicked)
--    backColor:addChild(button_play)
    
    --guide new player
    if s_CURRENT_USER.tutorialStep == s_tutorial_home then
        local finger = sp.SkeletonAnimation:create('spine/yindaoye_shoudonghua_dianji.json', 'spine/yindaoye_shoudonghua_dianji.atlas',1)
        finger:addAnimation(0, 'animation', true)
        finger:setPosition(button_play:getContentSize().width/2+20,-30)
        button_play:addChild(finger,10)
        s_CURRENT_USER:setTutorialStep(s_tutorial_home+1)
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_home+1)
    end

    local state_label = cc.Label:createWithSystemFont('当前状态：','',24)
    state_label:setPosition(button_play:getContentSize().width * 0.25,button_play:getContentSize().height / 2)
    button_play:addChild(state_label)

    local state_label2 = cc.Label:createWithSystemFont(state_str,'',40)
    state_label2:setPosition(button_play:getContentSize().width * 0.6,button_play:getContentSize().height / 2)
    button_play:addChild(state_label2)

    local state_label3 = cc.Label:createWithSystemFont('>>','',24)
    state_label3:setPosition(button_play:getContentSize().width * 0.9,button_play:getContentSize().height / 2)
    button_play:addChild(state_label3)   

    local button_data
    local data_back
    local isDataShow = false
    local button_data_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended and viewIndex == 1 then
            AnalyticsDataCenterBtn()

            -- button sound
            playSound(s_sound_buttonEffect)
            
           if isDataShow then
               isDataShow = false
               button_friend:setEnabled(true)
               button_main:setEnabled(true)
               local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, 0))
               local action2 = cc.CallFunc:create(function()
                   button_data:setLocalZOrder(0)
                   data_back:removeChildByName('PersonalInfo')
               end)
               button_data:runAction(cc.Sequence:create(action1, action2))
           else
               isDataShow = true
               button_friend:setEnabled(false)
               button_main:setEnabled(false)
               button_data:setLocalZOrder(2)
               button_data:runAction(cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT-280)))
               if true then
                   local PersonalInfo = require("view.PersonalInfo")
                   local personalInfoLayer = PersonalInfo.create()
                   personalInfoLayer:setPosition(-s_LEFT_X,0)
                   data_back:addChild(personalInfoLayer,0,'PersonalInfo') 
               else
                   local Item_popup = require("popup/PopupModel")
                   local item_popup = Item_popup.create(Site_From_Information)  
                   s_SCENE:popup(item_popup)
               end 
           end

        end
    end

    button_data = cc.Sprite:create("image/homescene/main_bottom.png")
    button_data:setAnchorPoint(0.5,0)
    button_data:setPosition(bigWidth/2, 0)
    --button_data:addTouchEventListener(button_data_clicked)
    backColor:addChild(button_data)
    
    data_back = cc.LayerColor:create(cc.c4b(255,255,255,255), bigWidth, s_DESIGN_HEIGHT - 280)  
    data_back:setAnchorPoint(0.5,1)
    data_back:ignoreAnchorPointForPosition(false)  
    data_back:setPosition(button_data:getContentSize().width/2, 0)
    button_data:addChild(data_back)
    
    local data_name = cc.Label:createWithSystemFont("数据","",28)
    data_name:setColor(cc.c4b(0,0,0,255))
    data_name:setPosition(button_data:getContentSize().width/2+30, button_data:getContentSize().height/2-5)
    button_data:addChild(data_name)

    -- setting ui
    setting_back = cc.Sprite:create("image/homescene/setup_background.png")
    setting_back:setAnchorPoint(1,0.5)
    setting_back:setPosition(s_LEFT_X, s_DESIGN_HEIGHT/2)
    layer:addChild(setting_back)

    
    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
        username = s_CURRENT_USER:getNameForDisplay()
        logo_name = {"head","book","feedback","logout"}
        label_name = {username,"选择书籍","用户反馈","登出游戏"}
    end
    for i = 1, #logo_name do
        local button_back_clicked = function(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                playSound(s_sound_buttonEffect)
                if label_name[i] == "选择书籍" then
                    AnalyticsChangeBookBtn()
                    s_CorePlayManager.enterBookLayer()
                elseif label_name[i] == "用户反馈" then
                    if  onLine == false then
                        offLineTipHome.setTrue(OffLineTipForHome_Feedback)
                    else
                        local alter = AlterI.create("用户反馈")
                        alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                        layer:addChild(alter)
                    end
                elseif label_name[i] == "完善个人信息" then
                    if  onLine == false then
                        offLineTipHome.setTrue(OffLineTipForHome_ImproveInformation)
                    else
                        local improveInfo = ImproveInfo.create(ImproveInfoLayerType_UpdateNamePwd_FROM_HOME_LAYER)
                        improveInfo:setTag(1)
                        improveInfo:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                        layer:addChild(improveInfo)

                        improveInfo.close = function()
                            layer:removeChildByTag(1)
                            if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
                                list[1].label:setString(s_CURRENT_USER.username)
                                list[5].button_back:setPosition(0, s_DESIGN_HEIGHT - list[5].button_back:getContentSize().height * (4 - 1) - 20)
                                if list[4].button_back ~= nil then list[4].button_back:removeFromParent() end
                            end
                        end
                    end
                elseif label_name[i] == "登出游戏" then
                    if  onLine == false then
                        offLineTipHome.setTrue(OffLineTipForHome_Logout)
                    else
                        -- logout
                        AnalyticsLogOut()
                        cx.CXAvos:getInstance():logOut()
                        s_LocalDatabaseManager.setLogOut(true)
                        s_LocalDatabaseManager.close()
                        s_START_FUNCTION()
                    end
                else
                    -- do nothing
                end
            end
        end

        local button_back = ccui.Button:create("image/homescene/setup_button.png","image/homescene/setup_button.png","")
        button_back:setAnchorPoint(0, 1)
        button_back:setPosition(0, s_DESIGN_HEIGHT-button_back:getContentSize().height * (i - 1) - 20)
        button_back:addTouchEventListener(button_back_clicked)
        setting_back:addChild(button_back)
        
        local logo = cc.Sprite:create("image/homescene/setup_"..logo_name[i]..".png")
        logo:setPosition(button_back:getContentSize().width-offset+50, button_back:getContentSize().height/2)
        button_back:addChild(logo)
        
        local label = cc.Label:createWithSystemFont(label_name[i],"",28)
        label:setColor(cc.c4b(0,0,0,255))
        label:setAnchorPoint(0, 0.5)
        label:setPosition(button_back:getContentSize().width-offset+100, button_back:getContentSize().height/2)
        button_back:addChild(label)
        
        local split = cc.Sprite:create("image/homescene/setup_line.png")
        split:setAnchorPoint(0.5,0)
        split:setPosition(button_back:getContentSize().width/2, 0)
        button_back:addChild(split)
        
        --add offline 
        if i == 1 or i == 2 then
        else
            if onLine == false then
               label:setColor(cc.c4b(157,157,157,255))
            end
        end

        local t = {}
        t.button_back = button_back
        t.logo = logo
        t.label = label
        t.split = split
        table.insert(list, t)
    end
    
    local setting_shadow = cc.Sprite:create("image/homescene/setup_shadow.png")
    setting_shadow:setAnchorPoint(1,0.5)
    setting_shadow:setPosition(setting_back:getContentSize().width, setting_back:getContentSize().height/2)
    setting_back:addChild(setting_shadow)
    
    local moveLength = 100
    local moved = false
    local start_x = nil
    local start_y = nil
    local onTouchBegan = function(touch, event)

        local location = layer:convertToNodeSpace(touch:getLocation())
        start_x = location.x
        start_y = location.y
        moved = false
        return true
    end
    
    local onTouchMoved = function(touch, event)
        if moved then
            return
        end
    
        local location = layer:convertToNodeSpace(touch:getLocation())
        local now_x = location.x
        local now_y = location.y
        
        if start_y < 0.1 * s_DESIGN_HEIGHT and start_x > s_DESIGN_WIDTH * 0.0 and start_x < s_DESIGN_WIDTH * 2.0 then
            if now_y - moveLength > start_y and not isDataShow and viewIndex == 1 then         
                   isDataShow = true
                   button_friend:setEnabled(false)
                   button_main:setEnabled(false)
                   button_data:setLocalZOrder(2)
                   button_data:runAction(cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT-280)))
                   if true then
                       local PersonalInfo = require("view.PersonalInfo")
                       local personalInfoLayer = PersonalInfo.create()
                       personalInfoLayer:setPosition(-s_LEFT_X,0)
                       data_back:addChild(personalInfoLayer,0,'PersonalInfo') 
                   else
                       local Item_popup = require("popup/PopupModel")
                       local item_popup = Item_popup.create(Site_From_Information)  
                       s_SCENE:popup(item_popup)
                   end 
                   return
            end
            
        end
        if start_y > s_DESIGN_HEIGHT - 280 and start_x > s_DESIGN_WIDTH * 0.0 and start_x < s_DESIGN_WIDTH * 2.0 then
            if now_y + moveLength < start_y and isDataShow and viewIndex == 1 then
                isDataShow = false
                button_friend:setEnabled(true)
                button_main:setEnabled(true)
                local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, 0))
                local action2 = cc.CallFunc:create(function()
                   button_data:setLocalZOrder(0)
                   data_back:removeChildByName('PersonalInfo')
                end)
                button_data:runAction(cc.Sequence:create(action1, action2))
                return
            end
            
        end

        if now_x - moveLength > start_x and not isDataShow then
            if viewIndex == 1 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

                viewIndex = 2

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2+offset,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X+offset,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        elseif now_x + moveLength < start_x and not isDataShow then
            if viewIndex == 2 then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

                viewIndex = 1

                local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
                backColor:runAction(action1)

                local action2 = cc.MoveTo:create(0.5, cc.p(s_LEFT_X,s_DESIGN_HEIGHT/2))
                local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
                setting_back:runAction(cc.Sequence:create(action2, action3))
            end
        end
    end

    local onTouchEnded = function(touch,event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        if not isDataShow then
            if location.y ~= start_y or location.x ~= start_x then
                return
            elseif viewIndex == 1 and location.y < 0.1 * s_DESIGN_HEIGHT then
                isDataShow = true
                   button_friend:setEnabled(false)
                   button_main:setEnabled(false)
                   button_data:setLocalZOrder(2)
                   button_data:runAction(cc.MoveTo:create(0.5,cc.p(bigWidth/2, s_DESIGN_HEIGHT-280)))
                   if true then

                    if onLine == false then
                        offLineTipHome.setFalse()
                        offLineTipFriend.setFalse()
                    end
                    
                       local PersonalInfo = require("view.PersonalInfo")
                       local personalInfoLayer = PersonalInfo.create()
                       personalInfoLayer:setPosition(-s_LEFT_X,0)
                       data_back:addChild(personalInfoLayer,0,'PersonalInfo') 
                   else
                       local Item_popup = require("popup/PopupModel")
                       local item_popup = Item_popup.create(Site_From_Information)  
                       s_SCENE:popup(item_popup)
                   end 
            end

        elseif location.y >  s_DESIGN_HEIGHT-280 and (location.y == start_y and location.x == start_x) and viewIndex == 1 then
            isDataShow = false
            button_friend:setEnabled(true)
            button_main:setEnabled(true)
            local action1 = cc.MoveTo:create(0.5,cc.p(bigWidth/2, 0))
            local action2 = cc.CallFunc:create(function()
               button_data:setLocalZOrder(0)
               data_back:removeChildByName('PersonalInfo')
            end)
            button_data:runAction(cc.Sequence:create(action1, action2))

        end
    end
 
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    -- main pape  "First_Noel_pluto" 
    playMusic(s_sound_First_Noel_pluto,true)

    return layer
end

return HomeLayer

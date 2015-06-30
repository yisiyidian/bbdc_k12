require("cocos.init")
require("common.global")

--HomeLayer 主界面
--

-- local AlterI = require("view.alter.AlterI")
local GuideView = require ("view.guide.GuideView")
local SettingLayer = require("view.home.SettingLayer") --设置界面

local MissionProgress = require("view.home.MissionProgressLayer") --中间的原型开始按钮
local OfflineTipHome = require("view.offlinetip.OfflineTipForHome")
local OfflineTipFriend = require("view.offlinetip.OfflineTipForFriend")

local RegisterAccountView = require("view.login.RegisterAccountView") --注册账号界面
local MoreInfomationView = require("view.home.MoreInformationView")   --修改/查看个人信息

local DownloadSoundButton = require("view.home.DownloadSoundButton") --下载音频的按钮

local MissionConfig = require("model.mission.MissionConfig") --任务的配置数据



local HomeLayer = class("HomeLayer", function ()
    return cc.Layer:create()
end)

local FRIEND_LOCKED = 0
local SHOP_LOCKED = 0
local REWARD_LOCKED = 0
local bigWidth = s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH
local list = {}

function HomeLayer.create()

    if s_CURRENT_USER:getLockFunctionState(1) == 0 then
        s_CURRENT_USER:unlockFunctionState(1)
    end
    -- task
    local todayTotalBossNum     = s_LocalDatabaseManager:getTodayTotalBossNum()
    local todayRemainBossNum    = s_LocalDatabaseManager:getTodayRemainBossNum()
    local todayTotalTaskNum     = s_LocalDatabaseManager:getTodayTotalTaskNum()
    local todayRemainTaskNum    = s_LocalDatabaseManager:getTodayRemainTaskNum()

    local totalStudyWordNum     = s_LocalDatabaseManager.getStudyWordsNum(os.date('%x',os.time()))
    local totalGraspWordNum     = s_LocalDatabaseManager.getGraspWordsNum(os.date('%x',os.time()))
    local totalStudyDayNum      = s_LocalDatabaseManager.getStudyDayNum()

    -- init first unit
    local maxID = s_LocalDatabaseManager.getMaxUnitID()
    if maxID == 0 then -- empty
        -- print('####test init unit info')
        s_LocalDatabaseManager.initUnitInfo(1)
    end

    if s_CURRENT_USER.summaryStep < s_summary_enterHomeLayer then
        s_CURRENT_USER:setSummaryStep(s_summary_enterHomeLayer)
        AnalyticsSummaryStep(s_summary_enterHomeLayer)
    end
    -- 打点
    -- data begin
    print("s_CURRENT_USER.bookKey:"..s_CURRENT_USER.bookKey)

    -- local bookName          = s_DataManager.books[s_CURRENT_USER.bookKey].name
    -- local bookWordCount     = s_DataManager.books[s_CURRENT_USER.bookKey].words
    -- data end

    s_SCENE.touchEventBlockLayer.unlockTouch()

    local layer = HomeLayer.new()
    return layer
end


--构造函数
function HomeLayer:ctor()
    self.offset = 500
    self.viewIndex = 1

    self.moveLength = 100
    self.moved = false
    self.start_x = nil
    self.start_y = nil

    --判断是否是注册用户
    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
        --任务：完善信息直接完成
        s_MissionManager:updateMission(MissionConfig.MISSION_INFO,1,false)
    end
    --背景颜色层
    local backColor = cc.LayerColor:create(cc.c4b(211,239,254,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    self.backColor = backColor
    self:addChild(backColor)

    local top = cc.Sprite:create('image/homescene/home_page_bg_top.png')
    top:setAnchorPoint(0.5,1)
    top:setPosition(0.5 * backColor:getContentSize().width,s_DESIGN_HEIGHT)
    backColor:addChild(top)
    --贝贝豆背景
    local been_number_back = cc.Sprite:create("image/chapter/chapter0/background_been_white.png")
    been_number_back:setPosition(bigWidth-100, s_DESIGN_HEIGHT-70)
    backColor:addChild(been_number_back)
    --贝贝豆数字
    local been_number = cc.Label:createWithSystemFont(s_CURRENT_USER:getBeans(),'',24)
    been_number:setColor(cc.c4b(0,0,0,255))
    been_number:setPosition(been_number_back:getContentSize().width * 0.65 , been_number_back:getContentSize().height/2)
    self.been_number = been_number
    been_number_back:addChild(been_number)
    --更新贝贝豆数量显示
    been_number:scheduleUpdateWithPriorityLua(handler(self,self.updateBean),0)

    --在线标志
    local online = s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()
    self.online = online
    local offlineTipHome = OfflineTipHome.create()
    local offlineTipFriend = OfflineTipFriend.create()
    self.offlineTipHome = offlineTipHome
    self.offlineTipFriend = offlineTipFriend
    self:addChild(offlineTipHome,2)
    self:addChild(offlineTipFriend,2)
    -- --设置界面
    -- local setting_back = SettingLayer.new(self)
    -- setting_back:setPosition(0, s_DESIGN_HEIGHT/2)
    -- setting_back:updateView()
    -- self.setting_back = setting_back
    -- backColor:addChild(setting_back)
    --任务开始按钮
    local mission_progress = nil
    --是否打卡
    local checkIn = s_CURRENT_USER.logInDatas[#s_CURRENT_USER.logInDatas]:isCheckIn(os.time(),s_CURRENT_USER.bookKey)
    local checkInDisplay = checkIn and not s_isCheckInAnimationDisplayed --s_isCheckInAnimationDisplayed 在global.lua里
    if checkInDisplay then
        -- --打卡
        -- if s_HUD_LAYER:getChildByName('missionComplete') ~= nil then
        --     s_HUD_LAYER:getChildByName('missionComplete'):setVisible(true)
        -- end
        s_isCheckInAnimationDisplayed = true
    end
    mission_progress = MissionProgress.create()
    if checkIn then
        --触发打卡任务
        s_MissionManager:updateMission(MissionConfig.MISSION_DAKA,1,false)
    end

    self.mission_progress = mission_progress
    backColor:addChild(mission_progress,1,'mission_progress')

    --下载音频的按钮
    local status = cx.CXNetworkStatus:getInstance():start()

    if status == NETWORK_STATUS_WIFI and string.find(s_CURRENT_USER.bookList,"|") == nil then
        local downloadSoundButton = DownloadSoundButton.create(top,false)
    else
        local downloadSoundButton = DownloadSoundButton.create(top,true)
    end


    --正在学习 文本
    local name = cc.Sprite:create('image/homescene/BBDC_word_title.png')
    name:setPosition(bigWidth/2, s_DESIGN_HEIGHT-85)
    backColor:addChild(name)

    local currentBook = cc.Label:createWithSystemFont("正在学习："..s_DataManager.books[s_CURRENT_USER.bookKey].name,"",22)
    currentBook:setPosition(bigWidth/2, s_DESIGN_HEIGHT-140)
    currentBook:setColor(cc.c4b(255,255,255,255))
    backColor:addChild(currentBook)
    --设置按钮
    local button_setting = ccui.Button:create("image/homescene/home_page_function_bg1.png",'',"")
    button_setting:setScale9Enabled(true)
    button_setting:setPosition(bigWidth / 2 - 166, 200)
    button_setting:setRotation(180)
    button_setting:addTouchEventListener(handler(self, self.onBtnSettingTouch))
    backColor:addChild(button_setting)
    --设置的icon
    local icon_setting = cc.Sprite:create('image/homescene/home_page_setting.png')
    icon_setting:setPosition(button_setting:getContentSize().width / 2,button_setting:getContentSize().height / 2)
    button_setting:addChild(icon_setting)

    --商店按钮
    local button_shop = nil
    local icon_shop = nil

    if SHOP_LOCKED == 0 then
        button_shop = ccui.Button:create("image/homescene/home_page_function_bg2.png","","")
        button_shop:setPosition(bigWidth / 2 + 1, 200)
        icon_shop = cc.Sprite:create('image/homescene/home_page_store.png')
    else
        button_shop = ccui.Button:create("image/homescene/home_page_function_locked_bg1.png","","")
        button_shop:setPosition(bigWidth / 2 + 0.5, 200)
        local cover = cc.Sprite:create('image/homescene/home_page_function_locked_cover1.png')
        cover:setPosition(button_shop:getContentSize().width / 2,button_shop:getContentSize().height / 2)
        button_shop:addChild(cover)
        local lock = cc.Sprite:create('image/homescene/home_page_function_lock.png')
        lock:setAnchorPoint(1,0)
        lock:setPosition(button_friend:getContentSize().width,button_friend:getContentSize().height * 0)
        button_shop:addChild(lock)
        icon_shop = cc.Sprite:create('image/homescene/home_page_store_locked.png')
    end
    button_shop:setScale9Enabled(true)
    button_shop:setAnchorPoint(0,0.5)
    --商店ICON
    icon_shop:setPosition(button_shop:getContentSize().width / 2,button_shop:getContentSize().height / 2)
    button_shop:addChild(icon_shop)

    button_shop:addTouchEventListener(handler(self, self.onBtnShopTouch))
    self.button_shop = button_shop
    backColor:addChild(button_shop) 

    --领奖
    local button_reward = nil
    local icon_reward = nil
    if REWARD_LOCKED == 0 then
        button_reward = ccui.Button:create("image/homescene/home_page_function_bg1.png","","")
        button_reward:setPosition(bigWidth / 2 + 166, 200)
        icon_reward = cc.Sprite:create('image/homescene/home_page_medal.png')
    else
        button_reward = ccui.Button:create("image/homescene/home_page_function_locked_bg2.png","","")
        button_reward:setPosition(bigWidth / 2 + 166, 200)
        local cover = cc.Sprite:create('image/homescene/home_page_function_locked_cover2.png')
        cover:setPosition(button_reward:getContentSize().width / 2,button_reward:getContentSize().height / 2)
        button_reward:addChild(cover)
        local lock = cc.Sprite:create('image/homescene/home_page_function_lock.png')
        lock:setAnchorPoint(1,0)
        lock:setPosition(button_reward:getContentSize().width,button_reward:getContentSize().height * 0)
        button_reward:addChild(lock)
        icon_reward = cc.Sprite:create('image/homescene/home_page_medal_locked.png')
    end

    button_reward:setScale9Enabled(true)    
    button_reward:addTouchEventListener(handler(self, self.onBtnRewardTouch))
    self.button_reward = button_reward
    backColor:addChild(button_reward)
    icon_reward:setPosition(button_reward:getContentSize().width / 2,button_reward:getContentSize().height / 2)
    button_reward:addChild(icon_reward)

    --数据按钮
    local button_data = nil
    local data_back = nil
    self.isDataShow = false
    button_data = cc.Sprite:create("image/homescene/main_bottom.png")
    button_data:setAnchorPoint(0.5,0)
    button_data:setPosition(bigWidth/2, 0)
    backColor:addChild(button_data,3)
    self.dataButton = button_data
    self.button_data = button_data

    data_back = cc.LayerColor:create(cc.c4b(255,255,255,255), bigWidth, s_DESIGN_HEIGHT - 280)  
    data_back:setAnchorPoint(0.5,1)
    data_back:ignoreAnchorPointForPosition(false)  
    data_back:setPosition(button_data:getContentSize().width/2, 0)
    self.dataBack = data_back
    self.data_back = data_back
    button_data:addChild(data_back,3)
    
    local bottom = cc.LayerColor:create(cc.c4b(255,255,255,255), button_data:getContentSize().width, 100)
    bottom:setAnchorPoint(0.5,1)
    bottom:ignoreAnchorPointForPosition(false)  
    bottom:setPosition(button_data:getContentSize().width/2, 0)
    data_back:addChild(bottom)
    local data_name = cc.Label:createWithSystemFont("数据","",36)
    data_name:setColor(cc.c4b(0,150,210,255))
    data_name:setPosition(button_data:getContentSize().width/2+30, button_data:getContentSize().height/2-5)
    button_data:addChild(data_name,0)

    --好友按钮
    local button_friend = nil
    local icon_friend = nil
    if s_CURRENT_USER:getLockFunctionState(1) == 1 then
        button_friend = ccui.Button:create("image/homescene/home_page_function_bg2.png","","")
        button_friend:setPosition(bigWidth / 2 - 1, 200)
        icon_friend = cc.Sprite:create('image/homescene/home_page_friends.png')
    else
        button_friend = ccui.Button:create("image/homescene/home_page_function_locked_bg1.png","","")
        button_friend:setPosition(bigWidth / 2 - 0.5, 200)
        local cover = cc.Sprite:create('image/homescene/home_page_function_locked_cover1.png')
        cover:setPosition(button_friend:getContentSize().width / 2,button_friend:getContentSize().height / 2)
        button_friend:addChild(cover)
        local lock = cc.Sprite:create('image/homescene/home_page_function_lock.png')
        lock:setAnchorPoint(1,0)
        lock:setPosition(button_friend:getContentSize().width,button_friend:getContentSize().height * 0)
        button_friend:addChild(lock)
        icon_friend = cc.Sprite:create('image/homescene/home_page_friends_locked.png')
    end
    button_friend:setScale9Enabled(true)
    button_friend:setAnchorPoint(1,0.5)
    button_friend:addTouchEventListener(handler(self, self.onBtnFriendTouch))
    backColor:addChild(button_friend)   
    icon_friend:setPosition(button_friend:getContentSize().width / 2,button_friend:getContentSize().height / 2)
    button_friend:addChild(icon_friend)
    self.button_friend = button_friend
    button_friend:scheduleUpdateWithPriorityLua(handler(self,self.updateFriendButton),0)
    --获取好友
    s_UserBaseServer.getFolloweesOfCurrentUser(handler(self,
        function (s,api,result)
            s_UserBaseServer.getFollowersOfCurrentUser(handler(s,
                function (s,api, result)     
                    s_CURRENT_USER:getFriendsInfo()
                    if s_CURRENT_USER.seenFansCount < s_CURRENT_USER.fansCount then
                        local redHint = cc.Sprite:create('image/friend/fri_infor.png')
                        local posx,posy = s.button_friend:getPosition()
                        local size = s.button_friend:getContentSize()
                        redHint:setPosition(posx - size.width * 0.2, posy + size.height * 0.4)
                        backColor:addChild(redHint,1,"redHint")
                        local num = cc.Label:createWithSystemFont(string.format('%d',s_CURRENT_USER.fansCount - s_CURRENT_USER.seenFansCount),'',28)
                        num:setPosition(redHint:getContentSize().width / 2,redHint:getContentSize().height / 2)
                        redHint:addChild(num)
                    end
                end,
                function (api, code, message, description)             
                end
            ))
        end,
        function (api, code, message, description)
        end
    ))
    
    --商品解锁任务触发 start
    local productNum = #s_DataManager.product
    for iii = 1,productNum do
        if s_CURRENT_USER:getLockFunctionState(iii) ~= 0 then
            if iii == 2 then 
                s_MissionManager:updateMission(MissionConfig.MISSION_DATA1,1,false)
            elseif iii == 3 then
                s_MissionManager:updateMission(MissionConfig.MISSION_DATA2,1,false)
            elseif iii == 5 then
                s_MissionManager:updateMission(MissionConfig.MISSION_DATA3,1,false)
            elseif iii == 6 then
                s_MissionManager:updateMission(MissionConfig.MISSION_VIP,1,false)
            end
        end
    end
    --商品解锁任务触发 end
    
    --自定义的事件监听
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(handler(self,self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(handler(self,self.onTouchMoved),cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(handler(self,self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    playMusic(s_sound_First_Noel_pluto,true)  --播放音乐
    self.button_setting = button_setting
    self.button_sound = downloadSoundButton
    self.button_reward = button_reward

   for i=1,5 do
        if math.floor(s_LocalDatabaseManager.isBuy() / math.pow(10,i-1)) == 1 then
            if i == 1 then
                self:friendButtonFunc()
            elseif i == 2 then
                self.isDataShow = true 
                self:showDataLayerByItem(3)
                s_SCENE:removeAllPopups()
            elseif i == 3 then
                self.isDataShow = true 
                self:showDataLayerByItem(2)
                s_SCENE:removeAllPopups()
            elseif i == 4 then
                self.isDataShow = true 
                self:showDataLayerByItem(1)
                s_SCENE:removeAllPopups()
            elseif i == 5 then
                self.isDataShow = true 
                self:showDataLayerByItem(0)
                s_SCENE:removeAllPopups()
            end
            s_LocalDatabaseManager.setBuy(0)
            s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
        end
    end

    -- 添加引导
    if s_CURRENT_USER.guideStep == s_guide_step_selectBook then
        s_CorePlayManager.enterGuideScene(3,backColor)
        s_CURRENT_USER:setGuideStep(s_guide_step_enterHome) 

        button_friend:setTouchEnabled(false)
        button_reward:setTouchEnabled(false)
        button_setting:setTouchEnabled(false)
        button_shop:setTouchEnabled(false)
    else
        s_CURRENT_USER:setGuideStep(s_guide_step_bag6) 
    end

    if s_CURRENT_USER.showSettingLayer == 1 then
        local SettingLayer = require("view.home.SettingLayer")
        local settinglayer = SettingLayer.new()
        s_SCENE:popup(settinglayer)
    end
    s_CURRENT_USER.showSettingLayer = 0

    onAndroidKeyPressed(self, function ()
        local isPopup = s_SCENE.popupLayer:getChildren()
        if self.viewIndex == 2 and #isPopup == 0 then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

            self.viewIndex = 1

            local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
            backColor:runAction(action1)

            local action2 = cc.DelayTime:create(0.5)
            local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            --self.setting_back:runAction(cc.Sequence:create(action2, action3))

        elseif self.isDataShow == true and #isPopup == 0 then
            self.isDataShow = false
            self:setButtonEnabled(true)

            local action1 = cc.MoveTo:create(0.3,cc.p(bigWidth/2, 0))
            local action2 = cc.CallFunc:create(function()
                button_data:setLocalZOrder(0)
                data_back:removeChildByName('PersonalInfo')
            end)
            button_data:runAction(cc.Sequence:create(action1, action2))

        elseif self.isDataShow == false and  self.viewIndex == 1 and #isPopup == 0 then
            cx.CXUtils:getInstance():shutDownApp()
        end
    end, function ()

    end)
end

--触摸开始
function HomeLayer:onTouchBegan(touch, event)    
    local location = self:convertToNodeSpace(touch:getLocation())
    self.start_x = location.x
    self.start_y = location.y
    self.moved = false
    return true
end

function HomeLayer:onTouchMoved(touch, event)
    if self.moved then
        return
    end

    local location = self:convertToNodeSpace(touch:getLocation())
    local now_x = location.x
    local now_y = location.y

    local start_x = self.start_x
    local start_y = self.start_y
    local moveLength = self.moveLength
    
    if start_y < 0.1 * s_DESIGN_HEIGHT and start_x > s_DESIGN_WIDTH * 0.0 and start_x < s_DESIGN_WIDTH * 2.0 then
        if now_y - moveLength > start_y and not self.isDataShow and self.viewIndex == 1 then         
            self.isDataShow = true
            self:setButtonEnabled(false)
            self.button_data:setLocalZOrder(2)
            self.button_data:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(bigWidth/2, s_DESIGN_HEIGHT-280))))
            s_SCENE:callFuncWithDelay(0.3,function ()
                local PersonalInfo = require("view.PersonalInfo")
                PersonalInfo.getNotContainedInLocalDatas(function ()
                    local personalInfoLayer = PersonalInfo.create()
                    self.personalInfoLayer = personalInfoLayer
                    self.personalInfoLayer:setPosition(-s_LEFT_X,0)
                    --personalInfoLayer:setPosition(-s_LEFT_X,0)
                    self.data_back:addChild(personalInfoLayer,3,'PersonalInfo') 
                end)
            end)
            return
        end
    end
    if start_y > s_DESIGN_HEIGHT - 280 and start_x > s_DESIGN_WIDTH * 0.0 and start_x < s_DESIGN_WIDTH * 2.0 then
        if now_y + moveLength < start_y and self.isDataShow and self.viewIndex == 1 then
            self.isDataShow = false
            self:setButtonEnabled(true)
            local action1 = cc.MoveTo:create(0.3,cc.p(bigWidth/2, 0))
            local action2 = cc.CallFunc:create(function()
                self.button_data:setLocalZOrder(0)
                self.data_back:removeChildByName('PersonalInfo')
            end)
            self.button_data:runAction(cc.Sequence:create(action1, action2))
            return
        end

    end

    if now_x + moveLength < start_x and not self.isDataShow then
        if self.viewIndex == 2 then
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            self.viewIndex = 1

            local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
            self.backColor:runAction(action1)

            local action2 = cc.DelayTime:create(0.5)
            local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            --self.setting_back:runAction(cc.Sequence:create(action2, action3))
        end
    end
end
--触摸结束
function HomeLayer:onTouchEnded(touch,event)
    local start_x = self.start_x
    local start_y = self.start_y
    
    local location = self:convertToNodeSpace(touch:getLocation())
    -- if not cc.rectContainsPoint(self.setting_back:getBoundingBox(),location) and self.viewIndex == 2 then
    --     s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()

    --     self.mission_progress.stopListener = false

    --     self.viewIndex = 1

    --     local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
    --     self.backColor:runAction(action1)

    --     local action2 = cc.DelayTime:create(0.5)
    --     local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
    --     self.setting_back:runAction(cc.Sequence:create(action2, action3))
    -- end
    if not self.isDataShow then
        if math.abs(location.y - start_y) > 10 or math.abs(location.x - start_x) > 10 then
            return
        elseif self.viewIndex == 1 and location.y < 0.1 * s_DESIGN_HEIGHT then
            self.isDataShow = true
            self:setButtonEnabled(false)
            self.button_data:setLocalZOrder(2)
            self.button_data:runAction(cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(bigWidth/2, s_DESIGN_HEIGHT-280))))
            s_SCENE:callFuncWithDelay(0.3,function ()
                if self.online == false then
                    self.offlineTipHome.setFalse()
                    self.offlineTipFriend.setFalse()
                end
                local PersonalInfo = require("view.PersonalInfo")
                PersonalInfo.getNotContainedInLocalDatas(function ()
                    local personalInfoLayer = PersonalInfo.create()
                    personalInfoLayer:setPosition(-s_LEFT_X,0)
                    self.data_back:addChild(personalInfoLayer,3,'PersonalInfo')
                end) 
            end) 
        end

    elseif location.y >  s_DESIGN_HEIGHT-280 and (math.abs(location.y - start_y) < 10 and math.abs(location.x - start_x) < 10) and self.viewIndex == 1 then
        --print('self.isDataShow')
        self.isDataShow = false
        self:setButtonEnabled(true)
        local action1 = cc.MoveTo:create(0.3,cc.p(bigWidth/2, 0))
        local action2 = cc.CallFunc:create(function()
            self.button_data:setLocalZOrder(0)
            self.data_back:removeChildByName('PersonalInfo')
        end)
        self.button_data:runAction(cc.Sequence:create(action1, action2))
    end

end

--好友按钮 处理触摸
function HomeLayer:onBtnFriendTouch(sender,eventType)
    if s_CURRENT_USER.guideStep <= s_guide_step_enterHome then
        return
    end
    if eventType == ccui.TouchEventType.began then
        AnalyticsFriendBtn()
        playSound(s_sound_buttonEffect)
    elseif eventType == ccui.TouchEventType.ended then
        if s_CURRENT_USER:getLockFunctionState(1) == 0 then -- check is friend function unlock
            local ShopAlter = require("view.shop.ShopAlter")
            local shopAlter = ShopAlter.create(1, 'out')
            s_SCENE:popup(shopAlter)
        else
            self:showFriendView()
        end
    end
end
--弹出好友界面
function HomeLayer:showFriendView()
    if self.online == false then
        self.offlineTipFriend.setTrue()
    elseif s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
        self:changeViewToFriendOrShop("FriendLayer")
    elseif s_CURRENT_USER.usertype == USER_TYPE_GUEST then
        local Item_popup = require("popup/PopupModel")
        local item_popup = Item_popup.create(Site_From_Friend_Guest)  
        s_SCENE:popup(item_popup)
        --TODO fix self
        item_popup.update = handler(self,function(...)
            if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
                self:updateSettingLayer()
            end
        end)
    end
end
--更新好友按钮状态
function HomeLayer:updateFriendButton(delta)    
    if s_CURRENT_USER:getLockFunctionState(1) == 1 then
        self.button_friend:removeFromParent()
        self.button_friend = ccui.Button:create("image/homescene/home_page_function_bg2.png","","")
        self.button_friend:setPosition(bigWidth / 2 - 1, 200)
        self.icon_friend = cc.Sprite:create('image/homescene/home_page_friends.png')
        self.button_friend:setScale9Enabled(true)
        self.button_friend:setAnchorPoint(1,0.5)
        self.button_friend:addTouchEventListener(handler(self, self.onBtnFriendTouch))
        self.backColor:addChild(self.button_friend)   

        self.icon_friend:setPosition(self.button_friend:getContentSize().width / 2,self.button_friend:getContentSize().height / 2)
        self.button_friend:addChild(self.icon_friend)
        self.button_friend:unscheduleUpdate()
    end
end

--领奖按钮 触摸事件
function HomeLayer:onBtnRewardTouch(sender,eventType)
    if eventType == ccui.TouchEventType.began then
        playSound(s_sound_buttonEffect)
    elseif eventType == ccui.TouchEventType.ended then
        local Loginreward = require("view.loginreward.LoginRewardPopup")
        local loginreward = Loginreward:create()
        s_SCENE:popup(loginreward)
    end
end

--商店按钮 触摸事件
function HomeLayer:onBtnShopTouch(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    AnalyticsShopBtn()
    self:changeViewToFriendOrShop("ShopLayer")
end

--设置按钮 触摸事件
function HomeLayer:onBtnSettingTouch(sender,eventType)
    if eventType == ccui.TouchEventType.began then
        playSound(s_sound_buttonEffect)
    elseif eventType == ccui.TouchEventType.ended then
        if self.online == false then
            self.offlineTipHome.setFalse()
            self.offlineTipFriend.setFalse()
        end

        self:showSettingView()
        -- local SettingLayer = require("view.home.SettingLayer")
        -- local settinglayer = SettingLayer.new()
        -- s_SCENE:popup(settinglayer)

        -- if self.viewIndex == 1 then
            -- s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            -- self.mission_progress.stopListener = true
            -- self.viewIndex = 2
            -- local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH / 2 + self.offset,s_DESIGN_HEIGHT/2))
            -- self.backColor:runAction(action1)

            -- local action2 = cc.DelayTime:create(0.5)
            -- local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            -- self.setting_back:runAction(cc.Sequence:create(action2, action3))
            --offline tip
        -- else
            -- s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            -- self.mission_progress.stopListener = false
            -- self.viewIndex = 1
            -- local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2))
            -- self.backColor:runAction(action1)

            -- local action2 = cc.DelayTime:create(0.5)
            -- local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            -- self.setting_back:runAction(cc.Sequence:create(action2, action3))
        -- end 
    end
end

function HomeLayer:showSettingView()
    local SettingLayer = require("view.home.SettingLayer")
    local settinglayer = SettingLayer.new()
    s_SCENE:popup(settinglayer)
end

--切换到好友界面或者商店界面
function HomeLayer:changeViewToFriendOrShop(destination)
    local DestinationLayer = nil
    if destination == "ShopLayer" then
        DestinationLayer = require("view.shop."..destination)
    elseif destination == "FriendLayer" then
        DestinationLayer = require("view.friend."..destination)
    else
        return
    end
        
    local destinationLayer = DestinationLayer.create()
    self:addChild(destinationLayer)
    destinationLayer:ignoreAnchorPointForPosition(false)
    destinationLayer:setAnchorPoint(0,0.5)
    destinationLayer:setPosition(s_RIGHT_X, s_DESIGN_HEIGHT/2)
    self.backColor:removeChildByName('redHint')
    if self.viewIndex == 2 then
        s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
        self.viewIndex = 1
        local action2 = cc.DelayTime:create(0.5)
        local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
        --self.setting_back:runAction(cc.Sequence:create(action2, action3))
    end
    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
       local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2 - bigWidth,s_DESIGN_HEIGHT/2))
    self.backColor:runAction(action1)
    local action2 = cc.MoveTo:create(0.5, cc.p(bigWidth - bigWidth,s_DESIGN_HEIGHT/2))
    local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
    destinationLayer:runAction(cc.Sequence:create(action2, action3))

    destinationLayer.backToHome = handler(self,
        function(self)
            s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
            local action1 = cc.MoveTo:create(0.5, cc.p(s_DESIGN_WIDTH/2 ,s_DESIGN_HEIGHT/2))
            self.backColor:runAction(action1)
            local action2 = cc.MoveTo:create(0.5, cc.p(bigWidth ,s_DESIGN_HEIGHT/2))
            local action3 = cc.CallFunc:create(s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
            local action4 = cc.CallFunc:create(function() destinationLayer:removeFromParent() end)
            destinationLayer:runAction(cc.Sequence:create(action2, action3,action4))
    end)
end

--更新贝贝豆
function HomeLayer:updateBean(delt)
    self.been_number:setString(s_CURRENT_USER:getBeans())
end

function HomeLayer:showDataLayerByItem(index)
    self:setButtonEnabled(false)
    self.button_data:setLocalZOrder(2)
    self.button_data:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2 + s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-280)))))
    s_SCENE:callFuncWithDelay(0.3,function ()
        local PersonalInfo = require("view.PersonalInfo")
        PersonalInfo.getNotContainedInLocalDatas(function ()
            local personalInfoLayer = PersonalInfo.create(false,self,index)
            personalInfoLayer:setPosition(-s_LEFT_X,0)
            self.data_back:addChild(personalInfoLayer,3,'PersonalInfo') 
        end)
    end)
end

--显示主页面下方的按钮
function HomeLayer:showDataLayer(checkIn)
    self.button_data:setLocalZOrder(2)
    self.button_data:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.EaseBackOut:create(cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2 + s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-280)))))
    s_SCENE:callFuncWithDelay(0.3,function ()
        local PersonalInfo = require("view.PersonalInfo")
        PersonalInfo.getNotContainedInLocalDatas(function ()
            local personalInfoLayer = PersonalInfo.create(true,self)
            personalInfoLayer:setPosition(-s_LEFT_X,0)
            self.data_back:addChild(personalInfoLayer,3,'PersonalInfo') 
        end)
    end)
end

function HomeLayer:hideDataLayer()
    local action1 = cc.MoveTo:create(0.3,cc.p(s_DESIGN_WIDTH / 2 + s_DESIGN_OFFSET_WIDTH, 0))
    local action2 = cc.CallFunc:create(function()
        self.button_data:setLocalZOrder(0)
        self.data_back:removeChildByName('PersonalInfo')
    end)
    self.button_data:runAction(cc.Sequence:create(action1, action2))
end

function HomeLayer:showShareCheckIn()
    local Share = require('view.share.ShareCheckIn')
    local shareLayer = Share.create(self)
    shareLayer:setPosition(0,-s_DESIGN_HEIGHT)
    local move = cc.MoveTo:create(0.3,cc.p(0,0))
    shareLayer:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),move,cc.CallFunc:create(function ()
        s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    end,{})))
    self:addChild(shareLayer,2)
end

function HomeLayer:setButtonEnabled(enabled)
    self.button_friend:setEnabled(enabled)
    self.button_shop:setEnabled(enabled)
    self.button_setting:setEnabled(enabled)
    if self.button_sound ~= nil and not tolua.isnull(self.button_sound) then
        self.button_sound:setEnabled(enabled)
    end
    self.button_reward:setEnabled(enabled)
end

return HomeLayer

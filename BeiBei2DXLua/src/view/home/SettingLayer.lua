-- 设置面板，在HomeLayer左侧
--
local RegisterAccountView = require("view.login.RegisterAccountView") --注册账号界面
local MoreInfomationView = require("view.home.MoreInformationView")   --修改/查看个人信息
local PopupModel = require("popup.PopupModel")
--local IntroLayer = require("view.login.IntroLayer")

local SettingLayer = class("SettingLayer",function ()
	-- local layout = cc.Sprite:create("image/homescene/setup_background.png")
	-- return layout
	local layer = cc.Layer:create()
	return layer
end)

--构造
function SettingLayer:ctor(homeLayer)
--function SettingLayer:ctor()
  self.homeLayer = homeLayer --HomeLayer的引用
 	self.logo_name = {"book","information"}
 	self.btns = {} --列表按钮集合
 	self.offset = 500
	self:initUI()
end

--初始化UI
function SettingLayer:initUI()

	--创建背景图片
    local backGround = cc.Sprite:create("image/homescene/set_background.png")
    backGround:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    backGround:setAnchorPoint(0.5,0.5)
    backGround:ignoreAnchorPointForPosition(false)
    self:addChild(backGround)
    self.backGround = backGround

    local width = self.backGround:getContentSize().width
    local height = self.backGround:getContentSize().height
	-- --头像什么的容器
	-- -- local button_back = ccui.Button:create("image/homescene/setup_button.png","image/homescene/setup_button.png","")
	-- local button_back = cc.Sprite:create("image/homescene/setup_button.png")
	-- local size = button_back:getContentSize()
	-- button_back:setPosition(0, s_DESIGN_HEIGHT - size.height * (1 - 1) - 80)
	-- button_back:setAnchorPoint(0,1)
	-- self:addChild(button_back)
 --    self.button_back = button_back
    --头像
    local headlogo = cc.Sprite:create("image/PersonalInfo/hj_personal_avatar.png")
    headlogo:setPosition(width/2 - 130,height - 100)
    backGround:addChild(headlogo)
    headlogo:setScale(0.9)
    self.headlogo = headlogo
    --姓名文本
    local labelname = cc.Label:createWithSystemFont(s_CURRENT_USER:getNameForDisplay(),"",36)
    labelname:setPosition(width*0.43,height - 100)    
    labelname:setColor(cc.c4b(0,0,0,255))
    labelname:setAnchorPoint(0, 0)
    backGround:addChild(labelname)
    self.labelname = labelname
    --正在学习的文本
    local labellearn = cc.Label:createWithSystemFont('正在学习词汇',"",24)
    labellearn:setPosition(width*0.43,height - 110)
    labellearn:setColor(cc.c4b(0,0,0,255))
    labellearn:setAnchorPoint(0, 1)
    backGround:addChild(labellearn)
    self.labellearn = labellearn

    --创建关闭按钮
    local closeButton = ccui.Button:create("image/popupwindow/closeButtonRed.png")
    closeButton:setPosition(width-30,height-30)
    backGround:addChild(closeButton)
    closeButton:addTouchEventListener(handler(self,self.onCloseTouch))
    closeButton:setAnchorPoint(0.5,0.5)
    closeButton:ignoreAnchorPointForPosition(false)
    self.closeButton = closeButton

    -- --分割线
    -- local split = cc.LayerColor:create(cc.c4b(150,150,150,255),854,1)
    -- split:ignoreAnchorPointForPosition(false)
    -- split:setAnchorPoint(0.5,0)
    -- split:setPosition(width/2, 0)
    -- self:addChild(split)

    local followButton = ccui.Button:create("image/homescene/attention_button.png","image/homescene/attention_button_press.png","image/homescene/attention_button_press.png")
    followButton:setAnchorPoint(0.5,0.5)
    followButton:setPosition(width/2-80,140)
    backGround:addChild(followButton)
    local deco = cc.Sprite:create("image/homescene/attention_beibei1.png")
    deco:setPosition(width-110,90)
    backGround:addChild(deco, 10)
    local text = cc.Label:createWithSystemFont("关注贝贝","",36)
    text:setColor(cc.c4b(255,255,255,255))
    text:setPosition(followButton:getContentSize().width/2, followButton:getContentSize().height/2)
    followButton:addChild(text)
    followButton:addTouchEventListener(handler(self,self.onFollowTouch))



    --按钮的回调函数
    self.btncall1 = handler(self, self.onChangeBookTouch)
    self.btncall2 = handler(self, self.onInfoTouch)
    self.btncall3 = handler(self, self.onLoginTouch)

    self:updateView()

    touchBackgroundClosePopup(self,self.backGround,function ( ... )s_SCENE:removeAllPopups() end)
end

--更新显示数据
function SettingLayer:updateView()
	--更新头像
	if s_CURRENT_USER.sex == 0 then
        self.headlogo:setTexture("image/PersonalInfo/hj_personal_avatar.png")
    else
        self.headlogo:setTexture("image/PersonalInfo/boy_head.png")
    end
    --更新学习状态
    local bookName = s_DataManager.books[s_CURRENT_USER.bookKey].name
    self.labellearn:setString(bookName.."词汇")
    --更新姓名
    self.labelname:setString(s_CURRENT_USER:getNameForDisplay())

    --TODO 更新列表
    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
    	--非游客登录
        -- self.username = s_CURRENT_USER:getNameForDisplay()
        self.label_name = {"选择书籍","查看个人信息"}
    else
    	--游客登录
	    -- self.username = "游客"
   		self.label_name = {"选择书籍","完善个人信息"}
    end
    --清空列表
    for _,b in pairs(self.btns) do
    	b:removeFromParent()
    end
    self.btns = {}

    local btn 	= nil
    local size 	= nil
    local logo 	= nil
    local label = nil
    for k,v in pairs(self.logo_name) do
    	--底图
    	btn = ccui.Button:create("image/homescene/setup_button.png","image/homescene/setup_button.png","")
    	size = btn:getContentSize()  --只调用一次好
        btn:setOpacity(0)
        btn:setAnchorPoint(0, 1)
        btn:setPosition(0, s_DESIGN_HEIGHT - size.height * k - 300)
        --print("qweqweqwe"..self["btncall"..k])
        -- btn:addTouchEventListener(handler(self, self.onInfoTouch))
        btn:addTouchEventListener(self["btncall"..k])
        --self:addChild(btn)
        self.backGround:addChild(btn)
        self.btns[#self.btns + 1] = btn
        --图标
        logo = cc.Sprite:create("image/homescene/setup_"..self.logo_name[k]..".png")
        --logo:setPosition(size.width - self.offset + 120, size.height / 2)
        logo:setPosition(self.backGround:getContentSize().width/2 - 130, size.height / 2)
        btn:addChild(logo)
        --文本
        label = cc.Label:createWithSystemFont(self.label_name[k],"",32)
        label:setColor(cc.c4b(0,0,0,255))
        label:setAnchorPoint(0, 0.5)
        label:setPosition(220, size.height / 2)
        btn:addChild(label)

        --分割线
       	local split = cc.LayerColor:create(cc.c4b(150,150,150,255),self.backGround:getContentSize().width-10,1)
        split:ignoreAnchorPointForPosition(false)
        split:setAnchorPoint(0,1)
        --split:setPosition(size.width/2 + 120, 0)
        split:setPosition(0, 0)
        btn:addChild(split)
        
        --离线灰色
        if k > 1 and online == false then
            label:setColor(cc.c4b(157,157,157,255))
        end
    end
end

--点击关闭按钮
function SettingLayer:onCloseTouch(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return 
    end
    s_SCENE:removeAllPopups()
    
end

--更换课本 触摸事件
function SettingLayer:onChangeBookTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	playSound(s_sound_buttonEffect)
	AnalyticsChangeBookBtn()
	s_SCENE:removeAllPopups()
	--选书
	s_CorePlayManager.enterBookLayer(s_CURRENT_USER.bookKey)
    s_CURRENT_USER.showSettingLayer = 1
end

--完善信息或者 查看信息  触摸事件
function SettingLayer:onInfoTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	playSound(s_sound_buttonEffect)

	if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
		--如果当前用户是注册的用户 则显示查看个人信息
        local moreview = MoreInfomationView.new()
        --s_SCENE:popup(moreview)
        s_SCENE.popupLayer:addChild(moreview)
        ----回调关闭函数 用来更新界面
        moreview.close = handler(self, self.closeCallBack)
	else
		--如果当前用户是游客 则显示注册帐号
		local online = s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()
		if  online == false then
	        self.homeLayer.offlineTipHome.setTrue(OfflineTipForHome_ImproveInformation)
	    else
	        local regiserView = RegisterAccountView.new()
            -- s_SCENE:popup(regiserView,self)
            s_SCENE.popupLayer:addChild(regiserView)
	        -- s_SCENE:popup(regiserView,self)
	        --回调关闭函数 用来更新界面
            print(self.closeCallBack)
	        regiserView.close = handler(self, self.closeCallBack)
	    end
	end
end

--切换帐号 触摸事件
function SettingLayer:onLoginTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	playSound(s_sound_buttonEffect)

	if not s_SERVER.isNetworkConnectedNow() then
        self.homeLayer.offlineTipHome.setTrue(OfflineTipForHome_Logout)
    else
        local registerView = RegisterAccountView.new(RegisterAccountView.STEP_6)
        s_SCENE:popup(registerView)
    end
end

--关注按钮点击
function SettingLayer:onFollowTouch( sender,eventType )
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

    local back = cc.Sprite:create("image/homescene/background_ciku_white.png")
    back:setPosition(cc.p(s_DESIGN_WIDTH/2, 550))
    local info = cc.Sprite:create('image/homescene/Phone-Hook1.png')
    info:setPosition(back:getContentSize().width/2, back:getContentSize().height/2)
    back:addChild(info)

    local close_button_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            s_SCENE:removeAllPopups()
        end
    end
    local closeButton = ccui.Button:create("image/popupwindow/closeButtonRed.png","image/popupwindow/closeButtonRed.png","")
    closeButton:setPosition(back:getContentSize().width-30, back:getContentSize().height-30)
    closeButton:addTouchEventListener(close_button_clicked)
    back:addChild(closeButton)

    local label2 = cc.Label:createWithSystemFont("V2.2.5","",25)
    label2:setColor(cc.c4b(36,61,78,255))
    label2:setPosition(back:getContentSize().width/2+45, back:getContentSize().height/2+75)
    info:addChild(label2)

    local layer = cc.Layer:create()
    layer:addChild(back)

    s_SCENE:popup(layer)

    touchBackgroundClosePopup(layer,back,function() s_SCENE:removeAllPopups() end)
end

--关闭事件回调
function SettingLayer:closeCallBack()
	s_SCENE:removeAllPopups()
    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
    	--刷新本界面
       self:updateView()
    end
end


return SettingLayer


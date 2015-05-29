-- 设置面板，在HomeLayer左侧
-- Author: whe
-- Date: 2015-05-13 16:12:08
--
local RegisterAccountView = require("view.login.RegisterAccountView") --注册账号界面
local MoreInfomationView = require("view.home.MoreInformationView")   --修改/查看个人信息

local SettingLayer = class("SettingLayer",function ()
	local layout = cc.Sprite:create("image/homescene/setup_background.png")
	return layout
end)

--构造
function SettingLayer:ctor()
	-- self.username = "游客"
 --    self.logo_name = {"head","book","information","logout"}
 --    self.label_name = {username,"选择书籍","完善个人信息","切换帐号"}


 --    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
 --        username = s_CURRENT_USER:getNameForDisplay()
 --        logo_name = {"head","book","information","logout"}
 --        label_name = {username,"选择书籍","查看个人信息",TEXT_CHANGE_ACCOUNT}
 --    end
 	self.logo_name = {"book","information","logout"}
 	self.btns = {} --列表按钮集合
 	self.offset = 500
	self:initUI()
end

--初始化UI
function SettingLayer:initUI()
	self:setAnchorPoint(1,0.5)
	--头像什么的容器
	-- local button_back = ccui.Button:create("image/homescene/setup_button.png","image/homescene/setup_button.png","")
	local button_back = cc.Sprite:create("image/homescene/setup_button.png")
	local size = button_back:getContentSize()
	button_back:setPosition(0, s_DESIGN_HEIGHT - size.height * (1 - 1) - 80)
	button_back:setAnchorPoint(0,1)
	self:addChild(button_back)
    self.button_back = button_back
    --头像
    local headlogo = cc.Sprite:create("image/PersonalInfo/hj_personal_avatar.png")
    headlogo:setPosition(size.width - self.offset + 120, size.height/2 + 40)
    button_back:addChild(headlogo)
    headlogo:setScale(0.9)
    self.headlogo = headlogo
    --姓名文本
    local labelname = cc.Label:createWithSystemFont(s_CURRENT_USER:getNameForDisplay(),"",36)
    labelname:setPosition(size.width - self.offset + 210, size.height/2 + 30)    
    labelname:setColor(cc.c4b(0,0,0,255))
    labelname:setAnchorPoint(0, 0)
    button_back:addChild(labelname)
    self.labelname = labelname
    --正在学习的文本
    local labellearn = cc.Label:createWithSystemFont('正在学习词汇',"",24)
    labellearn:setPosition(size.width - self.offset + 210, size.height/2 + 30)
    labellearn:setColor(cc.c4b(0,0,0,255))
    labellearn:setAnchorPoint(0, 1)
    button_back:addChild(labellearn)
    self.labellearn = labellearn
    --分割线
    local split = cc.LayerColor:create(cc.c4b(150,150,150,255),854,1)
    split:ignoreAnchorPointForPosition(false)
    split:setAnchorPoint(0.5,0)
    split:setPosition(size.width/2, 0)
    self:addChild(split)

    local followButton = ccui.Button:create("image/homescene/attention_button.png","image/homescene/attention_button_press.png","image/homescene/attention_button_press.png")
    followButton:setAnchorPoint(0,1)
    followButton:setPosition(400,190)
    self:addChild(followButton,10)
    local deco = cc.Sprite:create("image/homescene/attention_beibei1.png")
    deco:setPosition(750,100)
    self:addChild(deco, 10)
    local text = cc.Label:createWithSystemFont("关注贝贝","",36)
    text:setColor(cc.c4b(255,255,255,255))
    text:setPosition(followButton:getContentSize().width/2, followButton:getContentSize().height/2)
    followButton:addChild(text)
    followButton:addTouchEventListener(handler(self,self.onFollowTouch))

    --按钮的回调函数
    self.btncall1 = handler(self, self.onChangeBookTouch)
    self.btncall2 = handler(self, self.onInfoTouch)
    self.btncall3 = handler(self, self.onLoginTouch)
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
    self.labellearn:setString("正在学习"..bookName.."词汇")
    --更新姓名
    self.labelname:setString(s_CURRENT_USER:getNameForDisplay())

    --TODO 更新列表
    if s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then
    	--非游客登录
        -- self.username = s_CURRENT_USER:getNameForDisplay()
        self.label_name = {"选择书籍","查看个人信息","切换帐号"}
    else
    	--游客登录
	    -- self.username = "游客"
   		self.label_name = {"选择书籍","完善个人信息","切换帐号"}
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
        btn:setPosition(0, s_DESIGN_HEIGHT - size.height * k - 80)
        btn:addTouchEventListener(self["btncall"..k])
        self:addChild(btn)
        self.btns[#self.btns + 1] = btn
        --图标
        logo = cc.Sprite:create("image/homescene/setup_"..self.logo_name[k]..".png")
        logo:setPosition(size.width - self.offset + 120, size.height / 2)
        btn:addChild(logo)
        --文本
        label = cc.Label:createWithSystemFont(self.label_name[k],"",32)
        label:setColor(cc.c4b(0,0,0,255))
        label:setAnchorPoint(0, 0.5)
        label:setPosition(size.width - self.offset + 200, size.height / 2)
        btn:addChild(label)

       	local split = cc.LayerColor:create(cc.c4b(150,150,150,255),854,1)
        split:ignoreAnchorPointForPosition(false)
        split:setAnchorPoint(0.5,0)
        split:setPosition(size.width/2, 0)
        btn:addChild(split)
        
        --离线灰色
        if k > 1 and online == false then
            label:setColor(cc.c4b(157,157,157,255))
        end
    end
end

--更换课本 触摸事件
function SettingLayer:onChangeBookTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end

	playSound(s_sound_buttonEffect)
	AnalyticsChangeBookBtn()
	--选书
	s_CorePlayManager.enterBookLayer(s_CURRENT_USER.bookKey)
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
        s_SCENE:popup(moreview)
        ----回调关闭函数 用来更新界面
        moreview.close = handler(self, self.closeCallBack)
	else
		--如果当前用户是游客 则显示注册帐号
		local online = s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()
		if  online == false then
	        offlineTipHome.setTrue(OfflineTipForHome_ImproveInformation)
	    else
	        local regiserView = RegisterAccountView.new()
	        s_SCENE:popup(regiserView)
	        --回调关闭函数 用来更新界面
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
        offlineTipHome.setTrue(OfflineTipForHome_Logout)
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

    local label2 = cc.Label:createWithSystemFont("V2.0.5","",25)
    label2:setColor(cc.c4b(36,61,78,255))
    label2:setPosition(back:getContentSize().width/2+45, back:getContentSize().height/2+75)
    info:addChild(label2)

    local layer = cc.Layer:create()
    layer:addChild(back)

    s_SCENE:popup(layer)
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
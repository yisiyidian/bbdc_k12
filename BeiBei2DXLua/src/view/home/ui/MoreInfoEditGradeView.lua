-- 修改机构班级号码
-- Author: whe
-- Date: 2015-06-01 15:06:59
-- 
local InputNode = require("view.login.InputNode")

local MoreInfoEditGradeView = class("MoreInfoEditGradeView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	layerHoldTouch(layer) --让触摸事件不向下穿透,相当于让本层layer模态
	return layer
	end)

function MoreInfoEditGradeView:ctor()
	self:initUI()
end

--初始化UI布局
function MoreInfoEditGradeView:initUI()
	--标题
	local title = cc.Label:createWithSystemFont("修改班级","",60)
	title:setTextColor(cc.c3b(106,182,240))
	title:setPosition(s_DESIGN_WIDTH*0.5,s_DESIGN_HEIGHT*0.9)
	self:addChild(title)
	self.title = title
	--返回按钮
	local btnReturn = ccui.Button:create("image/shop/button_back2.png")
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self.btnReturn = btnReturn
	self.btnReturn:setPosition(s_DESIGN_WIDTH*0.1,s_DESIGN_HEIGHT*0.9)
	self:addChild(self.btnReturn)
	--输入班级号
	local inputNodeGrade = InputNode.new("image/signup/shuru_bbchildren_white.png","请输入班级号",nil,nil,nil,nil,4)
	inputNodeGrade:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self:addChild(inputNodeGrade)
	self.inputNodeGrade = inputNodeGrade

	local btnConfirm = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnConfirm:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 330)
	btnConfirm:addTouchEventListener(handler(self, self.onConfirmTouch))
	btnConfirm:setTitleText("确 定")
	btnConfirm:setTitleFontSize(36)
	self:addChild(btnConfirm)
end

--设置显示的数据
function MoreInfoEditGradeView:setData(key,type,data,title,closeCallBack,check)
	self.key = key
	self.type = type
	self.data = data
	self.titleText = title
	self.closeCallBack = closeCallBack
	self.check = check
	--最大输入长度
	self.maxlen = maxlen or 10
	self.inputNodeGrade:setMaxLength(self.maxlen)
	--
	self.title:setString("修改"..self.titleText)
end

--确定按钮触摸事件
function MoreInfoEditGradeView:onConfirmTouch(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return 
	end
	--string.find(id,"^1[3|4|6|5|8][0-9]%d%d%d%d%d%d%d%d$")
	local gradeNumber = self.inputNodeGrade:getText()
	if gradeNumber == "" then
		s_TIPS_LAYER:showSmallWithOneButton("班级号码不能为空！")
		return
	end

	if self.check ~= nil then
		local err,info = self.check(gradeNumber)
		if not err then
			s_TIPS_LAYER:showSmallWithOneButton(info)
			return
		end
	end
	--TODO --> 然后调用加入班级的API  ->根据返回值来 弹出提示
	--加入班级功能 跟保存user数据功能分开
	print("加入班级:"..gradeNumber)
	s_O2OController.joinGrade(gradeNumber, handler(self,self.onJoinGradeCallBack))
end

--返回按钮
function MoreInfoEditGradeView:onReturnClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then 
		return 
	end
	if self.closeCallBack ~= nil then
		self.closeCallBack()
	end
end

--加入班级回调
function MoreInfoEditGradeView:onJoinGradeCallBack(data,error)
	print("请求加入班级返回:")
	if error ~= nil then
		s_TIPS_LAYER:showSmallWithOneButton(error.description)
		return
	end
	dump(data)
	
	cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)

	local grade = data
	if grade ~= nil then
		s_CURRENT_USER.gradeNum = grade.gradeNum
		s_CURRENT_USER.gradeName = grade.gradeName
		
		--TODO bookKey可用的话 会涉及到换书
		local bookKey = grade.bookKey
		if bookKey and bookKey ~= "" then
			
			s_CURRENT_USER.bookKey = bookKey
		end

		if self.closeCallBack ~= nil then
			self.closeCallBack(self.key,self.type,grade.gradeName)
		end
	end
end

return MoreInfoEditGradeView
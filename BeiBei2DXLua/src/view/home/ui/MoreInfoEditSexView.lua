-- 性别选择界面
-- Author: whe
-- Date: 2015-05-05 15:15:35
--
local InputNode = require("view.login.InputNode")

local MoreInfoEditSexView = class("MoreInfoEditSexView", function()
	local layer = cc.LayerColor:create(cc.c4b(220,233,239,255),s_RIGHT_X - s_LEFT_X , s_DESIGN_HEIGHT)
	layerHoldTouch(layer)
	return layer
end)


function MoreInfoEditSexView:ctor()

	self:initUI()

end

function MoreInfoEditSexView:initUI()

	self.views = {}
	self:setTouchEnabled(true)
	self:setSwallowsTouches(true)

	--头像
	local headImg = cc.Sprite:create("image/login/gril_head.png")
	headImg:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self.views[#self.views + 1] = headImg
	self:addChild(headImg)
	self.headImg = headImg

	local headImg1 = cc.Sprite:create("image/login/change_head_setting_3.png")
	headImg1:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 200)
	self.views[#self.views + 1] = headImg1
	self:addChild(headImg1)
	self.headImg1 = headImg1

	self.headImg1:setVisible(false)
	
	--标题
	local title = cc.Label:createWithSystemFont("修改性别", "", 60)
	title:setPosition(s_DESIGN_WIDTH * 0.5, s_DESIGN_HEIGHT * 0.9)
	title:setTextColor(cc.c3b(106,182,240))
	self.title = title
	self:addChild(title)


	--返回按钮

	local btnReturn = ccui.Button:create("image/shop/button_back2.png")
	btnReturn:setPosition(s_DESIGN_WIDTH * 0.1, s_DESIGN_HEIGHT * 0.9)
	btnReturn:addTouchEventListener(handler(self, self.onReturnClick))
	self.btnReturn = btnReturn
	self:addChild(btnReturn)
	self.views[#self.views+1] = btnReturn

	--性别复选按钮
	--checkBox回调
	local chkCallback = function (self, sender, eventType)
	
		local chkName = sender:getName()	
		local state = eventType == 0 or false
		if eventType == ccui.CheckBoxEventType.selected then
			
		elseif eventType == ccui.CheckBoxEventType.unselected then

		end
		if chkName == "Male" and state then 
			self.checkBoxMale:setTouchEnabled(false) --禁用自己
			self.checkBoxFemale:setTouchEnabled(true) --启用另外一个
			self.checkBoxFemale:setSelected(false)
			self.checkBoxMale:setSelected(true)

			self.headImg1:setVisible(true)
			self.headImg:setVisible(false)
		end	
		if chkName == "Female" and state then
			self.checkBoxMale:setTouchEnabled(true) --启用另外一个
			self.checkBoxFemale:setTouchEnabled(false) --禁用自己
			self.checkBoxMale:setSelected(false)
			self.checkBoxFemale:setSelected(true)

			self.headImg:setVisible(true)
			self.headImg1:setVisible(false)
		end
			
	end
--男
	local checkBoxMale = ccui.CheckBox:create()
	checkBoxMale:setTouchEnabled(true)        
	checkBoxMale:loadTextures(
		"image/login/button_boygirl_gray_zhuce_unpressed.png",--normal
		"image/login/button_boygirl_gray_zhuce_unpressed.png",--normal press
		"image/login/button_boygirl_zhuce.png",--normal active
		"image/login/button_boygirl_gray_zhuce_unpressed.png",-- normal disable
		"image/login/button_boygirl_gray_zhuce_unpressed.png"--active disable
		)
	checkBoxMale:setPosition(s_DESIGN_WIDTH * 0.7, s_DESIGN_HEIGHT * 0.9 - 400)
	checkBoxMale:addEventListener(handler(self, chkCallback))
	checkBoxMale:setName("Male")
	checkBoxMale:setSelected(false)
	self.checkBoxMale = checkBoxMale
	self:addChild(checkBoxMale)
	self.views[#self.views+1] = checkBoxMale

	local labelWomen = cc.Label:createWithSystemFont("♂ 男","",30)
	labelWomen:setPosition(checkBoxMale:getContentSize().width/2,checkBoxMale:getContentSize().height/2)
	checkBoxMale:addChild(labelWomen)

--女
	local checkBoxFemale = ccui.CheckBox:create()
	checkBoxFemale:setTouchEnabled(false)
	checkBoxFemale:setName("Female")
	checkBoxFemale:loadTextures(
		"image/login/button_boygirl_gray_zhuce_unpressed.png",--normal
		"image/login/button_boygirl_gray_zhuce_unpressed.png",--normal press
		"image/login/button_boygirl_zhuce.png",--normal active
		"image/login/button_boygirl_gray_zhuce_unpressed.png",-- normal disable
		"image/login/button_boygirl_gray_zhuce_unpressed.png"--active disable
		)
	checkBoxFemale:setPosition(s_DESIGN_WIDTH * 0.3, s_DESIGN_HEIGHT * 0.9 - 400)
	checkBoxFemale:addEventListener(handler(self,chkCallback))
	checkBoxFemale:setSelected(true)
	self.checkBoxFemale = checkBoxFemale
	self:addChild(checkBoxFemale)
	self.views[#self.views+1] = checkBoxFemale

	local labelWomen = cc.Label:createWithSystemFont("♀ 女","",30)
	labelWomen:setPosition(checkBoxFemale:getContentSize().width/2,checkBoxFemale:getContentSize().height/2)
	checkBoxFemale:addChild(labelWomen)


	--确定按钮
	local btnConfirm = ccui.Button:create("image/login/button_next_unpressed_zhuce.png")
	btnConfirm:setPosition(0.5 * s_DESIGN_WIDTH,s_DESIGN_HEIGHT*0.9 - 550)
	btnConfirm:addTouchEventListener(handler(self, self.onConfirmTouch))
	btnConfirm:setTitleText("确 定")
	btnConfirm:setTitleFontSize(36)
	self:addChild(btnConfirm)
	self.btnConfirm = btnConfirm
	self.views[#self.views+1] = btnConfirm
	
end

--设置回调
--data  性别数据 0 女  1 男
function MoreInfoEditSexView:setData(key,type,data,title,closeCallBack,check)
	self.key = key
	self.type = type
	self.data = data
	self.titleText = title
	self.closeCallBack = closeCallBack
	self.check = check
	--TODO 设置占位文本

	self.title:setString("修改"..self.titleText)
end


function MoreInfoEditSexView:onReturnClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then 
		return 
	end

	if self.closeCallBack ~= nil then
		self.closeCallBack()
	end
end

function MoreInfoEditSexView:onConfirmTouch(sender,eventType)
	
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	local data = nil
	-- 0是被选中  1是不被选中
	local sexnan = self.checkBoxMale:isSelected() and 0 or 1 
	local sexnv = self.checkBoxFemale:isSelected() and 0 or 1
	print("sexnv"..sexnv)
	if sexnan == 1 and sexnv == 1 then 
		s_TIPS_LAYER:showSmallWithOneButton("性别不能为空!")
		return
	end
	self.sexnv = sexnv
	self.sexnan = sexnan
	if sexnv == 1 then 
		 data = 0 
		 -- self.checkBoxMale:setSelected(true)
		 -- self.checkBoxFemale:setSelected(false)
	elseif sexnv == 0 then
		 data = 1
		 -- self.checkBoxFemale:setSelected(true)
		 -- self.checkBoxMale:setSelected(false)
	end
	print("data"..data)
	print("self.key"..self.key)


	--关闭回调
	--MoreInformationView里的onEditClose
	if self.closeCallBack ~= nil then
		self.closeCallBack(self.key,self.type,data)
	end
	
end

return MoreInfoEditSexView
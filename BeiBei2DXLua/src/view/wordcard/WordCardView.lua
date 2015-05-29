local WordCardRender = require("view.wordcard.WordCardRender")
-- 词库功能UI
local WordCardView = class("WordCardView",function ()
	local layer = cc.Layer:create()
	return layer
end)

function WordCardView.create()
    local layer = WordCardView.new()
    return layer
end

function WordCardView:ctor()
	self.listView = nil 
	-- 用于显示词库
	self:initUI()
	-- 初始化UI
end

function WordCardView:initUI()
	local backPopup = cc.Sprite:create("image/islandPopup/backforlibrary.png")
    backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self.backPopup = backPopup
    self:addChild(self.backPopup)
    -- 面板主体

    local backPopupWidth = backPopup:getContentSize().width
    local backPopupHeight = backPopup:getContentSize().height

    local listView = ccui.ScrollView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setTouchEnabled(true)
    listView:setContentSize(backPopupWidth,backPopupHeight - 180)
    listView:removeAllChildren()
    listView:setPosition(0,80)
    self.backPopup:addChild(listView)
    self.listView = listView

    -- 关闭按钮
    local closeButton = ccui.Button:create("image/button/button_close.png")
	closeButton:addTouchEventListener(handler(self,self.CloseClick))
	self.closeButton = closeButton
	self.closeButton:setPosition(backPopupWidth - 10,backPopupHeight - 10)
	self.backPopup:addChild(self.closeButton)
	--渲染列表
	self:resetView()

	onAndroidKeyPressed(self,function() self:CloseFunc() end, function ()end)
	touchBackgroundClosePopup(self,self.backPopup,function() self:CloseFunc() end)
end

function WordCardView:resetView()
	self.wordList = {"funereal","funereal","funereal","funereal","funereal","funereal","funereal","funereal","funereal","funereal"}
	-- 显示的单词
	self.meaningList = {}
	for i=1,#self.wordList do
		local temp = s_LocalDatabaseManager.getWordInfoFromWordName(self.wordList[i]).wordMeaningSmall
		self.meaningList[#self.meaningList + 1] = temp
	end
	-- 显示的释义
	local render = nil 
	local renders = {} 
	local innerHeight = 0
	local renderheight = 160
	self.listView:removeAllChildren()

	for i = 1,#self.wordList do
		render = WordCardRender.new(self.wordList[i],self.meaningList[i])
		print(self.wordList[i])
	    render:setData()
		renders[#renders + 1] = render 
		self.listView:addChild(render)
		innerHeight = innerHeight + renderheight
	end

	local tlen = innerHeight - renderheight
	for _,rd in pairs(renders) do
		rd:setPosition(50,tlen)
		tlen = tlen - renderheight	
	end

	self.listView:setInnerContainerSize(cc.size(self.backPopup:getContentSize().width,innerHeight))
end

function WordCardView:CloseClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	playSound(s_sound_buttonEffect)
	print("close Button")
	self:CloseFunc()
end

function WordCardView:CloseFunc()
	local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
    local remove = cc.CallFunc:create(function() 
          s_SCENE:removeAllPopups()
    end)
    self.backPopup:runAction(cc.Sequence:create(move,remove))
end

return WordCardView
local WordCardRender = require("view.wordcard.WordCardRender")
-- 词库功能UI
local WordCardView = class("WordCardView",function ()
	local layer = cc.Layer:create()
	return layer
end)

function WordCardView.create(index)
    local layer = WordCardView.new(index)
    return layer
end

function WordCardView:ctor(index)
	self.index = index
	self.listView = nil 
	-- 用于显示词库
	self:initUI()
	-- 初始化UI
end

function WordCardView:initUI()
	local backPopup = cc.Sprite:create("image/islandPopup/unit_words_bg.png")
    backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self.backPopup = backPopup
    self:addChild(self.backPopup)
    -- 面板主体

    local backPopupWidth = backPopup:getContentSize().width
    local backPopupHeight = backPopup:getContentSize().height

    -- 提示信息
    local text = cc.Label:createWithSystemFont("挑战前先看看吧","",32)
    text:setColor(cc.c4b(255,255,255,255))
    text:setPosition(backPopupWidth/2,backPopupHeight* 0.9)
 	self.text = text
    self.backPopup:addChild(self.text)

    local listView = ccui.ScrollView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setTouchEnabled(true)
    listView:setContentSize(backPopupWidth,backPopupHeight* 0.75)
    listView:removeAllChildren()
    listView:setPosition(0,80)
    self.backPopup:addChild(listView)
    self.listView = listView

    -- 返回按钮
    local returnButton = ccui.Button:create("image/islandPopup/unit_words_back_button.png","image/islandPopup/unit_words_back.png","")
	returnButton:addTouchEventListener(handler(self,self.ReturnClick))
	self.returnButton = returnButton
	self.returnButton:setPosition(50,backPopupHeight - 50)
	self.backPopup:addChild(self.returnButton)
	--渲染列表
	self:resetView()

	onAndroidKeyPressed(self,function() self:CloseFunc() end, function ()end)
	touchBackgroundClosePopup(self,self.backPopup,function() self:CloseFunc() end)
end

function WordCardView:resetView()
	self.islandIndex = tonumber(self.index) + 1
	self.unit = s_LocalDatabaseManager.getUnitInfo(self.islandIndex)
	self.wordList = {}
	for i = 1 ,#self.unit.wrongWordList do
        table.insert(self.wordList,self.unit.wrongWordList[i])
    end
	-- 显示的单词
	self.meaningList = {}
	for i=1,#self.wordList do
		local temp = s_LocalDatabaseManager.getWordInfoFromWordName(self.wordList[i]).wordMeaningSmall
		self.meaningList[#self.meaningList + 1] = temp
	end
	-- 显示的释义
	local render = nil 
	local renders = {} 
	local innerHeight = self.backPopup:getContentSize().height * 0.75
	local renderheight = 160
	self.listView:removeAllChildren()

	for i = 1,#self.wordList do
		render = WordCardRender.new(self.wordList[i],self.meaningList[i])
	    render:setData()
		renders[#renders + 1] = render 
		self.listView:addChild(render)
	end

	if innerHeight < renderheight * #self.wordList then
		innerHeight = renderheight * #self.wordList
		self:createSlider(innerHeight)
	end
	local tlen = innerHeight - renderheight
	for _,rd in pairs(renders) do
		rd:setPosition(50,tlen)
		tlen = tlen - renderheight	
	end

	self.listView:setInnerContainerSize(cc.size(self.backPopup:getContentSize().width,renderheight * #self.wordList))
end

function WordCardView:ReturnClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	playSound(s_sound_buttonEffect)
	print("return Button")
	self:CloseFunc()
end

function WordCardView:createSlider(innerHeight)
	local slider = cc.Sprite:create("image/islandPopup/unit_words_scrollbar_bg.png")
    slider:setPosition(self.backPopup:getContentSize().width * 0.9,self.backPopup:getContentSize().height * 0.8)
    slider:ignoreAnchorPointForPosition(false)
    slider:setAnchorPoint(0.5,1)
    self.slider = slider
    self.backPopup:addChild(self.slider)

    local bar = cc.Sprite:create("image/islandPopup/unit_words_loudspeaker_scrollbar.png")
    bar:setPosition(self.slider:getContentSize().width * 0.5,self.slider:getContentSize().height)
    bar:ignoreAnchorPointForPosition(false)
    bar:setAnchorPoint(0.5,1)
    self.bar = bar
    self.slider:addChild(self.bar)

    local function update(delta)
        local h = -self.listView:getInnerContainer():getPositionY()
        local height = (self.slider:getContentSize().height - self.bar:getContentSize().height) * h * 1.5 / innerHeight + self.bar:getContentSize().height
        self.bar:setPositionY(height)
    end

    self:scheduleUpdateWithPriorityLua(update, 0)
end

function WordCardView:CloseFunc()
    local remove = cc.CallFunc:create(function() 
       	local LevelProgressPopup = require("view.islandPopup.LevelProgressPopup")
  	  	local levelProgressPopup = LevelProgressPopup.create(self.index)
    	s_SCENE:popup(levelProgressPopup)
    end)
    self.backPopup:runAction(cc.Sequence:create(remove))
end

return WordCardView
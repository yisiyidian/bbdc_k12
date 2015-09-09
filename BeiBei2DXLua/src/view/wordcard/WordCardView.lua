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
	self.wordIndex = 1
	-- 小岛编号 注意加1
	self.islandIndex = tonumber(self.index) + 1
	self.unit = s_LocalDatabaseManager.getUnitInfo(self.islandIndex)
	self.showRender = {}
	self.renders = {}

	self:initUI()
	-- 初始化UI
end

function WordCardView:initUI()
	local backPopup = cc.Sprite:create("image/islandPopup/wordPopup.png")
    backPopup:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self.backPopup = backPopup
    self:addChild(self.backPopup)
    -- 面板主体

    local backPopupWidth = backPopup:getContentSize().width
    local backPopupHeight = backPopup:getContentSize().height

    local title = cc.Label:createWithSystemFont("1/"..#self.unit.wrongWordList,"",50)
    title:setPosition(self.backPopup:getContentSize().width/2, self.backPopup:getContentSize().height - 75)
    title:setColor(cc.c3b(255,255,255))
    self.title = title
    self.backPopup:addChild(self.title)

    local close_Click = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            sender:setTouchEnabled(false)
            s_SCENE:removeAllPopups()
            s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch() --放开点击
        end
    end
    --加入关闭按钮
    local close_button = ccui.Button:create("image/islandPopup/closeNormal.png","image/islandPopup/closePress.png","")
    close_button:setPosition(self.backPopup:getContentSize().width - 40,self.backPopup:getContentSize().height - 40)
    close_button:addTouchEventListener(close_Click)
    self.backPopup:addChild(close_button)

    local layout = cc.Sprite:create("image/islandPopup/wordLayout.png")
    layout:setContentSize(backPopupWidth - 10,445)
    layout:setPosition(0,272)
    layout:ignoreAnchorPointForPosition(false)
    layout:setAnchorPoint(0,0)
    self.layout = layout
    self.backPopup:addChild(self.layout)

   	--单词信息
    local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(false)
    listView:setTouchEnabled(true)
    listView:setContentSize(backPopupWidth - 10,365)
    listView:removeAllChildren()
    listView:setPosition(0,20)
    self.layout:addChild(listView)
    self.listView = listView
	self.listView:addTouchEventListener(handler(self,self.scrollViewEvent))

	local go_button = ccui.Button:create("image/islandPopup/goNormal.png","image/islandPopup/goPress.png","")
    go_button:addTouchEventListener(handler(self,self.goClick))
    go_button:setPosition(self.backPopup:getContentSize().width * 0.8, self.backPopup:getContentSize().height * 0.13)
    self.backPopup:addChild(go_button)

	self:createTabBtn()
	--渲染列表
	self:resetView()

	if s_CURRENT_USER.guideStep <= s_guide_step_enterCard and s_CURRENT_USER.guideStep > s_guide_step_enterLevel then
        s_CURRENT_USER:setGuideStep(s_guide_step_returnPopup) 
    end

	onAndroidKeyPressed(self,function() self:CloseFunc() end, function ()end)
	touchBackgroundClosePopup(self,self.backPopup,function() self:CloseFunc() end)
end

function WordCardView:resetView(dir)
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	self:RunAction(dir)
	if self.listView ~= nil then
		self.listView:removeAllChildren()
	end

	if self.showView ~= nil then
		self.showRender = {}
	end 

	if self.renders ~= nil then
		self.renders = {}
	end

	self.showRender = self:createTable()
	local render = nil 
	local renders = {} 
	local innerHeight = 365
	local renderheight = {}

	-- 填充信息
	for i = 1,#self.showRender do
		render = WordCardRender.new(self.showRender[i],i)
	    renderheight[i] = render:setData()
	    render.PlaySoundCall = function ()
		    playWordSound(self.unit.wrongWordList[self.wordIndex])
	    end
	    render:ignoreAnchorPointForPosition(false)
	    render:setAnchorPoint(0.5,0)
		renders[#renders + 1] = render 
		self.renders[#self.renders + 1] = render
		self.listView:addChild(render)
	end

	-- 第一个单词高度信息
	local totalheight = 0
	for i=1,#renderheight do
		totalheight = totalheight + renderheight[i]
	end

	if innerHeight < totalheight  then
		innerHeight = totalheight 
		self:createSlider()
	end

	-- 调整高度
	local tlen = innerHeight
	local i = 0
	for _,rd in pairs(renders) do
		i = i + 1	
		tlen = tlen - renderheight[i]
		rd:setPosition(0,tlen)
	end

	-- 容器高度
	self.listView:scrollToTop(0.1,true)
	self.listView:setInnerContainerSize(cc.size(self.backPopup:getContentSize().width,totalheight + 100))
	self.listView:setSwallowTouches(false)
	self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function ()
		s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
	end)))
	self:autoChange()
end

function WordCardView:RunAction(dir)
	if self.layout == nil or dir == nil then
		return
	end
	local num = 0
	if dir > 0 then
		num = -600
	else
		num = 600
	end
	local move = cc.MoveBy:create(0.5,cc.p(num,0))
	local miss = cc.CallFunc:create(function ()
		self.layout:setVisible(false)
	end)
	local fadeout = cc.FadeOut:create(0.1)
	local place = cc.Place:create(cc.p(0,272))
	local come = cc.CallFunc:create(function ()
		self.layout:setVisible(true)
	end)
	local fadein = cc.FadeIn:create(0.3)
	local se = cc.Sequence:create(move,miss,place,come)
	self.layout:runAction(se)

end

function WordCardView:ReturnClick(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	playSound(s_sound_buttonEffect)
	-- print("return Button")
	self:CloseFunc()
end

-- 滚动条创建
function WordCardView:createSlider()
	-- local slider = cc.Sprite:create("image/islandPopup/unit_words_scrollbar_bg.png")
 --    slider:setPosition(self.backPopup:getContentSize().width * 0.9,485)
 --    slider:setScale(1,0.8)
 --    slider:ignoreAnchorPointForPosition(false)
 --    slider:setAnchorPoint(0.5,0.5)
 --    self.slider = slider
 --    self.backPopup:addChild(self.slider)

 --    local bar = cc.Sprite:create("image/islandPopup/unit_words_loudspeaker_scrollbar.png")
 --    bar:setPosition(self.slider:getContentSize().width * 0.5,self.slider:getContentSize().height)
 --    bar:ignoreAnchorPointForPosition(false)
 --    bar:setAnchorPoint(0.5,1)
 --    self.bar = bar
 --    self.slider:addChild(self.bar)

    -- local maxh = 1
    -- local function update(delta)
    --     local h = -self.listView:getInnerContainer():getPositionY()
    --     if h > maxh then
    --     	maxh = h
    --     end
    --     local percent = h / maxh
    --     local height = self.slider:getContentSize().height * percent
    --     self.bar:setAnchorPoint(0.5,percent)
    --     self.bar:setPositionY(height)
    -- end

    -- self:scheduleUpdateWithPriorityLua(update, 0)
end

-- 返回事件
function WordCardView:CloseFunc()
    local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
    local remove = cc.CallFunc:create(function() 
        s_SCENE:removeAllPopups()
    end)
    self.backPopup:runAction(cc.Sequence:create(move,remove))
end

function WordCardView:createTable()
	LocalDataBaseManager = require('model.LocalDatabaseManager')
	local table = {}

	table[1] = s_BookUnitWordMeaning[s_CURRENT_USER.bookKey][tostring(self.islandIndex)][self.unit.wrongWordList[self.wordIndex]]
	table[2] = self.unit.wrongWordList[self.wordIndex]
	table[3] = LocalDataBaseManager.getWordInfoFromWordName(self.unit.wrongWordList[self.wordIndex]).wordSoundMarkEn
	table[4] = LocalDataBaseManager.getWordInfoFromWordName(self.unit.wrongWordList[self.wordIndex]).sentenceEn..'\n'..LocalDataBaseManager.getWordInfoFromWordName(self.unit.wrongWordList[self.wordIndex]).sentenceCn

	return table
end

function WordCardView:createTabBtn()
	self.wordChangeBtn = {}
	self.label = {}
	for i=1,#self.unit.wrongWordList do
		local btn = cc.Sprite:create("image/islandPopup/changeBtnNormal.png")
		if #self.unit.wrongWordList <= 5 then
			btn:setPosition(40 + i * 60, self.backPopup:getContentSize().height * 0.13)
		end
		if #self.unit.wrongWordList > 5 then
			if i <= 5 then
				btn:setPosition(40 + i * 60, self.backPopup:getContentSize().height * 0.13 + 45)
			else
				btn:setPosition(40 + i%5 * 60, self.backPopup:getContentSize().height * 0.13 - 25)
			end
		end
		local label = cc.Label:createWithSystemFont(string.sub(self.unit.wrongWordList[i],1,1),"",36)
	    label:setColor(cc.c4b(255,255,255,255))
	    label:setPosition(btn:getContentSize().width / 2 ,35)
    	btn:addChild(label)
		if i == 1 then
			btn:setTexture("image/islandPopup/changeBtnPress.png")
			label:setPosition(26,30)
		end

    	self.label[#self.label + 1] = label
		self.wordChangeBtn[#self.wordChangeBtn + 1] = btn
		self.backPopup:addChild(self.wordChangeBtn[#self.wordChangeBtn])
	end

	local touchBeginPointX = 0
	local touchBeginPointY = 0
	local touchEndPointX = 0
	local touchEndPointY = 0

	local onTouchBegan = function(touch, event)
		touchBeginPointX = self.backPopup:convertToNodeSpace(touch:getLocation()).x
		touchBeginPointY = self.backPopup:convertToNodeSpace(touch:getLocation()).y
        return true  
    end

    local onTouchMoved = function(touch, event)
	    self.backPopup:stopAllActions()

		touchEndPointX = self.backPopup:convertToNodeSpace(touch:getLocation()).x
		touchEndPointY = self.backPopup:convertToNodeSpace(touch:getLocation()).y

		if  math.abs(touchEndPointY - touchBeginPointY) <= 20 and touchEndPointX - touchBeginPointX >= 150 then
			self.wordIndex = self.wordIndex % #self.unit.wrongWordList + 1
    		self:resetChange()
			self:resetView(-1)
		elseif math.abs(touchEndPointY - touchBeginPointY) <= 20 and touchEndPointX - touchBeginPointX <= -150 then
			self.wordIndex = self.wordIndex - 1
			if self.wordIndex == 0 then
				self.wordIndex = #self.unit.wrongWordList
			end
    		self:resetChange()
			self:resetView(1)
		end
    end
    
    local onTouchEnded = function(touch, event)
    	self:changeBtnState(touch)
    	self:touchFunc(touch)
    end
    
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )    
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self.backPopup:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.backPopup)  

end

function WordCardView:changeBtnState(touch)
    local location = self.backPopup:convertToNodeSpace(touch:getLocation())
    for i=1,#self.wordChangeBtn do
	    if cc.rectContainsPoint(self.wordChangeBtn[i]:getBoundingBox(),location) then
	    	local temp = i - self.wordIndex 
			self.wordIndex = i
    		self:resetChange()
			self:resetView(temp)
	    end
    end
end

function WordCardView:resetChange()
    for i=1,#self.wordChangeBtn do
		self.wordChangeBtn[i]:setTexture("image/islandPopup/changeBtnNormal.png")
		self.label[i]:setPosition(26,35)
    end
	self.wordChangeBtn[self.wordIndex]:setTexture("image/islandPopup/changeBtnPress.png")
	self.label[self.wordIndex]:setPosition(26,30)
	self.title:setString(self.wordIndex..'/'..#self.unit.wrongWordList)
end

function WordCardView:touchFunc(touch)
    local location = self.backPopup:convertToNodeSpace(touch:getLocation())
    -- print_lua_table(location)
    if cc.rectContainsPoint(cc.rect(0,262,500,722),location) then
		for i=1,#self.renders do
			self.renders[i]:setViewVisible()    	
		end
		playWordSound(self.unit.wrongWordList[self.wordIndex])
		self:autoChange()
    end
end

function WordCardView:goClick(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    playSound(s_sound_buttonEffect) 
    s_lastLevelOfEachBook[s_CURRENT_USER.bookKey] = self.index

    if s_CURRENT_USER.summaryStep < s_summary_enterFirstLevel and tonumber(self.index) == 0 then
        s_CURRENT_USER:setSummaryStep(s_summary_enterFirstLevel)
        AnalyticsSummaryStep(s_summary_enterFirstLevel)
    elseif s_CURRENT_USER.summaryStep < s_summary_enterSecondLevel and tonumber(self.index) == 1 then
        s_CURRENT_USER:setSummaryStep(s_summary_enterSecondLevel)
        AnalyticsSummaryStep(s_summary_enterSecondLevel)
    end

    self.islandIndex = tonumber(self.index) + 1
    self.unit = s_LocalDatabaseManager.getUnitInfo(self.islandIndex)
    local bossList = s_LocalDatabaseManager.getAllUnitInfo()
    local maxID = s_LocalDatabaseManager.getMaxUnitID()
    -- print('Self.unit.unitID:'..self.unit.unitID..',maxID:'..maxID)
    if self.unit.unitID < maxID then
        s_game_fail_level_index = self.unit.unitID - 1

        showProgressHUD('', true)
            local SummaryBossLayer = require('view.summaryboss.NewSummaryBossLayer')
            local summaryBossLayer = SummaryBossLayer.create(self.unit)
            s_CorePlayManager.currentUnitID = self.unit.unitID

            s_SCENE:replaceGameLayer(summaryBossLayer) 
            self:callFuncWithDelay(0.1,function()
                s_SCENE:removeAllPopups() 
            end) 
    else
        showProgressHUD('', true)    
        s_CorePlayManager.initTotalUnitPlay()
        self:callFuncWithDelay(0.1,function()
            s_SCENE:removeAllPopups() 
        end) 
    end 
end

function WordCardView:autoChange()
	self.backPopup:stopAllActions()
	local delay = cc.DelayTime:create(8)
	local func = cc.CallFunc:create(function ()
		self.wordIndex = self.wordIndex % #self.unit.wrongWordList + 1
		self:resetChange()
		self:resetView(1)
	end)
	local se = cc.Sequence:create(delay,func)
	self.backPopup:runAction(se)
end

function WordCardView:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end

function WordCardView:scrollViewEvent(sender, eventType)
	-- if eventType == ccui.TouchEventType.began then
	-- 	return
	-- end
	-- for i=1,#self.renders do
	-- 	self.renders[i]:setViewVisible()    	
	-- end
	-- if eventType == ccui.TouchEventType.ended then
	-- 	playWordSound(self.unit.wrongWordList[self.wordIndex])
	-- end
	-- self:autoChange()
end

return WordCardView
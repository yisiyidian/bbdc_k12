-- 选书重做
local bookConfig = require("view.book.BookList")

local ChooseBookController = class("ChooseBookController", function ()
    return cc.Layer:create()
end)

function ChooseBookController.create(stage)
	local layer = ChooseBookController.new(stage)
	return layer
end

function ChooseBookController:ctor(stage)   
	self.stage = "edu"
	if stage ~= nil then
		self.stage = stage
	end

	self.pubLayout = {}
	self.bookLayout = {}
	self:init()

    if s_CURRENT_USER.usertype ~= USER_TYPE_BIND then
        self:popupAccountBind()
        return
    else
        s_SCENE:removeAllPopups()
    end
end

function ChooseBookController:init()
	local curtain = cc.Sprite:create("image/book/curtain.png")
	curtain:ignoreAnchorPointForPosition(false)
	curtain:setAnchorPoint(0.5,1)
	curtain:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT)	
	self.curtain = curtain
	self:addChild(self.curtain,4)

	local backSprite = cc.Sprite:create("image/book/back.png")
	backSprite:ignoreAnchorPointForPosition(false)
	backSprite:setAnchorPoint(0.5,0.5)
	backSprite:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2)	
	self.backSprite = backSprite
	self:addChild(self.backSprite)


	local chooseEduSprite = cc.Sprite:create("image/book/edu.png")
	chooseEduSprite:ignoreAnchorPointForPosition(false)
	chooseEduSprite:setAnchorPoint(1,0)
	chooseEduSprite:setPosition(s_DESIGN_WIDTH,110)	
	self.chooseEduSprite = chooseEduSprite
	self:addChild(self.chooseEduSprite,3)
	self:initEdu()

	local choosePubSprite = cc.Sprite:create("image/book/pub.png")
	choosePubSprite:ignoreAnchorPointForPosition(false)
	choosePubSprite:setAnchorPoint(0,0)
	choosePubSprite:setPosition(s_DESIGN_WIDTH - 60,110)	
	self.choosePubSprite = choosePubSprite
	self:addChild(self.choosePubSprite,3)

	local arrowSprite = ccui.Button:create("image/book/arrowNormal.png","image/book/arrowPress.png","")
	arrowSprite:setPosition(60,175)	
	self.arrowSprite = arrowSprite
	self.choosePubSprite:addChild(self.arrowSprite)

	self:initBack()	
end

function ChooseBookController:initBack()
	local backButton = ccui.Button:create("image/book/backNormal.png","image/book/backPress.png","")
    backButton:addTouchEventListener(handler(self,self.chooseBack))
    backButton:setPosition(self.backSprite:getContentSize().width * 0.2, 30)
    self.backButton = backButton
    self.backSprite:addChild(self.backButton,10)

    if s_CURRENT_USER.bookKey == "" or s_CURRENT_USER.bookKey == nil then
		self.backButton:setVisible(false)
    end

    local tipLabel = cc.Label:createWithSystemFont("请选择你的学习阶段","",35)
    tipLabel:setPosition(self.backSprite:getContentSize().width /2,47)
    tipLabel:setColor(cc.c4b(255,255,255,255))
	tipLabel:enableOutline(cc.c4b(130,67,31,255),5)
    self.tipLabel = tipLabel
    self.backSprite:addChild(self.tipLabel)

    local mybookButton = ccui.Button:create("image/book/myNormal.png","image/book/myPress.png","")
    mybookButton:addTouchEventListener(handler(self,self.chooseMybook))
    mybookButton:setPosition(self.backSprite:getContentSize().width * 0.8, 30)
    self.mybookButton = mybookButton
    self.backSprite:addChild(self.mybookButton)

    if s_CURRENT_USER.bookKey == "" or s_CURRENT_USER.bookKey == nil then
		self.mybookButton:setVisible(false)
    end

   	if self.stage == "book" then
		local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 600,110))
	    self.chooseEduSprite:runAction(move)
	    local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 60,110))
	    self.choosePubSprite:runAction(move)
		
		s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	    callWithDelay(self,0.5,s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)

		self.book = split(s_CURRENT_USER.bookList,'|')
	    self:resetBook()

		self.stage = "book"
		self.tipLabel:setString("请你选择教材") 
	end
end

function ChooseBookController:initEdu()
	local primaryButton = ccui.Button:create("image/book/primaryNormal.png","image/book/primaryPress.png","")
    primaryButton:addTouchEventListener(handler(self,self.chooseEdu))
    primaryButton:setPosition(280, 400)
    primaryButton:setName("primary")
    self.primaryButton = primaryButton
    self.chooseEduSprite:addChild(self.primaryButton)

    local juniorButton = ccui.Button:create("image/book/juniorNormal.png","image/book/juniorPress.png","")
    juniorButton:addTouchEventListener(handler(self,self.chooseEdu))
    juniorButton:setPosition(577, 400)
    juniorButton:setName("junior")
    self.juniorButton = juniorButton
    self.chooseEduSprite:addChild(self.juniorButton)

    local highButton = ccui.Button:create("image/book/highNormal.png","image/book/highPress.png","")
    highButton:addTouchEventListener(handler(self,self.chooseEdu))
    highButton:setPosition(280, 270)
    highButton:setName("senior")
    self.highButton = highButton
    self.chooseEduSprite:addChild(self.highButton)

    local collegeButton = ccui.Button:create("image/book/collegeNormal.png","image/book/collegePress.png","")
    collegeButton:addTouchEventListener(handler(self,self.chooseEdu))
    collegeButton:setPosition(577, 270)
    collegeButton:setName("college")
    self.collegeButton = collegeButton
    self.chooseEduSprite:addChild(self.collegeButton)

    local moreButton = ccui.Button:create("image/book/moreNormal.png","image/book/morePress.png","")
    moreButton:addTouchEventListener(handler(self,self.chooseEdu))
    moreButton:setPosition(425, 130)
    moreButton:setName("more")
    self.moreButton = moreButton
    self.chooseEduSprite:addChild(self.moreButton)
end

function ChooseBookController:chooseEdu(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    if self.stage ~= "edu" then
    	return
    end

    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    local move = cc.MoveBy:create(0.5,cc.p(-600,0))
    self.chooseEduSprite:runAction(move)
    local move = cc.MoveBy:create(0.5,cc.p(-600,0))
    self.choosePubSprite:runAction(move)

    self.edu = sender:getName()
    self.pub = self:getPub()
    self:resetPub()

	self.stage = "pub"
	self.tipLabel:setString("请你选择教材的出版社") 

    callWithDelay(self,0.5,s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
end

function ChooseBookController:getPub()
	local list = {}
	if self.edu == "primary" then
		list = {"北京版课改","北师大版","牛津上海版","新牛津上海版","牛津苏教版","人教版","人教精通版","人教新起点版","上海新世纪版","外研社一年级起点","外研社三年级起点",}
	elseif self.edu == "junior" then
		list = {"中考","北师大版","冀教版","牛津上海版","牛津深圳版","牛津译林老版","仁爱初中老版","人教版","上海新世纪版","外研社版","牛津译林新版",}
	elseif self.edu == "senior" then
		list = {"高考","北师大版","牛津上海版","牛津译林版","人教版","外研社版","上海新世纪版",}
	elseif self.edu == "college" then
		list = {"四级","六级","专四","专八","考研",}
	elseif self.edu == "more" then
		list = {"kwekwe","厚海","新概念","gmat","gre","junior","primary","sat","senior","toefl","ielts"}
	end
	return list
end

function ChooseBookController:resetPub()
	if 	self.listView ~= nil then
		self.listView:removeAllChildren()
		self.listView = nil
	end

	local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setContentSize(cc.size(550,750))
    listView:setPosition(130,100)
    self.listView = listView
    self.choosePubSprite:addChild(self.listView)

    for i = 1, #self.pub do 
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(cc.size(550,110))

       	local sprite = cc.Sprite:create("image/book/colorback1.png")
       	if i % 2 == 0 then
       		sprite:setTexture("image/book/colorback2.png")
       	end
       	sprite:setPosition(custom_item:getContentSize().width /2,custom_item:getContentSize().height /2)
       	custom_item:addChild(sprite)

       	local label = cc.Label:createWithSystemFont(self.pub[i],"",35)
	    label:setPosition(95,sprite:getContentSize().height /2)
	    label:setColor(cc.c4b(255,255,255,255))
	    label:ignoreAnchorPointForPosition(false)
	    label:setAnchorPoint(0,0.5)
	    sprite:addChild(label)

	    local button = ccui.Button:create("image/book/okNormal.png","image/book/okPress.png","")
	    button:addTouchEventListener(handler(self,self.choosePub))
	    button:setPosition(450,sprite:getContentSize().height /2)
	    button:setName(self.pub[i])
	    sprite:addChild(button)

	    if s_CURRENT_USER.bookPub == self.pub[i] then
	    	local flag = cc.Sprite:create("image/book/pubFlag.png")
			flag:ignoreAnchorPointForPosition(false)
			flag:setAnchorPoint(0.5,1)
			flag:setPosition(50,custom_item:getContentSize().height)	
			sprite:addChild(flag)
	    end

        self.pubLayout[#self.pubLayout + 1] = custom_item
        self.listView:insertCustomItem(self.pubLayout[#self.pubLayout],i - 1)
    end
end

function ChooseBookController:choosePub(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

   	if self.stage ~= "pub" then
    	return
    end

	if sender:getWorldPosition().y <= 150 then
		if sender:getWorldPosition().y <= 100 then
			local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 600,110))
		    self.chooseEduSprite:runAction(move)
		    local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 60,110))
		    self.choosePubSprite:runAction(move)
			
			s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
		    callWithDelay(self,0.5,s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)

			self.book = split(s_CURRENT_USER.bookList,'|')
		    self:resetBook()

			self.stage = "book"
			self.tipLabel:setString("请你选择教材") 
		end
		return
	end

    s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    local move = cc.MoveBy:create(0.5,cc.p(600,0))
    self.choosePubSprite:runAction(move)

    self.currentPub = sender:getName()
    self.book = self:getBook()
    self:resetBook()

    s_CURRENT_USER.bookPub = self.currentPub
    saveUserToServer({['bookPub']=s_CURRENT_USER.bookPub})


	self.stage = "book"
	self.tipLabel:setString("请你选择教材") 

    callWithDelay(self,0.5,s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
end

function ChooseBookController:getBook()
	local list = {}
	for i,v in ipairs(bookConfig) do
		local k,_ =  string.find(bookConfig[i].name,self.currentPub) 
		if k ~= nil and bookConfig[i].type == self.edu then
			list[#list + 1] = bookConfig[i].key
		end
    end
	return list
end

function ChooseBookController:resetBook()
	if 	self.listView ~= nil then
		self.listView:removeAllChildren()
		self.listView = nil
	end

	local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setContentSize(cc.size(600,750))
    listView:setPosition(130,200)
    self.listView = listView
    self.backSprite:addChild(self.listView)

    for i = 1, #self.book do 
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(cc.size(600,125))

	    local button = ccui.Button:create("image/book/book.png","image/book/book.png","")
	    button:addTouchEventListener(handler(self,self.chooseBook))
	    button:setPosition(custom_item:getContentSize().width /2,custom_item:getContentSize().height /2)
	    button:setName(self.book[i])
	    custom_item:addChild(button)

	    local bookName = s_DataManager.books[self.book[i]].name

       	local label = cc.Label:createWithSystemFont(bookName,"",30)
	    label:setPosition(custom_item:getContentSize().width /2,custom_item:getContentSize().height /2)
	    label:setColor(cc.c4b(255,255,255,255))
		label:enableOutline(cc.c4b(32,120,162,255),3)
	    custom_item:addChild(label)

		if s_LocalDatabaseManager.getTotalStudyWordsNumByBookKey(self.book[i]) > 0 then
	        local percent = s_LocalDatabaseManager.getTotalStudyWordsNumByBookKey(self.book[i]) / s_DataManager.books[self.book[i]].words
	        local progress = cc.ProgressTimer:create(cc.Sprite:create("image/book/bookProgress.png"))
		    progress:setPosition(0 ,button:getContentSize().height / 2)
		    progress:ignoreAnchorPointForPosition(false)
		    progress:setAnchorPoint(0,0.5)
		  	progress:setMidpoint(cc.p(0, 0))
		    progress:setBarChangeRate(cc.p(1, 0))
		    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
		    progress:setPercentage(percent * 100)
		    button:addChild(progress)
	    end

	   	if s_CURRENT_USER.bookKey == self.book[i] then
	    	local flag = cc.Sprite:create("image/book/bookFlag.png")
			flag:ignoreAnchorPointForPosition(false)
			flag:setAnchorPoint(0.5,1)
			flag:setPosition(80,custom_item:getContentSize().height)	
			button:addChild(flag)
	    end

        self.bookLayout[#self.bookLayout + 1] = custom_item
        self.listView:insertCustomItem(self.bookLayout[#self.bookLayout],i - 1)
    end
end

function ChooseBookController:chooseBook(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then
        return
    end

    if self.stage ~= "book" then
    	return
    end

    key = sender:getName()

    if s_CURRENT_USER.tutorialStep <= s_tutorial_book_select then
        s_CURRENT_USER:setTutorialStep(s_tutorial_book_select+1) -- 0 -> 1
        s_CURRENT_USER:setTutorialSmallStep(s_smalltutorial_book_select+1) -- 0 -> 1
        AnalyticsFirstBook(key)
    end
    s_CURRENT_USER.bookKey = key
    s_CURRENT_USER:addBookList(key)
    saveUserToServer({['bookKey']=s_CURRENT_USER.bookKey})
    AnalyticsBook(key)
    AnalyticsFirst(ANALYTICS_FIRST_BOOK, key)
    -- 选择书籍后加载对应的配置信息
    s_BookUnitWord, s_BookUnitWordMeaning, s_BookUnitName = s_DataManager.loadK12Books(key)
    s_CURRENT_USER.showSettingLayer = 0
    s_CorePlayManager.enterHomeLayer()
    playSound(s_sound_buttonEffect)   
    if IS_DEVELOPMENT_MODE then s_WordDictionaryDatabase.nextframe = WDD_NEXTFRAME_STATE__RM_LOAD end
end

function ChooseBookController:chooseBack(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
        return
    end

    if self.stage == "edu" then
    	s_CorePlayManager.enterHomeLayer()
    elseif self.stage == "pub" then
	    local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH,110))
	    self.chooseEduSprite:runAction(move)
	    local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 60,110))
	    self.choosePubSprite:runAction(move)

		self.stage = "edu"
			self.tipLabel:setString("请选择你的学习阶段") 
		s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
	    callWithDelay(self,0.5,s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
	elseif self.stage == "book" then
		if self.currentPub ~= nil then
			local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 600,110))
		    self.chooseEduSprite:runAction(move)
		    local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 660,110))
		    self.choosePubSprite:runAction(move)

	    	self:resetPub()
			self.stage = "pub"
	    	self.tipLabel:setString("请你选择教材的出版社") 

			s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
		    callWithDelay(self,0.5,s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
		else
		    local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH,110))
		    self.chooseEduSprite:runAction(move)
		    local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 60,110))
		    self.choosePubSprite:runAction(move)

			self.stage = "edu"
			self.tipLabel:setString("请选择你的学习阶段") 
			s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
		    callWithDelay(self,0.5,s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)
		end
    end
end

function ChooseBookController:chooseMybook(sender, eventType)
	if eventType ~= ccui.TouchEventType.ended then
        return
    end
    
	local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 600,110))
    self.chooseEduSprite:runAction(move)
    local move = cc.MoveTo:create(0.5,cc.p(s_DESIGN_WIDTH - 60,110))
    self.choosePubSprite:runAction(move)
	
	s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
    callWithDelay(self,0.5,s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch)

	self.book = split(s_CURRENT_USER.bookList,'|')
    self:resetBook()

	self.stage = "book"
				self.tipLabel:setString("请你选择教材") 
end

function ChooseBookController:doguidStep()
    -- if s_CURRENT_USER.usertype ~= USER_TYPE_BIND then
    --     if s_CURRENT_USER.guideStep == 0 then
    --         s_CorePlayManager.enterGuideScene(1,self)
    --         s_CURRENT_USER:setGuideStep(s_guide_step_selectGrade) 
    --     end
    -- end
end

--弹出注册帐号的界面
function ChooseBookController:popupAccountBind()
    if s_CURRENT_USER.tutorialStep > s_tutorial_grade_select or s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then return end

	local RegisterAccountView = require("view.login.RegisterAccountView")
    local introLayer = RegisterAccountView.new(RegisterAccountView.STEP_10)
    s_SCENE:popup(introLayer)
    introLayer.close = handler(self,self.doguidStep)
end

return ChooseBookController
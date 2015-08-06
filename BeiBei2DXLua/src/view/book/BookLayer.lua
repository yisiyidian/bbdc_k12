require("cocos.init")
require("common.global")

local BookLayer = class("BookLayer", function ()
    return cc.Layer:create()
end)

function BookLayer.create(education)
    local layer = BookLayer.new(education)
    return layer
end

function BookLayer:ctor(education)
    self.education =    education
    self.layout = {}
    self.shelf = {}
    self.book = {}
    self:setAnalytics()

    self:init()
end

function BookLayer:setAnalytics()
    if s_CURRENT_USER.summaryStep < s_summary_selectBook then
        s_CURRENT_USER:setSummaryStep(s_summary_selectBook)
        AnalyticsSummaryStep(s_summary_selectBook)
    end
end

function BookLayer:enterEducationLayer(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        s_CorePlayManager.enterEducationLayer()
        playSound(s_sound_buttonEffect)
    end
end

function BookLayer:enterMyBookLayer(sender, eventType)
    if s_CURRENT_USER.bookList == '' or self.education == 'mybook' then
        return
    end

    if eventType == ccui.TouchEventType.began then
        playSound(s_sound_buttonEffect)   
    elseif eventType == ccui.TouchEventType.ended then
        s_CorePlayManager.enterBookLayer('mybook')
    end
end

function BookLayer:getAllBookForEducation()
    local key_array = {}
    if self.education ~= 'mybook' then
        for i = 1, #s_DataManager.bookkeys do
            if string.find(s_DataManager.books[s_DataManager.bookkeys[i]].key,"primary") == nil and 
                string.find(s_DataManager.books[s_DataManager.bookkeys[i]].key,"senior") == nil and 
                string.find(s_DataManager.books[s_DataManager.bookkeys[i]].key,"junior") == nil then
                if s_DataManager.books[s_DataManager.bookkeys[i]].type == self.education then
                    key_array[#key_array + 1] = s_DataManager.bookkeys[i]
                end
            end
        end
    else 
        key_array = split(s_CURRENT_USER.bookList,'|')
    end
    self.key_array = key_array
end

function BookLayer:selectBook(sender, eventType)
    local bookIndex = 1
    bookIndex = string.gsub(sender:getName(),"book","")
    bookIndex = tonumber(bookIndex)
    local key = ""
    key = self.key_array[bookIndex]
    if eventType == ccui.TouchEventType.ended then
        if s_CURRENT_USER.tutorialStep == s_tutorial_book_select then
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
end

function BookLayer:addBook(index)
    if index > #self.key_array then
        return
    end
    local book_str = s_DataManager.books[self.key_array[index]].type
    local smallBack = ccui.Button:create("image/book/grade/"..book_str.."/"..self.key_array[index]..".png", "", "")
    smallBack:setTouchEnabled(true)
    smallBack:setScale9Enabled(true)
    smallBack:addTouchEventListener(handler(self,self.selectBook))
    smallBack:setAnchorPoint(0.5,0)
    smallBack:setName("book"..tostring(index))

    self.book[index] = smallBack
    self:resetBook(index)

    local shelfIndex = math.ceil(index /2 + 0.5)
    local layout = self.layout[shelfIndex]
    local shelf = self.shelf[shelfIndex]
    local layoutwidth = layout:getContentSize().width
    local layoutheight = layout:getContentSize().height
    local shelfwidth = shelf:getContentSize().width
    local shelfheight = shelf:getContentSize().height

    self.book[index]:setPosition(layoutwidth / 2.0 ,layoutheight * 0.2 + 0.25 * shelfheight)
    layout:addChild(self.book[index])
    if index > 1 and index % 2 == 0 then
        self.book[index]:setPosition(layoutwidth / 2.0 - 0.2 * shelfwidth,layoutheight * 0.2 + 0.25 * shelfheight)
    elseif index > 1 and index % 2 ~= 0 then
        self.book[index]:setPosition(layoutwidth / 2.0 + 0.2 * shelfwidth,layoutheight * 0.2 + 0.25 * shelfheight)
    end
end

function BookLayer:resetBook(index)
    local rect_table = {'kwekwe','kwekwe_2','kwekwe_3'}

    local sprite = self.book[index]
    local key = self.key_array[index]
    local width = sprite:getContentSize().width
    local height = sprite:getContentSize().height

    if key == s_CURRENT_USER.bookKey then
        local shine
        local flag = false
        for i  =1,#rect_table do
            if key == rect_table[i] then
                flag = true
                break
            end
        end
        if not flag then
            shine = cc.Sprite:create('image/book/choose_book_using_now.png')
            shine:setPosition(width / 2 - 7,height / 2)
        else
            shine = cc.Sprite:create('image/book/choose_book_using_now_round.png')
            shine:setPosition(width / 2 - 3,height / 2)
        end
        sprite:addChild(shine)
        local girl = cc.Sprite:create('image/book/choose_book_using_now_beibei.png')
        sprite:addChild(girl,-1)
        if index == 1 or index % 2 == 0 then
            girl:setPosition(-30,height / 2 + 15)
        else
            girl:setRotationSkewY(180)
            girl:setPosition(width + 10,height / 2 + 15)
        end
    end

    if s_LocalDatabaseManager.getTotalStudyWordsNumByBookKey(key) > 0 then
        local progressBack = cc.Sprite:create('image/book/book_progress2.png')
        progressBack:setPosition(width / 2 - 7,height + 25)
        sprite:addChild(progressBack)
        local percent = s_LocalDatabaseManager.getTotalStudyWordsNumByBookKey(key) / s_DataManager.books[key].words
        local progress = ccui.Scale9Sprite:create('image/book/book_progress1.png',cc.rect(0,0,127,15),cc.rect(7.5, 0, 112, 15))
        progress:setContentSize(cc.size(15 + 178 * percent,15))
        progress:ignoreAnchorPointForPosition(false)
        progress:setAnchorPoint(0,0.5)
        progress:setPosition(0,progressBack:getContentSize().height / 2)
        progressBack:addChild(progress)
        local per = '%'
        local label = cc.Label:createWithSystemFont(string.format('%d%s',percent * 100,per),'',16)
        label:ignoreAnchorPointForPosition(false)
        label:setPosition(progress:getContentSize().width,progress:getContentSize().height / 2)
        progress:addChild(label)
        if percent < 0.5 then
            if percent < 0.01 then
                label:setString(string.format('%.1f%s',percent * 100,per))
            end
            label:setAnchorPoint(-0.3,0.5)
            label:setColor(cc.c3b(107,178,255))
        else
            label:setAnchorPoint(1.3,0.5)
        end
    end

    local richtext = ccui.RichText:create()
    richtext:ignoreContentAdaptWithSize(false)
    richtext:ignoreAnchorPointForPosition(false)
    richtext:setAnchorPoint(cc.p(0.5,0.5))
    richtext:setContentSize(cc.size(width *0.95, height *0.2))  

    local richElement1 = ccui.RichElementText:create(1,cc.c3b(0, 0, 0),150,'单词量: ','',22)                           
    richtext:pushBackElement(richElement1)       

    local richElement2 = ccui.RichElementText:create(2,cc.c3b(255,255,255),255,string.format('%d',s_DataManager.books[key].words),'',22)                           
    richtext:pushBackElement(richElement2)               
    richtext:setPosition(width *0.63, height *0.1)
    sprite:addChild(richtext) 
end

function BookLayer:addShelf(shelfIndex)
    local layout = self.layout[shelfIndex]
    local shelf = cc.Sprite:create('image/book/bookshelf_choose_book_button.png')
    shelf:ignoreAnchorPointForPosition(false)
    shelf:setAnchorPoint(0.5,0.5)
    shelf:setPosition(cc.p(layout:getContentSize().width / 2.0, layout:getContentSize().height * 0.2))
    self.shelf[shelfIndex] = shelf
    layout:addChild(self.shelf[shelfIndex])

    if shelfIndex == 1 then
        self:addBook(shelfIndex)
        local flower = cc.Sprite:create('image/book/flower_choose_book.png')
        flower:setAnchorPoint(0.5,0)
        flower:setPosition(0.75 * self.shelf[shelfIndex]:getContentSize().width,0.75 * self.shelf[shelfIndex]:getContentSize().height)
        self.shelf[shelfIndex]:addChild(flower)
    else
        self:addBook(shelfIndex * 2 - 2)
        self:addBook(shelfIndex * 2 - 1)
    end
end

function BookLayer:createTimer()
    local count = math.ceil(#self.key_array / 2 + 0.5)
    local percent = 0.85 / (#self.key_array * 0.28)
    if percent > 1 then
        percent = 1
    end

    local slider = cc.Sprite:create('image/book/process_button_light_color.png')
    slider:setPosition(0.97 * self.backColor:getContentSize().width,self.backColor:getContentSize().height - 200)
    slider:ignoreAnchorPointForPosition(false)
    slider:setAnchorPoint(0.5,1)
    self.slider = slider
    self.backColor:addChild(self.slider)

    local bar = ccui.Scale9Sprite:create('image/book/process_button_dark_color.png',cc.rect(0,0,15,856),cc.rect(0, 10, 15, 836))
    bar:setPosition(self.slider:getContentSize().width * 0.5,self.slider:getContentSize().height)
    bar:ignoreAnchorPointForPosition(false)
    bar:setAnchorPoint(0.5,1)
    bar:setContentSize(cc.size(15,20 + 836 * percent))
    self.bar = bar
    self.slider:addChild(self.bar)

    local time = 0
    local maxh = 1
    local function update(delta)
        local h = -self.listView:getInnerContainer():getPositionY()
        if h > maxh then
            maxh = h
        end
        local percent = h / maxh
        local height = self.slider:getContentSize().height * percent
        self.bar:setAnchorPoint(0.5,percent)
        self.bar:setPositionY(height)

        time = time + delta

        if time > 0.5 then        
            local beginIndex = math.floor(count * (1-percent)) - 4
            if beginIndex <= 1 then
                beginIndex = 1
            end
            local endIndex = math.ceil(count * (1-percent)) + 4
            if endIndex >= count then
                endIndex = count
            end
            for i=1,count do
                if self.shelf[i] == nil and i>= beginIndex and i<=endIndex then
                    self:addShelf(i)
                end 
            end
        end
    end

    self:scheduleUpdateWithPriorityLua(update, 0)
end

function BookLayer:init()

    local backColor = cc.LayerColor:create(cc.c4b(190,220,209,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self.backColor = backColor
    self:addChild(self.backColor)    
    
    local backButton = ccui.Button:create("image/book/choose_book_back.png","","")
    backButton:setScale9Enabled(true)
    backButton:setTouchEnabled(true)
    backButton:ignoreAnchorPointForPosition(false)
    backButton:setAnchorPoint(0.5 , 0.5)
    backButton:setPosition((s_RIGHT_X - s_LEFT_X) / 2 - 238, 1073)
    backButton:addTouchEventListener(handler(self,self.enterEducationLayer))
    self.backButton = backButton
    self.backColor:addChild(self.backButton)

    local mybookBtn = ccui.Button:create('image/book/k12/select_grade_mybook_button.png','image/book/k12/select_grade_mybook_button_click.png')
    mybookBtn:setPosition((s_RIGHT_X - s_LEFT_X) /2 +200,1073)
    self.mybookBtn = mybookBtn
    self.backColor:addChild(self.mybookBtn)
    self.mybookBtn:addTouchEventListener(handler(self,self.enterMyBookLayer))

    if s_CURRENT_USER.bookList == '' or self.education == 'mybook' then
        self.mybookBtn:setVisible(false)
    end 

    self:getAllBookForEducation()


    local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,0.85 * s_DESIGN_HEIGHT))
    listView:setPosition(s_LEFT_X,0)
    self.listView = listView
    self:addChild(self.listView)

    local count = math.ceil(#self.key_array / 2 + 0.5)
    for i = 1, count do 
        local custom_item = ccui.Layout:create()
        custom_item:setTouchEnabled(true)
        custom_item:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,0.28 * s_DESIGN_HEIGHT))
        self.layout[#self.layout + 1] = custom_item
        self.listView:insertCustomItem(self.layout[#self.layout],i - 1)
    end

    self:createTimer()

    if s_CURRENT_USER.guideStep == s_guide_step_selectGrade then
        s_CorePlayManager.enterGuideScene(2,self)
        s_CURRENT_USER:setGuideStep(s_guide_step_selectBook) 
    end

end


return BookLayer

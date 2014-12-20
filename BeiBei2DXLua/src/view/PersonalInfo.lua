require("cocos.init")
require("common.global")
CC_USE_DEPRECATED_API = true


local PersonalInfo = class("PersonalInfo", function()
    return cc.Layer:create()
end)

function PersonalInfo.create()
    local layer = PersonalInfo.new()
    return layer
end

function PersonalInfo:ctor()

    math.randomseed(os.time())
    self.totalDay = 1
    local moved = false
    local start_y = nil
    local colorArray = {cc.c4b(238,75,74,255 ),cc.c4b(251,166,24,255 ),cc.c4b(128,172,20,255 )}
    local titleArray = {'单词学习增长','登陆贝贝天数','学习效率统计'}
    self.intro_array = {}
    
    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    pageView:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT - 280))
    pageView:setPosition(s_LEFT_X,0)
    pageView:setVertical(true)   
    pageView:setCustomScrollThreshold(s_DESIGN_HEIGHT / 4) 
    
    for i = 1 , 3 do
        local layout = ccui.Layout:create()
        layout:setContentSize(cc.size(s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT))

        local intro = cc.LayerColor:create(cc.c4b(255,255,255,255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT - 280)
        intro:ignoreAnchorPointForPosition(false)
        intro:setAnchorPoint(0.5,0) 
        intro:setPosition(s_DESIGN_WIDTH/2 - s_LEFT_X ,0)
        layout:addChild(intro,0,string.format('back%d',i))
        if i > 1 then
            local scrollButton = cc.Sprite:create("image/PersonalInfo/scrollHintButton.png")
            scrollButton:setPosition(s_DESIGN_WIDTH/2 - s_LEFT_X  ,s_DESIGN_HEIGHT * 0.05)
            scrollButton:setLocalZOrder(1)
            layout:addChild(scrollButton)
            local move = cc.Sequence:create(cc.MoveBy:create(0.5,cc.p(0,-20)),cc.MoveBy:create(0.5,cc.p(0,20)))
            scrollButton:runAction(cc.RepeatForever:create(move))

        end
        local title = cc.Label:createWithSystemFont(titleArray[4 - i],'',30)
        title:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X,0.95 * intro:getContentSize().height)
        title:setColor(colorArray[4 - i])
        layout:addChild(title)
        table.insert(self.intro_array, intro)

        pageView:addPage(layout)

    end 
    
    self:addChild(pageView)
    local lastPage = -1
    local function update(delta)
        local curPage = pageView:getCurPageIndex()
        
        if curPage ~= lastPage then
            if lastPage >= 0 then
                self.intro_array[curPage+1]:removeAllChildren()
            end
            lastPage = curPage
            if curPage == 2 then
                self:PLVI()
            elseif curPage == 1 then
                self:login()
            else
                self:XXTJ()
            end
        end
    end
    self:scheduleUpdateWithPriorityLua(update, 0)
    
end


function PersonalInfo:PLVI()
    local back = self.intro_array[3]
    local to = os.time()
--    local from = os.time({year = tonumber(os.date("%Y", s_CURRENT_USER.localTime),10), 
--                         month = tonumber(os.date("%Y", s_CURRENT_USER.localTime),10),  
--                          date = tonumber(os.date("%Y", s_CURRENT_USER.localTime),10),
--                        hour = 0,
--                         min = 0})
    local from = s_CURRENT_USER.localTime - s_CURRENT_USER.localTime % (24 * 3600)
    local sub = to - from
    
    local dayCount = math.floor(sub / (24 * 3600)) + 1
    local scale = (s_RIGHT_X - s_LEFT_X) / s_DESIGN_WIDTH
    
    local yBar = cc.Sprite:create("image/PersonalInfo/PLVI/lv_information_zuobiantiao_1.png")
    yBar:setScaleX(scale)
    yBar:setAnchorPoint(0, 1)
    yBar:setPosition(0, s_DESIGN_HEIGHT * 0.8)
    back:addChild(yBar)
    
    local gezi = cc.Sprite:create("image/PersonalInfo/PLVI/wsy_gezi.png")
    gezi:setScaleX(scale)
    gezi:setAnchorPoint(0.0,0.5)
    gezi:setPosition(yBar:getContentSize().width * scale, s_DESIGN_HEIGHT * 0.53)
    back:addChild(gezi)
    
    local countArray = {}
    local dateArray = {}
    math.random(0,20)
    local selectDate = s_CURRENT_USER.localTime
    for i = 1 , dayCount do 
        local str = string.format("%s/%s/%s",os.date('%m',selectDate),os.date('%d',selectDate),os.date('%y',selectDate))
        countArray[i] = s_DATABASE_MGR.getStudyWordsNum(s_CURRENT_USER.bookKey,str)
        dateArray[i] = string.format("%s/%s",os.date('%m',selectDate),os.date('%d',selectDate))
        selectDate = selectDate + 24 * 3600
        if i > 1 then
            countArray[i] = countArray[i - 1] + countArray[i]
        end
    end
    local point = {}
    local selectPoint
    local countLabel
    local tableHeight = gezi:getContentSize().height
    local tableWidth = gezi:getContentSize().width
    local function drawXYLabel(date,count)
        local max = count[#count]
        local min = count[1]
        if max == min then
            min = 0
        end
        local yLabel = {}
        local xLabel = date
        point = {}
        
        for i = 1, #count do
            local x
            local y
            if #count > 1 then
                --yLabel[i] = min + (max - min) * (i - 1) / (#count - 1)
                x = (i - 0.5) / (#count + 1)
            else 
                --yLabel[i] = min
                x = 0.5 / 5
            end
            if max > min then
                y = (count[i] - min) / (max - min) * 0.58 + 0.2
            elseif max > 0 then
                y = 0.78
            else 
                y = 0.2              
            end
            point[i] = cc.p(x,y)
            local x_i = cc.Label:createWithSystemFont(xLabel[i],'',24)
            x_i:setScaleX(1/ scale)
            x_i:setPosition(x * tableWidth , 0)
            gezi:addChild(x_i)
        end
        local y = {}
        for i = 1, 5 do
            yLabel[i] = min + (max - min) * (i - 1) / (5 - 1)
            y[i] = cc.Label:createWithSystemFont(math.ceil(yLabel[i]),'',24)
            y[i]:setScaleX(1/ scale)
            y[i]:setColor(cc.c3b(201,43,44))
            y[i]:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)
            y[i]:setPosition(0.5 * yBar:getContentSize().width , (0.2 + 0.58 * (i - 1) / 4) * tableHeight)
            yBar:addChild(y[i])
        end
        if max == 0 then
            for i = 1, 5 do
                y[i]:setString(string.format('%d',10 * (i - 1)))
            end
        end
        local length = {}
        if #count > 0 then
            for i = 1,#count - 1 do
                 length[i] = math.sqrt( math.pow((point[i + 1].x - point[i].x) * tableWidth,2) + math.pow((point[i + 1].y - point[i].y) * tableHeight,2))
                local angle = math.acos((point[i + 1].x - point[i].x) * tableWidth / length[i])
                local line = cc.ProgressTimer:create(cc.Sprite:create('image/PersonalInfo/PLVI/chart_line.png'))
                line:setType(cc.PROGRESS_TIMER_TYPE_BAR)
                line:ignoreAnchorPointForPosition(false)
                line:setAnchorPoint(0.02,0.5)
                line:setPosition(point[i].x * tableWidth ,point[i].y * tableHeight+ (yBar:getPositionY() - (yBar:getContentSize().height - gezi:getContentSize().height * 0.5 ) - gezi:getPositionY()))
                line:setScale(length[i] / (line:getContentSize().width*0.98),1)
                line:setRotation(-angle * 180 / math.pi)
                line:setPercentage(0)
                line:setMidpoint(cc.p(0,0))
                line:setBarChangeRate(cc.p(1,0))
                local to = cc.ProgressTo:create(length[i] / 500, 100)
                local delayTime = 0
                if i > 1 then
                    for j = 1,i - 1 do
                	   delayTime = delayTime + length[j] / 500
                    end
                end
                
                line:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime),to))
                gezi:addChild(line)
            end
        end
        selectPoint = cc.Sprite:create('image/PersonalInfo/login/wsy_suanzhong.png')
        selectPoint:setScaleX(1 / scale)
        selectPoint:ignoreAnchorPointForPosition(false)
        selectPoint:setAnchorPoint(0.5,0.5)
        selectPoint:setPosition(point[#count].x * tableWidth ,point[#count].y * tableHeight+ (yBar:getPositionY() - (yBar:getContentSize().height - gezi:getContentSize().height * 0.5 ) - gezi:getPositionY()))
        gezi:addChild(selectPoint)
        selectPoint:setVisible(false)
        local time = 0
        for i = 1,#count - 1 do
            time = time + length[i] / 200
        end
        selectPoint:runAction(cc.Sequence:create(cc.DelayTime:create(time),cc.Show:create()))
        
        local board = cc.Sprite:create('image/PersonalInfo/PLVI/learnedCountBoard_IC.png')
        board:ignoreAnchorPointForPosition(false)
        board:setAnchorPoint(0.5,0)
        board:setPosition(0.5 * selectPoint:getContentSize().width,selectPoint:getContentSize().height)
        selectPoint:addChild(board)
        
        local label = cc.Label:createWithSystemFont('个','',24)
        label:setColor(cc.c3b(0,0,0))
        label:setAnchorPoint(0,0.5)
        label:setPosition(0.65 * board:getContentSize().width,0.5 * board:getContentSize().height)
        board:addChild(label)
        countLabel = cc.Label:createWithSystemFont(string.format('%d',count[#count]),'',52)
        countLabel:ignoreAnchorPointForPosition(false)
        countLabel:setAnchorPoint(0.7,0.5)
        countLabel:setColor(cc.c3b(0,0,0))
        countLabel:setPosition(0.5 * board:getContentSize().width,0.55 * board:getContentSize().height)
        board:addChild(countLabel,0,'count')
    end
    
    local xArray = {}
    local yArray = {}
    local labelCount = 4
    if dayCount < 4 then
        labelCount = dayCount
    end
    for i = 1, labelCount do
        yArray[i] = countArray[dayCount - labelCount + i]
        xArray[i] = dateArray[dayCount - labelCount + i]
    end
    drawXYLabel(xArray,yArray)
    
    local menu = cc.Node:create()
    menu:setPosition(0, 0.16 * s_DESIGN_HEIGHT)
    back:addChild(menu)
    local selectButton = 1
    local rightButton = 1
    local button = {}
    local date = os.time()
    for i = 1, dayCount do
    
        button[i] = ccui.Button:create()
        if i > 4 then
            button[i]:setVisible(false)
        end
        button[i]:setTouchEnabled(true)
        --add label on button
        local dateLabel = cc.Label:createWithSystemFont(os.date("%d", date),'',40)
        local yearLabel = cc.Label:createWithSystemFont(os.date("%Y", date),'',24)
        local monthLabel = cc.Label:createWithSystemFont(string.upper(os.date("%b", date)),'',28)
        local sun = cc.Sprite:create('res/image/PersonalInfo/login/wsy_suanzhong.png')

        if i > 1 then
            button[i]:loadTextures("res/image/PersonalInfo/login/wsy_hongseban.png", "res/image/PersonalInfo/login/wsy_hongseban.png", "")
            sun:setVisible(false)
        else 
            button[i]:loadTextures("res/image/PersonalInfo/login/wsy_baiban.png", "res/image/PersonalInfo/login/wsy_baiban.png", "")
            dateLabel:setString('今天')
            dateLabel:setSystemFontSize(30)
            monthLabel:setString('today')
            yearLabel:setString(' ')
            monthLabel:setColor(cc.c3b(201,43,44))
            dateLabel:setColor(cc.c3b(201,43,44))
            yearLabel:setColor(cc.c3b(201,43,44))
        end
        monthLabel:setPosition(0.5 * button[i]:getContentSize().width,button[i]:getContentSize().height * 0.4)
        button[i]:addChild(monthLabel,0,'month')
        yearLabel:setPosition(0.5 * button[i]:getContentSize().width,button[i]:getContentSize().height * 0.2)
        button[i]:addChild(yearLabel,0,'year')
        dateLabel:setPosition(0.5 * button[i]:getContentSize().width,button[i]:getContentSize().height * 0.7)
        if i == 1 then
            dateLabel:setPosition(0.5 * button[i]:getContentSize().width,button[i]:getContentSize().height * 0.6)
        end
        button[i]:addChild(dateLabel,0,'date')
        sun:setPosition(0.5 * button[i]:getContentSize().width,button[i]:getContentSize().height)
        button[i]:addChild(sun,0,'sun')
        if dayCount > 3 then
            button[i]:setPosition((5-i)/5 * (s_RIGHT_X - s_LEFT_X),0)  
        else
            button[i]:setPosition((dayCount + 1 - i)/5 * (s_RIGHT_X - s_LEFT_X),0)
        end  
        menu:addChild(button[i])
        date = date - 24 * 3600
        --button event
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended  and selectButton ~= i then
                button[selectButton]:getChildByName('sun'):setVisible(false)
                button[selectButton]:getChildByName('date'):setColor(cc.c3b(255,255,255))
                button[selectButton]:getChildByName('year'):setColor(cc.c3b(255,255,255))
                button[selectButton]:getChildByName('month'):setColor(cc.c3b(255,255,255))
                button[selectButton]:loadTextures("res/image/PersonalInfo/login/wsy_hongseban.png", "res/image/PersonalInfo/login/wsy_hongseban.png", "")
                selectButton = i
                button[selectButton]:getChildByName('sun'):setVisible(true)
                button[selectButton]:getChildByName('date'):setColor(cc.c3b(201,43,44))
                button[selectButton]:getChildByName('year'):setColor(cc.c3b(201,43,44))
                button[selectButton]:getChildByName('month'):setColor(cc.c3b(201,43,44))
                button[selectButton]:loadTextures("res/image/PersonalInfo/login/wsy_baiban.png", "res/image/PersonalInfo/login/wsy_baiban.png", "")
                --selectPoint:setVisible(true)
                selectPoint:setPosition(point[#point - selectButton + rightButton].x * tableWidth ,point[#point - selectButton + rightButton].y * tableHeight+ (yBar:getPositionY() - (yBar:getContentSize().height - gezi:getContentSize().height * 0.5 ) - gezi:getPositionY()))
                countLabel:setString(string.format('%d',countArray[#countArray + 1 - selectButton]))
            end
        end      
        button[i]:addTouchEventListener(touchEvent)
           
    end
    --add front/back button
    if dayCount > 4 then  
        local menu1 = cc.Menu:create()
        menu1:setPosition(0,0)
        back:addChild(menu1,0,'menu')

        local frontButton = cc.MenuItemImage:create('res/image/PersonalInfo/login/front_button.png','','')
        --frontButton:loadTextures('res/image/PersonalInfo/login/back_button.png','res/image/PersonalInfo/login/back_button.png','')
        frontButton:setPosition(0.95 * (s_RIGHT_X - s_LEFT_X),0.16 * s_DESIGN_HEIGHT)
        --frontButton:setVisible(false)
        menu1:addChild(frontButton,0,'front')
        local backButton = cc.MenuItemImage:create('res/image/PersonalInfo/login/back_button.png','','')
        --backButton:loadTextures('res/image/PersonalInfo/login/back_button.png','res/image/PersonalInfo/login/back_button.png','')
        backButton:setPosition(0.05 * (s_RIGHT_X - s_LEFT_X),0.16 * s_DESIGN_HEIGHT)
        backButton:setVisible(false)
        menu1:addChild(backButton)

        --frontButton:setVisible(true)
        -- button event
        local function onFront(sender)
            --if eventType == ccui.TouchEventType.ended then
            gezi:removeAllChildrenWithCleanup(true)
            yBar:removeAllChildrenWithCleanup(true)
            for i = 1, labelCount do
                yArray[i] = countArray[dayCount - labelCount + i - rightButton]
                xArray[i] = dateArray[dayCount - labelCount + i - rightButton]
            end
            button[rightButton]:setVisible(false)
            button[rightButton + 4]:setVisible(true)
            menu:runAction(cc.MoveBy:create(0.2,cc.p(0.2 * (s_RIGHT_X - s_LEFT_X),0) ))
            rightButton = rightButton + 1
            
            drawXYLabel(xArray,yArray)
            if rightButton >= dayCount - 3 and frontButton:isVisible() then
                frontButton:setVisible(false)
            end
            if rightButton > 1 and  backButton:isVisible() == false then
                backButton:setVisible(true)
            end
            --end
        end
        --            
        local function onBack(sender,eventType)
            --if eventType == ccui.TouchEventType.ended then
            gezi:removeAllChildrenWithCleanup(true)
            yBar:removeAllChildrenWithCleanup(true)
            for i = 1, labelCount do
                yArray[i] = countArray[dayCount - labelCount + i - rightButton + 2]
                xArray[i] = dateArray[dayCount - labelCount + i - rightButton + 2]
            end
            drawXYLabel(xArray,yArray)
            button[rightButton + 3]:setVisible(false)
            button[rightButton - 1]:setVisible(true)
            menu:runAction(cc.MoveBy:create(0.2,cc.p(-0.2 *(s_RIGHT_X - s_LEFT_X),0) ))
            rightButton = rightButton - 1
            
            if rightButton <= 1 then
                backButton:setVisible(false)
            end
            if rightButton < dayCount - 3 then
                frontButton:setVisible(true)
            end
            --end
        end
        frontButton:registerScriptTapHandler(onFront)
        backButton:registerScriptTapHandler(onBack)

    end
    
end

function PersonalInfo:login()
    local back = self.intro_array[2]
    local loginData = s_CURRENT_USER.logInDatas
    math.randomseed(os.time()) 
    local loginArray = {}
    local weekCount = #loginData
    local totalDay = 0
    local weekDay = {}
    local isWeek = tonumber(os.date('%w',os.time()),10)
    local lastDate = os.time()
    if isWeek > 0 then
        lastDate = lastDate + (7 - isWeek) * 24 * 3600
    end
    local firstDate = lastDate - 6 * 24 * 3600
    for i = 1 , weekCount do 
        loginArray[i] = loginData[i]:getDays()
        weekDay[i] = 0
        for j = 1,7 do
            --loginArray[i][j] = math.random(0,1)
            if loginArray[i][j] == 1 then
                totalDay = totalDay + 1
                weekDay[i] = weekDay[i] + 1
            end
        end
    end
    self.totalDay = totalDay
    --draw circle 
    for i = 1,7 do
        local str
        if loginArray[1][i] == 1 then
            str = 'res/image/PersonalInfo/PLVI/login.png'
        elseif i <= isWeek  then
            str = 'res/image/PersonalInfo/PLVI/not_login.png'
        else
            str = 'res/image/PersonalInfo/PLVI/not_coming.png'
        end
        local dayRing = cc.ProgressTimer:create(cc.Sprite:create(str))
        dayRing:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X,0.5 * s_DESIGN_HEIGHT)
        dayRing:setScale(1.0)
        dayRing:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        dayRing:setReverseDirection(false)
        dayRing:setPercentage(100/7)
        dayRing:setRotation( 360 * (i-1) / 7)
        back:addChild(dayRing,0,string.format('day%d',i))
    end
    local center = cc.Sprite:create('res/image/PersonalInfo/PLVI/center.png')
    center:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X,0.5 * s_DESIGN_HEIGHT)
    center:setScale(1.0)
    
    local line = cc.LayerColor:create(cc.c4b(0,0,0,255),center:getContentSize().width * 0.8,1)
    line:ignoreAnchorPointForPosition(false)
    line:setAnchorPoint(0.5,0.5)
    line:setPosition(0.5 * center:getContentSize().width,0.5 * center:getContentSize().height)
    center:addChild(line)
    
    local weekDayLabel = cc.Label:createWithSystemFont(string.format('本周 %d 天',weekDay[1]),'',40)
    weekDayLabel:setColor(cc.c3b(0,0,0))
    weekDayLabel:ignoreAnchorPointForPosition(false)
    weekDayLabel:setAnchorPoint(0.5,0)
    weekDayLabel:setPosition(0.5 * center:getContentSize().width,0.55 * center:getContentSize().height)
    center:addChild(weekDayLabel)
    
    local totalLabel = cc.Label:createWithSystemFont(string.format('累计登陆%d天',totalDay),'',28)
    totalLabel:setColor(cc.c3b(0,0,0))
    totalLabel:ignoreAnchorPointForPosition(false)
    totalLabel:setAnchorPoint(0.5,1)
    totalLabel:setPosition(0.5 * center:getContentSize().width,0.45 * center:getContentSize().height)
    center:addChild(totalLabel)
    
    back:addChild(center,1)
    --add button
    local menu = cc.Node:create()
    menu:setPosition(0, 0.2 * s_DESIGN_HEIGHT)
    back:addChild(menu)
    local selectButton = 1
    local rightButton = 1
    local button = {}
    for i = 1, weekCount do
        
        button[i] = ccui.Button:create()
        if i > 4 then
            button[i]:setVisible(false)
        end
        button[i]:setTouchEnabled(true)
        --add label on button
        local weekLabel = cc.Label:createWithSystemFont(string.format('%d周',weekCount + 1 - i),'',40)
        local yearLabel = cc.Label:createWithSystemFont(os.date("%Y", os.time()),'',28)
        local dateLabel = cc.Label:createWithSystemFont(string.format('%s~%s',string.sub(os.date('%x',firstDate),1,5),string.sub(os.date('%x',lastDate),1,5)),'',18)
        firstDate = firstDate - 7 * 24 * 3600
        lastDate = lastDate - 7 * 24 * 3600
        local sun = cc.Sprite:create('res/image/PersonalInfo/login/wsy_suanzhong.png')
        
        if i > 1 then
            button[i]:loadTextures("res/image/PersonalInfo/login/wsy_chengseban.png", "res/image/PersonalInfo/login/wsy_chengseban.png", "")
            sun:setVisible(false)
        else 
            button[i]:loadTextures("res/image/PersonalInfo/login/wsy_baiban.png", "res/image/PersonalInfo/login/wsy_baiban.png", "")
            
            weekLabel:setString('本周')
            weekLabel:setColor(cc.c3b(255,103,0))
            dateLabel:setColor(cc.c3b(255,103,0))
            yearLabel:setColor(cc.c3b(255,103,0))
        end
        weekLabel:setPosition(0.5 * button[i]:getContentSize().width,button[i]:getContentSize().height * 0.7)
        button[i]:addChild(weekLabel,0,'week')
        yearLabel:setPosition(0.5 * button[i]:getContentSize().width,button[i]:getContentSize().height * 0.4)
        button[i]:addChild(yearLabel,0,'year')
        dateLabel:setPosition(0.5 * button[i]:getContentSize().width,button[i]:getContentSize().height * 0.2)
        button[i]:addChild(dateLabel,0,'date')
        sun:setPosition(0.5 * button[i]:getContentSize().width,button[i]:getContentSize().height)
        button[i]:addChild(sun,0,'sun')
        if weekCount > 3 then
            button[i]:setPosition((5-i)/5 * (s_RIGHT_X - s_LEFT_X),0)  
        else
            button[i]:setPosition((weekCount + 1 - i)/5 * (s_RIGHT_X - s_LEFT_X),0)
        end
        menu:addChild(button[i])
        
        --button event
        local function touchEvent(sender,eventType)
            if eventType == ccui.TouchEventType.ended  and selectButton ~= i then
                button[selectButton]:getChildByName('sun'):setVisible(false)
                button[selectButton]:getChildByName('date'):setColor(cc.c3b(255,255,255))
                button[selectButton]:getChildByName('year'):setColor(cc.c3b(255,255,255))
                button[selectButton]:getChildByName('week'):setColor(cc.c3b(255,255,255))
                button[selectButton]:loadTextures("res/image/PersonalInfo/login/wsy_chengseban.png", "res/image/PersonalInfo/login/wsy_chengseban.png", "")
                selectButton = i
                button[selectButton]:getChildByName('sun'):setVisible(true)
                button[selectButton]:getChildByName('date'):setColor(cc.c3b(255,103,0))
                button[selectButton]:getChildByName('year'):setColor(cc.c3b(255,103,0))
                button[selectButton]:getChildByName('week'):setColor(cc.c3b(255,103,0))
                button[selectButton]:loadTextures("res/image/PersonalInfo/login/wsy_baiban.png", "res/image/PersonalInfo/login/wsy_baiban.png", "")
                weekDayLabel:setString(string.format('本周 %d 天',weekDay[i]))
                for j = 1,7 do
                    local str
                    if loginArray[i][j] == 1 then
                        str = 'res/image/PersonalInfo/PLVI/login.png'
                    elseif i < weekCount or j <= isWeek then
                        str = 'res/image/PersonalInfo/PLVI/not_login.png'
                    else
                        str = 'res/image/PersonalInfo/PLVI/not_coming.png'
                    end
                    local dayRing = back:getChildByName(string.format('day%d',j))
                    dayRing:removeFromParent()
                    dayRing = cc.ProgressTimer:create(cc.Sprite:create(str))
                    dayRing:setPosition(0.5 * s_DESIGN_WIDTH,0.5 * s_DESIGN_HEIGHT)
                    dayRing:setScale(1.0)
                    dayRing:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
                    dayRing:setReverseDirection(false)
                    dayRing:setPercentage(100/7)
                    dayRing:setRotation( 360 * (j-1) / 7)
                    back:addChild(dayRing,0,string.format('day%d',j))
                end 
            end
        end      
        button[i]:addTouchEventListener(touchEvent)   
    end
    --add front/back button
    if weekCount > 4 then  
        local menu1 = cc.Menu:create()
        menu1:setPosition(0,0)
        back:addChild(menu1,0,'menu')

        local frontButton = cc.MenuItemImage:create('res/image/PersonalInfo/login/front_button.png','','')
        --frontButton:loadTextures('res/image/PersonalInfo/login/back_button.png','res/image/PersonalInfo/login/back_button.png','')
        frontButton:setPosition(0.95 * (s_RIGHT_X - s_LEFT_X),0.2 * s_DESIGN_HEIGHT)
        --frontButton:setVisible(false)
        menu1:addChild(frontButton,0,'front')
        local backButton = cc.MenuItemImage:create('res/image/PersonalInfo/login/back_button.png','','')
        --backButton:loadTextures('res/image/PersonalInfo/login/back_button.png','res/image/PersonalInfo/login/back_button.png','')
        backButton:setPosition(0.05 * (s_RIGHT_X - s_LEFT_X),0.2 * s_DESIGN_HEIGHT)
        backButton:setVisible(false)
        menu1:addChild(backButton)

        --frontButton:setVisible(true)
        -- button event
        local function onFront(sender)
            --if eventType == ccui.TouchEventType.ended then
            button[rightButton]:setVisible(false)
            button[rightButton + 4]:setVisible(true)
            menu:runAction(cc.MoveBy:create(0.2,cc.p(0.2 *(s_RIGHT_X - s_LEFT_X),0) ))
            rightButton = rightButton + 1

            if rightButton >= weekCount - 3 and frontButton:isVisible() then
                frontButton:setVisible(false)
            end
            if rightButton > 1 and  backButton:isVisible() == false then
                backButton:setVisible(true)
            end
            --end
        end
        --            
        local function onBack(sender,eventType)
            --if eventType == ccui.TouchEventType.ended then
            button[rightButton + 3]:setVisible(false)
            button[rightButton - 1]:setVisible(true)
            menu:runAction(cc.MoveBy:create(0.2,cc.p(-0.2 *(s_RIGHT_X - s_LEFT_X),0) ))
            rightButton = rightButton - 1
            if rightButton <= 1 then
                backButton:setVisible(false)
            end
            if rightButton < weekCount - 3 then
                frontButton:setVisible(true)
            end
            --end
        end
        frontButton:registerScriptTapHandler(onFront)
        --frontButton:addTouchEventListener(onFront)
        backButton:registerScriptTapHandler(onBack)

    end
end   

function PersonalInfo:XXTJ()

    local totalDay = 6
    local everydayWord = math.floor(s_DATABASE_MGR.getStudyWordsNum(s_CURRENT_USER.bookKey,nil) / totalDay)
    local totalWord = s_DATA_MANAGER.books[s_CURRENT_USER.bookKey].words
    local wordFinished = s_DATABASE_MGR.getStudyWordsNum(s_CURRENT_USER.bookKey,nil)
    local dayToFinish = 100
    if everydayWord > 0 then
        dayToFinish = math.ceil((totalWord - s_DATABASE_MGR.getStudyWordsNum(s_CURRENT_USER.bookKey,nil)) / everydayWord)
    end
    local back = self.intro_array[1]

    local drawLabel = function(label,count,unit,y)
   
        local speedLabel = cc.Label:createWithSystemFont(string.format('%s ',label),'',36)
        speedLabel:setAnchorPoint(0,0)
        speedLabel:setColor(cc.c4b(128,172,20,255))
        back:addChild(speedLabel)

        local speed = cc.Label:createWithSystemFont(string.format('%d',count),'',80)
        speed:setAnchorPoint(0,0.1)
        speed:setColor(cc.c4b(128,172,20,255))
        back:addChild(speed)

        local unit1 = cc.Label:createWithSystemFont(string.format(' %s',unit),'',36)
        unit1:setAnchorPoint(1,0)
        unit1:setColor(cc.c4b(128,172,20,255))
        back:addChild(unit1)

        local length = speed:getContentSize().width + speedLabel:getContentSize().width + unit1:getContentSize().width
        speedLabel:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X - length / 2,y)
        speed:setPosition(speedLabel:getPositionX() + speedLabel:getContentSize().width,y)
        unit1:setPosition(speedLabel:getPositionX() + length,y)
    end

    drawLabel('日均学习',everydayWord,'个',0.5 * back:getContentSize().width)
    local dayLabel = '还需学习'
    if dayToFinish > 99 then
        dayToFinish = 99
        dayLabel = '还需学习大于'
    end
    drawLabel(dayLabel,dayToFinish,'天',0.75 * back:getContentSize().width)

    if dayToFinish > 99 then
        dayToFinish = 99
    end
    local finishTime = os.time() + dayToFinish * 24 * 3600

        local speedLabel = cc.Label:createWithSystemFont(string.format('完成日期预测%s年 ',os.date('%y',finishTime)),'',36)
        speedLabel:setAnchorPoint(0,0)
        speedLabel:setColor(cc.c4b(128,172,20,255))
        back:addChild(speedLabel)

        local month = cc.Label:createWithSystemFont(string.format('%s',tonumber(os.date('%m',finishTime),10)),'',76)
        month:setAnchorPoint(0,0.1)
        month:setColor(cc.c4b(128,172,20,255))
        back:addChild(month)

        local unit1 = cc.Label:createWithSystemFont(' 月 ','',36)
        unit1:setAnchorPoint(0,0)
        unit1:setColor(cc.c4b(128,172,20,255))
        back:addChild(unit1)

        local day = cc.Label:createWithSystemFont(string.format('%s',tonumber(os.date('%d',finishTime),10)),'',76)
        day:setAnchorPoint(0,0.1)
        day:setColor(cc.c4b(128,172,20,255))
        back:addChild(day)

        local unit2 = cc.Label:createWithSystemFont(' 日','',36)
        unit2:setAnchorPoint(1,0)
        unit2:setColor(cc.c4b(128,172,20,255))
        back:addChild(unit2)

        local length = month:getContentSize().width + day:getContentSize().width + speedLabel:getContentSize().width + unit1:getContentSize().width + unit2:getContentSize().width
        speedLabel:setPosition(0.5 * s_DESIGN_WIDTH - s_LEFT_X - length / 2,1.0 * back:getContentSize().width)
        month:setPosition(speedLabel:getPositionX() + speedLabel:getContentSize().width,1.0 * back:getContentSize().width)
        unit1:setPosition(month:getPositionX() + month:getContentSize().width,1.0 * back:getContentSize().width)
        day:setPosition(unit1:getPositionX() + unit1:getContentSize().width,1.0 * back:getContentSize().width)
        unit2:setPosition(speedLabel:getPositionX() + length,1.0 * back:getContentSize().width)    
	
end

return PersonalInfo
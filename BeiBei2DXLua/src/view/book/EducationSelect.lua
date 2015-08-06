
local RegisterAccountView = require("view.login.RegisterAccountView")

--选择年级  小学 初中 高中
--
local EducationSelect = class("EducationSelect", function ()
    return cc.Layer:create()
end)

function EducationSelect.create()
	local layer = EducationSelect.new()
	return layer
end

function EducationSelect:ctor()   
    -- 打点
	local background = cc.LayerColor:create(cc.c4b(200,240,255,255),s_RIGHT_X - s_LEFT_X,s_DESIGN_HEIGHT)
	background:ignoreAnchorPointForPosition(false)
	background:setAnchorPoint(0.5,0)
	background:setPosition(s_DESIGN_WIDTH / 2,0)
	self:addChild(background)

    --椰树海滩的图
	local bottom = cc.Sprite:create('image/book/k12/K12_choose_grade_bottom_bg.png')
	bottom:setAnchorPoint(0.5,0)
	bottom:setPosition(s_DESIGN_WIDTH / 2,0)
	self:addChild(bottom)

    --返回HomeLayer的回调
	local backHome = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)   
        elseif eventType == ccui.TouchEventType.ended then
            s_CorePlayManager.enterHomeLayer()
            --cx.CXUtils:getInstance():shutDownApp()
        end
    end
    --返回按钮
	local backBtn = ccui.Button:create('image/book/k12/K12_choose_book_back_button.png','image/book/k12/K12_choose_book_back_button_press.png')
	backBtn:setPosition((s_RIGHT_X - s_LEFT_X) / 2 - 238, 1073)
    backBtn:addTouchEventListener(backHome)
    background:addChild(backBtn)

    local hint = cc.Label:createWithSystemFont("请选择年级","",24)
    hint:setPosition((s_RIGHT_X - s_LEFT_X)/2,1073)
    hint:setColor(cc.c4b(66,66,62,255))
    background:addChild(hint) 
    backBtn:setVisible(false)
    -- if have not selected any book
    if s_CURRENT_USER.bookKey == '' or s_CURRENT_USER.bookKey == nil then 
    else
        backBtn:setVisible(true)
    end
    --进入选书界面
    local enterBookLayer = function (sender,eventType)
    	if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)   
        elseif eventType == ccui.TouchEventType.ended then
            if s_CURRENT_USER.summaryStep < s_summary_selectGrade then
                s_CURRENT_USER:setSummaryStep(s_summary_selectGrade)
                AnalyticsSummaryStep(s_summary_selectGrade)
            end
            s_CorePlayManager.enterBookLayer(sender:getName())
        end
    end

    local education = {'primary','junior','senior','college','more','mybook'}
    local titleArray = {'小学','初中','高中','大学','更多','我的书'}
    for i = 1,4 do
    	local bookBtn = ccui.Button:create('image/book/k12/select_grade_button.png','image/book/k12/select_grade_button_click.png')
        local y = -200
        if i <= 2 then
            y = 100
        end
        local x = -120
        if i % 2 == 0 then
            x = 120
        end
    	bookBtn:setPosition((s_RIGHT_X - s_LEFT_X) /2 +x,s_DESIGN_HEIGHT / 2 +y +30)
    	background:addChild(bookBtn)
    	bookBtn:setName(education[i])

        local icon = ccui.Button:create('image/book/k12/select_grade_'..education[i]..'_school.png','image/book/k12/select_grade_'..education[i]..'_school.png')
        icon:setPosition(bookBtn:getPositionX(),bookBtn:getPositionY() + 150)
        icon:setName(education[i])
        background:addChild(icon)
        
		local title = cc.Label:createWithSystemFont(titleArray[i],'',34)
        title:setPosition(bookBtn:getContentSize().width*0.5,bookBtn:getContentSize().height*0.5)
        bookBtn:addChild(title)   

        icon:addTouchEventListener(enterBookLayer)  
        bookBtn:addTouchEventListener(enterBookLayer) 	
    end
    --更多书籍的按钮
    local bookBtn = ccui.Button:create('image/book/k12/select_grade_more_button.png','image/book/k12/select_grade_more_button_click.png')
    bookBtn:setPosition((s_RIGHT_X - s_LEFT_X) /2 +120,s_DESIGN_HEIGHT / 2 -280)
    background:addChild(bookBtn)
    bookBtn:setName(education[5]) 
    bookBtn:addTouchEventListener(enterBookLayer)
    --我的书
    if s_CURRENT_USER.bookList ~= '' then
        local mybookBtn = ccui.Button:create('image/book/k12/select_grade_mybook_button.png','image/book/k12/select_grade_mybook_button_click.png')
        mybookBtn:setPosition((s_RIGHT_X - s_LEFT_X) /2 +200,1073)
        background:addChild(mybookBtn)
        mybookBtn:setName('mybook') 
        mybookBtn:addTouchEventListener(enterBookLayer)
    end
    --弹出注册帐号
    --TODO 这块的流程太乱 需整理
    
    --如果是直接登陆的用户没有选书 则走else
    --如果是游客登录或者注册 就走if
    if s_CURRENT_USER.usertype ~= USER_TYPE_BIND then
        s_CURRENT_USER.guideStep = 0
        self:popupAccountBind()
        return
    else
        s_SCENE:removeAllPopups()
    end

    -- 添加引导
    if s_CURRENT_USER.guideStep == 0 then
        s_CorePlayManager.enterGuideScene(1,self)
        s_CURRENT_USER:setGuideStep(s_guide_step_selectGrade) 
    end


    onAndroidKeyPressed(self,function ( ... )
        s_CorePlayManager.enterHomeLayer()
    end,function ( ... )
        -- body
    end)
end


function EducationSelect:doguidStep()
    
    if s_CURRENT_USER.usertype ~= USER_TYPE_BIND then
        if s_CURRENT_USER.guideStep == 0 then
            s_CorePlayManager.enterGuideScene(1,self)
            s_CURRENT_USER:setGuideStep(s_guide_step_selectGrade) 
        end
    end
end




--弹出注册帐号的界面
function EducationSelect:popupAccountBind()
    if s_CURRENT_USER.tutorialStep > s_tutorial_book_select or s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then return end
    --
    local introLayer = RegisterAccountView.new(RegisterAccountView.STEP_10)
    s_SCENE:popup(introLayer)
    introLayer.close = handler(self,self.doguidStep)
end

return EducationSelect
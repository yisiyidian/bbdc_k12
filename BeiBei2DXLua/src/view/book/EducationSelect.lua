

IntroLayer = require("view.login.IntroLayer")
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
    if s_CURRENT_USER.k12SmallStep < s_K12_selectGrade then
        s_CURRENT_USER:setK12SmallStep(s_K12_selectGrade)
    end
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
    -- if have not selected any book
    if s_CURRENT_USER.bookKey == '' then 
        backBtn:setVisible(false)
        --黄色椭圆
        local tutorial_text = cc.Sprite:create('image/tutorial/tutorial_text.png')
        tutorial_text:setPosition((s_RIGHT_X - s_LEFT_X)/2, 1073)
        background:addChild(tutorial_text,120)
        --请选择合适你的书籍
        local text = cc.Label:createWithSystemFont(s_DataManager.getTextWithIndex(TEXT__TUTORIAL_BOOK_SELECT),'',28)
        text:setPosition(tutorial_text:getContentSize().width/2,tutorial_text:getContentSize().height/2)
        text:setColor(cc.c3b(0,0,0))
        tutorial_text:addChild(text)
    else
        backBtn:setVisible(true)
    end
    --进入选书界面
    local enterBookLayer = function (sender,eventType)
    	if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)   
        elseif eventType == ccui.TouchEventType.ended then
            s_CorePlayManager.enterBookLayer(sender:getName())
        end
    end

    local education = {'primary','junior','senior'}
    local titleArray = {'小学','初中','高中'}
    for i = 1,#education do
    	local bookBtn = ccui.Button:create('image/book/k12/K12_choose_book_'..education[i]..'_school_button.png','image/book/k12/K12_choose_book_'..education[i]..'_school_button_press.png')
    	bookBtn:setPosition((s_RIGHT_X - s_LEFT_X) / 2,s_DESIGN_HEIGHT / 2 + (2 - i) * 240 + 50)
    	background:addChild(bookBtn)
    	bookBtn:setName(education[i])

		local title = cc.Label:createWithSystemFont(titleArray[i],'',34)
        title:setPosition(bookBtn:getContentSize().width*0.35,bookBtn:getContentSize().height*0.4)
        bookBtn:addChild(title)   

        bookBtn:addTouchEventListener(enterBookLayer) 	
    end
    --弹出注册帐号
    --TODO 这块的流程太乱 需整理
    
    --如果是直接登陆的用户没有选书 则走else
    --如果是游客登录或者注册 就走if
    if s_CURRENT_USER.usertype ~= USER_TYPE_BIND then
        self:popupAccountBind()
    else
        s_SCENE:removeAllPopups()
    end
end


--弹出注册帐号的界面
function EducationSelect:popupAccountBind()
    if s_CURRENT_USER.tutorialStep > s_tutorial_book_select or s_CURRENT_USER.usertype ~= USER_TYPE_GUEST then return end
    --
    --这里修改为直接进登陆/注册界面
    -- local introLayer = IntroLayer.create()
    -- s_SCENE:popup(introLayer)
    -- 
    --直接进登陆了
    local layer = RegisterAccountView.new(RegisterAccountView.STEP_10)
    s_SCENE:popup(layer)
end

return EducationSelect
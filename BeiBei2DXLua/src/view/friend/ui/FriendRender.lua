-- 好友渲染器 
-- Author: whe
-- Date: 2015-06-04 16:38:20
--

local FriendRender = class("FriendRender", function()
	local layer = ccui.Layout:create()
	layer:setContentSize(640,160)
	return layer
end)

function FriendRender:ctor()
	self:initUI()
end

--初始化UI
function FriendRender:initUI()
	local scale = (s_RIGHT_X - s_LEFT_X) / s_DESIGN_WIDTH
	self.scale = scale
	local nameStr = "image/friend/friendRankButton.png"
	local button = ccui.Button:create(nameStr,nameStr,'')
    button:setScaleX(scale)
    button:ignoreAnchorPointForPosition(false)
    button:setAnchorPoint(0,0)
    button:setName("Title Button")
    button:setScale9Enabled(true)
    button:addTouchEventListener(handler(self, self.onBtnTouch))
    
    self.button = button
    self:addChild(button,1)

    local btnsize = button:getContentSize()

    --背景
    local back = cc.LayerColor:create(cc.c4b(208,212,215,255),s_RIGHT_X - s_LEFT_X,160 + 2)
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5,0.5)
    back:setPosition((s_RIGHT_X - s_LEFT_X) * 0.5, 160 * 0.5)
 	self:addChild(back,0)
 	--排名的icon
 	local rankIcon = cc.Sprite:create()
    rankIcon:setScaleX(1 / scale)
    rankIcon:setPosition(0.08 * 640,0.5 * 160)
    self.rankIcon = rankIcon
    rankIcon:setName('rankIcon')
    button:addChild(rankIcon)
    --头像
    local head = cc.Sprite:create()
    head:setScaleX(1 / scale * 0.8)
    head:setScaleY(0.8)
    head:setPosition(0.26 * 640,0.5 * 160)
    button:addChild(head)
    self.head = head

    local fri_name = cc.Label:createWithSystemFont("",'',32)
    fri_name:setScaleX(1 / scale)
    fri_name:setColor(cc.c3b(0,0,0))
    fri_name:ignoreAnchorPointForPosition(false)
    fri_name:setAnchorPoint(0,0)
    fri_name:setPosition(0.42 * btnsize.width,0.60 * btnsize.height)
    button:addChild(fri_name)
    self.fri_name = fri_name

    -- local fri_word = cc.Label:createWithSystemFont(string.format('已学单词总数：%d',self.array[i].wordsCount),'',24)
    --单词数
    local fri_process = cc.Label:createWithSystemFont('','',24)
    fri_process:setScaleX(1 / scale)
    fri_process:setColor(cc.c3b(150,153,156))
    fri_process:ignoreAnchorPointForPosition(false)
    fri_process:setAnchorPoint(0,1)
    fri_process:setPosition(0.42 * btnsize.width,0.52 * btnsize.height)
    self.fri_process = fri_process
    button:addChild(fri_process)
    --今日关卡
    local fri_guanka = cc.Label:createWithSystemFont('','',24)
    fri_guanka:setScaleX(1 / scale)
    fri_guanka:setColor(cc.c3b(150,153,156))
    fri_guanka:ignoreAnchorPointForPosition(false)
    fri_guanka:setAnchorPoint(0,1)
    fri_guanka:setPosition(0.42 * btnsize.width,0.30 * btnsize.height)
    self.fri_guanka = fri_guanka
    button:addChild(fri_guanka)
    --用时
    local fri_time = cc.Label:createWithSystemFont('','',24)
    fri_time:setScaleX(1 / scale)
    fri_time:setColor(cc.c3b(150,153,156))
    fri_time:ignoreAnchorPointForPosition(false)
    fri_time:setAnchorPoint(0,1)
    fri_time:setPosition(0.65 * btnsize.width,0.30 * btnsize.height)
    self.fri_time = fri_time
    button:addChild(fri_time)
    --班级名称
    local fri_grade = cc.Label:createWithSystemFont('','',24)
    fri_grade:setScaleX(1 / scale)
    fri_grade:setColor(cc.c3b(111,181,219))
    fri_grade:ignoreAnchorPointForPosition(false)
    fri_grade:setAnchorPoint(1,1)
    fri_grade:setPosition(0.80 * btnsize.width,0.75 * btnsize.height)
    self.fri_grade = fri_grade
    button:addChild(fri_grade)
end

--设置数据
function FriendRender:setData(data,index,callback)
	self.index = index
	self.data = data
	self.callback = callback
	self.button.index = index

	print("startTime"..tostring(self.data.startTime))
	print("usingTime"..tostring(self.data.usingTime))

	--前三名的特殊ICON
	local str = 'n'
    if index < 4 then
        str = string.format('%d',index)
    end
    --排名ICON
	self.rankIcon:setTexture(string.format('image/friend/fri_rank_%s.png',str))
	--排名文本
	local rankLabel = cc.Label:createWithSystemFont(string.format('%d',index),'',36)
    rankLabel:setPosition(self.rankIcon:getContentSize().width / 2,self.rankIcon:getContentSize().width / 2)
    rankLabel:setName("rankLabel")
    self.rankIcon:addChild(rankLabel)
    --头像
    local headimg = nil 
    if data.sex == 0 then
		headimg = "image/PersonalInfo/hj_personal_avatar.png"
    else
    	headimg = "image/PersonalInfo/boy_head.png"
    end
    self.head:setTexture(headimg)

    --如果是QQ登陆 或者是新的注册用户(手机注册并且启用nickName字段)
    local name = self.data.username
    if self.data.userType == USER_TYPE_QQ or self.data.nickName ~= "" then
        name = self.data.nickName
    end
    self.fri_name:setString(name)

    local ssecond = self.data.bossCountUpdate --时间
    local sbosscount = self.data.bossCount
    local tDate = os.date("%x", ssecond)          --最后登陆日期
    local tNow  = os.date("%x", os.time())        --当前日期
    if tDate ~= tNow then
        sbosscount = 1
    end


    local unitName = 'Unit '..s_BookUnitName[self.data.bookKey][''..tonumber(self.data.unitID) + 1]
    --已学单词数
    self.fri_process:setString(string.format('当前进度：%s',unitName))
    --今日关卡
    self.fri_guanka:setString(string.format("今日关卡：%d",sbosscount))
    --用时
	self.fri_time:setString(string.format("用时：%d分钟",math.ceil(self.data.usingTime/60000)))
	--班级
	self.fri_grade:setString(self.data.gradeName)
    --[[  --注释掉删除好友箭头
    if self.data.username ~= s_CURRENT_USER.username then
        local str = 'image/friend/fri_jiantouxia.png'
        local arrow = cc.Sprite:create(str)
        arrow:setScaleX(1 / self.scale)
        arrow:setPosition(0.9 * self.button:getContentSize().width,0.5 * self.button:getContentSize().height)
        self.button:addChild(arrow,0)
        arrow:setName("arrow")
    end
    ]]
end

function FriendRender:onBtnTouch(sender,eventType)
	if eventType ~= ccui.TouchEventType.ended then
		return
	end
	if self.callback ~= nil then
		self.callback(sender)
	end
end

return FriendRender
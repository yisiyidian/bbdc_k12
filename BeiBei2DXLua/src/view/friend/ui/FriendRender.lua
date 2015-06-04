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
    fri_name:setPosition(0.42 * button:getContentSize().width,0.52 * button:getContentSize().height)
    button:addChild(fri_name)
    self.fri_name = fri_name

    -- local fri_word = cc.Label:createWithSystemFont(string.format('已学单词总数：%d',self.array[i].wordsCount),'',24)
    local fri_word = cc.Label:createWithSystemFont('','',24)
    fri_word:setScaleX(1 / scale)
    fri_word:setColor(cc.c3b(0,0,0))
    fri_word:ignoreAnchorPointForPosition(false)
    fri_word:setAnchorPoint(0,1)
    fri_word:setPosition(0.42 * button:getContentSize().width,0.48 * button:getContentSize().height)
    self.fri_word = fri_word
    button:addChild(fri_word)
end

--设置数据
function FriendRender:setData(data,index,callback)
	self.index = index
	self.data = data
	self.callback = callback
	self.button.index = index
	dump(data)
	local str = 'n'
    if index < 4 then
        str = string.format('%d',index)
    end

	self.rankIcon:setTexture(string.format('image/friend/fri_rank_%s.png',str))

	local rankLabel = cc.Label:createWithSystemFont(string.format('%d',index),'',36)
    rankLabel:setPosition(self.rankIcon:getContentSize().width / 2,self.rankIcon:getContentSize().width / 2)
    self.rankIcon:addChild(rankLabel)
    local headimg = nil --头像
    if data.sex == 0 then
		headimg = "image/PersonalInfo/hj_personal_avatar.png"
    else
    	headimg = "image/PersonalInfo/boy_head.png"
    end
    self.head:setTexture(headimg)


    local name = self.data.username
        --如果是QQ登陆 或者是新的注册用户(手机注册并且启用nickName字段)
    if self.data.userType == USER_TYPE_QQ or self.data.nickName ~= "" then
        name = self.data.nickName
    end
    self.fri_name:setString(name)

    self.fri_word:setString(string.format('已学单词总数：%d',self.data.wordsCount))
    
    if self.data.username ~= s_CURRENT_USER.username then
        local str = 'image/friend/fri_jiantouxia.png'
        local arrow = cc.Sprite:create(str)
        arrow:setScaleX(1 / self.scale)
        arrow:setPosition(0.9 * self.button:getContentSize().width,0.5 * self.button:getContentSize().height)
        self.button:addChild(arrow,0)
        arrow:setName("arrow")
    end
end

--设置索引
function FriendRender:setIndex(index)
	
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
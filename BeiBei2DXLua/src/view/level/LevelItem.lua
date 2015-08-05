-- 以一屏为单位的Item，一般包含4关或5关
-- 用于添加到LevelListView中，可动态添加或删除Item(动态加载)

require("cocos.init")
require('common.global')

local LevelItem = class('LevelItem',function() 
    return ccui.Layout:create()
end)

--根据当前是第几屏来初始化UI
function LevelItem.create(screenId)
    local layer = LevelItem.new(screenId)
    return layer
end

-- 初始化LevelItem
function LevelItem:ctor(screenId)
	-- 记录该Item 的基本信息
	self.info = {}
	--print('screenId:'..screenId)
	self.info['screenId'] = screenId
	-- 初始化item的属性
	self:setContentSize(level_item_width,level_item_height)  
    --self:setName('screen'..screenId)  
    self:setAnchorPoint(0,0)

    local fullWidth = level_item_width
    self:setContentSize(fullWidth, s_DESIGN_HEIGHT) 
    --self:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))

	-- 初始化screen的关卡信息
	self.info['startLevelId'], self.info['endLevelId'] = self:getLevelIdRange()
	-- 更新UI
	self:initViewFromConfig(screenId)
	print('----------------------')
	print_lua_table(self.info)
	print('----------------------')
	--print(self.info['lock5'])
end

function LevelItem:refreshViewFromConfig(screenId)

end

-- 从配置初始化Item UI
function LevelItem:initViewFromConfig(screenId)
	if screenId - 1 == 0 then   -- 第一屏有4关的配置
		for k, v in pairs(s_screenConfig['1']) do 
			self:createObjectForResource(v)
		end
	else   -- 其他屏为5关的配置
		for k, v in pairs(s_screenConfig['2']) do 
			self:createObjectForResource(v)
		end
	end
end

-- 获取该Item存储的levelId 范围
function LevelItem:getLevelIdRange()
	--print('ID range:start max')
	local bookMaxLevelId = s_LocalDatabaseManager.getBookMaxUnitID(s_CURRENT_USER.bookKey) -- 从1开始
	--print('ID range:end max')
	local startLevelId, endLevelId
	if self.info['screenId'] - 1 == 0 then
		startLevelId = 1
		endLevelId = 4
	else
		startLevelId = (self.info['screenId'] - 1) * 5
		endLevelId = startLevelId + 4
	end
	if endLevelId > bookMaxLevelId then  -- 最后一关
		endLevelId = bookMaxLevelId
	end
	return startLevelId, endLevelId
end


-- 读取配置，为每个资源实例化对象
function LevelItem:createObjectForResource(config)
	local element
	local config_info = split(config, '\t')
	local location = split(config_info[3],'|')
	--print('config_info:'..config)
	-- 初始化element的属性
	if config_info[5] == 'decoration' then -- 装饰品，Sprite
		--print('Decoration')
		element = cc.Sprite:create(config_info[6])
		element:setName(config_info[1])
	elseif config_info[5] == 'cloud' then 
		return
	elseif config_info[5] == 'island' then -- 岛屿
		local function touchEvent1(sender,eventType) -- 点击已解锁岛屿响应事件
	        if eventType == ccui.TouchEventType.ended then
	            print('LevelItem:levelbutton '..sender:getName()..' touched...')                
	            self:addPopup(sender:getName()-1)
	        end
    	end
		local function touchEvent2(sender,eventType) -- 点击未解锁岛屿响应事件
	        if eventType == ccui.TouchEventType.ended then
	        	print('LevelItem:levelbutton '..sender:getName()..' touched...')        
                local levelId = sender:getName()
                local lockLayer = self:getChildByName(levelId)
                --print('-------------selfinfo--------------')
                --print_lua_table(self.info)
                --print('levelId:'..levelId)
                --print_lua_table(self.info['lock17'])
                local lock = self.info['lock'..levelId]
                --local lock = self:getChildByName('lock'..levelId)
                local action1 = cc.ScaleTo:create(0.12, 1.15, 0.85)
                local action2 = cc.ScaleTo:create(0.12, 0.85, 1.15)
                local action3 = cc.ScaleTo:create(0.12, 1.08, 0.92)
                local action4 = cc.ScaleTo:create(0.12, 0.92, 1.08)
                local action5 = cc.ScaleTo:create(0.12, 1.0, 1.0)
                local action6 = cc.Sequence:create(action1, action2, action3, action4, action5, nil)

                local l1 = cc.MoveBy:create(0.1, cc.p(10,0))
                local l2 = cc.MoveBy:create(0.1, cc.p(-20,0))
                local l3 = cc.MoveBy:create(0.1, cc.p(20,0))

                local l4 = cc.Repeat:create(cc.Sequence:create(l2, l3),3)
                local l5 = cc.MoveBy:create(0.1, cc.p(-10, 0))
                lock:runAction(cc.Sequence:create(l1,l4, l5,nil))
                lockLayer:runAction(action6)
            end
    	end

		-- 计算当前资源关的Id
		local level_info = split(config_info[1],'_')
		local levelId
		if self.info['screenId'] - 1 == 0 then
			levelId = tonumber(level_info[2])
		else
			levelId = tonumber(level_info[2]) + (self.info['screenId'] - 1) * 5 - 1 
		end 
		-- 当前这本书的活跃关Id
		local curLevelId = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey) -- 从1开始

		if levelId <= curLevelId then  -- 该关卡已经解锁
			element = ccui.Button:create(config_info[6],config[6],config[6])
			--添加关卡编号
			local number = ccui.TextBMFont:create()
            number:setFntFile('font/number_inclined.fnt')
            number:setString(levelId)
            --number:setScale(0.85)
            number:setPosition(element:getContentSize().width/2-5, element:getContentSize().height/2)
            element:addChild(number)
            element:setName(levelId)
            element:addTouchEventListener(touchEvent1)
		elseif levelId <= self.info['endLevelId'] then -- 该关卡尚未解锁
			element = ccui.Button:create(config_info[7],config[7],config[7])
			--element = ccui.Button:create('image/chapter/chapter0/lockisland2.png','image/chapter/chapter0/lockisland2.png','image/chapter/chapter0/lockisland2.png')
            element:setScale9Enabled(true)
            element:setName(levelId)
            print('LEVELID:'..levelId)
            self.info['lock'..levelId] = ccui.Scale9Sprite:create('image/chapter/chapter0/unit_lock.png')
            self.info['lock'..levelId]:setName('lock'..levelId)
            self.info['lock'..levelId]:setPosition(cc.p(tonumber(location[1])-10,tonumber(location[2])+3))
            self:addChild(self.info['lock'..levelId],100)
            print('lockName:'..self.info['lock'..levelId]:getName())
			local number = ccui.TextBMFont:create()
            number:setFntFile('font/number_brown.fnt')
            number:setString(levelId)
            --number:setScale(0.85)
            number:setPosition(self.info['lock'..levelId]:getContentSize().width/2, self.info['lock'..levelId]:getContentSize().height/2)
            self.info['lock'..levelId]:addChild(number)
            element:addTouchEventListener(touchEvent2)
			-- 添加锁和关卡编号
			-- local lock = cc.Sprite:create('image/chapter/chapter0/unit_lock.png')
   --          lock:setName('lock'..levelId)
   --          lock:setPosition(cc.p(tonumber(location[1]),tonumber(location[2])))
			-- local number1 = cc.Label:createWithSystemFont(''..levelId,'',35)
   --          number1:setPosition(lock:getContentSize().width/2, lock:getContentSize().height/2)
   --         -- number:setColor(cc.c3b(164, 125, 46))
			-- number1:setColor(cc.c3b(255,255,255))
   --          lock:addChild(number1,10)
   --          self:addChild(lock)
		else --已经完成该书籍的学习
			-- TODO something
			return
		end
		element:setScale9Enabled(true)

	end
	element:setPosition(cc.p(tonumber(location[1]),tonumber(location[2])))
	local anchor = split(config_info[2], '|')
	element:setAnchorPoint(cc.p(tonumber(anchor[1]),tonumber(anchor[2])))
   	self:addChild(element, tonumber(config_info[4]))
end

-- 添加某个关卡点击时的弹窗
-- levelIndex:关卡索引
-- playAnimation: 是否播放动画
function LevelItem:addPopup(levelId,playAnimation)
    print("LevelItem:addPopup(levelId,playAnimation)"..tostring(playAnimation))
    local LevelProgressPopup = require("view.islandPopup.LevelProgressPopup")
    local levelProgressPopup = LevelProgressPopup.create(levelId,playAnimation)
    s_SCENE:popup(levelProgressPopup)
end

-- 播放某个关卡解锁时的动画
-- levelKey: 关卡key
function LevelItem:plotUnlockLevelAnimation(levelId)
    --local levelIndex = string.sub(levelKey, 6)
    local lockSprite = self:getChildByName('lock'..levelId)
    local lockLayer = self:getChildByName(levelId)
    local action1 = cc.MoveBy:create(0.1, cc.p(-5,0))
    local action2 = cc.MoveBy:create(0.1, cc.p(10,0))
    local action3 = cc.MoveBy:create(0.1, cc.p(-10, 0))
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action3),2)
    local action5 = cc.MoveBy:create(0.1, cc.p(5,0))  
    local action6 = cc.FadeOut:create(0.1)
    local action = cc.Sequence:create(action1, action4, action5, action6, nil)
    if lockSprite ~= nil then
        lockSprite:runAction(action)
    end

    local action7 = cc.DelayTime:create(0.6)
    local action8 = cc.FadeOut:create(0.1)
    if lockLayer ~= nil then
        lockLayer:runAction(cc.Sequence:create(action7, action8))
    end
    if lockSprite ~= nil or lockLayer ~= nil then
        s_SCENE:callFuncWithDelay(0.7,function()
            self:plotDecorationOfLevel(levelIndex-0)
        end)
    end
end

return LevelItem
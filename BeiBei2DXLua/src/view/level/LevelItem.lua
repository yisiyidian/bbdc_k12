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
	self.info['screenId'] = screenId
	-- 初始化item的属性
	self:setContentSize(level_item_width,level_item_height)  
    self:setName('screen'..screenId)  
    self:setAnchorPoint(0.5,0)
    self:setPosition(cc.p((s_RIGHT_X-s_LEFT_X) / 2, 0))
	-- 初始化screen的关卡信息
	self.info['startLevelId'], self.info['endLevelId'] = self:getLevelIdRange()
	-- 初始化UI
	self:initUIFromConfig()
end


-- 从配置初始化Item UI
function LevelItem:initUIFromConfig()
	if self.info['screenId'] - 1 == 0 then   -- 第一屏有4关的配置
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
function levelItem:getLevelIdRange()
	local bookMaxLevelId = s_LocalDatabaseManager.getBookMaxUnitID(s_CURRENT_USER.bookKey) -- 从1开始
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
	-- 初始化element的属性
	if config_info[6] == 'decoration' then -- 装饰品，Sprite
		element = cc.Sprite:create(config_info[7])
		element:setName(config_info[1])
	elseif config_info[6] == 'island' then -- 岛屿
		local function touchEvent(sender,eventType) -- 点击岛屿响应事件
	        if eventType == ccui.TouchEventType.ended then
	            print('LevelItem:levelbutton '..sender:getName()..' touched...')                
	            --self:addPopup(sender:getName())
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
			element = ccui.Button:create(config_info[7],config[7],config[7])
		elseif levelId <= self.info['endLevelId'] then -- 该关卡尚未解锁
			element = ccui.Button:create(config_info[8],config[8],config[8])
		else --已经完成该书籍的学习
			-- TODO something
		end
		element:setScale9Enabled(true)
		element:addTouchEventListener(touchEvent)
		element:setName(config_info[1])
	end
	local location = split(config_info[3],'|')
	element:setPosition(cc.p(tonumber(location[1]),tonumber(location[2])))
	local anchor = split(config_inf[4], '|')
	element:setAnchorPoint(cc.p(tonumber(anchor[1]),tonumber(anchor[2])))
    self:addChild(element, tonumber(config_info[5]))
end


return LevelItem
-- 继承ScrollView, 实现关卡根据配置自动滚动的类
require("cocos.init")
require('common.global')

local LevelScrollView = class('LevelScrollView',function() 
    return ccui.ScrollView:create()
end)

function LevelScrollView.create()
	local layer = LevelScrollView.new()
	return layer
end

-- 初始化LevelScrollView
function LevelScrollView:ctor()
	-- 存储全局的一些信息
	self.info = {}
	self.scrollTopLock = false  -- 用于控制滚动到上方时是否添加新的LevelItem
	-- 记录当前书最多和当前screenID
	self.info['maxScreenId'] = self:getBookMaxScreenID()
	--self.info['activeScreenId'] = self:getBookActiveScreenID()
	self.info['activeScreenId'] = 3 -- test
	self.info['curScreenId'] = self.info['activeScreenId']  -- 记录当前显示在屏幕中的 cur screen Id
	-- 初始化添加当前Item 和 云层
	self:initScrollView()
	-- 初始化ScrollView属性
	self:setBounceEnabled(true)
    self:setTouchEnabled(true)
    self:setBackGroundImageScale9Enabled(true)
    self:addScrollListener()
    self:setContentSize(level_item_width, s_DESIGN_HEIGHT)
    self:setPosition(cc.p(0, 0))
    -- 添加底层的Bounce
    self:addBottomBounce()
end

-- 滚动时动态更新ScorllView
function LevelScrollView:refreshScrollView()
	
end

-- 初始化ScrollView的Items
function LevelScrollView:initScrollView()
	print('curScreenId:'..self.info['curScreenId'])
	local LevelItem = require('view.level.LevelItem')
    self.info['screen'..self.info['curScreenId']] = LevelItem.create(self.info['curScreenId'])
    self.info['screen'..self.info['curScreenId']]:setPosition(cc.p((s_DESIGN_WIDTH - level_item_width) / 2, 0))
    self:addChild(self.info['screen'..self.info['curScreenId']])
    local screenCount = 1
    if self.info['curScreenId'] == 1 then -- 第一屏
	    -- 判断当前屏下方是否显示下一屏
	    if self.info['curScreenId'] < self.info['maxScreenId'] then
	    	self.info['nextScreenId'] = self.info['curScreenId'] + 1
	    	self.info['screen'..self.info['nextScreenId']] = LevelItem.create(self.info['nextScreenId'])
	    	self.info['screen'..self.info['nextScreenId']]:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width) / 2, 0))
	    	self.info['screen'..self.info['curScreenId']]:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width) / 2, s_DESIGN_HEIGHT))
	    	self:addChild(self.info['screen'..self.info['curScreenId']])
	    	screenCount = 2
	    end
	else
		-- 添加上一屏
		self.info['preScreenId'] = self.info['curScreenId'] - 1
    	self.info['screen'..self.info['preScreenId']] = LevelItem.create(self.info['preScreenId'])
    	self.info['screen'..self.info['preScreenId']]:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width) / 2, s_DESIGN_HEIGHT))
    	self.info['screen'..self.info['curScreenId']]:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width) / 2, 0))
    	self:addChild(self.info['screen'..self.info['preScreenId']])
    	screenCount = 2
    	-- 判断当前屏下方是否显示下一屏 (每两屏一次云层)
	    if self.info['curScreenId'] < self.info['maxScreenId'] and self.info['curScreenId'] % 2 == 1 then
	    	self.info['nextScreenId'] = self.info['curScreenId'] + 1
	    	self.info['screen'..self.info['nextScreenId']] = LevelItem.create(self.info['nextScreenId'])
	    	self.info['screen'..self.info['nextScreenId']]:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width) / 2, 0))
	    	self.info['screen'..self.info['curScreenId']]:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width) / 2, s_DESIGN_HEIGHT))
	    	self.info['screen'..self.info['preScreenId']]:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width) / 2, 2*s_DESIGN_HEIGHT))
	    	self:addChild(self.info['screen'..self.info['nextScreenId']])
	    	screenCount = 3
	    end
	end
	self.info['screenCount'] = screenCount
	print('screenCount:'..screenCount)
    -- self.info['nextScreen'] = LevelItem.create(self.info['curScreenId']+1)
    -- self.info['nextScreen']:setPosition(cc.p((s_DESIGN_WIDTH - level_item_width) / 2, -s_DESIGN_HEIGHT))
    -- self:addChild(self.info['nextScreen'])
    -- self.info['nextScreen']:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width)/2, s_DESIGN_HEIGHT))
    self:setInnerContainerSize(cc.size(level_item_width, screenCount * s_DESIGN_HEIGHT))
    if screenCount == 2 then
		self:scrollToPercentVertical(100,0,false)
	else
		self:scrollToPercentVertical(100,0,false)
	end
end

-- 添加底层云层和下一个关卡的Bounce层 （云层每两屏出现一次）
function LevelScrollView:addBottomBounce()
	print('add bottom bounce:'..self.info['activeScreenId'])
	if (self.info['activeScreenId'] % 2 == 0 and self.info['activeScreenId'] < self.info['maxScreenId'])
		or (self.info['activeScreenId'] % 2 == 1 and self.info['activeScreenId'] + 1 < self.info['maxScreenId']) then  -- 存在云层后面的关卡
		-- local cloud1 = cc.Sprite:create('image/level/cloud_1.png')
		-- cloud1:setPosition(150, 0)
		-- self:addChild(cloud1,100)
		-- local cloud2 = cc.Sprite:create('image/level/cloud_2.png')
		-- cloud2:setPosition(400, 0)
		-- self:addChild(cloud2,100)
		-- local cloud3 = cc.Sprite:create('image/level/cloud_3.png')
		-- cloud3:setPosition(650, 0)
		-- self:addChild(cloud3,100)

		-- 添加云层显示
		for k, v in pairs(s_screenConfig['2']) do 
			self:createObjectForResource(v)
		end
		
		if self.info['activeScreenId'] % 2 == 0 then
			self.info['bottomScreenId'] = self.info['activeScreenId'] + 1
		else
			self.info['bottomScreenId'] = self.info['activeScreenId'] + 2
		end
		local LevelItem = require('view.level.LevelItem')
		local screenKey = 'screen'..self.info['bottomScreenId']
   		self.info[screenKey] = LevelItem.create(self.info['bottomScreenId'])
    	self.info[screenKey]:setPosition(cc.p((s_DESIGN_WIDTH - level_item_width) / 2, -s_DESIGN_HEIGHT))
    	self:addChild(self.info[screenKey])
	end
end

-- 根据当前书籍进度关卡所属的屏幕添加到scrollview中
function LevelScrollView:addCurScreen()
	local LevelItem = require('view.level.LevelItem')
	--print('curScreenID:'..self.info['curScreenId'])
    self.info['curScreen'] = LevelItem.create(self.info['curScreenId'])
    self.info['curScreen']:setPosition(cc.p((s_DESIGN_WIDTH - level_item_width) / 2, 0))
    self:addChild(self.info['curScreen'])

    self.info['nextScreen'] = LevelItem.create(self.info['curScreenId']+1)
    self.info['nextScreen']:setPosition(cc.p((s_DESIGN_WIDTH - level_item_width) / 2, -s_DESIGN_HEIGHT))
    self:addChild(self.info['nextScreen'])
    self.info['nextScreen']:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width)/2, s_DESIGN_HEIGHT))
    self:setInnerContainerSize(cc.size(level_item_width, 2 * s_DESIGN_HEIGHT))
end

-- 添加滚动监听函数（实现了资源的动态加载更新）
function LevelScrollView:addScrollListener()
	local function scrollViewEvent(sender, evenType)
	    if evenType == ccui.ScrollviewEventType.scrollToBottom then
	    	print('scroll to bottom')
	    elseif evenType == ccui.ScrollviewEventType.scrollToTop then
	    	print('scroll to top')
	    elseif evenType == ccui.ScrollviewEventType.scrolling then
	    	print('scrolling')
	    	if self.info['screenCount'] >= 3 then  -- 大于等于3屏才实施动态更新的逻辑
		    	-- 计算当前滚动到第几屏
		    	local innerPositionY = self:getInnerContainer():getPositionY()
		    	local innerHeight = self:getInnerContainer():getContentSize().height
		    	print('innerHeight:'..innerHeight..',positionY:'..innerPositionY)
		    	local realY = innerHeight - level_item_height + innerPositionY
		    	-- 四舍五入
		    	local offset = realY / level_item_height - math.floor(realY / level_item_height)
		    	local curScreenId
		    	if offset >= 0.5 then
		    		curScreenId = math.ceil(realY / level_item_height) + 1
		    	else 
		    		curScreenId = math.floor(realY / level_item_height) + 1
		    	end
		    	print('curScreenId:'..curScreenId..',realY:'..realY)
		    	if curScreenId == 2 then  -- 到达从上数第2个屏时，检查是否需要在第一屏前加载新的一屏
		    		if self.info['preScreenId'] ~= nil and self.info['preScreenId'] > 1 then -- top screen前还可以添加screen
				    	if not self.scrollTopLock then
				    		self.scrollTopLock = true
				    		local LevelItem = require('view.level.LevelItem')
				    		self.info['screenCount'] = self.info['screenCount'] + 1
							self.info['preScreenId'] = self.info['preScreenId'] - 1
					    	self.info['screen'..self.info['preScreenId']] = LevelItem.create(self.info['preScreenId'])
					    	self.info['screen'..self.info['preScreenId']]:setPosition(cc.p((s_DESIGN_WIDTH-level_item_width) / 2, (self.info['screenCount']-1)*s_DESIGN_HEIGHT))
					    	self:addChild(self.info['screen'..self.info['preScreenId']])

							self:setInnerContainerSize(cc.size(level_item_width, self.info['screenCount'] * s_DESIGN_HEIGHT))
							self:callFuncWithDelay(2.0, function()
			                    scrollTopLock = false
			                end)
						end
					end
				end
	    	end
	    end
	end
    self:addEventListener(scrollViewEvent)
end

-- 获取当前书籍当前进度的 active screen Id
function LevelScrollView:getBookActiveScreenID()
	local activeLevelId = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey) -- 从1开始
	local activeScreenId
	if activeLevelId <= 4 then  -- 第一屏只有4关（保证不被浮动层按钮挡住岛屿）
		activeScreenId = 1
	else  
		activeScreenId = 1 + math.ceil((curLevelId - 4) / 5)
	end
	return activeScreenId
end

-- 延时调用方法
function LevelScrollView:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end

-- 获取当前书籍最大的ScreenID
function LevelScrollView:getBookMaxScreenID()
	local bookMaxLevelId = s_LocalDatabaseManager.getBookMaxUnitID(s_CURRENT_USER.bookKey) -- 从1开始
	-- 这本书最多可能的Item数量（屏幕数量）
	local totalScreenCount
	if bookMaxLevelId <= 4 then
		totalScreenCount = 1
	else
		totalScreenCount = 1 + math.ceil((bookMaxLevelId - 4) / 5)
	end
	return totalScreenCount
end

-- 读取配置，为每个资源实例化对象
function LevelScrollView:createObjectForResource(config)
	local element
	local config_info = split(config, '\t')
	local location = split(config_info[3],'|')
	--print('config_info:'..config)
	-- 初始化element的属性
	if config_info[5] == 'cloud' then -- 云层
		--print('Decoration')
		element = cc.Sprite:create(config_info[6])
		element:setName(config_info[1])
		element:setPosition(cc.p(tonumber(location[1]),tonumber(location[2])))
		local anchor = split(config_info[2], '|')
		element:setAnchorPoint(cc.p(tonumber(anchor[1]),tonumber(anchor[2])))
	   	self:addChild(element, tonumber(config_info[4]))
	end
end

return LevelScrollView
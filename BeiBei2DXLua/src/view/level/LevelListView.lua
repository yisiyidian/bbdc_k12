-- 继承ListView, 实现关卡根据配置自动滚动的类
require("cocos.init")
require('common.global')

local LevelListView = class('LevelListView',function() 
    return ccui.ListView:create()
end)

function LevelListView.create()
    local layer = LevelListView.new()
    return layer
end

-- 初始化LevelListView
function LevelListView:ctor()
	-- 存储全局的一些信息
	self.info = {}
	-- 初始化活跃屏范围
	self.info['preScreenId'], self.info['curScreenId'], self.info['nextScreenId'] = self:getCurScreenIdRange()
    -- 初始化listview属性
    self:setDirection(ccui.ScrollViewDir.vertical)
    local function listViewEvent(sender, eventType)
    	print('touch listview')
        if eventType == ccui.ListViewEventType.ONSELECTEDITEM_START then
            print("select child index = ",sender:getCurSelectedIndex())
        end
    end
    self:setBounceEnabled(true)
    self:setTouchEnabled(true)
    self:setBackGroundImageScale9Enabled(true)
	self:addEventListener(listViewEvent)
    self:addScrollListener()  -- 监听函数
   	local fullWidth = level_item_width
    self:setContentSize(fullWidth, s_DESIGN_HEIGHT)
    self:setPosition(cc.p((s_DESIGN_WIDTH - fullWidth) / 2, 0))
   	--self:setAnchorPoint(0.5,0)
   	self:setContentSize(level_item_width, s_DESIGN_HEIGHT)
   	print('Active Screen :'..self.info['preScreenId']..','..self.info['curScreenId']..','..self.info['nextScreenId'])
    -- 锁定添加滚动Item
    self.info['levelItemLock'] = 0  -- 当为1时，不更新pre,cur,next，只更新item

    -- 添加活跃屏Item
    if self.info['preScreenId'] ~= self.info['curScreenId'] then -- 避免第一屏和当前屏重复
    	self:addLevelItem(self.info['preScreenId'],0)
    end
    self:addLevelItem(self.info['curScreenId'],0)
    if self.info['nextScreenId'] ~= self.info['curScreenId'] then  --避免最后一屏和当前屏重复
    	self:addLevelItem(self.info['nextScreenId'],0)
    end
    -- self:scrollToPercentVertical()
    --更新视图
    self:requestRefreshView()
    --self.info['levelItemLock'] = 0

end

-- 滚动到指定屏
-- @param screenId 
function LevelListView:scrollToScreen(screenId)
	if screenId < 1 or screenId > self.info['maxScreenId'] then  -- 不符合要求
		return 
	end
	-- 计算当前屏幕数量 2 or 3
	local currentScreenCount
	if self.info['preScreenId'] == self.info['curScreenId'] or self.info['curScreenId'] == self.info['nextScreenId'] then
		currentScreenCount = 2
	else
		currentScreenCount = 3
	end

end

-- 延时调用方法
function LevelListView:callFuncWithDelay(delay, func) 
    local delayAction = cc.DelayTime:create(delay)
    local callAction = cc.CallFunc:create(func)
    local sequence = cc.Sequence:create(delayAction, callAction)
    self:runAction(sequence)   
end

-- 更新内部滚动高度
function LevelListView:updateInnerContainerSize()
	print('========In function updateInnerContainerSize============')
	local items = self:getItems()
	local width = 0.0
	local height = 0.0
	for k, v in pairs(items) do
		width = v:getContentSize().width
		height = v:getContentSize().height + height
	end
	self:setInnerContainerSize(cc.size(width,height))
	--self:scrollToPercentVertical(45,0,false)
end

--添加滚动监听函数
-- 动态加载新屏的资源，删除旧屏资源
function LevelListView:addScrollListener()
	local function scrollViewEvent(sender, evenType)
	    if evenType == ccui.ScrollviewEventType.scrollToBottom then
	    	print('scroll to bottom')
	    elseif evenType == ccui.ScrollviewEventType.scrollToTop then
	    	print('scroll to top')
	    elseif evenType == ccui.ScrollviewEventType.scrolling then
	    	--print('scrolling')
	    	-- local curSelectedIndex = self:getCurSelectedIndex()
	    	--print('self:'..self.info['curScreenId']..',curSelected:'..curSelectedIndex)
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
	    	print('curScreenId:'..curScreenId..',self.cur:'..self.info['curScreenId']..','..'pre:'..self.info['preScreenId']..',next:'..self.info['nextScreenId'])
	    	print('levelItemLock:'..self.info['levelItemLock'])
	    	if self.info['curScreenId'] ~= curScreenId and self.info['levelItemLock'] ~= 1 then  -- 动态加载新屏资源，消除旧屏资源
	    		self.info['levelItemLock'] = 1
	    		print('########'..(self.info['curScreenId'] - curScreenId))
	    		-- if self.info['curScreenId'] - curScreenId == 1 then  -- 向上滚动
	    		-- 	self.info['curScreenId'] = curScreenId
	    		-- 	-- 尝试在头部添加新的Item
	    		-- 	self.info['preScreenId'] = curScreenId - 1
	    		-- 	if self.info['preScreenId'] >= 1 then -- 没有到达顶部
	    		-- 		self:addLevelItem(self.info['preScreenId'],1)
	    		-- 	else --到达顶部
	    		-- 		self.info['preScreenId'] = 1
	    		-- 	end
	    		-- 	-- 尝试删除尾部的item
		    	-- 	if self.info['nextScreenId'] == curScreenId + 2 then
		    	-- 		self.info['nextScreenId'] = curScreenId + 1
	    		-- 		self:callFuncWithDelay(0.2,function()
		    	-- 			self:removeLevelItem(0)
		    	-- 		end)
	    		-- 	end
	    			--更新视图
    				--self:requestRefreshView()
	    		if curScreenId - self.info['curScreenId'] == 1 then -- 向上滚动
	    			-- 尝试在尾部添加新的item
	    			self.info['curScreenId'] = curScreenId
	    			self.info['nextScreenId'] = curScreenId + 1
	    			print('add new item in bottom:'..self.info['curScreenId']..','..self.info['nextScreenId'])
	    			if self.info['nextScreenId'] <= self.info['maxScreenId'] then --没有到达尾部
	    				self:addLevelItem(self.info['nextScreenId'],0)
	    				--self:addLevelItem(4,0)
	    			else -- 到达尾部
	    				self.info['nextScreenId'] = self.info['maxScreenId']
	    			end

	    			-- -- 尝试删除头部旧的item
	    			-- if self.info['preScreenId'] == self.info['curScreenId'] - 2 then
	    			-- 	self:callFuncWithDelay(0.2,function()
	    			-- 	self:removeLevelItem(1)
	    			-- 	end)
	    			-- 	self.info['preScreenId'] = self.info['curScreenId'] - 1
	    			-- end
	 				--更新视图
    				--self:updateInnerContainerSize()
	    		end
	    		self:callFuncWithDelay(0.3,function()
	    			print('=======set item lock 0')
					self.info['levelItemLock'] = 0
	    		end)
	    		--self.info['levelItemLock'] = 0
	    	end
   			--print('Position:'..inner:getPositionX()..inner:getPositionY())

	    end
	end 
    self:addScrollViewEventListener(scrollViewEvent)
end


-- 添加新的LevelItem
-- @param topOrBottom 决定插入在头部或者插入尾部, top:1, bottom:0
function LevelListView:addLevelItem(screenId,topOrBottom)
	if topOrBottom == 1 then
		print('=====In function addLevelItem:screen'..screenId..'from top')
	else
		print('=====In function addLevelItem:screen'..screenId..'from bottom')
	end
	local LevelItem = require('view.level.LevelItem')
    local newItem = LevelItem.create(screenId)
   	if topOrBottom == 1 then
    	self:insertCustomItem(newItem, 0)
    elseif topOrBottom == 0 then
    	self:pushBackCustomItem(newItem)
    end
    --更新视图
    self:refreshView()
   	--self:updateInnerContainerSize()
end

--删除旧的LevelItem
-- @param topOrBottom 决定删除头部或者删除尾部, top:1, bottom:0
function LevelListView:removeLevelItem(topOrBottom)
	if topOrBottom == 1 then 
		print('=====In function removeLevelItem from top')
	else
		print('=====In function removeLevelItem from bottom')
	end
	if topOrBottom == 1 then -- 向下滚动，删除头部
		self:removeItem(0)
	else
		self:removeLastItem()
	end
	--更新视图
	self:refreshView()
	--self:updateInnerContainerSize()
end


-- 获取当前活跃屏幕的Id区间，如当前加载屏3-屏5的资源
-- 保证每次至多加载3屏的内容，滚动时会动态添加或删除非活跃区间屏
-- 从1 开始编码
function LevelListView:getCurScreenIdRange()
	local curLevelId = s_CURRENT_USER.levelInfo:getLevelInfo(s_CURRENT_USER.bookKey) -- 从1开始
	local bookMaxLevelId = s_LocalDatabaseManager.getBookMaxUnitID(s_CURRENT_USER.bookKey) -- 从1开始
	-- 这本书最多可能的Item数量（屏幕数量）
	local totalScreenCount
	if bookMaxLevelId <= 4 then
		totalScreenCount = 1
	else
		totalScreenCount = 1 + math.ceil((bookMaxLevelId - 4) / 5)
	end
	self.info['maxScreenId'] = totalScreenCount

	local preScreenId, curScreenId, nextScreenId  -- 至多三个连续活跃的screen id
	if curLevelId <= 4 then  -- 第一屏只有4关（保证不被浮动层按钮挡住岛屿）
		curScreenId = 1
	else  
		curScreenId = 1 + math.ceil((bookMaxLevelId - 4) / 5)
	end
	preScreenId = curScreenId - 1
	if preScreenId < 1 then
		preScreenId = 1
	end
	nextScreenId = curScreenId + 1
	if nextScreenId > totalScreenCount then
		nextScreenId = totalScreenCount
	end

	print('ActiveScreenId'..preScreenId..','..curScreenId..','..nextScreenId..','..totalScreenCount)
	return preScreenId,curScreenId,nextScreenId
end

return LevelListView
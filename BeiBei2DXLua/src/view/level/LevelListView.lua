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
	self.info['preScreenId'], self.info['curScreenId'], self.info['nextScreenId'] = getCurScreenIdRange()
    -- 初始化listview属性
    self:setDirection(ccui.ScrollViewDir.vertical)
    self:setBounceEnabled(true)
    self:setBackGroundImageScale9Enabled(true)
    self:addScrollViewEventListener(self:scrollViewEvent)
   	self:setPosition(cc.p(0, 0)) --位置
   	self:setContentSize(level_item_width, s_DESIGN_HEIGHT)
    -- 添加活跃屏Item
    if self.info['preScreenId'] ~= self.info['curScreenId'] then -- 避免第一屏和当前屏重复
    	self:addLevelItem(self.info['preScreenId'],0)
    end
    self:addLevelItem(self.info['curScreenId'],0)
    if self.info['nextScreenId'] ~= self.info['curScreenId'] then  --避免最后一屏和当前屏重复
    	self:addLevelItem(self.info['nextScreenId'],0)
    end
end


-- 添加新的LevelItem
-- @param topOrBottom 决定插入在头部或者插入尾部, top:1, bottom:0
function LevelListView:addLevelItem(screenId,topOrBottom)
	local LevelItem = require('view.level.LevelItem')
    local newItem = LevelItem.create(screenId)
   	if topOrBottom == 1 then
    	self:insertCustomItem(newItem, 0)
    elseif topOrBottom == 0 then
    	self:pushBackCustomItem(newItem)
    end
    --更新视图
    self:refreshView()
end

--删除旧的LevelItem
-- @param topOrBottom 决定删除头部或者删除尾部, top:1, bottom:0
function LevelListView:removeLevelItem(topOrBottom)
	if topOrBottom == 1 then -- 向下滚动，删除头部
		self:removeItem(0)
	else
		self:removeLastItem()
	end
	--更新视图
	self:refreshView()
end

-- 滚动事件的监听
-- 动态加载新屏的资源，删除旧屏资源
function LevelListView:scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.scrollToBottom then
        	print('scroll to bottom')
        elseif evenType == ccui.ScrollviewEventType.scrollToTop then
        	print('scroll to top')
        elseif evenType == ccui.ScrollviewEventType.scrolling then
        	print('scrolling')
        end
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
	return preScreenId,curScreenId,nextScreenId
return LevelListView
-- 关卡界面主界面
-- 添加浮动层，LevelListView等
require("cocos.init")
require('common.global')

local LevelLayer = class('LevelLayer',function() 
    return cc.Layer:create()
end)

function LevelLayer.create()
    local layer = LevelLayer.new()
    return layer
end

-- 初始化LevelLayer
function LevelLayer:ctor()
	-- 存储全局信息
	self.info = {}
	-- 初始化属性
	self:setAnchorPoint(0,0)
	self:setContentSize(level_item_width, s_DESIGN_HEIGHT)
	-- 创建关卡层
	self:createLevelView()
	-- 测试
	-- local LevelItem = require('view.level.LevelItem')
 --    local newItem = LevelItem.create(1)
 --    self:addChild(newItem,5)
end

-- 创建关卡层，关卡UI，逻辑
function LevelLayer:createLevelView()
	--local LevelListView = require('view.level.LevelListView')
	local LevelListView = require('view.level.LevelScrollView')
	self.info['levelListView'] = LevelListView.create()
    self:addChild(self.info['levelListView'])
end


return LevelLayer


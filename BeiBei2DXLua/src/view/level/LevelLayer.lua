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
	self:setAnchorPoint(0.5,0)
	-- 创建关卡层
	self:createLevelView()
end

-- 创建关卡层，关卡UI，逻辑
function LevelLayer:createLevelView()
	local LevelListView = require('view.level.LevelListView')
	self.info['levelListView'] = LevelListView.create()
    self:addChild(self.info['levelListView'])

end


return LevelLayer


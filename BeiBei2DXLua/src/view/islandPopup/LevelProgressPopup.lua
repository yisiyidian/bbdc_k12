local LevelProgressPopup = class ("LevelProgressPopup",
    function ()
    return cc.Layer:create()
end) 

local Button                = require("view.button.longButtonInStudy")
local ProgressBar           = require("view.islandPopup.ProgressBar")

function LevelProgressPopup.create(index)
    local layer = LevelProgressPopup.new(index)
    local islandIndex = tonumber(index) + 1
    layer.unit = s_LocalDatabaseManager.getUnitInfo(islandIndex)
    layer.wrongWordList = {}
    for i = 1 ,#layer.unit.wrongWordList do
        table.insert(layer.wrongWordList,layer.unit.wrongWordList[i])
    end
    print_lua_table(layer.unit)
    return layer
    
end




function LevelProgressPopup:ctor()

    --界面初始化
    --createPape()
    self:createSummary()

end

function LevelProgressPopup:createSummary()
    --local back = cc.LayerColor:create(cc.c4b(0,0,0,0), 545, 900)


    local background = cc.Sprite:create("image/islandPopup/subtask_bg.png")
    background:setPosition(s_DESIGN_WIDTH / 2,s_DESIGN_HEIGHT / 2 - 10)
    self:addChild(background)
    self.background = background

    
    --加入上部 绿色背景
    local background_green = cc.Sprite:create("image/boss_view/background_green.png")
    background_green:setPosition(0,background:getContentSize().height)
    background_green:ignoreAnchorPointForPosition(false)
    background_green:setAnchorPoint(0,1)
    background:setContentSize(background_green:getContentSize().width,background:getContentSize().height)
    background:addChild(background_green)

    

    --加入怪物
    local monsters = sp.SkeletonAnimation:create("image/boss_view/guaishou_special.json", "image/boss_view/guaishou_special.atlas")
    monsters:setPosition(background:getContentSize().width/2,background:getContentSize().height/2)
    background:addChild(monsters)
    monsters:addAnimation(0, 'animation', true)

    --加入任务提示
    local text = cc.Label:createWithSystemFont("任务目标： 打败这货","",30)
    text:setPosition(background:getContentSize().width/2,background:getContentSize().height * 0.25)
    text:setColor(cc.c4b(50,50,50,255))
    background:addChild(text)

    --加入按钮
    local go_button = Button.create("long","blue","GO") 
    go_button:setPosition(background:getContentSize().width * 0.5 - 2, background:getContentSize().height * 0.13)

    local function button_func(  )
        s_CorePlayManager.initTotalUnitPlay()
    end
    go_button.func = function ()
        button_func()
    end
    background:addChild(go_button)


    --加入title
    local title = cc.Label:createWithSystemFont("Unit1","",50)
    title:setPosition(background:getContentSize().width/2, background:getContentSize().height - 75)
    title:setColor(cc.c3b(255,255,255))
    background:addChild(title)

--[[
    local title2 = cc.Label:createWithSystemFont("good good study day day up", "",25)
    title2:setPosition(background:getContentSize().width/2, background:getContentSize().height - 150)
    title2:setColor(cc.c3b(255,255,255))
    background:addChild(title2)
]]--

    --点击开始
    local onTouchBegan = function(touch, event)
        return true  
    end

    --点击结束
    local onTouchEnded = function(touch, event)
        --获取点击的位置
        local location = self:convertToNodeSpace(touch:getLocation())
        --判断是否点击在弹出的方框内
        if not cc.rectContainsPoint(self.background:getBoundingBox(),location) then
            --是  移走
            local move = cc.MoveBy:create(0.3, cc.p(0, s_DESIGN_HEIGHT))
            local remove = cc.CallFunc:create(function() 
                s_SCENE:removeAllPopups()
            end)
            --执行动作
            self.background:runAction(cc.Sequence:create(move,remove))
        end
    end

    --监听函数
    local listener = cc.EventListenerTouchOneByOne:create()
    --不向下传递触摸
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    --获取响应事件
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self) 



      onAndroidKeyPressed(self, function ()
        local move = cc.EaseBackIn:create(cc.MoveTo:create(0.3, cc.p(s_DESIGN_WIDTH / 2, s_DESIGN_HEIGHT * 1.5)))
        local remove = cc.CallFunc:create(function() 
            s_SCENE:removeAllPopups()
        end)
        self.background:runAction(cc.Sequence:create(move,remove))
    end, function ()

    end)
end




return LevelProgressPopup
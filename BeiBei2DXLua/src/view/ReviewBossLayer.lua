require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local RBProgressBar = require("view.RBProgressBar")
local ReviewBossNode = require("view.ReviewBossNode")
local ReviewBossAlter = require("view.ReviewBossAlter")


local ReviewBossLayer = class("ReviewBossLayer", function ()
    return cc.Layer:create()
end)


function ReviewBossLayer.create()
    math.randomseed(os.time())
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()

    local layer = ReviewBossLayer.new()

    local back = cc.Sprite:create("image/reviewbossscene/background_fuxiboss_diyiguan.png")
    back:ignoreAnchorPointForPosition(false)
    back:setAnchorPoint(0.5, 0.5)
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(back)

    local rbProgressBar = RBProgressBar.create(#s_CorePlayManager.rbWordList)
    rbProgressBar:setPosition(s_DESIGN_WIDTH/2, 1040)
    layer:addChild(rbProgressBar)
    
    s_CorePlayManager.rbCurrentWord = s_CorePlayManager.dictionary[s_CorePlayManager.rbCurrentWordIndex]
    local wordMeaningBeTestedNow = cc.Label:createWithSystemFont(s_CorePlayManager.rbCurrentWord.wordMeaningSmall,"",40)
    wordMeaningBeTestedNow:setColor(cc.c4b(0,0,0,255))
    wordMeaningBeTestedNow:setPosition(size.width/2, size.height*0.8)
    layer:addChild(wordMeaningBeTestedNow)
    
    local rightIndex = {}
    local sprite_array = {}
    for i = 1, #s_CorePlayManager.rbWordList do 
        local tmp = {}
        local randomIndex = math.random(1, 3)
        rightIndex[i] = randomIndex
        for j = 1, 3 do
            local sprite = nil
            if j == randomIndex then
                sprite = ReviewBossNode.create(s_CorePlayManager.rbWordList[i])
            else
                sprite = ReviewBossNode.create(s_CorePlayManager.rbWordList[math.random(1,#s_CorePlayManager.rbWordList)])
            end
            sprite:setPosition(cc.p(200*j - 80, 936 - 260*i))
            sprite:setScale(0.8)
            layer:addChild(sprite)
            tmp[j] = sprite
        end
        sprite_array[i] = tmp
    end
    
    local checkTouchIndex = function(location)
        for i = 1, #s_CorePlayManager.rbWordList do
            for j = 1, 3 do
                local sprite = sprite_array[i][j]
                if cc.rectContainsPoint(sprite:getBoundingBox(), location) then
                    return {x=i, y=j}
                end
            end
        end
        return {x=-1, y=-1}
    end
    
    local onTouchBegan = function(touch, event)
        local location = layer:convertToNodeSpace(touch:getLocation())
        local logic_location = checkTouchIndex(location)
        
        print(logic_location.x, logic_location.y)
        
        if logic_location.x == s_CorePlayManager.rbCurrentWordIndex then
            rbProgressBar.addOne()
        
            if rightIndex[logic_location.x] == logic_location.y then
                sprite_array[logic_location.x][logic_location.y].right()
            else
                sprite_array[logic_location.x][logic_location.y].wrong()
            end
            
            if s_CorePlayManager.rbCurrentWordIndex < #s_CorePlayManager.rbWordList then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                for i = 1, #s_CorePlayManager.rbWordList do
                    for j = 1, 3 do
                        local sprite = sprite_array[i][j]
                        if i == s_CorePlayManager.rbCurrentWordIndex then
                            --layer:removeChild(sprite,true)
                            --sprite:setVisible(false)
                            local action1 = cc.MoveBy:create(0.5, cc.p(0,130))
                            local action2 = cc.ScaleTo:create(0.5, 0)
                            local action3 = cc.Spawn:create(action1, action2)
                            sprite:runAction(action3)
                        else
                            local action = cc.MoveBy:create(0.5, cc.p(0,260))
                            sprite:runAction(action)
                        end
                    end
                end
                
                local action1 = cc.DelayTime:create(0.5)
                local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action1, action2))
                
                s_CorePlayManager.rbCurrentWordIndex = s_CorePlayManager.rbCurrentWordIndex + 1
                s_CorePlayManager.rbCurrentWord = s_CorePlayManager.dictionary[s_CorePlayManager.rbCurrentWordIndex]
                wordMeaningBeTestedNow:setString(s_CorePlayManager.rbCurrentWord.wordMeaningSmall)
            else
                print("game over")
                --s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                local alter = ReviewBossAlter.create()
                alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                layer:addChild(alter)
            end            
        end
        
        return true
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    return layer
end

return ReviewBossLayer

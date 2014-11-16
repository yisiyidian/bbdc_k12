require("Cocos2d")
require("Cocos2dConstants")

require("common.global")

local RBProgressBar = require("view.reviewboss.RBProgressBar")
local ReviewBossNode = require("view.reviewboss.ReviewBossNode")
local ReviewBossAlter = require("view.reviewboss.ReviewBossAlter")


local ReviewBossLayer = class("ReviewBossLayer", function ()
    return cc.Layer:create()
end)


function ReviewBossLayer.create()
    math.randomseed(os.time())

    local layer = ReviewBossLayer.new()
    
    local fillColor1 = cc.LayerColor:create(cc.c4b(10,152,210,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 263)
    fillColor1:setAnchorPoint(0.5,0)
    fillColor1:ignoreAnchorPointForPosition(false)
    fillColor1:setPosition(s_DESIGN_WIDTH/2,0)
    layer:addChild(fillColor1)
    
    local fillColor2 = cc.LayerColor:create(cc.c4b(26,169,227,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 542-263)
    fillColor2:setAnchorPoint(0.5,0)
    fillColor2:ignoreAnchorPointForPosition(false)
    fillColor2:setPosition(s_DESIGN_WIDTH/2,263)
    layer:addChild(fillColor2)
    
    local fillColor3 = cc.LayerColor:create(cc.c4b(36,186,248,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, 776-542)
    fillColor3:setAnchorPoint(0.5,0)
    fillColor3:ignoreAnchorPointForPosition(false)
    fillColor3:setPosition(s_DESIGN_WIDTH/2,542)
    layer:addChild(fillColor3)
    
    local fillColor4 = cc.LayerColor:create(cc.c4b(213,243,255,255), s_DESIGN_WIDTH+2*s_DESIGN_OFFSET_WIDTH, s_DESIGN_HEIGHT-776)
    fillColor4:setAnchorPoint(0.5,0)
    fillColor4:ignoreAnchorPointForPosition(false)
    fillColor4:setPosition(s_DESIGN_WIDTH/2,776)
    layer:addChild(fillColor4)
    
    local back = sp.SkeletonAnimation:create("res/spine/fuxiboss_background.json", "res/spine/fuxiboss_background.atlas", 1)
    back:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    layer:addChild(back)      
    back:addAnimation(0, 'animation', true)

    local rbProgressBar = RBProgressBar.create(#s_CorePlayManager.rbWordList, "blue")
    rbProgressBar:setPosition(s_DESIGN_WIDTH/2, 1040)
    layer:addChild(rbProgressBar)
    
    local getRandomWordForRightWord = function(wordName)
        local currentWordIndex = nil
    	tmp = {}
    	for i = 1, #s_CorePlayManager.rbWordList do
            table.insert(tmp, s_CorePlayManager.rbWordList[i])
            if s_CorePlayManager.rbWordList[i] == wordName then
                currentWordIndex = i
            end
    	end
    	
    	table.remove(tmp, currentWordIndex)
    
    	local randomIndex = math.random(1, #tmp)
    	local word1 = tmp[randomIndex]
        table.remove(tmp, randomIndex)
        local randomIndex = math.random(1, #tmp)
        local word2 = tmp[randomIndex]
    	
        local rightIndex = math.random(1,1024)%3 + 1
        ans = {}
        ans[rightIndex] = wordName
        if rightIndex == 1 then
            ans[2] = word1
            ans[3] = word2
        elseif rightIndex == 2 then
            ans[3] = word1
            ans[1] = word2
        else
            ans[1] = word1
            ans[2] = word2
        end
    	return ans
    end

    local rbCurrentWordIndex = 1
    local wordToBeTested = {}
    local sprite_array = {}
    for i = 1, #s_CorePlayManager.rbWordList do
        table.insert(wordToBeTested, s_CorePlayManager.rbWordList[i])
        local words = getRandomWordForRightWord(s_CorePlayManager.rbWordList[i])
        local tmp = {}
        for j = 1, 3 do
            local sprite = ReviewBossNode.create(words[j])
            if i == 1 then
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 200 + 200*(j-1), 850 - 260*i - 260))
            else
                sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), 850 - 260*i - 260))
                sprite:setScale(0.8)
            end
            layer:addChild(sprite)
            tmp[j] = sprite
        end
        sprite_array[i] = tmp
    end
    
    local wordMeaningBeTestedNow = cc.Label:createWithSystemFont(s_WordPool[wordToBeTested[rbCurrentWordIndex]].wordMeaningSmall,"",40)
    wordMeaningBeTestedNow:setColor(cc.c4b(0,0,0,255))
    wordMeaningBeTestedNow:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT*0.8)
    layer:addChild(wordMeaningBeTestedNow)
    
    local checkTouchIndex = function(location)
        for i = 1, #wordToBeTested do
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
        
        if logic_location.x == rbCurrentWordIndex then
            if wordToBeTested[logic_location.x] == sprite_array[logic_location.x][logic_location.y].character then
                rbProgressBar.addOne()
                sprite_array[logic_location.x][logic_location.y].right()
            else
                sprite_array[logic_location.x][logic_location.y].wrong()
                
                table.insert(wordToBeTested, wordToBeTested[rbCurrentWordIndex])
                local words = getRandomWordForRightWord(wordToBeTested[#wordToBeTested])
                local index_x, index_y = sprite_array[#sprite_array][1]:getPosition()
                local tmp = {}
                for j = 1, 3 do
                    local sprite = ReviewBossNode.create(words[j])
                    sprite:setPosition(cc.p(s_DESIGN_WIDTH/2 - 160 + 160*(j-1), index_y - 260))
                    sprite:setScale(0.8)
                    layer:addChild(sprite)
                    tmp[j] = sprite
                end
                table.insert(sprite_array, tmp)
            end
            
            if rbCurrentWordIndex < #wordToBeTested then
                s_TOUCH_EVENT_BLOCK_LAYER.lockTouch()
                for i = 1, #wordToBeTested do
                    for j = 1, 3 do
                        local sprite = sprite_array[i][j]
                        if i == rbCurrentWordIndex-1 then
                            local action0 = cc.DelayTime:create(0.1)
                            local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,260))
                            local action2 = cc.ScaleTo:create(0.4, 0)
                            local action3 = cc.Spawn:create(action1, action2)
                            sprite:runAction(cc.Sequence:create(action0, action3))
                        elseif i == rbCurrentWordIndex then
                            local action0 = cc.DelayTime:create(0.1)
                            local action1 = cc.MoveBy:create(0.4, cc.p(80-40*j,260))
                            local action2 = cc.ScaleTo:create(0.4, 0.8)
                            local action3 = cc.Spawn:create(action1, action2)
                            sprite:runAction(cc.Sequence:create(action0, action3))
                        elseif i == rbCurrentWordIndex + 1 then
                            local action0 = cc.DelayTime:create(0.1)
                            local action1 = cc.MoveBy:create(0.4, cc.p(40*j-80,260))
                            local action2 = cc.ScaleTo:create(0.4, 1)
                            local action3 = cc.Spawn:create(action1, action2)
                            sprite:runAction(cc.Sequence:create(action0, action3))
                        else
                            local action0 = cc.DelayTime:create(0.1)
                            local action1 = cc.MoveBy:create(0.4, cc.p(0,260))
                            sprite:runAction(cc.Sequence:create(action0, action1))
                        end
                    end
                end
                
                local action1 = cc.DelayTime:create(0.5)
                local action2 = cc.CallFunc:create(s_SCENE.touchEventBlockLayer.unlockTouch)
                layer:runAction(cc.Sequence:create(action1, action2))
                
                rbCurrentWordIndex = rbCurrentWordIndex + 1
                wordMeaningBeTestedNow:setString(s_WordPool[wordToBeTested[rbCurrentWordIndex]].wordMeaningSmall)
            else
                rbCurrentWordIndex = rbCurrentWordIndex + 1
                s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
                
                local showAlter = function()
                    local alter = ReviewBossAlter.create()
                    alter:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
                    layer:addChild(alter)
                end
                
                local action1 = cc.DelayTime:create(0.5)
                local action2 = cc.CallFunc:create(showAlter)
                local action3 = cc.Sequence:create(action1,action2)
                layer:runAction(action3)
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

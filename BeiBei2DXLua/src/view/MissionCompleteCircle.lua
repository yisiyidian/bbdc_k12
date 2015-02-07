require("cocos.init")
require("common.global")

local MissionCompleteCircle = class('MissionCompleteCircle',function ()
	return cc.Layer:create()
end)

function MissionCompleteCircle.create()
	local layer = MissionCompleteCircle.new()
	return layer
end

function MissionCompleteCircle:ctor()
	s_SCENE.touchEventBlockLayer.lockTouch()
	local missionCount = s_LocalDatabaseManager:getTodayTotalTaskNum()
	local completeCount = missionCount - s_LocalDatabaseManager:getTodayRemainTaskNum() + 1

	local bigWidth = s_RIGHT_X - s_LEFT_X

	local background = cc.LayerColor:create(cc.c4b(126,239,255,255), s_RIGHT_X - s_LEFT_X, s_DESIGN_HEIGHT)
	background:ignoreAnchorPointForPosition(false)
	background:setAnchorPoint(0.5,0.5)
	background:setPosition(0.5 * s_DESIGN_WIDTH, 0.5 * s_DESIGN_HEIGHT)
	self:addChild(background)

	local backCircle = cc.Sprite:create('image/homescene/missionprogress/learning_process_finish_task_bg.png')
	backCircle:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
    self:addChild(backCircle,0,'back')

	local backProgress = cc.Sprite:create("image/homescene/missionprogress/white_circle_thick.png")
    backProgress:setColor(cc.c4b(170,217,230,0))
    backProgress:setOpacity(0)
    backProgress:setPosition(backCircle:getContentSize().width / 2 ,backCircle:getContentSize().height / 2 )
    backCircle:addChild(backProgress)

    background:setOpacity(0)
    background:runAction(cc.Sequence:create(cc.FadeIn:create(0.5)))
    backCircle:setOpacity(0)
    backCircle:runAction(cc.FadeIn:create(0.5))

    local back = {}
    for i = 1,missionCount do
        back[i] = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/white_circle_thick.png'))
        back[i]:setColor(cc.c4b(170,217,231,255 * 0.2 * (i % 3 + 1)))
        back[i]:setOpacity(255 * 0.2 * ((i - 1) % 3 + 1))
        back[i]:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        back[i]:setPercentage(100 / missionCount)
        back[i]:setRotation(360 * (i - 1) / missionCount)
        back[i]:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
        backProgress:addChild(back[i])
        back[i]:runAction(cc.FadeIn:create(0.5))
        
    end

    local circle_color = {cc.c3b(76,223,204),cc.c3b(36,168,217),cc.c3b(18,128,213)}
    
        if completeCount <= missionCount then
            for i = 1, completeCount + 1 do 
                local split_line = cc.Sprite:create('image/homescene/missionprogress/learning_process_finish_task_circle_interval_long.png')
                split_line:setAnchorPoint(0.5,- 87 / 161)
                split_line:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2)
                backProgress:addChild(split_line,1)
                split_line:setRotation(360 * (i - 1) / missionCount)
                
                if i > completeCount then
                	split_line:setRotation(360 * (i - 2) / missionCount)
                	--split_line:setVisible(false)
                	split_line:runAction(cc.Sequence:create(cc.FadeIn:create(0.5),cc.RotateBy:create(0.5,360 / missionCount)))
                else
                	split_line:setOpacity(0)
                	split_line:runAction(cc.FadeIn:create(0.5))
            	end
            end
        end

        for i = 1, completeCount do 
            local taskProgress = cc.ProgressTimer:create(cc.Sprite:create('image/homescene/missionprogress/white_circle_thick.png'))
            taskProgress:setColor(circle_color[(i - 1) % 3 + 1])
            taskProgress:setPosition(backProgress:getContentSize().width / 2 ,backProgress:getContentSize().height / 2 )
            taskProgress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
            taskProgress:setReverseDirection(false)
            taskProgress:setPercentage(i / missionCount * 100)
            if i < completeCount then
            	taskProgress:setOpacity(0)
            	taskProgress:runAction(cc.FadeIn:create(0.5))
            else
            	taskProgress:setPercentage(0)
            	local runProgress = cc.ProgressTo:create(0.5 ,100 / missionCount)
            	taskProgress:runAction(cc.Sequence:create(cc.FadeIn:create(0.5),runProgress,cc.CallFunc:create(function ()
            		local delayTime = 1.0
            		if completeCount == missionCount then
            			local final = cc.Sprite:create('image/homescene/missionprogress/learning_process_finish_task_put_tick.png')
            			final:setPosition(backCircle:getContentSize().width / 2 ,backCircle:getContentSize().height / 2 )
        				backCircle:addChild(final)
        				final:setOpacity(0)
        				final:runAction(cc.FadeIn:create(0.5))
        				delayTime = 1.5
            		end
          			s_SCENE.touchEventBlockLayer.unlockTouch()
            		background:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime),cc.FadeOut:create(0.5)))
            		backCircle:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime),cc.Spawn:create(cc.ScaleTo:create(0.5,0.1),cc.MoveBy:create(0.5,cc.p(-bigWidth / 2 + 40,s_DESIGN_HEIGHT / 2 - 40)))))
            	end,{})))
            end
            back[i]:addChild(taskProgress)

        end
    

	
end

return MissionCompleteCircle
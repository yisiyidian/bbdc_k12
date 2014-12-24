require("cocos.init")
require('common.global')

local BaseChapterLayer = class('BaseChapterLayer',function()
    return widget
end)

function BaseChapterLayer.create(chapterKey, startLevelKey, chapterLayerHeight)
    local layer = BaseChapterLayer.new(chapterKey, startLevelKey)
    layer:setContentSize(cc.size(s_MAX_WIDTH, chapterLayerHeight))
    return layer
end

function BaseChapterLayer:ctor(chapterKey, startLevelKey)
    self.ccbBaseChapterLayer = {}
    self.ccb = {}
    self.chapterKey = chapterKey
    self.startLevelKey = startLevelKey
    if self.chapterKey == 'chapter0' then
        local proxy = cc.CCBProxy:create()
        local contentNode = CCBReaderLoad('ccb/chapter1.ccbi',proxy,self.ccbBaseChapterLayer,self.ccb)
        self.ccbBaseChapterLayer['contentNode'] = contentNode
        self.ccbBaseChapterLayer['levelSet'] = contentNode:getChildByTag(5)
    elseif self.chapterKey == 'chapter1' then
        local proxy = cc.CCBProxy:create()
        local contentNode = CCBReaderLoad('ccb/chapter2.ccbi',proxy,self.ccbBaseChapterLayer,self.ccb)
        self.ccbBaseChapterLayer['contentNode'] = contentNode
        self.ccbBaseChapterLayer['levelSet'] = contentNode:getChildByTag(5)  
    elseif self.chapterKey == 'chapter2' then
        local proxy = cc.CCBProxy:create()
        local contentNode = CCBReaderLoad('ccb/chapter3.ccbi',proxy,self.ccbBaseChapterLayer,self.ccb)
        self.ccbBaseChapterLayer['contentNode'] = contentNode
        self.ccbBaseChapterLayer['levelSet'] = contentNode:getChildByTag(5)
    elseif self.chapterKey == 'chapter3' then
        self.ccb['chapter3'] = self.ccbRepeatLevelLayer
        local proxy = cc.CCBProxy:create()
        local contentNode = CCBReaderLoad('ccb/chapter3.ccbi',proxy,self.ccbBaseChapterLayer,self.ccb)
        self.ccbBaseChapterLayer['contentNode'] = contentNode
        self.ccbBaseChapterLayer['levelSet'] = contentNode:getChildByTag(5)
    end
    
    -- init level container name
    local levelContainerSet = self.ccbRepeatLevelLayer['levelSet']:getChildren()
    local key = self.startLevelKey
    for i = 1, #levelContainerSet do
        local containerName = 'level'..(string.sub(key,6)+i-1)..'Container'
        levelContainerSet[i]:setName(containerName)
    end
    self:setAnchorPoint(0,0)
    self:addChild(contentNode)

    -- level button touch event
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local levelKey = sender:getName()
            print('button clicked')
            self:onLevelButtonClicked(levelKey)
        end
    end

    -- replot levelbutton ui based on the configuration file
    local levelConfig = s_DATA_MANAGER.getLevels(s_CURRENT_USER.bookKey)
    for i = 1, #levelConfig do
        if levelConfig[i]['chapter_key'] == self.chapterKey then
            -- change button image
            local levelContainer = self.ccbRepeatLevelLayer['levelSet']:getChildByName(levelConfig[i]['level_key']..'Container')
            if levelContainer ~= nil then
                if string.format('%s',levelConfig[i]['type']) == '1' then
                    --TODO change chapter ui
                    local levelImageName = 'image/chapter_level/chapter3_level_button_unlock.png'
                    local levelButton = ccui.Button:create(levelImageName, levelImageName, levelImageName)
                    levelButton:setPosition(levelContainer:getPositionX(),levelContainer:getPositionY())
                    levelButton:setName(levelConfig[i]['level_key'])
                    levelButton:setScale9Enabled(true)
                    self:addChild(levelButton) 
                    levelButton:addTouchEventListener(touchEvent)  
                    if s_CURRENT_USER:getIsLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then
                        self:plotLevelDecoration(levelConfig[i]['level_key'])
                    else
                        local lockLayer = cc.Sprite:create('image/chapter_level/chapter3_level_button_lock.png')
                        lockLayer:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2)
                        lockLayer:setName('lockLayer'..string.sub(levelButton:getName(),6))
                        levelButton:addChild(lockLayer)
                        levelButton:setScale9Enabled(true)

                        local lockSprite = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_locked_zongjieboss.png')
                        lockSprite:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2)
                        lockSprite:setName('lockSprite'..string.sub(levelButton:getName(),6))
                        levelButton:addChild(lockSprite)
                    end
                else   
                    local levelImageName = 'image/chapter_level/chapter3_level_button_unlock.png'
                    local levelButton = ccui.Button:create(levelImageName, levelImageName, levelImageName) 
                    levelButton:setPosition(levelContainer:getPositionX(),levelContainer:getPositionY())
                    levelButton:setName(levelConfig[i]['level_key'])
                    self:addChild(levelButton)   
                    levelButton:addTouchEventListener(touchEvent)            
                    if  s_CURRENT_USER:getIsLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then  
                        self:plotLevelDecoration(levelConfig[i]['level_key'])
                    else       
                        local lockLayer = cc.Sprite:create('image/chapter_level/chapter3_level_button_lock.png')
                        lockLayer:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2)
                        levelButton:addChild(lockLayer)
                        lockLayer:setName('lockLayer'..string.sub(levelButton:getName(),6))

                        local lockSprite = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_locked_Lock.png')
                        lockSprite:setPosition(levelButton:getContentSize().width/2, levelButton:getContentSize().height/2)
                        lockSprite:setName('lockSprite'..string.sub(levelButton:getName(), 6))
                        levelButton:addChild(lockSprite)               
                    end
                end
                self:plotLevelNumber(levelConfig[i]['level_key'])
            end
        end  
    end

    -- register touch event
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function BaseChapterLayer:plotLevelStar(levelButton, heart)
    local star1, star2, star3
    if heart >= 3 then
        star1 = cc.Sprite:create('image/chapter_level/starFull.png')
        star2 = cc.Sprite:create('image/chapter_level/starFull.png')
        star3 = cc.Sprite:create('image/chapter_level/starFull.png')
    elseif heart == 2 then
        star1 = cc.Sprite:create('image/chapter_level/starFull.png')
        star2 = cc.Sprite:create('image/chapter_level/starFull.png')
        star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
    elseif heart == 1 then
        star1 = cc.Sprite:create('image/chapter_level/starFull.png')
        star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
    else
        star1 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
    end
    star1:setPosition(30,30)
    star2:setPosition(80,10)
    star3:setPosition(130,30)
    levelButton:addChild(star1, 5)
    levelButton:addChild(star2, 5)
    levelButton:addChild(star3, 5)
end

function BaseChapterLayer:plotStarAnimation(levelKey, starCount)
    local levelButton = self:getChildByName(levelKey)
    local levelConfig = s_DATA_MANAGER.getLevelConfig(s_CURRENT_USER.bookKey,self.chapterKey,levelKey)
    if levelConfig['type'] == 0 then
        local star1, star2, star3
        if starCount >= 3 then
            star1 = cc.Sprite:create('image/chapter_level/starFull.png')
            star2 = cc.Sprite:create('image/chapter_level/starFull.png')
            star3 = cc.Sprite:create('image/chapter_level/starFull.png')
        elseif starCount == 2 then
            star1 = cc.Sprite:create('image/chapter_level/starFull.png')
            star2 = cc.Sprite:create('image/chapter_level/starFull.png')
            star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        elseif starCount == 1 then
            star1 = cc.Sprite:create('image/chapter_level/starFull.png')
            star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
            star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        else
            star1 = cc.Sprite:create('image/chapter_level/starEmpty.png')
            star2 = cc.Sprite:create('image/chapter_level/starEmpty.png')
            star3 = cc.Sprite:create('image/chapter_level/starEmpty.png')
        end
        star1:setPosition(30,30)
        star2:setPosition(80,10)
        star3:setPosition(130,30)
        star1:setScale(2)
        star2:setScale(2)
        star3:setScale(2)

        levelButton:addChild(star1, 5)
        levelButton:addChild(star2, 5)
        levelButton:addChild(star3, 5)
        star1:setVisible(false)
        star2:setVisible(false)
        star3:setVisible(false)

        s_SCENE:callFuncWithDelay(0.3,function()
            star1:setVisible(true)
            local action = cc.ScaleTo:create(0.4, 1.0)
            star1:runAction(action)
            --            -- star sound
            --            if starCount >= 1 then
            --                playSound(s_sound_star1)
            --            end
        end)
        s_SCENE:callFuncWithDelay(0.6,function()
            star2:setVisible(true)
            local action = cc.ScaleTo:create(0.4, 1.0)
            star2:runAction(action)
            --            --star sound
            --            if starCount >= 2 then
            --                playSound(s_sound_star2)
            --            end
        end)
        s_SCENE:callFuncWithDelay(0.9,function()
            star3:setVisible(true)
            local action = cc.ScaleTo:create(0.4, 1.0)
            star3:runAction(action)
            --            --star sound
            --            if starCount >= 3 then
            --                playSound(s_sound_star3)
            --            end
        end)
    end
end

function BaseChapterLayer:plotUnlockLevelAnimation(levelKey)
    local levelIndex = string.sub(levelKey, 6)
    local levelButton = self:getChildByName(levelKey)
    local lockSprite = levelButton:getChildByName('lockSprite'..levelIndex)
    local lockLayer = levelButton:getChildByName('lockLayer'..levelIndex)

    local action1 = cc.MoveBy:create(0.1, cc.p(-5,0))
    local action2 = cc.MoveBy:create(0.1, cc.p(10,0))
    local action3 = cc.MoveBy:create(0.1, cc.p(-10, 0))
    local action4 = cc.Repeat:create(cc.Sequence:create(action2, action3),4)
    local action5 = cc.MoveBy:create(0.1, cc.p(5,0))  
    local action6 = cc.FadeOut:create(0.1)
    local action = cc.Sequence:create(action1, action4, action5, action6, nil)
    lockSprite:runAction(action)

    local action7 = cc.DelayTime:create(0.6)
    local action8 = cc.FadeOut:create(0.1)
    lockLayer:runAction(cc.Sequence:create(action7, action8))

    s_SCENE:callFuncWithDelay(1.1,function()
        self:plotLevelDecoration(levelKey)
    end)
end

return BaseChapterLayer
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
    
    elseif self.chapterKey == 'chapter1' then
    
    elseif self.chapterKey == 'chapter2' then
    
    elseif self.chapterKey == 'chapter3' then
        self.ccb['chapter3'] = self.ccbRepeatLevelLayer
        local proxy = cc.CCBProxy:create()
        local contentNode = CCBReaderLoad('ccb/chapter3.ccbi',proxy,self.ccbRepeatLevelLayer,self.ccb)
        self.ccbRepeatLevelLayer['contentNode'] = contentNode
        self.ccbRepeatLevelLayer['levelSet'] = contentNode:getChildByTag(5)
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

return BaseChapterLayer
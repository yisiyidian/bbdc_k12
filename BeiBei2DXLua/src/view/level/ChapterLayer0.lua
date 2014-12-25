local BaseChapterLayer = require('view.level.BaseChapterLayer')

local s_chapterKey = 'chapter0'
local s_startLevelKey = 'level0'
local s_layerHeight = 2527

local ChapterLayer0 = class("ChapterLayer0",function()
    return BaseChapterLayer.create(s_chapterKey, s_startLevelKey, s_layerHeight)
end)

function ChapterLayer0.create()
    local layer = ChapterLayer0.new()
    return layer
end

function ChapterLayer0:ctor()
    -- TODO replotUI
    -- replot levelbutton ui based on the configuration file
    local levelConfig = s_DATA_MANAGER.getLevels(s_CURRENT_USER.bookKey)
    for i = 1, #levelConfig do
        if levelConfig[i]['chapter_key'] == 'chapter0' then
            -- change button image
            local levelContainer = self.ccbLevelLayerI['levelSet']:getChildByName(levelConfig[i]['level_key']..'Container')
            if string.format('%s',levelConfig[i]['type']) == '1' then
                local levelImageName = 'ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_unlocked.png'
                local levelButton = ccui.Button:create(levelImageName, levelImageName, levelImageName)
                levelButton:setPosition(levelContainer:getPositionX(),levelContainer:getPositionY())
                levelButton:setName(levelConfig[i]['level_key'])
                levelButton:setScale9Enabled(true)
                self:addChild(levelButton) 
                levelButton:addTouchEventListener(touchEvent)  
                if s_CURRENT_USER:getIsLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then
                    self:plotLevelDecoration(levelConfig[i]['level_key'])
                else
                    local lockLayer = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_locked.png')
                    lockLayer:setPosition(levelButton:getContentSize().width/2 - 11, levelButton:getContentSize().height/2 + 5)
                    lockLayer:setName('lockLayer'..string.sub(levelButton:getName(),6))
                    levelButton:addChild(lockLayer)
                    levelButton:setScale9Enabled(true)

                    local lockSprite = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_locked_zongjieboss.png')
                    lockSprite:setPosition(levelButton:getContentSize().width/2 - 11, levelButton:getContentSize().height/2 + 5)
                    lockSprite:setName('lockSprite'..string.sub(levelButton:getName(),6))
                    levelButton:addChild(lockSprite)
                end
            else   
                local levelImageName = 'ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_unlocked.png'
                local levelButton = ccui.Button:create(levelImageName, levelImageName, levelImageName) 
                levelButton:setPosition(levelContainer:getPositionX(),levelContainer:getPositionY())
                levelButton:setName(levelConfig[i]['level_key'])
                self:addChild(levelButton)   
                levelButton:addTouchEventListener(touchEvent)            
                if  s_CURRENT_USER:getIsLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then  
                    self:plotLevelDecoration(levelConfig[i]['level_key'])
                else       
                    local lockLayer = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_locked.png')
                    lockLayer:setPosition(levelButton:getContentSize().width/2 - 10, levelButton:getContentSize().height/2 + 4)
                    levelButton:addChild(lockLayer)
                    lockLayer:setName('lockLayer'..string.sub(levelButton:getName(),6))

                    local lockSprite = cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_locked_Lock.png')
                    lockSprite:setPosition(levelButton:getContentSize().width/2 - 10, levelButton:getContentSize().height/2 + 4)
                    lockSprite:setName('lockSprite'..string.sub(levelButton:getName(), 6))
                    levelButton:addChild(lockSprite)               
                end
            end
            self:plotLevelNumber(levelConfig[i]['level_key'])
        end  
    end
end


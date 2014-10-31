require('Cocos2d')
require('Cocos2dConstants')
require('common.global')
require('CCBReaderLoad')

local LevelLayerI = class('LevelLayerI', function()
    return cc.Layer:create()
end)

function LevelLayerI.create()
    local layer = LevelLayerI.new()
    return layer
end

function isLevelUnlocked(chapterKey, levelKey) 
    for i = 1, #s_CURRENT_USER.levels do
        if s_CURRENT_USER.levels[i].chapterKey == chapterKey and s_CURRENT_USER.levels[i].levelKey == levelKey then
            if s_CURRENT_USER.levels[i].isLevelUnlocked then
                return true
            else
                return false
            end
        end
    end
end

function LevelLayerI:ctor()
    self.ccbLevelLayerI = {}
    self.ccbLevelLayerI['onLevelButtonClicked'] = self.onLevelButtonClicked
    self.ccb = {}
    self.ccb['chapter1'] = self.ccbLevelLayerI
    
    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/chapter1.ccbi',proxy,self.ccbLevelLayerI,self.ccb)
    self.ccbLevelLayerI['levelSet'] = contentNode:getChildByTag(5)
    for i = 1, #self.ccbLevelLayerI['levelSet']:getChildren() do
        self.ccbLevelLayerI['levelSet']:getChildren()[i]:setName('level'..(self.ccbLevelLayerI['levelSet']:getChildren()[i]:getTag()-1))
    end
    self:setContentSize(contentNode:getContentSize())
    self:addChild(contentNode)
    
    -- replot levelbutton ui based on the configuration file
    local levelConfig = s_DATA_MANAGER.level_ncee

    for i = 1, #levelConfig do
        if levelConfig[i]['chapter_key'] == 'Chapter0' then
            s_logd('%s, %s, %s',levelConfig[i]['chapter_key'],levelConfig[i]['type'],levelConfig[i]['level_key'])
            local levelButton = self.ccbLevelLayerI['levelSet']:getChildByName(levelConfig[i]['level_key'])
            if string.format('%s',levelConfig[i]['type']) == '1' then
                if isLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then
                    levelButton:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_unlocked.png'))
                    levelButton:setSelectedImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_unlocked.png'))
                else
                    levelButton:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_locked.png'))
                    levelButton:setSelectedImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_locked.png'))
                end
            else 
                if not isLevelUnlocked(levelConfig[i]['chapter_key'],levelConfig[i]['level_key']) then
                    levelButton:setNormalImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_locked.png')) 
                    levelButton:setSelectedImage(cc.Sprite:create('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_level_locked.png')) 
                end
            end
        end
    end
end

function LevelLayerI:onLevelButtonClicked()
    s_logd('on LevelButtonClicked')
end

return LevelLayerI
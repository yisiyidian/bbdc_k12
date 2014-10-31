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

function LevelLayerI:ctor()
    self.ccbLevelLayerI = {}
    self.ccbLevelLayerI['onLevelButtonClicked'] = self.onLevelButtonClicked
    self.ccb = {}
    self.ccb['chapter1'] = self.ccbLevelLayerI
    
    local proxy = cc.CCBProxy:create()
    local contentNode = CCBReaderLoad('ccb/chapter1.ccbi',proxy,self.ccbLevelLayerI,self.ccb)
    self.ccbLevelLayerI['levelSet'] = contentNode:getChildByTag(5)
    for i = 1, #self.ccbLevelLayerI['levelSet']:getChildren() do
        self.ccbLevelLayerI['levelSet']:getChildren()[i]:setName('level'..self.ccbLevelLayerI['levelSet']:getChildren()[i]:getTag())
    end
    self:setContentSize(contentNode:getContentSize())
    self:addChild(contentNode)
    
    -- replot levelbutton ui based on the configuration file
    local levelConfig = s_DATA_MANAGER.level_ncee;
    for i = 1, #levelConfig do
        if levelConfig[i]['chapter_key'] == 'Chapter0' then
            if levelConfig[i]['type'] == '1' then
                local levelButton = self.ccbLevelLayerI['levelSet']:getChildByName(levelConfig[i]['level_key'])
                levelButton:setNormalImage('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_unlocked.png')
                cc.MenuItemImage:setSelectedImage('ccb/ccbResources/chapter_level/button_xuanxiaoguan1_bosslevel_unlocked.png')
            end
            s_logd('%s, %s, %s',levelConfig[i]['chapter_key'],levelConfig[i]['type'],levelConfig[i]['level_key'])
        end
    end
end

function LevelLayerI:onLevelButtonClicked()
    s_logd('on LevelButtonClicked')
end

return LevelLayerI
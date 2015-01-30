require("cocos.init")
require("common.global")

local BackLayer         = require("view.newstudy.NewStudyBackLayer")
local SoundMark         = require("view.newstudy.NewStudySoundMark")
local FlipMat           = require("view.mat.FlipMat")
local GuideAlter        = require("view.newstudy.NewStudyGuideAlter")
local LastWordAndTotalNumber= require("view.newstudy.LastWordAndTotalNumberTip") 
local CollectUnfamiliar = require("view.newstudy.CollectUnfamiliarLayer")

local  SlideCoconutLayer = class("SlideCoconutLayer", function ()
    return cc.Layer:create()
end)

function SlideCoconutLayer.create()
    local layer = SlideCoconutLayer.new()
    s_TOUCH_EVENT_BLOCK_LAYER.unlockTouch()
    return layer
end

local function createRefreshButton()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local click_refresh_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            mat.forceFail()
        end
    end

    local refreshButton = ccui.Button:create("image/newstudy/refreshbegin.png","image/newstudy/refreshend.png","")
    refreshButton:setPosition(bigWidth * 0.9, 800)
    refreshButton:addTouchEventListener(click_refresh_button)
    return refreshButton  
end

local function createLastButton()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local click_before_button = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            playSound(s_sound_buttonEffect)        
        elseif eventType == ccui.TouchEventType.ended then
            print("last")
        end
    end

    local choose_before_button = ccui.Button:create("image/newstudy/button_twobutton_size.png","image/newstudy/button_twobutton_size_pressed.png","")
    choose_before_button:setPosition(bigWidth/2, 153)
    choose_before_button:setTitleText("偷看一眼")
    choose_before_button:setTitleColor(cc.c4b(255,255,255,255))
    choose_before_button:setTitleFontSize(32)
    choose_before_button:addTouchEventListener(click_before_button)
    return choose_before_button  
end

function SlideCoconutLayer:ctor()
    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH

    local backColor = BackLayer.create(97) 
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    self:addChild(backColor)
    
    self.currentWord = "apple"
    self.currentList = {"apple","banana","cat","dog","egg","floor"}

    self.wordInfo = CollectUnfamiliar:createWordInfo(self.currentWord)
    self.randWord = CollectUnfamiliar:createRandWord(self.currentWord,self.currentList)
    
    self.lastWordAndTotalNumber = LastWordAndTotalNumber.create()
    backColor:addChild(self.lastWordAndTotalNumber,1)
    self.lastWordAndTotalNumber.setNumber(9999)
    self.lastWordAndTotalNumber.setWord("apple",true)
    
    local word_meaning_label = cc.Label:createWithSystemFont(self.wordInfo[5],"",50)
    word_meaning_label:setPosition(bigWidth/2, 950)
    word_meaning_label:setColor(cc.c4b(31,68,102,255))
    backColor:addChild(word_meaning_label)
    
    local size_big = backColor:getContentSize()
    mat = FlipMat.create(self.wordInfo[2],4,4,false,"coconut_light")
    mat:setPosition(size_big.width/2, 160)
    backColor:addChild(mat)
    
    local success = function()
        playWordSound(self.currentWord) 
        print("success")
    end
    
    mat.success = success
    mat.rightLock = true
    mat.wrongLock = false
    
    self.refreshButton = createRefreshButton()
    backColor:addChild(self.refreshButton)
    
    self.lastButton = createLastButton()
    backColor:addChild(self.lastButton)
end

return SlideCoconutLayer
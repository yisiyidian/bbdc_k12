require("cocos.init")
require("common.global")

local DownloadLayer = class("DownloadLayer", function()
    return cc.Layer:create()
end)

function DownloadLayer.create(bookKey)
    local bookImageName = "image/download/big_"..string.upper(bookKey)..".png"

    local layer = DownloadLayer.new()

    local bigWidth = s_DESIGN_WIDTH + 2*s_DESIGN_OFFSET_WIDTH
    local backColor = cc.LayerColor:create(cc.c4b(197,219,208,255), bigWidth, s_DESIGN_HEIGHT)  
    backColor:setAnchorPoint(0.5,0.5)
    backColor:ignoreAnchorPointForPosition(false)  
    backColor:setPosition(s_DESIGN_WIDTH/2,s_DESIGN_HEIGHT/2)
    layer:addChild(backColor)
    
    local shelf = cc.Sprite:create('image/book/bookshelf_choose_book_button.png')
    shelf:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
    backColor:addChild(shelf)

    local girl = cc.Sprite:create('image/download/choose_book_girl.png')
    girl:setPosition(bigWidth/2+80, s_DESIGN_HEIGHT/2+400)
    backColor:addChild(girl)
    
    local book = cc.Sprite:create(bookImageName)
    book:setAnchorPoint(0.5,0)
    book:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2+20)
    backColor:addChild(book)

    local label_hint = cc.Label:createWithSystemFont("单词量: ","",30)
    label_hint:setPosition(bigWidth/2-50, s_DESIGN_HEIGHT/2+70)
    label_hint:setColor(cc.c4b(0,0,0,255))
    backColor:addChild(label_hint)

    local label_num = cc.Label:createWithSystemFont(s_DATA_MANAGER.books[bookKey].words,"",30)
    label_num:setPosition(bigWidth/2+40, s_DESIGN_HEIGHT/2+70)
    backColor:addChild(label_num)
    
    
    local button_back_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            
            s_CorePlayManager.enterBookLayer()
        end
    end
    
    local button_back = ccui.Button:create("image/download/choose_book_back.png","image/download/choose_book_back_click.png","")
    button_back:setPosition(bigWidth/2-238, 1073)
    button_back:addTouchEventListener(button_back_clicked)
    backColor:addChild(button_back)
    
    local button_choose_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
           if s_CURRENT_USER.tutorialStep == s_tutorial_book_select then
               s_CURRENT_USER:setTutorialStep(s_tutorial_book_select+1)
           end
           s_CURRENT_USER.bookKey = bookKey
           s_DATA_MANAGER.loadLevels(s_CURRENT_USER.bookKey)
           s_CURRENT_USER:initChapterLevelAfterLogin() -- update user data
           showProgressHUD()
           s_CURRENT_USER:setUserLevelDataOfUnlocked('chapter0', 'level0', 1, 
               function (api, result)
                   s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER, 
                       function (api, result)
                           s_CorePlayManager.enterHomeLayer()
                           hideProgressHUD()
                       end,
                       function (api, code, message, description)
                           s_TIPS_LAYER:showSmall(message)
                           hideProgressHUD()
                       end)
               end,
               function (api, code, message, description)
                   s_TIPS_LAYER:showSmall(message)
                   hideProgressHUD()
               end)
           s_SCENE.touchEventBlockLayer.lockTouch()
        end
    end

    local button_choose = ccui.Button:create("image/download/button_onebutton_size.png","image/download/button_onebutton_size_clicked.png","")
    button_choose:setTitleText("选择此书")
    button_choose:setTitleFontSize(40)
    button_choose:setPosition(bigWidth/2, 333)
    button_choose:addTouchEventListener(button_choose_clicked)
    backColor:addChild(button_choose)
    
    
    local button_download_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            
        end
    end

    local button_download = ccui.Button:create("image/download/button_onebutton_size.png","image/download/button_onebutton_size_clicked.png","")
    button_download:setTitleText("下载音频(12MB)")
    button_download:setTitleFontSize(40)
    button_download:setPosition(bigWidth/2, 222)
    button_download:addTouchEventListener(button_download_clicked)
    backColor:addChild(button_download)
    
    return layer
end


return DownloadLayer








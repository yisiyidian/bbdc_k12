require("cocos.init")
require("common.global")

local DownloadAlter        = require("view.book.DownloadAlter")

local DownloadLayer = class("DownloadLayer", function()
    return cc.Layer:create()
end)

function DownloadLayer.create(bookKey)
    local bookImageName = "image/download/big_"..string.upper(bookKey)..".png"
    local total_size = s_DATA_MANAGER.books[bookKey].music
    
    local download_state = 0 -- 0 for no download, 1 for downloading and 2 for downloaded
    if s_DATABASE_MGR.getDownloadState(bookKey) == 1 then
        download_state = 2
    end
    download_state = 2

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
            if download_state == 1 then
                local downloadAlter = DownloadAlter.create("正在下载，取消下载方可返回上一个界面。")
                downloadAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                backColor:addChild(downloadAlter)
            else
                s_CorePlayManager.enterBookLayer()
            end
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

    local button_choose = ccui.Button:create("image/download/button_blue.png","image/download/button_blue_clicked.png","")
    button_choose:setTitleText("选择此书")
    button_choose:setTitleFontSize(34)
    button_choose:setPosition(bigWidth/2, 333)
    button_choose:addTouchEventListener(button_choose_clicked)
    backColor:addChild(button_choose)
    
   
    local progress
    local progress_clicked
    local button_title
    local percent = 30
    local title1 = "下载音频("..total_size..")"
    local title2 = "取消下载(1.1M/"..total_size..")"
    local title3 = "删除音频("..total_size..")"

    local button_download_clicked = function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            if download_state == 0 then
                
                
                
            elseif download_state == 1 then
                progress:setVisible(false)
                progress_clicked:setVisible(true)
            else
            
            end
        elseif eventType == ccui.TouchEventType.ended then
            if download_state == 0 then
                local downloadAlter = DownloadAlter.create("需要消耗流量"..total_size.."，确定下载？")
                downloadAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                backColor:addChild(downloadAlter)
            
                downloadAlter.sure = function()
                    percent = 30
                    progress:setPercentage(percent)
                    progress_clicked:setPercentage(percent)
                    progress:setVisible(true)
                    
                    button_title:setString(title2)
                    download_state = 1
                    progress:setVisible(true)
                    progress_clicked:setVisible(false)
                end
            elseif download_state == 1 then
                local downloadAlter = DownloadAlter.create("取消之后您需要重新下载，确定取消？")
                downloadAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                backColor:addChild(downloadAlter)
                
                downloadAlter.sure = function()
                    button_title:setString(title1)
                    download_state = 0
                    progress:setVisible(false)
                    progress_clicked:setVisible(false)
                end
            else
                local downloadAlter = DownloadAlter.create("删除之后您需要重新下载，确定删除？")
                downloadAlter:setPosition(bigWidth/2, s_DESIGN_HEIGHT/2)
                backColor:addChild(downloadAlter)

                downloadAlter.sure = function()
                    button_title:setString(title1)
                    download_state = 0
                    progress:setVisible(false)
                    progress_clicked:setVisible(false)
                end
            end
        end
    end

    local button_download = ccui.Button:create("image/download/button_yellow.png","image/download/button_yellow_clicked.png","")
    button_download:setPosition(bigWidth/2, 222)
    button_download:addTouchEventListener(button_download_clicked)
    backColor:addChild(button_download)

    progress = cc.ProgressTimer:create(cc.Sprite:create("image/download/button_download.png"))
    progress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress:setMidpoint(cc.p(0, 0))
    progress:setBarChangeRate(cc.p(1, 0))
    progress:setPosition(button_download:getPosition())
    progress:setPercentage(percent)
    progress:setVisible(false)
    backColor:addChild(progress)

    progress_clicked = cc.ProgressTimer:create(cc.Sprite:create("image/download/button_download_clicked.png"))
    progress_clicked:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    progress_clicked:setMidpoint(cc.p(0, 0))
    progress_clicked:setBarChangeRate(cc.p(1, 0))
    progress_clicked:setPosition(button_download:getPosition())
    progress_clicked:setPercentage(percent)
    progress_clicked:setVisible(false)
    backColor:addChild(progress_clicked)

    if download_state == 0 then
        button_title = cc.Label:createWithSystemFont(title1,"",34)
        button_title:setPosition(bigWidth/2, 222)
        backColor:addChild(button_title)
    else
        percent = 100
        progress:setPercentage(percent)
        progress_clicked:setPercentage(percent)
        progress:setVisible(true)
        
        
        button_title = cc.Label:createWithSystemFont(title3,"",34)
        button_title:setPosition(bigWidth/2, 222)
        backColor:addChild(button_title)
        
        
        
    end

    
    
    

    return layer
end


return DownloadLayer








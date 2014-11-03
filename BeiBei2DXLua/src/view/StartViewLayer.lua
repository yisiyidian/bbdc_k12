

local StartViewLayer = class("StartViewLayer", function ()
    return cc.Layer:create()
end)

function StartViewLayer.create()
    local layer = StartViewLayer.new()
    return layer
end

function StartViewLayer:ctor()
    self.ccbStartViewLayer = {}
    self.ccbStartViewLayer['onPlay'] = self.onPlay
    self.ccbStartViewLayer['onSignUp'] = self.onSignUp
    self.ccbStartViewLayer['onLogIn'] = self.onLogIn

    self.ccb = {}
    self.ccb['start_view'] = self.ccbStartViewLayer

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/start_view.ccbi", proxy, self.ccbStartViewLayer, self.ccb)
    self:addChild(node)
end

function StartViewLayer:onPlay()
    local function onResponse(u, e, code)

        s_UserBaseServer.getLevelsOfCurrentUser(
            function (api, result)
                s_CURRENT_USER:parseServerLevelData(result.results)
                
                 s_DATA_MANAGER.loadText()
                 s_DATA_MANAGER.loadLevels(s_BOOK_KEY_NCEE)
                 local level = require('view/LevelLayer.lua')
                 layer = level.create()
                 s_SCENE:replaceGameLayer(layer)
            end,
            function (api, code, message, description)
            end
        )

-- DONE
        -- s_UserBaseServer.dailyCheckInOfCurrentUser( 
        --    function (api, result)
        --        s_CURRENT_USER:parseServerDailyCheckInData(result.results)
        --    end,
        --    function (api, code, message, description) end
        -- )
        
-- DONE        
        -- s_UserBaseServer.getFolloweesOfCurrentUser( 
        --     function (api, result)
        --         parseServerFolloweesData(result.results)
        --     end,
        --     function (api, code, message, description)
        --     end
        -- )

-- DONE
        -- s_UserBaseServer.getFollowersOfCurrentUser( 
        --     function (api, result)
        --         parseServerFollowersData(result.results)
        --     end,
        --     function (api, code, message, description)
        --     end
        -- )

        
        
    end 
    s_UserBaseServer.login('yehanjie1', '111111', onResponse)
end

function StartViewLayer:onSignUp()
    local PopupLoginSignup = require('popup.PopupLoginSignup')
    local layer = PopupLoginSignup.create()
    layer:setAnchorPoint(0.5,0)
    s_SCENE:popup(layer)
        
    -- -- TODO
    -- s_STORE.init()
    -- s_STORE.login(nil)
end

function StartViewLayer:onLogIn()
    local PopupLoginSignup = require('popup.PopupLoginSignup')
    local layer = PopupLoginSignup.create()
    layer:setAnchorPoint(0.5, 0)
    s_SCENE:popup(layer)

    -- s_STORE.buy(function (code, msg, info) 
    --     -- s_DEBUG_LAYER.debugInfo:setString(msg)
    --     s_logd('s_STORE:' .. code .. ', msg:' .. msg)
    -- end)
end

return StartViewLayer


ccbStartViewLayer = ccbStartViewLayer or {}
ccb['start_view'] = ccbStartViewLayer

local StartViewLayer = class("StartViewLayer", function ()
    return cc.Layer:create()
end)

function StartViewLayer.create()
    local layer = StartViewLayer.new()
    return layer
end

function StartViewLayer:ctor()
    ccbStartViewLayer['onPlay'] = self.onPlay
    ccbStartViewLayer['onSignUp'] = self.onSignUp
    ccbStartViewLayer['onLogIn'] = self.onLogIn

    local proxy = cc.CCBProxy:create()
    local node  = CCBReaderLoad("res/ccb/start_view.ccbi", proxy, ccbStartViewLayer)
    self:addChild(node)
end

function StartViewLayer:onPlay()
    local function onSucceed(api, result)
        -- s_logd('onSucceed:' .. api .. ', ' .. s_JSON.encode(result))
        parseServerDataToUserData(result, s_CURRENT_USER)

        s_UserBaseServer.dailyCheckIn(s_CURRENT_USER.userId, 
            function (api, result)
                local DataDailyCheckIn = require('model.user.DataDailyCheckIn')
                s_CURRENT_USER.dailyCheckInData = {}
                for i, v in ipairs(result['results']) do
                    local data = DataDailyCheckIn.create()
                    parseServerDataToUserData(v, data)
                    s_CURRENT_USER.dailyCheckInData[i] = data
                    print_lua_table(data)
                end 
            end,
            function (api, code, message)
            end)
    end 
    local function onFailed(api, code, message)
        s_logd('onFailed:' ..  api .. ', ' .. code .. ', ' .. message)
    end
    s_UserBaseServer.login('yehanjie1', '111111', onSucceed, onFailed)
    -- s_funcSignin('_test000', '111111', onSucceed, onFailed)
end

function StartViewLayer:onSignUp()
    local PopupLoginSignup = require('popup.PopupLoginSignup')
    local layer = PopupLoginSignup.create()
    layer:setAnchorPoint(0.5,0)
    s_SCENE:popup(layer)
    
    -- TODO
    s_STORE.buy(function (code, msg, info) 
        s_DEBUG_LAYER.debugInfo:setString(msg)
    end)
end

function StartViewLayer:onLogIn()
    local PopupLoginSignup = require('popup.PopupLoginSignup')
    local layer = PopupLoginSignup.create()
    layer:setAnchorPoint(0.5,0)
    s_SCENE:popup(layer)
end

return StartViewLayer


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

--        s_UserBaseServer.dailyCheckInOfCurrentUser( 
--            function (api, result)
--                print_lua_table(result)
--                local DataDailyCheckIn = require('model.user.DataDailyCheckIn')
--                s_CURRENT_USER.dailyCheckInData = {}
--                for i, v in ipairs(result['WMAV_DailyCheckInData']) do
--                    local data = DataDailyCheckIn.create()
--                    parseServerDataToUserData(v, data)
--                    s_CURRENT_USER.dailyCheckInData[i] = data
--                    print('111')
--                    print_lua_table(v)
--                    print('222')
--                    print_lua_table(data)
--                end 
--            end,
--            function (api, code, message) end
--        )
        
        s_UserBaseServer.getFolloweesOfCurrentUser( 
            function (api, result)
                print_lua_table(result.result)
--                local DataUser = require('model.user.DataUser')
                for i, v in ipairs(result.result.results) do
--                    local data = DataUser.create()
--                    parseServerDataToUserData(v, data)
                    print_lua_table(v)
                end 
            end,
            function (api, code, message)
            end
        )

        
        
    end 
    local function onFailed(api, code, message)
        s_logd('onFailed:' ..  api .. ', ' .. code .. ', ' .. message)
    end
    s_UserBaseServer.login('yehanjie1', '111111', onSucceed, onFailed)
end

function StartViewLayer:onSignUp()
    local PopupLoginSignup = require('popup.PopupLoginSignup')
    local layer = PopupLoginSignup.create()
    layer:setAnchorPoint(0.5,0)
    s_SCENE:popup(layer)
    
    s_UserBaseServer.getLevelsOfCurrentUser(
        function (api, result)
            print_lua_table(result) 
        end,
        function (api, code, message)
        end
    )
    
    -- TODO
--    s_STORE.buy(function (code, msg, info) 
--        s_DEBUG_LAYER.debugInfo:setString(msg)
--    end)
end

function StartViewLayer:onLogIn()
    local PopupLoginSignup = require('popup.PopupLoginSignup')
    local layer = PopupLoginSignup.create()
    layer:setAnchorPoint(0.5,0)
    s_SCENE:popup(layer)
end

return StartViewLayer

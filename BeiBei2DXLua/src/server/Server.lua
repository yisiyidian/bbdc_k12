require "Cocos2d"
require "Cocos2dConstants"
local json  = require('json')
local debugger = require("common.debugger")
local logd = debugger.logd

local Server = {}

Server.url = 'https://cn.avoscloud.com/1.1/functions/'
Server.localUrl = "http://localhost:3000/avos/"
Server.appId = '9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l'
Server.appKey = '8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg'

function Server.request(api, parameters, onSucceed, onFailed)
    local xhr = cc.XMLHttpRequest:new()    
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open('POST', Server.url .. api)
    xhr:setRequestHeader('X-AVOSCloud-Application-Id', Server.appId)
    xhr:setRequestHeader('X-AVOSCloud-Application-Key', Server.appKey)

    --
    xhr:registerScriptHandler(function ()
        logd('Server.onResponse: api:' .. api .. ', type:' .. xhr.responseType .. ', data:' .. xhr.response) -- .. ', ' .. xhr:getAllResponseHeaders())
        local data = json.decode(xhr.response)
        local result = data.result
        local code = result.code
        local message = result.message

        if code and onFailed then
            onFailed(api, code, message)
        end
        if not code and onSucceed then 
            onSucceed(api, result)
        end
    end)

    --
    local str = ''
    for key, value in pairs(parameters) do  
        if string.len(str) > 0 then str = str .. '&' end
        str = str .. key .. '=' .. value
    end 
    xhr:send(str)
    logd('Server.request: api:' .. api .. ', parameters:' .. str)
end

return Server

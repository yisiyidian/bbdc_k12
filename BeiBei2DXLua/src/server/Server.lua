require("common.global")

local Server = {}

Server.debugLocalHost = false
Server.isAppStoreServer = false

local function getURL()
    if Server.debugLocalHost then
        return 'http://localhost:3000/avos/'
    else
        return 'https://cn.avoscloud.com/1.1/functions/'
    end
end

local function getAppData()
    if Server.isAppStoreServer then
        return 'eowk9vvvcfzeoqd646sz1n3ml13ly735gsg7f3xstoutaozw', '9qzx8oyd30q40so5tc4g0kgu171y7wg28v7gg59q4rn1xgv6'
    else -- test server
        return '9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l', '8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg'
    end
end

-- api : string
-- parameters : table
-- onSucceed(api, result) -- result : json
-- onFailed(api, code, message)
function Server.request(api, parameters, onSucceed, onFailed)
    local appId, appKey = getAppData()
    local xhr = cc.XMLHttpRequest:new()    
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open('POST', getURL() .. api)
    xhr:setRequestHeader('X-AVOSCloud-Application-Id', appId)
    xhr:setRequestHeader('X-AVOSCloud-Application-Key', appKey)
    xhr:setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8')

    --
    xhr:registerScriptHandler(function ()
        -- * xhr.readyState：XMLHttpRequest对象的状态，等于4表示数据已经接收完毕
        -- * xhr.status：服务器返回的状态码，等于200表示一切正常
        -- * xhr.responseText：服务器返回的文本数据
        -- * xhr.statusText：服务器返回的状态文本
        s_logd('response api:  ' .. api .. ', status:' .. xhr.status .. ', statusText:' .. xhr.statusText .. ', type:' .. xhr.responseType)
        s_logd('response data: ' .. xhr.response) -- .. ', ' .. xhr:getAllResponseHeaders())
        
        -- readyState == 4
        if xhr.status ~= 200 then
            onFailed(api, xhr.status, xhr.statusText)
        elseif xhr.response ~= nil then
            local data = s_json.decode(xhr.response)
            local result
            if Server.debugLocalHost then 
                result = data 
            else
                result = data.result
            end
            local code = result.code
            local message = result.message

            if code and onFailed then
                onFailed(api, code, message)
            elseif not code and onSucceed then 
                onSucceed(api, result)
            end
        end

        xhr:unregisterScriptHandler()
    end)

    --
    local str = ''
    for key, value in pairs(parameters) do  
        if string.len(str) > 0 then str = str .. '&' end
        str = str .. key .. '=' .. value
    end 
    xhr:send(str)
    s_logd('request: api:' .. api .. ', parameters:' .. str)
end

-- AssetsManager: download http://ac-eowk9vvv.qiniudn.com/WJZJ2GGKNsFjPDlv.bin

return Server

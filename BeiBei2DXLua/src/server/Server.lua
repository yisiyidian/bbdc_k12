require("common.global")

local Server = {}

Server.debugLocalHost = false
Server.isAppStoreServer = false
Server.sessionToken = ''

local function getURL()
    if Server.debugLocalHost then
        return 'http://localhost:3000/avos/'
    else
        return 'https://leancloud.cn/1.1/functions/'
    end
end

local function getAppData()
    local timestamp = os.time()

    -- test server
    local appId = '9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l'
    local appKey = '8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg'

    if Server.isAppStoreServer then
        appId = 'eowk9vvvcfzeoqd646sz1n3ml13ly735gsg7f3xstoutaozw'
        appKey = '9qzx8oyd30q40so5tc4g0kgu171y7wg28v7gg59q4rn1xgv6'
    end

    local xmd5 = ''
    xmd5 = cx.CXUtils:md5(timestamp .. appKey, xmd5)
    local sign = xmd5 .. ',' .. timestamp
    return appId, sign
end

-- api : string
-- parameters : table
-- onSucceed(api, result) -- result : json
-- onFailed(api, code, message)
function Server.request(api, parameters, onSucceed, onFailed)
    local appId, sign = getAppData()
    local xhr = cc.XMLHttpRequest:new()    
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open('POST', getURL() .. api)
    xhr:setRequestHeader('X-AVOSCloud-Application-Id', appId)
    xhr:setRequestHeader('X-AVOSCloud-Request-Sign', sign)
    xhr:setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8')
    if (string.len(Server.sessionToken) > 0) then
        xhr:setRequestHeader('X-AVOSCloud-Session-Token', Server.sessionToken)
    end

    --
    xhr:registerScriptHandler(function ()
        -- * xhr.readyState：XMLHttpRequest对象的状态，等于4表示数据已经接收完毕
        -- * xhr.status：服务器返回的状态码，等于200表示一切正常
        -- * xhr.responseText：服务器返回的文本数据
        -- * xhr.statusText：服务器返回的状态文本
        s_logd('\n>>>\nresponse api:  ' .. api .. ', status:' .. xhr.status .. ', statusText:' .. xhr.statusText .. ', type:' .. xhr.responseType)
        s_logd('response data: \n' .. xhr.response .. '\n<<<\n') -- .. ', ' .. xhr:getAllResponseHeaders())
        
        -- readyState == 4
        if xhr.status ~= 200 then
            onFailed(api, xhr.status, xhr.statusText)
        elseif xhr.response ~= nil then
            local data = s_JSON.decode(xhr.response)
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
    if parameters ~= nil then
        for key, value in pairs(parameters) do  
            if string.len(str) > 0 then str = str .. '&' end
            str = str .. key .. '=' .. value
        end
        xhr:send(str)
    else 
        xhr:send()
    end
    s_logd('\n>>>\nrequest: api:' .. api .. ', parameters:' .. str .. '\n<<<\n')
end

-- doCloudQuery 回调中的 result 包含三个属性：
--     results - 查询结果的 AV.Object 列表
--     count - 如果使用了 select count(*) 的查询语法，返回符合查询条件的记录数目。
--     className - 查询的 class name
function Server.CloudQueryLanguage(cql, onSucceed, onFailed)
    Server.request('apiCQL', {['cql']=cql}, onSucceed, onFailed)
end

function Server.CloudQueryLanguageExtend(cat, cql, onSucceed, onFailed)
    Server.request('apiCQLExtend', {['cat']=cat, ['cql']=cql}, onSucceed, onFailed)
end

-- AssetsManager: download http://ac-eowk9vvv.qiniudn.com/WJZJ2GGKNsFjPDlv.bin

return Server

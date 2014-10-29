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

-- create : POST
-- update : PUT
-- https://leancloud.cn/1.1/classes/

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
-- onFailed(api, code, message, description)
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
        s_logd('response data: \n\n' .. xhr.response .. '\n\n<<<\n') -- .. ', ' .. xhr:getAllResponseHeaders())
        
        -- readyState == 4
        
    -- pure RESTful API : TODO
        -- 一个请求是否成功是由 HTTP 状态码标明的. 
        -- 一个 2XX 的状态码表示成功, 而一个 4XX 表示请求失败. 
        -- 当一个请求失败时响应的主体仍然是一个 JSON 对象, 
        -- 但是总是会包含 code 和 error 这两个字段, 
        -- 您可以用它们来进行 debug. 
        -- 举个例子, 如果尝试用不允许的 key 来保存一个对象会得到如下信息:
        -- {
        --   "code": 105,
        --   "error": "invalid field name: bl!ng"
        -- }

    -- Cloud Code
        -- {'code': error.code, 'message': error.message, 'description':error.description}
        if xhr.status ~= 200 then
            onFailed(api, xhr.status, xhr.statusText, '')
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
            local description = result.description

            if code and onFailed then
                onFailed(api, code, message, description)
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

-- create & update
function Server.createData(obj, onSucceed, onFailed)
    Server.request('apiCreate', {['className']=obj.className, ['obj']=dataToJSONString(obj)}, onSucceed, onFailed)
end

function Server.updateData(obj, onSucceed, onFailed)
    Server.request('apiUpdate', {['className']=obj.className, ['objectId']=obj.objectId, ['obj']=dataToJSONString(obj)}, onSucceed, onFailed)
end

-- AssetsManager: download http://ac-eowk9vvv.qiniudn.com/WJZJ2GGKNsFjPDlv.bin

return Server

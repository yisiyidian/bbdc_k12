require("common.global")

local Server = {}

Server.debugLocalHost = false -- CQL can NOT debug at local host
Server.isAppStoreServer = false
Server.production = 0
Server.appId = ''
Server.appKey = ''
Server.sessionToken = ''

CONTENT_TYPE_JSON = 'application/json'
CONTENT_TYPE_FORM = 'application/x-www-form-urlencoded; charset=UTF-8'

local function getURL()
    if Server.debugLocalHost then
        return 'http://localhost:3000/avos/'
    else
        return 'https://leancloud.cn/1.1/'
    end
end

local function getAppData()
    local timestamp = os.time()

    local appId = Server.appId
    local appKey = Server.appKey

    local xmd5 = ''
    xmd5 = cx.CXUtils:md5(timestamp .. appKey, xmd5)
    local sign = xmd5 .. ',' .. timestamp
    return appId, sign
end

-- *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

-- api : string
-- parameters : table
-- onSucceed(api, result) -- result : json
-- onFailed(api, code, message, description)
local function __request__(api, httpRequestType, contentType, parameters, onSucceed, onFailed)
    local appId, sign = getAppData()
    local xhr = cc.XMLHttpRequest:new()    
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open(httpRequestType, getURL() .. api)
    xhr:setRequestHeader('X-AVOSCloud-Application-Id', appId)
    xhr:setRequestHeader('X-AVOSCloud-Request-Sign', sign)
    xhr:setRequestHeader('X-AVOSCloud-Application-Production', Server.production)
    xhr:setRequestHeader('Content-Type', contentType)
    if (string.len(Server.sessionToken) > 0) then
        xhr:setRequestHeader('X-AVOSCloud-Session-Token', Server.sessionToken)
    end

    --
    xhr:registerScriptHandler(function ()
        -- * xhr.readyState：XMLHttpRequest对象的状态，等于4表示数据已经接收完毕
        -- * xhr.status：服务器返回的状态码，等于200表示一切正常
        -- * xhr.responseText：服务器返回的文本数据
        -- * xhr.statusText：服务器返回的状态文本
        print('\n>>>\nresponse api:  ' .. api .. ', status:' .. xhr.status .. ', statusText:' .. xhr.statusText .. ', type:' .. xhr.responseType)
        if parameters ~= nil then print_lua_table(parameters) end
        print('response data: \n\n' .. xhr.response .. '\n\n<<<\n') -- .. ', ' .. xhr:getAllResponseHeaders())
        
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
            if onFailed then onFailed(api, xhr.status, xhr.statusText, '') end
        elseif xhr.response ~= nil then

            local data = s_JSON.decode(xhr.response)
            local result
            if data.result ~= nil then
                result = data.result
            else 
                result = data 
            end
            local code = result.code
            local message = result.message
            if message == nil then message = result.error end
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
    print('\n>>>\nrequest: api:' .. api .. ', sessionToken:' .. Server.sessionToken .. ', parameters:' .. str .. '\n<<<\n')
end

-- *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

local function create_onSucceed(onResponse)
    local ret = function (api, result)
        if onResponse ~= nil then onResponse(api, result, nil) end
    end
    return ret
end

local function create_onFailed(onResponse)
    local ret = function (api, code, message, description)
        if onResponse ~= nil then onResponse(api, nil, {['code']=code, ['message']=message, ['description']=description}) end
    end
    return ret
end

function Server.requestFunction(api, parameters, onSucceed, onFailed)
    if Server.debugLocalHost then
        __request__(api,                 'POST', CONTENT_TYPE_FORM, parameters, onSucceed, onFailed)
    else
        __request__('functions/' .. api, 'POST', CONTENT_TYPE_FORM, parameters, onSucceed, onFailed)
    end
end

-- 计数器
function Server.increment(key, userId, appVersion)
    Server.requestFunction('increment', {['className']='DataCounter', ['key']=key, ['userId']=userId, ['appVersion']=appVersion}, nil, nil)
end

function Server.incrementPerDay(key, currentDay, appVersion)
    Server.requestFunction('incrementPerDay', {['className']='DataCounterPerDay' .. key, ['key']=key, ['currentDay']=currentDay, ['appVersion']=appVersion}, nil, nil)
end

-- return {followers: [粉丝列表], followees: [关注用户列表]}
-- TODO: status

function Server.requestFollowersAndFollowees(userObjectId, onResponse)
    __request__('users/' .. userObjectId .. '/followersAndFollowees?include=followee', 
        'GET', 
        CONTENT_TYPE_JSON, 
        nil, 
        create_onSucceed(onResponse),
        create_onFailed(onResponse))
end

function Server.follow(userObjectId, targetObjectId, onResponse)
    __request__('users/' .. userObjectId .. '/friendship/' .. targetObjectId, 
        'POST', 
        CONTENT_TYPE_JSON, 
        nil, 
        create_onSucceed(onResponse),
        create_onFailed(onResponse))
end

function Server.unfollow(userObjectId, targetObjectId, onResponse)
    __request__('users/' .. userObjectId .. '/friendship/' .. targetObjectId, 
        'DELETE', 
        CONTENT_TYPE_JSON, 
        nil, 
        create_onSucceed(onResponse),
        create_onFailed(onResponse))
end

---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------

-- CQL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- doCloudQuery 回调中的 result 包含三个属性：
--     results - 查询结果的 AV.Object 列表
--     count - 如果使用了 select count(*) 的查询语法，返回符合查询条件的记录数目。
--     className - 查询的 class name
-- function Server.CloudQueryLanguage(cql, onSucceed, onFailed)
--     Server.requestFunction('apiCQL', {['cql']=cql}, onSucceed, onFailed)
-- end

-- function Server.CloudQueryLanguageExtend(cat, cql, onSucceed, onFailed)
--     Server.requestFunction('apiCQLExtend', {['cat']=cat, ['cql']=cql}, onSucceed, onFailed)
-- end
-- CQL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



-- cloud function >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- create & update
function Server.createData(obj, onSucceed, onFailed)
    Server.requestFunction('apiCreate', {['className']=obj.className, ['obj']=dataToJSONString(obj)}, onSucceed, onFailed)
end

function Server.updateData(obj, onSucceed, onFailed)
    Server.requestFunction('apiUpdate', {['className']=obj.className, ['objectId']=obj.objectId, ['obj']=dataToJSONString(obj)}, onSucceed, onFailed)
end
-- cloud function <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



-- rest >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- 回调中的 result 包含一个至三个属性：
--     results - 查询结果的 AV.Object 列表
--     count - 
--     className - 查询的 class name
--
-- s_SERVER.search('classes/DataBulletinBoard,
--     function (api, result)
--         print_lua_table (result)
--     end, 
--     function (api, code, message, description)
--         print(code)
--         print(message)
--         print(description)
--     end
-- )
function Server.search(restSQL, onSucceed, onFailed)
    Server.requestFunction('apiRestSearch', {['path']='/1.1/' .. restSQL, ['limit']=999}, onSucceed, onFailed)
end

-- s_SERVER.searchCount('DataBulletinBoard', 
--     '{"index":1}', 
--     function (api, result) 
--       print (result.count)
--     end, 
--     function (api, code, message, description) end)
function Server.searchCount(className, where, onSucceed, onFailed)
    local sql = {
        ['path']='/1.1/classes/' .. className, 
        ['count']=1,
        ['limit']=0
    }
    if where ~= nil then sql['where'] = where end
    Server.requestFunction('apiRestSearch', sql, onSucceed, onFailed)
end

function Server.searchRelations(className, where, relations, onSucceed, onFailed)
    local sql = {
        ['path']='/1.1/classes/' .. className, 
        ['where'] = where,
        ['include']=relations
    }
    Server.requestFunction('apiRestSearch', sql, onSucceed, onFailed)
end

--[[
curl -X PUT \
>   -H "X-AVOSCloud-Application-Id: 9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l" \
>   -H "X-AVOSCloud-Application-Key: 8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg" \
>   -H "X-AVOSCloud-Session-Token: 43jda47e79x8734m0bic30jyg" \
>   -H "Content-Type: application/json" \
>   -d '{"old_password":"111111", "new_password":"222222"}' \
>   https://leancloud.cn/1.1/users/54128e44e4b080380a47debc/updatePassword
{"updatedAt":"2014-11-04T07:34:43.718Z","objectId":"54128e44e4b080380a47debc"}
]]--
-- onSucceed result = {"updatedAt":"2014-11-05T07:26:00.515Z","objectId":"54128e44e4b080380a47debc"}
function Server.updatePassword(old_password, new_password, userObjectId, onSucceed, onFailed)
    Server.requestFunction('apiRestUpdate', {['path']='/1.1/users/' .. userObjectId .. '/updatePassword', ['json']=dataToJSONString({['old_password']=old_password, ['new_password']=new_password})}, onSucceed, onFailed)
end
-- rest <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

-- AssetsManager: download http://ac-eowk9vvv.qiniudn.com/WJZJ2GGKNsFjPDlv.bin


-- network status >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function Server.isOnline()
    return true
end

return Server

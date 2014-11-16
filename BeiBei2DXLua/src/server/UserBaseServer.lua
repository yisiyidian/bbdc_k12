
require("common.global")

local UserBaseServer = {}

---------------------------------------------------------------------------------------------------------------------

function validateUsername(s)
    local length = string.len(s)
    if length < 1 then return false end
    s_logd(string.format('%s, %d', s, length))

    local c = s:sub(1, 1)
    local ord = c:byte()
    if (ord >= 65 and ord <= 90) or (ord >= 97 and ord <= 122) or ord > 128 then 
        local i = 1
        local len = 0
        while i <= length do
            local c = s:sub(i, i)
            local ord = c:byte()
            if (ord >= 48 and ord <= 57) or(ord >= 65 and ord <= 90) or (ord >= 97 and ord <= 122) or ord > 128 then
                if ord > 128 then
                    i = i + 3
                else
                    i = i + 1
                end
            else
                s_logd(string.format('%s, %d, %s', s, length, c))
                return false
            end

            len = len + 1
        end

        if len < 4 or len > 16 then 
          s_logd(string.format('%s, %d, %d', s, length, len))
          return false 
        end
    else
        return false
    end

    return true
end

function validatePassword(s)
    local length = string.len(s)
    if length < 6 or length > 16 then return false end

    local modifiedString, numberOfSubstitutions = string.gsub(s, '[0-9a-zA-Z]', '')
    s_logd(string.format('%s, %d, %s, %d', s, length, modifiedString, numberOfSubstitutions))
    return numberOfSubstitutions >= 6 and numberOfSubstitutions <= 16 and numberOfSubstitutions == length
end

local function onResponse_signup_login(objectjson, e, code, onResponse)
    if e ~= nil then 
        s_logd('signup/logIn:' .. e) 
        if onResponse ~= nil then onResponse(s_CURRENT_USER, e, code) end
    elseif objectjson ~= nil then 
        -- TODO: Android unknown error
        if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
            local sessionToken = objectjson
            s_logd('signup/logIn:' .. sessionToken)
            s_CURRENT_USER.sessionToken = sessionToken
            s_SERVER.sessionToken = sessionToken
            UserBaseServer.searchUserByUserName(s_CURRENT_USER.username, function (api, result)
                for i, v in ipairs(result.results) do
                   
                   parseServerDataToUserData(v, s_CURRENT_USER)
                   s_CURRENT_USER.userId = s_CURRENT_USER.objectId
                   s_DATABASE_MGR.saveDataClassObject(s_CURRENT_USER)

                   if onResponse ~= nil then onResponse(s_CURRENT_USER, nil, code) end
                   print_lua_table(s_CURRENT_USER)
                   break
               end
            end,
            function (api, code, message, description)
                if onResponse ~= nil then onResponse(s_CURRENT_USER, description, code) end
            end)
        else
            s_logd('signup/logIn:' .. type(objectjson) .. ',  ' .. objectjson)
            local user = s_JSON.decode(objectjson)
            s_CURRENT_USER.sessionToken = user.sessionToken
            s_SERVER.sessionToken = user.sessionToken
            parseServerDataToUserData(user, s_CURRENT_USER)
            s_CURRENT_USER.userId = s_CURRENT_USER.objectId
            s_DATABASE_MGR.saveDataClassObject(s_CURRENT_USER)
            
            if onResponse ~= nil then onResponse(s_CURRENT_USER, nil, code) end
        end
    else
        s_logd('signup/logIn:no sessionToken') 
        if onResponse ~= nil then onResponse(s_CURRENT_USER, 'no sessionToken', code) end
    end
end

-- https://cn.avoscloud.com/docs/error_code.html

-- function (user data, error description, error code)
function UserBaseServer.signup(username, password, onResponse)
    -- s_SERVER.request('apiSignUp', {['username']=username, ['password']=password}, onSucceed, onFailed)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    cx.CXAvos:getInstance():signUp(username, password, function (objectjson, e, code)
        onResponse_signup_login(objectjson, e, code, onResponse)
    end)
end

-- function (user data, error description, error code)
function UserBaseServer.login(username, password, onResponse)
    -- s_SERVER.request('apiLogIn', {['username']=username, ['password']=password}, onSucceed, onFailed)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    cx.CXAvos:getInstance():logIn(username, password, function (objectjson, e, code)
        onResponse_signup_login(objectjson, e, code, onResponse)
    end)
end

-- function (username, password, error description, error code)
function UserBaseServer.updateUsernameAndPassword(username, password, onResponse)
    local change_password = function (password, onResponse)
        if s_CURRENT_USER.password ~= password then
            s_SERVER.updatePassword(s_CURRENT_USER.password, password, s_CURRENT_USER.objectId, 
                function (api, result) 
                    s_CURRENT_USER.password = password
                    onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, nil, 0)
                end, 
                function (api, code, message, description) 
                    onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, description, code)
                end)
        else
            s_CURRENT_USER.password = password
            onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, nil, 0)
        end
    end

    if s_CURRENT_USER.username ~= username then

        UserBaseServer.isUserNameExist(username, function (api, result)
            if result.count <= 0 then
                local obj = {['className']=s_CURRENT_USER.className, ['objectId']=s_CURRENT_USER.objectId, ['username']=username}
                UserBaseServer.saveDataObjectOfCurrentUser(obj, 
                    function (api, result) 
                        s_CURRENT_USER.username = username
                        change_password(password, onResponse)
                    end, 
                    function (api, code, message, description) 
                        onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, description, code)
                    end
                )
            else
                onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, s_DATA_MANAGER.getTextWithIndex(TEXT_ID_USERNAME_HAS_ALREADY_BEEN_TAKEN), 65535)
            end
        end,
        function (api, code, message, description)
            onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, description, code)
        end)

    else
        change_password(password, onResponse)
    end
end

---------------------------------------------------------------------------------------------------------------------

-- onSucceed(api, result) -- result : json
-- onFailed(api, code, message, description)

---------------------------------------------------------------------------------------------------------------------

--[[ api test
curl -X GET \
  -H "X-AVOSCloud-Application-Id: 9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l" \
  -H "X-AVOSCloud-Application-Key: 8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg" \
  -G \
  --data-urlencode 'cql=select include followee from _Followee where user=pointer("_User", "54128e44e4b080380a47debc")' \
  https://leancloud.cn/1.1/cloudQuery
]]--

--[[
curl -X GET \
  -H "X-AVOSCloud-Application-Id: 9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l" \
  -H "X-AVOSCloud-Application-Key: 8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg" \
  -G \
  --data-urlencode 'cql=select * from _User where username="yehanjie1"' \
  https://leancloud.cn/1.1/cloudQuery
]]--
function UserBaseServer.searchUserByUserName(username, onSucceed, onFailed)
    s_SERVER.search('classes/_User?where={"username":"' .. username .. '"}', onSucceed, onFailed)
end

function UserBaseServer.isUserNameExist(username, onSucceed, onFailed)
    s_SERVER.searchCount('_User', '{"username":"' .. username .. '"}', onSucceed, onFailed)
end

----
--[[
s_UserBaseServer.getDailyCheckInOfCurrentUser( 
   function (api, result)
       s_CURRENT_USER:parseServerDailyCheckInData(result.results)
   end,
   function (api, code, message, description) end
)
]]--
function UserBaseServer.getDailyCheckInOfCurrentUser(onSucceed, onFailed)
    s_SERVER.search('classes/WMAV_DailyCheckInData?where={"userId":"' .. s_CURRENT_USER.objectId .. '"}', onSucceed, onFailed)
end

----

-- who I follow
--[[
s_UserBaseServer.getFolloweesOfCurrentUser( 
    function (api, result)
        parseServerFolloweesData(result.results)
    end,
    function (api, code, message, description)
    end
)
]]--
function UserBaseServer.getFolloweesOfCurrentUser(onSucceed, onFailed)
    local sql = string.format('{"user":{"__type":"Pointer","className":"_User","objectId":"%s"}}', s_CURRENT_USER.objectId)
    s_SERVER.searchRelations('_Followee', sql, 'followee', onSucceed, onFailed)
end

-- who follow me
--[[
s_UserBaseServer.getFollowersOfCurrentUser( 
    function (api, result)
        parseServerFollowersData(result.results)
    end,
    function (api, code, message, description)
    end
)
]]--
function UserBaseServer.getFollowersOfCurrentUser(onSucceed, onFailed)
    local sql = string.format('{"user":{"__type":"Pointer","className":"_User","objectId":"%s"}}', s_CURRENT_USER.objectId)
    s_SERVER.searchRelations('_Follower', sql, 'follower', onSucceed, onFailed)
end

function UserBaseServer.follow(targetDataUser, onSucceed, onFailed)
    s_SERVER.requestFunction('apiFollow', {['myObjectId']=s_CURRENT_USER.objectId, ['targetObjectId']=targetDataUser.objectId}, onSucceed, onFailed)
end

function UserBaseServer.unfollow(targetDataUser, onSucceed, onFailed)
    s_SERVER.requestFunction('apiUnfollow', {['myObjectId']=s_CURRENT_USER.objectId, ['targetObjectId']=targetDataUser.objectId}, onSucceed, onFailed)
end

function UserBaseServer.removeFan(fanDataUser, onSucceed, onFailed)
    s_SERVER.requestFunction('apiRemoveFan', {['myObjectId']=s_CURRENT_USER.objectId, ['fanObjectId']=fanDataUser.objectId}, onSucceed, onFailed)
end

----

function UserBaseServer.getDataLogIn(userId, week, onSucceed, onFailed)
    s_SERVER.search('classes/WMAV_LogInDateData?where={"userId":"' .. userId .. '","week":' .. week .. '}', onSucceed, onFailed)
end

----

--[[
s_UserBaseServer.getLevelsOfCurrentUser(
    function (api, result)
        s_CURRENT_USER:parseServerLevelData(result.results)
    end,
    function (api, code, message, description)
    end
)
]]--
local function getLevels(userId, bookKey, onSucceed, onFailed)
    s_SERVER.search('classes/WMAV_LevelData?where={"userId":"' .. userId .. '","bookKey":"' .. bookKey .. '"}', onSucceed, onFailed)
end
function UserBaseServer.getLevelsOfCurrentUser(onSucceed, onFailed)
    getLevels(s_CURRENT_USER.objectId, s_CURRENT_USER.bookKey, onSucceed, onFailed)
end

----

---------------------------------------------------------------------------------------------------------------------

function UserBaseServer.saveDataObjectOfCurrentUser(dataObject, onSucceed, onFailed)
    local s = function (api, result)
        --for i, v in ipairs(result) do
            parseServerDataToUserData(result, dataObject)
        --end
        if onSucceed ~= nil then onSucceed(api, result) end
    end
    
    dataObject.userId = s_CURRENT_USER.objectId
    
    if string.len(dataObject.objectId) <= 0 then
        s_SERVER.createData(dataObject, s, onFailed)
    else
        s_SERVER.updateData(dataObject, s, onFailed)
    end
end

return UserBaseServer


require("common.global")

local UserBaseServer = {}

---------------------------------------------------------------------------------------------------------------------

-- function validateUsername(s)
--     return string.match(s, "[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]{3,14}+")
-- end

-- function validatePassword(s)
--     return string.match(s, "^[\\x00-\\x7F]{6,16}$")
-- end

local function onResponse_signup_login(sessionToken, e, code, onResponse)
    if e ~= nil then 
        s_logd('signup/logIn:' .. e) 
        if onResponse ~= nil then onResponse(s_CURRENT_USER, e, code) end
    elseif sessionToken ~= nil then 
        s_logd('signup/logIn:' .. sessionToken)
        s_CURRENT_USER.sessionToken = sessionToken
        UserBaseServer.searchUserByUserName(s_CURRENT_USER.username, function (api, result)
            for i, v in ipairs(result.results) do
               parseServerDataToUserData(v, s_CURRENT_USER)
               if onResponse ~= nil then onResponse(s_CURRENT_USER, nil, code) end
               print_lua_table(s_CURRENT_USER)
               break
           end
        end,
        function (api, code, message, description)
            if onResponse ~= nil then onResponse(s_CURRENT_USER, description, code) end
        end)
    else
        s_logd('signup/logIn:no sessionToken') 
        if onResponse ~= nil then onResponse(s_CURRENT_USER, 'no sessionToken', code) end
    end
end

-- function (user data, error description, error code)
function UserBaseServer.signup(username, password, onResponse)
    -- s_SERVER.request('apiSignUp', {['username']=username, ['password']=password}, onSucceed, onFailed)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    cx.CXAvos:getInstance():signUp(username, password, function (sessionToken, e, code)
        onResponse_signup_login(sessionToken, e, code, onResponse)
    end)
end

-- function (user data, error description)
function UserBaseServer.login(username, password, onResponse)
    -- s_SERVER.request('apiLogIn', {['username']=username, ['password']=password}, onSucceed, onFailed)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    cx.CXAvos:getInstance():logIn(username, password, function (sessionToken, e)
        onResponse_signup_login(sessionToken, e, code, onResponse)
    end)
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

----
--[[
s_UserBaseServer.dailyCheckInOfCurrentUser( 
   function (api, result)
       s_CURRENT_USER:parseServerDailyCheckInData(result.results)
   end,
   function (api, code, message, description) end
)
]]--
function UserBaseServer.dailyCheckInOfCurrentUser(onSucceed, onFailed)
    local cql = "select * from WMAV_DailyCheckInData where userId='" .. s_CURRENT_USER.userId .. "'"
    s_SERVER.CloudQueryLanguage(cql, onSucceed, onFailed)
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
    local cql = string.format("select include followee from _Followee where user=pointer('_User', '%s')", s_CURRENT_USER.userId)
    s_SERVER.CloudQueryLanguageExtend('followee', cql, onSucceed, onFailed)
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
    local cql = string.format("select include follower from _Follower where user=pointer('_User', '%s')", s_CURRENT_USER.userId)
    s_SERVER.CloudQueryLanguageExtend('follower', cql, onSucceed, onFailed)
end

--[[
curl -X GET \
  -H "X-AVOSCloud-Application-Id: 9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l" \
  -H "X-AVOSCloud-Application-Key: 8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg" \
  -G \
  --data-urlencode 'cql=select * from _User where username="yehanjie1"' \
  https://leancloud.cn/1.1/cloudQuery
]]--
function UserBaseServer.searchUserByUserName(username, onSucceed, onFailed)
    local cql = "select * from _User where username='" .. username
    s_SERVER.CloudQueryLanguage(cql, onSucceed, onFailed)
end

function UserBaseServer.follow(targetDataUser, onSucceed, onFailed)
    s_SERVER.request('apiFollow', {['myObjectId']=s_CURRENT_USER.objectId, ['targetObjectId']=targetDataUser.objectId}, onSucceed, onFailed)
end

function UserBaseServer.unfollow(targetDataUser, onSucceed, onFailed)
    s_SERVER.request('apiUnfollow', {['myObjectId']=s_CURRENT_USER.objectId, ['targetObjectId']=targetDataUser.objectId}, onSucceed, onFailed)
end

function UserBaseServer.removeFan(fanDataUser, onSucceed, onFailed)
    s_SERVER.request('apiRemoveFan', {['myObjectId']=s_CURRENT_USER.objectId, ['fanObjectId']=fanDataUser.objectId}, onSucceed, onFailed)
end

----

function UserBaseServer.getLevels(userId, bookKey, onSucceed, onFailed)
    local cql = "select * from WMAV_LevelData where userId='" .. userId .. "' and bookKey='" .. bookKey .. "'"
    s_SERVER.CloudQueryLanguage(cql, onSucceed, onFailed)
end

--[[
s_UserBaseServer.getLevelsOfCurrentUser(
    function (api, result)
        s_CURRENT_USER:parseServerLevelData(result.results)
    end,
    function (api, code, message, description)
    end
)
]]--
function UserBaseServer.getLevelsOfCurrentUser(onSucceed, onFailed)
    UserBaseServer.getLevels(s_CURRENT_USER.userId, s_CURRENT_USER.bookKey, onSucceed, onFailed)
end

----

---------------------------------------------------------------------------------------------------------------------

function UserBaseServer.saveDataObjectOfCurrentUser(dataObject, onSucceed, onFailed)
    local s = function (api, result)
        for i, v in ipairs(result.results) do
            parseServerDataToUserData(v, dataObject)
        end
        if onSucceed ~= nil then onSucceed(api, result) end
    end
    dataObject.userId = s_CURRENT_USER.objectId
    if string.len(dataObject.objectId) <= 0 then
        s_SERVER.createData(dataObject, onSucceed, onFailed)
    else
        s_SERVER.updateData(dataObject, onSucceed, onFailed)
    end
end

return UserBaseServer

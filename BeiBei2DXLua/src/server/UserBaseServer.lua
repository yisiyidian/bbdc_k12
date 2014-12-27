
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

        if len < 4 or len > 10 then 
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

local function parseServerUser( objectjson )
    local user = s_JSON.decode(objectjson)
    s_CURRENT_USER.sessionToken = user.sessionToken
    s_SERVER.sessionToken = user.sessionToken
    parseServerDataToUserData(user, s_CURRENT_USER)
    return true
end

local function onResponse_signUp_logIn(hasParsed, objectjson, e, code, onResponse)
    if e ~= nil then 
        s_logd('signup/logIn:' .. e) 
        if onResponse ~= nil then onResponse(s_CURRENT_USER, e, code) end
    elseif objectjson ~= nil then 
        s_logd('signup/logIn:' .. type(objectjson) .. ',  ' .. objectjson)
        if hasParsed == false then parseServerUser( objectjson ) end

        s_CURRENT_USER.userId = s_CURRENT_USER.objectId
        s_DATABASE_MGR.saveDataClassObject(s_CURRENT_USER)
        s_DATABASE_MGR.setLogOut(false)
        
        if onResponse ~= nil then onResponse(s_CURRENT_USER, nil, code) end
    else
        s_logd('signup/logIn:no sessionToken') 
        if onResponse ~= nil then onResponse(s_CURRENT_USER, 'no sessionToken', code) end
    end
end

-- https://cn.avoscloud.com/docs/error_code.html

-- function (user data, error description, error code)
function UserBaseServer.signUp(username, password, onResponse)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    cx.CXAvos:getInstance():signUp(username, password, function (objectjson, e, code)
        onResponse_signUp_logIn(false, objectjson, e, code, onResponse)
    end)
end

-- function (user data, error description, error code)
function UserBaseServer.logIn(username, password, onResponse)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    cx.CXAvos:getInstance():logIn(username, password, function (objectjson, e, code)
        onResponse_signUp_logIn(false, objectjson, e, code, onResponse)
    end)
end

function UserBaseServer.logInByQQAuthData(onResponse)
    cx.CXAvos:getInstance():logInByQQAuthData(s_CURRENT_USER.openid, s_CURRENT_USER.access_token, s_CURRENT_USER.expires_in,
        function (objectjson, qqjson, authjson, e, code)
            onResponse_signUp_logIn(false, objectjson, e, code, onResponse)
        end
    )
end

-- ["access_token"] = "F24DE9192D4FB7E96594D33AEAD3E848",
-- ["openid"] = "4736E8D1D0A42BF6DF94F7A972CDD933",
-- ["expires_in"] = "1427014567",

-- ["yellow_vip_level"] = "0",
-- ["figureurl_1"] = "http://qzapp.qlogo.cn/qzapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/50",
-- ["figureurl_qq_2"] = "http://q.qlogo.cn/qqapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/100",
-- ["city"] = "深圳",
-- ["level"] = "0",
-- ["figureurl_qq_1"] = "http://q.qlogo.cn/qqapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/40",
-- ["is_lost"] = 0,
-- ["nickname"] = "qzuser",
-- ["figureurl"] = "http://qzapp.qlogo.cn/qzapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/30",
-- ["is_yellow_year_vip"] = "0",
-- ["ret"] = 0,
-- ["vip"] = "0",
-- ["year"] = "1990",
-- ["gender"] = "男",
-- ["figureurl_2"] = "http://qzapp.qlogo.cn/qzapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/100",
-- ["msg"] = "",
-- ["is_yellow_vip"] = "0",
-- ["province"] = "广东",
function UserBaseServer.onLogInByQQ(onResponse)
    s_CURRENT_USER.usertype = USER_TYPE_QQ
    local isParsed = false
    cx.CXAvos:getInstance():logInByQQ(function (objectjson, qqjson, authjson, e, code)
        if e == nil and qqjson ~= nil and authjson ~= nil then
            if objectjson ~= nil then 
                isParsed = parseServerUser( objectjson ) 
                print ('---- QQ USER INFO ----')
                print_lua_table (s_CURRENT_USER)
            end

            local qqUserInfo = s_JSON.decode(qqjson)
            local authData = s_JSON.decode(authjson)
            s_CURRENT_USER.localAuthData = authData
            s_CURRENT_USER.snsUserInfo = qqUserInfo

            if authData ~= nil and qqUserInfo ~= nil then 
                print ('---- QQ USER INFO authData ----')
                print_lua_table (authData)

                s_CURRENT_USER.access_token = s_CURRENT_USER.localAuthData.access_token
                s_CURRENT_USER.openid = s_CURRENT_USER.localAuthData.openid
                s_CURRENT_USER.expires_in = s_CURRENT_USER.localAuthData.expires_in
    
                print ('')

                print ('---- QQ USER INFO qqUserInfo ----')
                print_lua_table (qqUserInfo)

                s_CURRENT_USER.nickName = s_CURRENT_USER.snsUserInfo.nickname
                -- save nick name
                local obj = {['className']=s_CURRENT_USER.className, 
                             ['objectId']=s_CURRENT_USER.objectId, 
                             ['nickName']=s_CURRENT_USER.snsUserInfo.nickname,
                             ['access_token']=s_CURRENT_USER.localAuthData.access_token,
                             ['openid']=s_CURRENT_USER.localAuthData.openid,
                             ['usertype']=USER_TYPE_QQ}
                UserBaseServer.saveDataObjectOfCurrentUser(obj, 
                    function (api, result) 
                        onResponse_signUp_logIn(isParsed, objectjson, e, code, onResponse)
                    end, 
                    function (api, code, message, description) 
                        onResponse_signUp_logIn(isParsed, objectjson, e, code, onResponse)
                    end
                )
            end
        else
            onResponse_signUp_logIn(isParsed, objectjson, e, code, onResponse)
        end
    end)
end

-- function (username, password, error description, error code)
function UserBaseServer.updateUsernameAndPassword(username, password, onResponse)
    local onCompleted = function ()
        s_CURRENT_USER.password = password
        s_CURRENT_USER.usertype = USER_TYPE_BIND
        s_DATABASE_MGR.saveDataClassObject(s_CURRENT_USER)
        s_UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER)
        onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, nil, 0)
    end

    local change_password = function (password, onResponse)
        if s_CURRENT_USER.password ~= password then
            s_SERVER.updatePassword(s_CURRENT_USER.password, password, s_CURRENT_USER.objectId, 
                function (api, result) 
                    onCompleted()
                end, 
                function (api, code, message, description) 
                    onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, description, code)
                end)
        else
            onCompleted()
        end
    end

    if s_CURRENT_USER.username ~= username then

        UserBaseServer.isUserNameExist(username, function (api, result)
            if result.count <= 0 then
                local obj = {['className']=s_CURRENT_USER.className, ['objectId']=s_CURRENT_USER.objectId, ['username']=username}
                UserBaseServer.saveDataObjectOfCurrentUser(obj, 
                    function (api, result) 
                        s_CURRENT_USER.username = username
                        s_DATABASE_MGR.saveDataClassObject(s_CURRENT_USER)
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

function UserBaseServer.searchUserByNickName(nickName, onSucceed, onFailed)
    s_SERVER.search('classes/_User?where={"nickName":"' .. nickName .. '"}', onSucceed, onFailed)
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
    s_SERVER.search('classes/DataDailyCheckIn?where={"userId":"' .. s_CURRENT_USER.objectId .. '"}', onSucceed, onFailed)
end

function UserBaseServer.saveDailyCheckInOfCurrentUser(lastCheckInAward, onSucceed, onFailed)
    s_CURRENT_USER.dailyCheckInData.dailyCheckInAwards = lastCheckInAward
    UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER.dailyCheckInData,
        function (api, result) 
            if lastCheckInAward <= #s_DATA_MANAGER.dailyCheckIn then
                local metaDailyCheckIn = s_DATA_MANAGER.dailyCheckIn[lastCheckInAward]
                s_CURRENT_USER.energyCount = s_CURRENT_USER.energyCount + metaDailyCheckIn.count
                UserBaseServer.saveDataObjectOfCurrentUser(s_CURRENT_USER, nil, nil)
                AnalyticsDailyCheckIn(lastCheckInAward)
            end
            if onSucceed ~= nil then onSucceed(api, result) end
        end, 
        onFailed
    )
end

----

function UserBaseServer.getFollowersAndFolloweesOfCurrentUser(onResponse)
    s_SERVER.requestFollowersAndFollowees(s_CURRENT_USER.objectId, 
        function (api, result, err)
            if result ~= nil then
                s_CURRENT_USER:parseServerFolloweesData(result.followees) -- who I follow
                s_CURRENT_USER:parseServerFollowersData(result.followers) -- who follow me
            end
            if onResponse ~= nil then onResponse(api, result, err) end
        end)
end

function UserBaseServer.follow(targetDataUser, onResponse)
    s_SERVER.follow(s_CURRENT_USER.objectId, targetDataUser.objectId, onResponse)
end

function UserBaseServer.unfollow(targetDataUser, onResponse)
    s_SERVER.unfollow(s_CURRENT_USER.objectId, targetDataUser.objectId, onResponse)
end

function UserBaseServer.removeFan(fanDataUser, onSucceed, onFailed)
    s_SERVER.requestFunction('apiRemoveFan', {['myObjectId']=s_CURRENT_USER.objectId, ['fanObjectId']=fanDataUser.objectId}, onSucceed, onFailed)
end

----

function UserBaseServer.getDataLogIn(userId, week, onSucceed, onFailed)
    s_SERVER.search('classes/DataLogIn?where={"userId":"' .. userId .. '","week":' .. week .. '}', onSucceed, onFailed)
end

----
function UserBaseServer.getDataBookProgress(objectId, onSucceed, onFailed)
    s_SERVER.search('classes/DataBookProgress?where={"objectId":"' .. objectId.. '}', onSucceed, onFailed)
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
-- local function getLevels(userId, bookKey, onSucceed, onFailed)
--     s_SERVER.search('classes/DataLevel?where={"userId":"' .. userId .. '","bookKey":"' .. bookKey .. '"}', onSucceed, onFailed)
-- end
-- function UserBaseServer.getLevelsOfCurrentUser(onSucceed, onFailed)
--     getLevels(s_CURRENT_USER.objectId, s_CURRENT_USER.bookKey, onSucceed, onFailed)
-- end

----

---------------------------------------------------------------------------------------------------------------------

function UserBaseServer.saveDataObjectOfCurrentUser(dataObject, onSucceed, onFailed)
    local s = function (api, result)
        parseServerDataToUserData(result, dataObject)
        if onSucceed ~= nil then onSucceed(api, result) end
    end
    
    dataObject.userId = s_CURRENT_USER.objectId
    
    if string.len(dataObject.objectId) <= 0 then
        s_SERVER.createData(dataObject, s, onFailed)
    else
        s_SERVER.updateData(dataObject, s, onFailed)
    end
end

function UserBaseServer.saveWordProciencyOfCurrentUser(bookKey, wordName, prociencyValue, onSucceed, onFailed)
    local DataWordProciency = require('model/user/DataWordProciency')

    local dataObject = DataWordProciency.create()
    dataObject.userId = s_CURRENT_USER.objectId
    dataObject.bookKey = bookKey
    dataObject.wordName = wordName
    dataObject.prociencyValue = prociencyValue

    local s = function (api, result)
        if #result.results > 0 then
            for i, data in ipairs(result.results) do
                data.prociencyValue = dataObject.prociencyValue
                parseServerDataToUserData(data, dataObject)
                s_SERVER.updateData(dataObject, onSucceed, onFailed)
                break
            end
        else
            s_SERVER.createData(dataObject, onSucceed, onFailed)
        end
    end
    local f = function (api, result)
        s_SERVER.createData(dataObject, onSucceed, onFailed)        
    end

    s_SERVER.search('classes/DataWordProciency?where={"userId":"' .. dataObject.userId .. '","bookKey":"' .. dataObject.bookKey .. '","wordName":"' .. dataObject.wordName .. '"}', s, f)
end

return UserBaseServer

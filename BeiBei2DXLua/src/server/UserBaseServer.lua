-- onSucceed(api, result) -- result : json
-- onFailed(api, code, message, description)

require("common.global")

local UserBaseServer = {}

---------------------------------------------------------------------------------------------------------------------

function UserBaseServer.signup(username, password, onSucceed, onFailed)
    s_SERVER.request('apiSignUp', {['username']=username, ['password']=password}, onSucceed, onFailed)
end

function UserBaseServer.login(username, password, onSucceed, onFailed)
    s_SERVER.request('apiLogIn', {['username']=username, ['password']=password}, onSucceed, onFailed)
end

---------------------------------------------------------------------------------------------------------------------

--[[ api test
curl -X GET \
  -H "X-AVOSCloud-Application-Id: 9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l" \
  -H "X-AVOSCloud-Application-Key: 8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg" \
  -G \
  --data-urlencode 'cql=select include followee from _Followee where user=pointer("_User", "54128e44e4b080380a47debc")' \
  https://leancloud.cn/1.1/cloudQuery
]]--

-- CQL >>>

function UserBaseServer.dailyCheckInOfCurrentUser(onSucceed, onFailed)
    local cql = "select * from WMAV_DailyCheckInData where userId='" .. s_CURRENT_USER.userId .. "'"
    s_SERVER.CloudQueryLanguage(cql, onSucceed, onFailed)
end

-- who I follow
function UserBaseServer.getFolloweesOfCurrentUser(onSucceed, onFailed)
    local cql = string.format("select include followee from _Followee where user=pointer('_User', '%s')", s_CURRENT_USER.userId)
    s_SERVER.CloudQueryLanguageExtend('followee', cql, onSucceed, onFailed)
end

-- who follow me
function UserBaseServer.getFollowersOfCurrentUser(onSucceed, onFailed)
    local cql = string.format("select include follower from _Follower where user=pointer('_User', '%s')", s_CURRENT_USER.userId)
    s_SERVER.CloudQueryLanguageExtend('follower', cql, onSucceed, onFailed)
end

function UserBaseServer.getLevels(userId, bookKey, onSucceed, onFailed)
    local cql = "select * from WMAV_LevelData where userId='" .. userId .. "' and bookKey='" .. bookKey .. "'"
    s_SERVER.CloudQueryLanguage(cql, onSucceed, onFailed)
end

function UserBaseServer.getLevelsOfCurrentUser(onSucceed, onFailed)
    UserBaseServer.getLevels(s_CURRENT_USER.userId, s_CURRENT_USER.bookKey, onSucceed, onFailed)
end

-- CQL <<<

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

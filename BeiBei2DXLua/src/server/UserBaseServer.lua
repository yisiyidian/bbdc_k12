-- onSucceed(api, result) -- result : json
-- onFailed(api, code, message)

require("common.global")

local UserBaseServer = {}

function UserBaseServer.signup(username, password, onSucceed, onFailed)
    s_SERVER.request('apiSignUp', {['username']=username, ['password']=password}, onSucceed, onFailed)
end

function UserBaseServer.login(username, password, onSucceed, onFailed)
    s_SERVER.request('apiLogIn', {['username']=username, ['password']=password}, onSucceed, onFailed)
end

function UserBaseServer.dailyCheckInOfCurrentUser(onSucceed, onFailed)
    local cql = "select * from WMAV_DailyCheckInData where userId='" .. s_CURRENT_USER.userId .. "'"
    s_SERVER.CloudQueryLanguage(cql, onSucceed, onFailed)
end

-- who I follow
function UserBaseServer.getFolloweesOfCurrentUser(onSucceed, onFailed)
    local cql = string.format("select include followee from _Followee where user=pointer('_User', '%s')", s_CURRENT_USER.userId)
--    s_SERVER.CloudQueryLanguage(cql, function (api, result)
--        for i, v in ipairs(result.result.results) do
--        end 
--    end, onFailed)
    s_SERVER.CloudQueryLanguage(cql, onSucceed, onFailed)
end

-- who follow me
function UserBaseServer.getFollowers(onSucceed, onFailed)
    s_SERVER.request('apiGetFollowers', nil, onSucceed, onFailed)
end

function UserBaseServer.getLevels(userId, bookKey, onSucceed, onFailed)
    local cql = "select * from WMAV_LevelData where userId='" .. userId .. "' and bookKey='" .. bookKey .. "'"
    s_SERVER.CloudQueryLanguage(cql, onSucceed, onFailed)
end

function UserBaseServer.getLevelsOfCurrentUser(onSucceed, onFailed)
    UserBaseServer.getLevels(s_CURRENT_USER.userId, s_CURRENT_USER.bookKey, onSucceed, onFailed)
end

return UserBaseServer

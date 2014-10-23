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

function UserBaseServer.dailyCheckIn(onSucceed, onFailed)
    s_SERVER.request('apiUserDailyCheckin', nil, onSucceed, onFailed)
end

-- who I follow
function UserBaseServer.getFollowees(onSucceed, onFailed)
    s_SERVER.request('apiGetFollowees', nil, onSucceed, onFailed)
end

-- who follow me
function UserBaseServer.getFollowers(onSucceed, onFailed)
    s_SERVER.request('apiGetFollowers', nil, onSucceed, onFailed)
end

return UserBaseServer

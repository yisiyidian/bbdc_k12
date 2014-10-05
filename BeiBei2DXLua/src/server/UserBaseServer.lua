-- onSucceed(api, result) -- result : json
-- onFailed(api, code, message)

require("common.global")

local UserBaseServer = {}

function UserBaseServer.signin(username, password, onSucceed, onFailed)
    s_SERVER.request('apiSignIn', {['username']=username, ['password']=password}, onSucceed, onFailed)
end

function UserBaseServer.login(username, password, onSucceed, onFailed)
    s_SERVER.request('apiLogIn', {['username']=username, ['password']=password}, onSucceed, onFailed)
end

return UserBaseServer

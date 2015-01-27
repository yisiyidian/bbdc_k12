local ProtoBase = require('server.protocol.ProtocolBase')

-- callback(isExist, error)
function isUsernameExist(username, callback)
    local protocol = ProtoBase.create('searchusername', false, {['username']=username}, function (result, error)
        if error == nil then
            if callback then callback(result.datas.count > 0, nil) end
        else
            if callback then callback(nil, error) end
        end
    end)
    protocol:request()
end

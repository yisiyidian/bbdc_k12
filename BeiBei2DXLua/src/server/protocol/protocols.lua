local ProtoBase = require('server.protocol.ProtocolBase')

function isUsernameExist(username, callback)
    local protocol = ProtoBase.create('searchusername', false, {['username']=username}, callback)
    protocol:request()
end

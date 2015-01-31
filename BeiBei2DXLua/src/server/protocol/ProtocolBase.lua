
server = s_SERVER

local M = class("ProtocolBase", function()
    return {}
end)

-- api : string
-- t : bool
-- parameters : table
-- callback : function (result, error) 
--                   -> result: {['api']=api, ['t']=t, ['datas']=datas} -- datas is a table
--                   -> error: {['code']=code, ['message']=message, ['description']=description}
function M.create(api, t, parameters, callback)
    local protocol = M.new()
    protocol:init(api, t, parameters, callback)
    return protocol
end

function M:init(api, t, parameters, callback)
    self.api = api
    self.t = t
    self.parameters = parameters
    self.callback = callback
end

function M:ctor()
    self.api = nil
    self.t = false
    self.parameters = nil
    self.callback = nil
end

function M:request()
    if self.api == nil then
        if self.callback then 
            self.callback(nil, {['code']=ERROR_CODE_MAX, ['message']='API is nil', ['description']='API is nil'}) 
        else

        end
    else
        local cb = function (result, error) 
            self:onResponse(result, error)
            if self.callback then self.callback(result, error) end
        end
        server.request(self.api, self.t, self.parameters, cb)
    end
end

function M:onResponse(result, error)
end

return M

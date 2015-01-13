local DataClassBase = require('model.user.DataClassBase')

local DataIAP = class("DataIAP", function()
    return DataClassBase.new()
end)

function DataIAP.create()
    local data = DataIAP.new()
    return data
end

function DataIAP:ctor()
    self.className = 'DataIAP'
    
    self.pid = ''
    self.paymentInfo = 0
    self.isSucceed = 0
end

return DataIAP

local DataClassBase = require('model/user/DataClassBase')

local DataIAP = class("DataIAP", function()
    return DataClassBase.new()
end)

function DataIAP.create()
    local data = DataIAP.new()
    return data
end

function DataIAP:ctor()
    self.className = 'WMAV_IAPData'
    
    self.pid = ''
    self.paymentInfo = nil
    self.isSucceed = false
end

return DataIAP

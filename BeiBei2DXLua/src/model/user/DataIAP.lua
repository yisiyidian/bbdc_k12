local DataIAP = class("DataIAP", function()
    return {}
end)

function DataIAP.create()
    local data = DataIAP.new()
    data.userId = ''
    data.pid = ''
    data.paymentInfo = nil
    data.isSucceed = false
    return data
end

return DataIAP

local Manager = s_LocalDatabaseManager

local M = {}

function M.getUserDataFromLocalDB(objectOfDataClass, usertype)
    local lastLogIn = 0
    local data = nil
    print("SELECT * FROM " .. objectOfDataClass.className)
    for row in Manager.database:nrows("SELECT * FROM " .. objectOfDataClass.className) do
        print ('getUserDataFromLocalDB result:')
        
        local rowTime = row.updatedAt
        if rowTime <= 0 then
            rowTime = row.createdAt 
        end

        if rowTime > lastLogIn then
            print(string.format('getUserDataFromLocalDB updatedAt: objectIds:%s, userName:%s, updateAt:%f, lastLogIn:%f', row.objectId, row.username, row.updatedAt, lastLogIn))
            if usertype == USER_TYPE_GUEST then
                if (row.isGuest == 1 and row.usertype == nil) or row.usertype == USER_TYPE_GUEST then
                    lastLogIn = rowTime
                    data = row
                end
            elseif usertype == USER_TYPE_QQ then
                if row.usertype == USER_TYPE_QQ then
                    lastLogIn = rowTime
                    data = row
                end
            else
                lastLogIn = rowTime
                data = row
            end
        end
    end

    if data ~= nil then
        if data.usertype == nil then
            if data.isGuest == 1 then 
                data.usertype = USER_TYPE_GUEST
            else
                data.usertype = USER_TYPE_MANUAL
            end
        end
        parseLocalDBDataToClientData(data, objectOfDataClass)     
        return true
    end

    return false
end

return M
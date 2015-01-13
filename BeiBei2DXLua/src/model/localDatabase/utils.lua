local Manager = s_DATABASE_MGR

local M = {}

----------------------------------------------------------------------------------------------------

function M.createTable(objectOfDataClass)
    local sql = 'create table if not exists ' .. objectOfDataClass.className .. '(\n'

    local str = ''
    for key, value in pairs(objectOfDataClass) do  
        if (key == 'sessionToken'  
            or string.find(key, '__') ~= nil 
            or value == nil) == false then 

            if key == 'PRIMARY' then key = 'fuckprimary' end

            if (type(value) == 'string') then
                if string.len(str) > 1 then str = str .. ',\n' end
                str = str .. key .. ' TEXT'
            elseif (type(value) == 'boolean') then
                if string.len(str) > 1 then str = str .. ',\n' end
                str = str .. key .. ' Boolean'
            elseif (type(value) == 'number') then
                if string.len(str) > 1 then str = str .. ',\n' end
                str = str .. key .. ' INTEGER'
            end     
        end
    end

    sql = sql .. str .. '\n);'
    local ret = Manager.database:exec(sql)
    if ret ~= 0 then
        print ('\n\n\nSQLITE ERROR: >>>>>>>>>>>>')
        print ('M.createTable: ' .. objectOfDataClass.className .. ', ' .. tostring(ret))
        print (sql)
        print_lua_table (objectOfDataClass)
        print ('SQLITE ERROR: <<<<<<<<<<<<\n\n\n')
    end

    M.alterLocalDatabase(objectOfDataClass)
end

----------------------------------------------------------------------------------------------------
-- add new column
-- ALTER TABLE table_name ADD column_name datatype
function M.alterLocalDatabase(objectOfDataClass)
    local function createData (col, type, isAlreadyInDB)
        local data = {}
        data.col = col
        data.type = type
        data.isAlreadyInDB = isAlreadyInDB
        return data
    end

    local dataCols = {}
    for key, value in pairs(objectOfDataClass) do  
        if (key == 'sessionToken'  
            or string.find(key, '__') ~= nil 
            or value == nil) == false then 

            if key == 'PRIMARY' then key = 'fuckprimary' end

            local data = nil
            if (type(value) == 'string') then
                data = createData(key, 'TEXT', false)
            elseif (type(value) == 'boolean') then
                data = createData(key, 'Boolean', false)
            elseif (type(value) == 'number') then
                data = createData(key, 'INTEGER', false)
            end 
            if data ~= nil then
                dataCols[ key ] = data
            end
        end
    end

    Manager.database:exec('PRAGMA table_info(' .. objectOfDataClass.className .. ')', 
        function (udata, cols, values, names)
            local n = nil
            local t = nil
            for i = 1, cols do 
                if names[i] == 'name' then
                    n = values[i]
                elseif names[i] == 'type' then
                    t = values[i]
                end
            end

            if n ~= nil and t ~= nil then
                dataCols[ n ] = nil
            end

            return 0
        end)

    for k, v in pairs(dataCols) do
        if v ~= nil then
            Manager.database:exec('ALTER TABLE ' .. objectOfDataClass.className .. ' ADD ' .. v.col .. ' ' .. v.type)
        end
    end
end

----------------------------------------------------------------------------------------------------

function getInsertRecord(objectOfDataClass)
    local keys, values = '', ''
    for key, value in pairs(objectOfDataClass) do  
        if (key == 'sessionToken'  
            or string.find(key, '__') ~= nil 
            or value == nil) == false then 

            if key == 'PRIMARY' then key = 'fuckprimary' end

            if (type(value) == 'string') then
                if string.len(keys) > 0 then keys = keys .. ',' end
                keys = keys .. "'" .. key .. "'"

                if string.len(values) > 0 then values = values .. ',' end
                values = values .. "'" .. value .. "'"
            elseif (type(value) == 'boolean') then
                if string.len(keys) > 0 then keys = keys .. ',' end
                if string.len(values) > 0 then values = values .. ',' end
                    keys = keys .. "'" .. key .. "'"
                    values = values .. tostring(value)
                -- if value then
                --     keys = keys .. "'" .. key .. "'"
                --     values = values .. '1'
                -- else
                --     keys = keys .. "'" .. key .. "'"
                --     values = values .. '0'
                -- end
            elseif (type(value) == 'number') then
                if string.len(keys) > 0 then keys = keys .. ',' end
                keys = keys .. "'" .. key .. "'"

                if string.len(values) > 0 then values = values .. ',' end
                values = values .. value
            end
        end
    end
    return keys, values
end

function getUpdateRecord(objectOfDataClass)
    local str = ''
    for key, value in pairs(objectOfDataClass) do  
        if (key == 'sessionToken'  
            or string.find(key, '__') ~= nil 
            or value == nil) == false then 

            if key == 'PRIMARY' then key = 'fuckprimary' end

            if (type(value) == 'string') then
                if string.len(str) > 0 then str = str .. ',' end
                str = str .. "'" .. key .. "'" .. '=' .. "'" .. value .. "'"
            elseif (type(value) == 'boolean') then
                if string.len(str) > 0 then str = str .. ',' end
                str = str .. "'" .. key .. "'=" .. tostring(value)
                -- if value then
                --     str = str .. "'" .. key .. "'=1"
                -- else
                --     str = str .. "'" .. key .. "'=0"
                -- end
            elseif (type(value) == 'number') then
                if string.len(str) > 0 then str = str .. ',' end
                str = str .. "'" .. key .. "'" .. '=' .. value
            end     
        end
    end
    return str
end

-- recordsNum : 0 or positive integer
-- conditions : "' and bookKey = '"..bookKey.."' and dayString = '"..today.."' ;"
function M.saveData(objectOfDataClass, userId, username, recordsNum, conditions)
    conditions = conditions or ''
    M.alterLocalDatabase(objectOfDataClass)
    
    print ('\n\nManager saveData:' .. objectOfDataClass.className .. ' == ' .. tostring(getLocalSeconds() - objectOfDataClass.updatedAt) .. ', updatedAt:' .. tostring(objectOfDataClass.updatedAt) .. ', getLocalSeconds:' .. tostring(getLocalSeconds()))
    if objectOfDataClass.updatedAt > getLocalSeconds() then return end
    if objectOfDataClass.updatedAt < getLocalSeconds() then objectOfDataClass.updatedAt = getLocalSeconds() end
    local query = ''
    local ret = 'nothing saved'
    if recordsNum == 0 then
        local keys, values = getInsertRecord(objectOfDataClass)
        query = "INSERT INTO " .. objectOfDataClass.className .. " (" .. keys .. ")" .. " VALUES (" .. values .. ");"
        ret = Manager.database:exec(query)
    elseif userId ~= nil and userId ~= '' then
        query = "UPDATE " .. objectOfDataClass.className .. " SET " .. getUpdateRecord(objectOfDataClass) .. " WHERE userId = '".. userId .."'" .. conditions
        ret = Manager.database:exec(query)
    elseif username ~= nil and username ~= '' then
        query = "UPDATE " .. objectOfDataClass.className .. " SET " .. getUpdateRecord(objectOfDataClass) .. " WHERE username = '".. username .."'" .. conditions
        ret = Manager.database:exec(query)
    else
        query = "UPDATE " .. objectOfDataClass.className .. " SET " .. getUpdateRecord(objectOfDataClass) .. " WHERE objectId = '".. objectOfDataClass.objectId .."'" .. conditions
        ret = Manager.database:exec(query)
    end

    print ('[M saveData: result:' .. tostring(ret) .. ']: ' .. query .. '\n\n')
end

function M.addData(objectOfDataClass, userId, username)
    local hasRecords = 1
    M.saveData(objectOfDataClass, userId, username, hasRecords)
end

-- if record exists then update record
-- else create record
function M.saveDataClassObject(objectOfDataClass, userId, username)
    local searchSql = ''
    local num = 0
    if objectOfDataClass.objectId ~= '' then
        local searchSql = "SELECT * FROM " .. objectOfDataClass.className .. " WHERE objectId = '".. objectOfDataClass.objectId .."'"
        print ('M.saveDataClassObject: ' .. searchSql)
        for row in Manager.database:nrows(searchSql) do
            num = num + 1
            break
        end
    end

    if num == 0 and userId ~= nil and userId ~= '' then
        local searchSql = "SELECT * FROM " .. objectOfDataClass.className .. " WHERE userId = '".. userId .."'"
        print ('M.saveDataClassObject: ' .. searchSql)
        for row in Manager.database:nrows(searchSql) do
            num = num + 1
            break
        end
    end

    if num == 0 and username ~= nil and username ~= '' then
        local searchSql = "SELECT * FROM " .. objectOfDataClass.className .. " WHERE username = '".. username .."'"
        print ('M.saveDataClassObject: ' .. searchSql)
        for row in Manager.database:nrows(searchSql) do
            num = num + 1
            break
        end
    end

    M.saveData(objectOfDataClass, nil, username, num)
end

----------------------------------------------------------------------------------------------------

function M.getDatas(classNameOfDataClass, userId, username)
    local sql = ''
    local sqlUsername = string.format('SELECT * FROM %s WHERE username = "%s"', classNameOfDataClass, username)
    local sqlUserId = string.format('SELECT * FROM %s WHERE userId = "%s"', classNameOfDataClass, userId)
    if username ~= '' then
        sql = sqlUsername
    elseif userId ~= '' then
        sql = sqlUserId
    end
    if sql == '' then return {} end

    local ret = {}
    for row in Manager.database:nrows(sql) do
        table.insert(ret, row)
    end
    if #ret == 0 and sql == sqlUsername and userId ~= '' then
        for row in Manager.database:nrows(sqlUserId) do
            table.insert(ret, row)
        end
    end
    return ret
end

return M


require("common.global")
local OfflineTip = require("view.offlinetip.OfflineTipForHome")

local UserBaseServer = {}

---------------------------------------------------------------------------------------------------------------------

function validateUsername(s)
    local length = string.len(s)
    if length < 1 then return false end
    print(string.format('validateUsername:0 name:%s, str length:%d', s, length))

    local c = s:sub(1, 1)
    local ord = c:byte()
    if (ord >= 65 and ord <= 90) or (ord >= 97 and ord <= 122) or ord > 128 then 
        local i = 1
        local len = 0
        local lenChinese = 0
        while i <= length do
            local c = s:sub(i, i)
            local ord = c:byte()
            local isChinese = false
            if (ord >= 48 and ord <= 57) or(ord >= 65 and ord <= 90) or (ord >= 97 and ord <= 122) or ord > 128 then
                if ord > 128 then
                    i = i + 3
                    isChinese = true
                else
                    i = i + 1
                end
            else
                print(string.format('validateUsername:1 name:%s, str length:%d, c:%s', s, length, c))
                return false
            end

            len = len + 1
            if isChinese then lenChinese = lenChinese + 1 end
        end

        if lenChinese < 2 and (len < 2 or len > 10) then 
          print(string.format('validateUsername:2 name:%s, str length:%d, name len:%d, lenChinese:%d', s, length, len, lenChinese))
          return false 
        end
    else
        return false
    end

    return true
end

--验证邮箱
function validateEmail(email)
    if (email:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then 
        -- print(email .. " is a valid email address") 
        return true
    else 
        -- print(email .. " is a invalid email address") 
        return false
    end 
end

function validatePassword(s)
    local length = string.len(s)
    if length < 6 or length > 16 then return false end

    local modifiedString, numberOfSubstitutions = string.gsub(s, '[0-9a-zA-Z]', '')
    print(string.format('%s, %d, %s, %d', s, length, modifiedString, numberOfSubstitutions))
    return numberOfSubstitutions >= 6 and numberOfSubstitutions <= 16 and numberOfSubstitutions == length
end

local function parseServerUser( objectjson )
    local user = s_JSON.decode(objectjson)
    s_CURRENT_USER.sessionToken = user.sessionToken
    s_SERVER.sessionToken = user.sessionToken
    parseServerDataToClientData(user, s_CURRENT_USER)
    return true
end

--注册或者登陆之后的回调
function onResponse_signUp_logIn(hasParsed, objectjson, e, code, onResponse)
    if e ~= nil then 
        print('signup/logIn:' .. e) 
        if onResponse ~= nil then onResponse(s_CURRENT_USER, e, code) end
    elseif objectjson ~= nil then 
        --没有错误  直接返回数据
        print('signup/logIn:' .. type(objectjson) .. ',  ' .. objectjson)
        if hasParsed == false then parseServerUser( objectjson ) end
        --
        s_CURRENT_USER.userId = s_CURRENT_USER.objectId
        s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER, nil, s_CURRENT_USER.username)
        s_LocalDatabaseManager.setLogOut(false)
        
        if onResponse ~= nil then onResponse(s_CURRENT_USER, nil, code) end
    else
        print('signup/logIn:no sessionToken') 
        if onResponse ~= nil then onResponse(s_CURRENT_USER, 'no sessionToken', code) end
    end
end

-- https://cn.avoscloud.com/docs/error_code.html
-- 注册用户 首次安装会进这里 注册一个匿名的账号
-- 卸载再安装的话，就会生成一个新的匿名账号
--username 帐号
--password 密码
---onResponese 回调函数
-- function (user data, error description, error code)
function UserBaseServer.signUp(username, password, onResponse)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    cx.CXAvos:getInstance():signUp(username, password, function (objectjson, e, code)
        onResponse_signUp_logIn(false, objectjson, e, code, onResponse)
    end)
end

-- function (user data, error description, error code)
function UserBaseServer.logIn(username, password, onResponse)
    s_CURRENT_USER.username = username
    s_CURRENT_USER.password = password
    -- dump(s_CURRENT_USER,"UserBaseServer.logIn登陆前数据")
    cx.CXAvos:getInstance():logIn(username, password, function (objectjson, e, code)
        dump(objectjson,"登陆返回数据")
        onResponse_signUp_logIn(false, objectjson, e, code, onResponse)
    end)
end

--用手机号码+密码登陆
function UserBaseServer.loginByPhoneNumber(phoneNumber,password,onResponse)
    s_CURRENT_USER.username = ""
    s_CURRENT_USER.mobilePhoneNumber = phoneNumber
    s_CURRENT_USER.password = password

    cx.CXAvos:getInstance():logInByPhoneNumber(phoneNumber, password, function (objectjson, e, code)
        dump(objectjson,"登陆返回数据")
        onResponse_signUp_logIn(false, objectjson, e, code, onResponse)
    end)
end

function UserBaseServer.logInByQQAuthData(openid, access_token, expires_in, onResponse)
    cx.CXAvos:getInstance():logInByQQAuthData(openid, access_token, expires_in,
        function (objectjson, qqjson, authjson, e, code)
            onResponse_signUp_logIn(false, objectjson, e, code, onResponse)
        end
    )
end


-- function UserBaseServer.changePa( ... )
--     -- body
-- end

-- ["access_token"] = "F24DE9192D4FB7E96594D33AEAD3E848",
-- ["openid"] = "4736E8D1D0A42BF6DF94F7A972CDD933",
-- ["expires_in"] = "1427014567",

-- ["yellow_vip_level"] = "0",
-- ["figureurl_1"] = "http://qzapp.qlogo.cn/qzapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/50",
-- ["figureurl_qq_2"] = "http://q.qlogo.cn/qqapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/100",
-- ["city"] = "深圳",
-- ["level"] = "0",
-- ["figureurl_qq_1"] = "http://q.qlogo.cn/qqapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/40",
-- ["is_lost"] = 0,
-- ["nickname"] = "qzuser",
-- ["figureurl"] = "http://qzapp.qlogo.cn/qzapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/30",
-- ["is_yellow_year_vip"] = "0",
-- ["ret"] = 0,
-- ["vip"] = "0",
-- ["year"] = "1990",
-- ["gender"] = "男",
-- ["figureurl_2"] = "http://qzapp.qlogo.cn/qzapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/100",
-- ["msg"] = "",
-- ["is_yellow_vip"] = "0",
-- ["province"] = "广东",
function UserBaseServer.onLogInByQQ(onResponse)
    s_CURRENT_USER.usertype = USER_TYPE_QQ
    local isParsed = false
    cx.CXAvos:getInstance():logInByQQ(function (objectjson, qqjson, authjson, e, code)
        if e == nil and qqjson ~= nil and authjson ~= nil then
            if objectjson ~= nil then 
                isParsed = parseServerUser( objectjson ) 
                print ('---- QQ USER INFO ----')
                print_lua_table (s_CURRENT_USER)
            end

            local qqUserInfo = s_JSON.decode(qqjson)
            local authData = s_JSON.decode(authjson)
            s_CURRENT_USER.localAuthData = authData
            s_CURRENT_USER.snsUserInfo = qqUserInfo

            if authData ~= nil and qqUserInfo ~= nil then 
                print ('---- QQ USER INFO authData ----')
                print_lua_table (authData)

                s_CURRENT_USER.access_token = s_CURRENT_USER.localAuthData.access_token
                s_CURRENT_USER.openid = s_CURRENT_USER.localAuthData.openid
                s_CURRENT_USER.expires_in = s_CURRENT_USER.localAuthData.expires_in
    
                print ('')

                print ('---- QQ USER INFO qqUserInfo ----')
                print_lua_table (qqUserInfo)

                s_CURRENT_USER.nickName = s_CURRENT_USER.snsUserInfo.nickname
                -- save nick name
                local obj = {['nickName']=s_CURRENT_USER.snsUserInfo.nickname,
                             ['access_token']=s_CURRENT_USER.localAuthData.access_token,
                             ['openid']=s_CURRENT_USER.localAuthData.openid,
                             ['usertype']=USER_TYPE_QQ}
                saveUserToServer(obj, function (datas, error) onResponse_signUp_logIn(isParsed, objectjson, e, code, onResponse) end)
            end
        else
            onResponse_signUp_logIn(isParsed, objectjson, e, code, onResponse)
        end
    end)
end

-- function (username, password, error description, error code)
--oldPwd 通过个人信息面板修改密码的时候
function UserBaseServer.updateUsernameAndPassword(username, password, onResponse ,oldPwd)
    if not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken() then
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onResponse ~= nil then onResponse(username, password, s_TIPS_LAYER.offlineOrNoSessionTokenTip, ERROR_CODE_MAX) end
        return
    end
    -- 修改密码成功回调
    local onCompleted = function ()
        s_CURRENT_USER.password = password
        s_CURRENT_USER.usertype = USER_TYPE_BIND

        saveUserToServer({['usertype']=USER_TYPE_BIND,["sex"]=s_CURRENT_USER.sex}, function (datas, error)
            onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, nil, 0)
        end)
    end

    local change_password = function (password, onResponse)
        if s_CURRENT_USER.password ~= password or oldPwd ~= nil then
            --如果新旧密码不一致 老的修改逻辑
            --如果oldPwd不为nil 新的修改逻辑
            local oPwd = nil
            if oldPwd~=nil then
                oPwd = oldPwd
            else
                oPwd = s_CURRENT_USER.password
            end
            
            s_SERVER.updatePassword(oPwd, password, s_CURRENT_USER.objectId, 
                function (api, result)
                    onCompleted()
                end, 
                function (api, code, message, description) 
                    onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, description, code)
                end)

        else
            onCompleted()
        end
    end

    if s_CURRENT_USER.username ~= username then

        isUsernameExist(username, function (exist, error)
            if error ~= nil then
                onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, error.description, error.code)
            elseif not exist then
                saveUserToServer({['username']=username}, function (datas, error)
                    if error ~= nil then
                        onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, error.description, error.code)
                    else
                        s_CURRENT_USER.username = username
                        s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER, s_CURRENT_USER.userId, s_CURRENT_USER.username)
                        change_password(password, onResponse)
                    end
                end)
            else
                onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, s_DataManager.getTextWithIndex(TEXT__USERNAME_HAS_ALREADY_BEEN_TAKEN), ERROR_CODE_MAX)
            end
        end)

    else
        change_password(password, onResponse)
    end
end

--更新登陆信息
--username 昵称 在老版本的登陆里,昵称作为username,在新版本的登陆里昵称就是昵称,不允许用昵称登陆
--password 密码
--phoneNumber 手机号码
--onResponse  回调函数
--sex 性别
function UserBaseServer.updateLoginInfo(username, password, phoneNumber,onResponse,nickName,sex)
    if not s_SERVER.isNetworkConnectedNow() or not s_SERVER.hasSessionToken() then
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onResponse ~= nil then onResponse(username, password, phoneNumber,s_TIPS_LAYER.offlineOrNoSessionTokenTip, ERROR_CODE_MAX) end
        return
    end
    --修改密码成功回调
    local onCompleted = function()
        s_CURRENT_USER.password = password
        s_CURRENT_USER.usertype = USER_TYPE_BIND

        saveUserToServer({['usertype']=USER_TYPE_BIND}, function (datas, error)
            onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password,s_CURRENT_USER.mobilePhoneNumber ,nil, 0)
        end)
    end

    --调用Server里修改密码的方法
    --修改username 和 mobilePhoneNumber成功的回调
    local nameAndPhoneComplete = function (password)
        if s_CURRENT_USER.password ~= password then
            s_SERVER.updatePassword(s_CURRENT_USER.password, password, s_CURRENT_USER.objectId, 
                function (api, result) 
                    onCompleted()
                end, 
                function (api, code, message, description) 
                    onResponse(s_CURRENT_USER.username, s_CURRENT_USER.password, description, code)
                end)
        else
            onCompleted()
        end
    end

    if s_CURRENT_USER.mobilePhoneNumber ~= phoneNumber then
        --判断手机号是否已存在
        isPhoneNumberExist(phoneNumber,function (exist,error)
            if error ~= nil then
                --手机号码已存在
                onResponse(s_CURRENT_USER.username,password,s_CURRENT_USER.mobilePhoneNumber,error.description,error.code)
            elseif not exist then
                if s_CURRENT_USER.nickName ~= nickName then
                    saveUserToServer({["nickName"]=nickName,["mobilePhoneNumber"]=phoneNumber,['sex']=sex}, function(datas,error)
                        if error ~= nil then
                            onResponse(s_CURRENT_USER.username,s_CURRENT_USER.password,phoneNumber,error.description,error.code)
                        else
                            s_CURRENT_USER.nickName = nickName
                            s_CURRENT_USER.mobilePhoneNumber = phoneNumber
                            s_LocalDatabaseManager.saveDataClassObject(s_CURRENT_USER,s_CURRENT_USER.userId,s_CURRENT_USER.username)
                            nameAndPhoneComplete(password)
                        end
                    end)
                end
            end            
        end)
    else
        --手机号码已绑定
        print("s_CURRENT_USER.mobilePhoneNumber:"..s_CURRENT_USER.mobilePhoneNumber)
        print("phoneNumber:"..phoneNumber)
    end
end

---------------------------------------------------------------------------------------------------------------------

-- onSucceed(api, result) -- result : json
-- onFailed(api, code, message, description)

---------------------------------------------------------------------------------------------------------------------

--[[ api test
curl -X GET \
  -H "X-AVOSCloud-Application-Id: 9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l" \
  -H "X-AVOSCloud-Application-Key: 8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg" \
  -G \
  --data-urlencode 'cql=select include followee from _Followee where user=pointer("_User", "54128e44e4b080380a47debc")' \
  https://leancloud.cn/1.1/cloudQuery
]]--

--[[
curl -X GET \
  -H "X-AVOSCloud-Application-Id: 9xbbmdasvu56yv1wkg05xgwewvys8a318x655ejuay6yw38l" \
  -H "X-AVOSCloud-Application-Key: 8985fsy50arzouq9l74txc25akvjluygt83qvlcvi46xsagg" \
  -G \
  --data-urlencode 'cql=select * from _User where username="yehanjie1"' \
  https://leancloud.cn/1.1/cloudQuery
]]--
function UserBaseServer.searchUserByUserName(username, onSucceed, onFailed)
    if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
        s_SERVER.search('classes/_User?where={"username":"' .. username .. '"}', onSucceed, onFailed)
    else
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onFailed ~= nil then onFailed('searchUserByUserName', -1, '', '') end
    end
end

function UserBaseServer.searchUserByNickName(nickName, onSucceed, onFailed)
    if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
        s_SERVER.search('classes/_User?where={"nickName":"' .. nickName .. '"}', onSucceed, onFailed)
    else
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onFailed ~= nil then onFailed('searchUserByNickName', -1, '', '') end
    end
end

----

function UserBaseServer.getFollowersAndFolloweesOfCurrentUser(onResponse)
    if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
        s_SERVER.requestFollowersAndFollowees(s_CURRENT_USER.objectId, 
            function (api, result, err)
                if result ~= nil then
                    s_CURRENT_USER:parseServerFolloweesData(result.followees) -- who I follow
                    s_CURRENT_USER:parseServerFollowersData(result.followers) -- who follow me
                end
                if onResponse ~= nil then onResponse(api, result, err) end
            end)
    else
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onResponse ~= nil then onResponse('unfollow', nil, 'err') end
    end
end

function UserBaseServer.getFollowersOfCurrentUser(onResponse)
    if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
        s_SERVER.requestFollowers(s_CURRENT_USER.objectId, 
            function (api, result, err)
                if result ~= nil then
                    s_CURRENT_USER:parseServerFollowersData(result.results) -- who follow me
                end
                if onResponse ~= nil then onResponse(api, result, err) end
            end)
    else
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onResponse ~= nil then onResponse('unfollow', nil, 'err') end
    end
end

function UserBaseServer.getFolloweesOfCurrentUser(onResponse)
    if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
        s_SERVER.requestFollowees(s_CURRENT_USER.objectId, 
            function (api, result, err)
                if result ~= nil then
                    s_CURRENT_USER:parseServerFolloweesData(result.results) -- who I follow
                end
                if onResponse ~= nil then onResponse(api, result, err) end
            end)
    else
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onResponse ~= nil then onResponse('unfollow', nil, 'err') end
    end
end

function UserBaseServer.follow(targetDataUser, onResponse)
    if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
        s_SERVER.follow(s_CURRENT_USER.objectId, targetDataUser.objectId, onResponse)
    else
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onResponse ~= nil then onResponse('unfollow', nil, 'err') end
    end
end

function UserBaseServer.unfollow(targetDataUser, onResponse)
    if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
        s_SERVER.unfollow(s_CURRENT_USER.objectId, targetDataUser.objectId, onResponse)
    else
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onResponse ~= nil then onResponse('unfollow', nil, 'err') end
    end
end

function UserBaseServer.removeFan(fanDataUser, onSucceed, onFailed)
    if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
        s_SERVER.requestFunction('apiRemoveFan', {['myObjectId']=s_CURRENT_USER.objectId, ['fanObjectId']=fanDataUser.objectId}, onSucceed, onFailed)
    else
        s_TIPS_LAYER:showTip(s_TIPS_LAYER.offlineOrNoSessionTokenTip)
        if onFailed ~= nil then onFailed('apiRemoveFan', -1, '', '') end
    end
end

---------------------------------------------------------------------------------------------------------------------

function UserBaseServer.saveDataObjectOfCurrentUser(dataObject, onSucceed, onFailed)
    local s = function (api, result)
        parseServerDataToClientData(result, dataObject)
        if onSucceed ~= nil then onSucceed(api, result) end
    end
    
    updateDataFromUser(dataObject, s_CURRENT_USER)
    
    if s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken() then
        if string.len(dataObject.objectId) <= 0 then
            s_SERVER.createData(dataObject, s, onFailed)
        else
            s_SERVER.updateData(dataObject, s, onFailed)
        end
    else
        s_LocalDatabaseManager.saveDataClassObject(dataObject, s_CURRENT_USER.userId, s_CURRENT_USER.username)
        s ('saveDataObjectOfCurrentUser ' .. dataObject.className, nil)
    end
end

-- function UserBaseServer.saveDataNewPlayState()
--     UserBaseServer.synBookRelations({'DataNewPlayState'}, nil, false)
-- end

-- function UserBaseServer.saveDataWrongWordBuffer()
--     UserBaseServer.synBookRelations({'DataWrongWordBuffer'}, nil, false)
-- end

-- function UserBaseServer.saveDataTodayReviewBossNum()
--     UserBaseServer.synBookRelations({'DataTodayReviewBossNum'}, nil, false)
-- end

-- function UserBaseServer.synBookRelations(classNames, onCompleted, saveToLocalDB)
--     if not (s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()) then
--         if onCompleted then onCompleted() end
--         return
--     end

--     if s_CURRENT_USER.bookKey == '' then 
--         if onCompleted then onCompleted() end
--         return 
--     end

--     local all = {'DataNewPlayState', 'DataWrongWordBuffer', 'DataTodayReviewBossNum'}
--     classNames = classNames or all
--     saveToLocalDB = saveToLocalDB or true

--     print ('synBookRelations AAA >>>')
--     print_lua_table (classNames)

--     local objs = {}
--     objs.className = 'DataBookRelations'
--     objs.bookKey = s_UserBaseServer.bookKey
--     updateDataFromUser(objs, s_CURRENT_USER)

--     local clientDatas = {}
--     for key, value in pairs(classNames) do
--         if value == 'DataNewPlayState' then
--             local data = s_LocalDatabaseManager.getDataNewPlayState()
--             if data ~= nil then
--                 objs['lastUpdate' .. value] = data.lastUpdate
--                 objs.playModel = data.playModel
--                 objs.rightWordList = data.rightWordList
--                 objs.wrongWordList = data.wrongWordList
--                 objs.wordCandidate = data.wordCandidate
--                 clientDatas[value] = data
--             end
--         elseif value == 'DataWrongWordBuffer' then
--             local data = s_LocalDatabaseManager.getDataWrongWordBuffer()
--             if data ~= nil then
--                 objs['lastUpdate' .. value] = data.lastUpdate
--                 objs.wordNum = data.wordNum
--                 objs.wordBuffer = data.wordBuffer
--                 clientDatas[value] = data
--             end
--         elseif value == 'DataTodayReviewBossNum' then
--             local data = s_LocalDatabaseManager.getDataTodayTotalBoss()
--             if data ~= nil then
--                 objs['lastUpdate' .. value] = data.lastUpdate
--                 objs.bossNum = data.bossNum
--                 clientDatas[value] = data
--             end
--         end
--     end

--     print ('\n')
--     print_lua_table (objs)
--     print ('synBookRelations AAA <<<')

--     s_SERVER.synData(objs, 
--         function (api, result) 
--             print ('synBookRelations synData >>>')
--             print_lua_table (result)
            
--             if saveToLocalDB == true then
--                 -- update local db data
--                 for key, value in pairs(clientDatas) do
--                     local timestamp = result['lastUpdate'..key]
--                     if timestamp ~= nil and value['lastUpdate'] ~= nil and timestamp > value['lastUpdate'] then
--                         value['lastUpdate'] = timestamp
--                         if key == 'DataNewPlayState' then
--                             s_LocalDatabaseManager.saveDataNewPlayState(result.playModel, result.rightWordList, result.wrongWordList, result.wordCandidate, timestamp)
--                         elseif key == 'DataWrongWordBuffer' then
--                             s_LocalDatabaseManager.saveDataWrongWordBuffer(result.wordNum, result.wordBuffer, timestamp)
--                         elseif key == 'DataTodayReviewBossNum' then
--                             s_LocalDatabaseManager.saveDataTodayReviewBossNum(result.bossNum, timestamp)
--                         end
--                     end
--                 end -- for
--             end

--             print ('synBookRelations synData <<<')

--             if onCompleted then onCompleted() end
--         end, 
--         function (api, code, message, description) 
--             if onCompleted then onCompleted() end
--         end)
-- end

-- function UserBaseServer.synTodayDailyStudyInfo(data, onCompleted, saveToLocalDB)
--     if not (s_SERVER.isNetworkConnectedNow() and s_SERVER.hasSessionToken()) then
--         if onCompleted then onCompleted() end
--         return
--     end

--     saveToLocalDB = saveToLocalDB or true

--     s_SERVER.synData(data, 
--         function (api, result) 
--             print ('synTodayDailyStudyInfo >>>')
--             print_lua_table (result)
--             print ('synTodayDailyStudyInfo <<<')

--             local timestamp = result['lastUpdate']
--             if saveToLocalDB and timestamp ~= nil and data.lastUpdate ~= nil and timestamp > data.lastUpdate then
--                 parseServerDataToClientData(result, data)
--                 s_LocalDatabaseManager.saveDataDailyStudyInfo(data)
--             end

--             if onCompleted then onCompleted() end
--         end, 
--         function (api, code, message, description)
--             if onCompleted then onCompleted() end 
--         end)
-- end

return UserBaseServer

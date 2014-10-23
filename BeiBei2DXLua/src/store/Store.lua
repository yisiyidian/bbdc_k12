local Store = {}

Store.isRequestProductsSucceed = false

function Store.init()
    s_logd('getTargetPlatform:' .. cc.Application:getInstance():getTargetPlatform())
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
    --xiao mi
    --AppID： 2882303761517265897
    --AppKey： 5291726510897
    --AppSecret： je+JDjdcf6lgRDrb9FaNKw==

        local appKey = "AAE74B88-AB0E-4345-E14C-867708E18AFA"
        local appSecret = "a254b3174edb02ed4a93b231887cddf1"
        local privateKey = "DADD0816DB496CA2C98A34D9A616BD55"
        local oauthLoginServer = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php"
        local agent = AgentManager:getInstance()
        agent:init(appKey,appSecret,privateKey,oauthLoginServer)
    
        agent:loadALLPlugin()
    end
end

-- function onResult( code, msg, info )   --code: pay result code, msg: par result message, info: product info
function Store.buy(onResult)
    local productId = "com.beibei.wordmaster.ep30"
    --- android
    --支付成功           kPaySuccess null或者错误信息的简单描述
    --支付取消           kPayCancel  null或者错误信息的简单描述
    --支付失败           kPayFail    null或者错误信息的简单描述
    --支付网络出现错误     kPayNetworkError    null或者错误信息的简单描述
    --支付信息提供不完全   kPayProductionInforIncomplete   null或者错误信息的简单描述
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
        local info = {
            Product_Price="6", 
            Product_Id=productId,  
            Product_Name="贝贝体力值30点",  
            Server_Id="1",  
            Product_Count="1",  
            Role_Id=s_CURRENT_USER.userId,  
            Role_Name=s_CURRENT_USER.username,
            Role_Grade=s_CURRENT_USER.currentLevelIndex
        }
        for key, value in pairs(iap_plugin_maps) do
            value:payForProduct(info)
            value:setResultListener(onResult)
        end
    --- iOS
    -- kPaySuccess = 0,
    -- kPayFail,
    -- kPayCancel,
    -- kPayTimeOut,
    elseif Store.isRequestProductsSucceed == true then
        cx.CXStore:getInstance():payForProduct(productId, onResult)
    else
        -- RequestSuccees=0,
        -- RequestFail,
        -- RequestTimeout,
        cx.CXStore:getInstance():requestProducts(productId, function (ret, json)
            if ret == 0 then
                Store.isRequestProductsSucceed = true
                cx.CXStore:getInstance():payForProduct(productId, onResult)
            elseif onResult ~= nil then
                onResult(ret, json, info)
            end
        end)
    end
end

return Store

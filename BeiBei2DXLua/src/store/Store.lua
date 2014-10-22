local Store = {}

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

return Store

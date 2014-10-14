
function initGlobal()
    require("model.ReadAllWord")

    s_spineCoconutLightJson   = "res/spine/coconut_light.json"
    s_spineCoconutLightAtalas = "res/spine/coconut_light.atlas"

    s_APP_VERSION             = 150
    s_SCENE_WIDTH             = 1.0
    s_SCREEN_HEIGHT           = 1.0
    s_HEIGHT                  = 1136.0
    s_HEIGHT_SCALE            = 1.0

    s_debugger                = require("common.debugger")
    s_logd                    = s_debugger.logd
    s_json                    = require('json')

    s_SCENE                   = nil
    s_SERVER                  = require('server.Server')
    local userbaseserver      = require('server.UserBaseServer')
    s_funcSignin              = userbaseserver.signin
    s_funcLogin               = userbaseserver.login

    --global function
    s_spineCoconutLightJson   = "res/spine/coconut_light.json"
    s_spineCoconutLightAtalas = "res/spine/coconut_light.atlas"

    --global variate
    s_WordPool                = ReadAllWord()
    s_CorePlayManager         = nil
end

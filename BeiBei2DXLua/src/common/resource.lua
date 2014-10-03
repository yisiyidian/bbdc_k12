s_spineCoconutLightJson   = "res/spine/coconut_light.json"
s_spineCoconutLightAtalas = "res/spine/coconut_light.atlas"

s_debugger                = nil
s_logd                    = nil
s_json                    = nil

s_SCENE                   = nil
s_SERVER                  = nil

--global class
s_flipNode                = nil
s_flipMat                 = nil

--global function
s_randomMat               = nil

function initGlobal()
    s_debugger                = require("common.debugger")
    s_logd                    = s_debugger.logd
    s_json                    = require('json')

    s_SCENE                   = nil
    s_SERVER                  = require('server.Server')

    --global class
    s_flipNode                = require("model.flipNode")
    s_flipMat                 = require("model.flipMat")

    --global function
    s_randomMat               = require("model.randomMat")
end
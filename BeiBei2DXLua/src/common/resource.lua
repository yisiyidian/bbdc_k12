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

s_HEIGHT                  = 1136.0
s_HEIGHT_SCALE            = 1.0

function initGlobal()
    s_debugger                = require("common.debugger")
    s_logd                    = s_debugger.logd
    s_json                    = require('json')

    s_SCENE                   = nil
    s_SERVER                  = require('server.Server')

    --global class
    s_flipNode                = require("model.FlipNode")
    s_flipMat                 = require("model.FlipMat")

    --global function
    s_randomMat               = require("model.RandomMat")
end
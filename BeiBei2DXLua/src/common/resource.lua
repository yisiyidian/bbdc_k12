s_spineCoconutLightJson   = "res/spine/coconut_light.json"
s_spineCoconutLightAtalas = "res/spine/coconut_light.atlas"

s_debugger                = nil
s_logd                    = nil
s_json                    = nil

s_SCENE                   = nil
s_SERVER                  = nil

--global class
s_FlipNode                = nil
s_FlipMat                 = nil

--global function
s_RandomMat               = nil

s_SCENE_WIDTH             = 1.0
s_SCREEN_HEIGHT           = 1.0
s_HEIGHT                  = 1136.0
s_HEIGHT_SCALE            = 1.0

function initGlobal()
    s_debugger                = require("common.debugger")
    s_logd                    = s_debugger.logd
    s_json                    = require('json')

    s_SCENE                   = nil
    s_SERVER                  = require('server.Server')

    --global class
    s_FlipNode                = require("model.FlipNode")
    s_FlipMat                 = require("model.FlipMat")

    --global function
    s_RandomMat               = require("model.RandomMat")
end

local function _initConstant()
    --
    s_spineCoconutLightJson   = "res/spine/coconut_light.json"
    s_spineCoconutLightAtalas = "res/spine/coconut_light.atlas"

    s_DATA_MANAGER = require('model.DataManager')
end

local function _initTool()
    -- tools
    s_JSON = require('json')

    -- debug
    s_debugger = require("common.debugger")
    s_debugger.configLog(true, true)
    s_logd     = s_debugger.logd
    s_logdStr  = s_debugger.logdStr

    require('common.utils')
end

local function _initScene()
    -- size
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local _SCREEN_WIDTH  = size.width
    local _SCREEN_HEIGHT = size.height
    
    -- ********************** --
    s_DESIGN_WIDTH  = 640.0
    s_DESIGN_HEIGHT = 1136.0
    -- ********************** --

    local _HEIGHT        = _SCREEN_HEIGHT
    local _HEIGHT_SCALE  = _SCREEN_HEIGHT / s_DESIGN_HEIGHT
    local _WIDTH         = s_DESIGN_WIDTH * _HEIGHT_SCALE

    -- ********************** --
    s_DESIGN_OFFSET_WIDTH = (_SCREEN_WIDTH - _WIDTH) / 2.0 / _HEIGHT_SCALE
    s_LEFT_X = -s_DESIGN_OFFSET_WIDTH
    s_RIGHT_X = s_DESIGN_WIDTH + s_DESIGN_OFFSET_WIDTH
    -- ********************** --

    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(s_DESIGN_WIDTH, s_DESIGN_HEIGHT, cc.ResolutionPolicy.FIXED_HEIGHT)

    -- create main scene 
    local scene = require("AppScene")
    s_SCENE = scene.create()
    -- layers of main scene
    s_BG_LAYER                = s_SCENE.bgLayer
    s_GAME_LAYER              = s_SCENE.gameLayer
    s_HUD_LAYER               = s_SCENE.hudLayer
    s_POPUP_LAYER             = s_SCENE.popupLayer
    s_TIPS_LAYER              = s_SCENE.tipsLayer
    s_TOUCH_EVENT_BLOCK_LAYER = s_SCENE.touchEventBlockLayer
    s_DEBUG_LAYER             = s_SCENE.debugLayer
end

local function _initServer()
    -- server
    s_SERVER                  = require('server.Server')
    s_SERVER.debugLocalHost   = false -- 'http://localhost:3000/avos/'
    s_SERVER.isAppStoreServer = false
    -- user base server
    local userbaseserver      = require('server.UserBaseServer')
    s_funcSignin              = userbaseserver.signin
    s_funcLogin               = userbaseserver.login
end

local function _declaration()
    s_WordPool        = nil
    s_CorePlayManager = nil
end

function initApp()
    -- versions
    s_APP_VERSION = 150

    _initConstant()
    _initTool()
    _initScene()
    _initServer()
    _declaration()
end



local function _initConstant()
    -- number
    s_max_wrong_num_everyday  = 5
    s_gamestate_reviewbossmodel = 1
    s_gamestate_studymodel      = 2
    s_gamestate_reviewmodel     = 3
    s_gamestate_overmodel       = 4
    
    --
    s_spineCoconutLightJson   = "res/spine/coconut_light.json"
    s_spineCoconutLightAtalas = "res/spine/coconut_light.atlas"

    s_sound_Aluminum_Can_Open = 'res/sound/Aluminum_Can_Open.mp3'
    s_sound_bgm1 = 'res/sound/bgm1.mp3'
    s_sound_buttonEffect = 'res/sound/buttonEffect.mp3'
    s_sound_clickLocked = 'res/sound/clickLocked.mp3'
    s_sound_clickWave = 'res/sound/clickWave.mp3'
    s_sound_cost = 'res/sound/cost.mp3'
    s_sound_faila = 'res/sound/fail.m4a'
    s_sound_fail = 'res/sound/fail.mp3'
    s_sound_FightBoss = 'res/sound/FightBoss.mp3'
    s_sound_First_Noel_pluto = 'res/sound/First_Noel_pluto.mp3'
    s_sound_Get_Outside = 'res/sound/Get_Outside.mp3'
    s_sound_learn_false = 'res/sound/learn_false.mp3'
    s_sound_learn_true = 'res/sound/learn_true.mp3'
    s_sound_Mechanical_Clock_Ring = 'res/sound/Mechanical_Clock_Ring.mp3'
    s_sound_Pluto = 'res/sound/Pluto.mp3'
    s_sound_ReadyGo = 'res/sound/ReadyGo.mp3'
    s_sound_Road_to_Moscow = 'res/sound/Road_to_Moscow.mp3'
    s_sound_slideCoconut = 'res/sound/slideCoconut.mp3'
    s_sound_slideCoconut1 = 'res/sound/slideCoconut1.mp3'
    s_sound_slideCoconut2 = 'res/sound/slideCoconut2.mp3'
    s_sound_slideCoconut3 = 'res/sound/slideCoconut3.mp3'
    s_sound_slideCoconut4 = 'res/sound/slideCoconut4.mp3'
    s_sound_slideCoconut5 = 'res/sound/slideCoconut5.mp3'
    s_sound_slideCoconut6 = 'res/sound/slideCoconut6.mp3'
    s_sound_star1 = 'res/sound/star1.mp3'
    s_sound_star2 = 'res/sound/star2.mp3'
    s_sound_star3 = 'res/sound/star3.mp3'
    s_sound_wina = 'res/sound/win.m4a'
    s_sound_win = 'res/sound/win.mp3'
    s_sound_wrong = 'res/sound/wrong.mp3'

    CUSTOM_EVENT_SIGNUP = 'CUSTOMxx_EVENT_SIGNUP'
    CUSTOM_EVENT_LOGIN = 'CUSTOMxx_EVENT_LOGIN'

    s_DATA_MANAGER = require('model.DataManager')
    s_DATA_MANAGER.clear()
end

local function _initTool()
    require("cocos.init")
    -- require('Deprecated')
    
    -- tools
    s_JSON = require("common/json")

    -- debug
    s_debugger = require("common.debugger")
    s_debugger.configLog(true, true)
    s_logd     = s_debugger.logd
    s_logdStr  = s_debugger.logdStr

    require('common.utils')
    require("AudioMgr")

    DEBUG_PRINT_LUA_TABLE = true
end

local function _initScene()
    -- size
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    local _SCREEN_WIDTH  = size.width
    local _SCREEN_HEIGHT = size.height
    
    -- ********************** --
    s_DESIGN_WIDTH  = 640.0
    s_DESIGN_HEIGHT = 1136.0

    s_MAX_WIDTH     = 854.0
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
    s_SERVER.production       = 0
    s_SERVER.sessionToken     = ''

    -- user base server
    s_UserBaseServer          = require('server.UserBaseServer')
    s_HttpRequestClient       = require('server.HttpRequestClient')

    require('server.Analytics')
end

local function _initData()
    s_DATABASE_MGR = require('model.LocalDatabaseManager')
    s_DATABASE_MGR.open()
    s_DATABASE_MGR.initTables()

    local DataUser = require('model.user.DataUser')
    s_CURRENT_USER = DataUser.create()
end

local function _initStore()
    s_STORE = require('store.Store')
    s_STORE.init()
end

local function _declaration()
    s_WordPool        = nil
    s_CorePlayManager = nil
end

function initApp(start)
    s_START_FUNCTION = start

    _initConstant()
    _initTool()
    _initScene()
    _initServer()
    _initData()
    _initStore()
    _declaration()
end


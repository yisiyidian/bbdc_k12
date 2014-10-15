
local function _initConstant()
    --
    s_spineCoconutLightJson   = "res/spine/coconut_light.json"
    s_spineCoconutLightAtalas = "res/spine/coconut_light.atlas"

    s_allwords = "cfg/allwords"
    
    s_books = 'cfg/books.json'
    s_chapters = 'cfg/chapters.json'
    s_daily = 'cfg/dailyCheckIn.json'
    s_energy = 'cfg/energy.json'
    s_items = 'cfg/items.json'
    s_lv_cet4 = 'cfg/lv_cet4.json'
    s_lv_cet6 = 'cfg/lv_cet6.json'
    s_ielts = 'cfg/lv_ielts.json'
    s_necc = 'cfg/lv_ncee.json'
    s_toefl = 'cfg/lv_toefl.json'
    s_review_boos = 'cfg/review_boss.json'
    s_starRule = 'cfg/starRule.json'
    s_text = 'cfg/text.json'

    -- s_energy
    s_energyMaxCount = 4
    s_energyCoolDownSecs = 1800
    s_normal_level_energy_cost = 1
    s_summary_boss_energy_cost = 1
    s_review_boss_energy_cost = 1
    s_friend_request_max_count = 30
    s_friend_max_count = 50

    require('common.text')
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
end

local function _initScene()
    -- size
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()
    s_DESIGN_WIDTH  = size.width
    s_DESIGN_HEIGHT = size.height
    s_HEIGHT        = 1136.0
    s_HEIGHT_SCALE  = s_HEIGHT / s_DESIGN_HEIGHT

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


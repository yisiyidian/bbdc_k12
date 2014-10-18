require "Cocos2d"

local DataExample = require('example.DataExample')
require("common.global")


local ziaoangTest = require("view.ZiaoangTest")


function test()
    --local a = ziaoangTest.create()
    --s_SCENE:replaceGameLayer(a)

    --local corePlayManager = CorePlayManager.create()
    -- s_SCENE.gameLayer:addChild(corePlayManager)

    --cx.CXUtils:showMail('test', 'palyerName')
    -- cx.CXUtils:getInstance():requestProducts('com.beibei.wordmaster.ep30', function (ret, text)
    --   s_logd(ret)
    --   s_logd(text)
    -- end)


    s_WordPool = s_DATA_MANAGER.loadAllWords()
    s_CorePlayManager = require("controller.CorePlayManager")
    s_CorePlayManager.create()

    s_DATA_MANAGER.loadText()
    s_logdStr(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_FEEDBACK_MAIL_SUGGESTION))
    s_logdStr(s_DATA_MANAGER.getTextWithKey('feedback_btn_bug'))
    
    s_DATA_MANAGER.loadBooks()
    s_DATA_MANAGER.loadChapters()
    s_DATA_MANAGER.loadDailyCheckIns()
    s_DATA_MANAGER.loadEnergy()
    s_DATA_MANAGER.loadItems()
    -- s_DATA_MANAGER.loadLevels(s_BOOK_KEY_NCEE)
    s_DATA_MANAGER.loadReviewBoss()
    s_DATA_MANAGER.loadStarRules()

    -- print_lua_table(s_DATA_MANAGER.level_ncee)

    --s_CorePlayManager.enterTestLayer()
    --s_CorePlayManager.enterStudyLayer()
    s_CorePlayManager.enterReviewBossLayer()

    -- s_level = require('view/LevelLayer.lua')
    -- layer = s_level.create()
    --layer:setAnchorPoint(0.5,0)
    --layer:setPosition(s_LEFT_X, 0)
    -- s_SCENE:replaceGameLayer(layer)

    --logd('testSpine')
    --local main_back = sp.SkeletonAnimation:create(s_spineCoconutLightJson, s_spineCoconutLightAtalas, 0.5)
    --main_back:setPosition(50, 50)
    --layer:addChild(main_back)
    
--    local data = DataExample.create()
--    s_logd(data.des)
--
--    local function onSucceed(api, result)
--        s_logd('onSucceed:' .. api .. ', ' .. s_JSON.encode(result))
--    end 
--    local function onFailed(api, code, message)
--        s_logd('onFailed:' ..  api .. ', ' .. code .. ', ' .. message)
--    end
--    s_SERVER.request('apiLogIn', {['username']='Guo1', ['password']=111111}, onSucceed, onFailed)
--    s_SERVER.request('apiLogIn', {['username']='yehanjie1', ['password']=111111}, onSucceed, onFailed)
--
--
--    local sqlite3 = require("lsqlite3")
--    local dbPath = cc.FileUtils:getInstance():getWritablePath().."local.sqlite"
--    s_logd(cc.FileUtils:getInstance():getWritablePath())
--    local db = sqlite3.open(dbPath)
--
--
--    db:exec[[
--      CREATE TABLE test (id INTEGER PRIMARY KEY, content);
--
--      INSERT INTO test VALUES (NULL, 'Hello World');
--      INSERT INTO test VALUES (NULL, 'Hello Lua');
--      INSERT INTO test VALUES (NULL, 'Hello Sqlite3')
--    ]]
--
--    for row in db:nrows("SELECT * FROM test") do
--        s_logd('sqlite3:' .. row.id .. ', ' .. row.content)
--    end


   -- local function onSucceed(api, result)
   --     s_logd('onSucceed:' .. api .. ', ' .. s_JSON.encode(result))
   -- end 
   -- local function onFailed(api, code, message)
   --     s_logd('onFailed:' ..  api .. ', ' .. code .. ', ' .. message)
   -- end
   s_funcLogin('yehanjie1', '111111', onSuccexed, onFailed)
   -- s_funcSignin('_test000', '111111', onSucceed, onFailed)

   -- local LogInSignUpLayer = require('view.LogInSignUpLayer')
   -- local node = LogInSignUpLayer.create()
   -- s_SCENE.gameLayer:addChild(node)
   
--    local sqlite3 = require("lsqlite3")
--    local db = sqlite3.open_memory()
--
--    db:exec[[
--      CREATE TABLE test (id INTEGER PRIMARY KEY, content);
--
--      INSERT INTO test VALUES (NULL, 'Hello World');
--      INSERT INTO test VALUES (NULL, 'Hello Lua');
--      INSERT INTO test VALUES (NULL, 'Hello Sqlite3')
--    ]]
--
--    for row in db:nrows("SELECT * FROM test") do
--        s_logd('sqlite3:' .. row.id .. ', ' .. row.content)
--    end

    -- local path = cc.FileUtils:getInstance():fullPathForFilename('data/lv_cet4.json')
    -- local data = cc.FileUtils:getInstance():getStringFromFile(path)
    -- s_logd('start')
    -- s_JSON.decode(data)
    -- s_logd('end')

    -- cx.CXAnalytics:logEventAndLabel('luatestEvent', 'lualabel')
end

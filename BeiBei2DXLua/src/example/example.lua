require "Cocos2d"

local DataExample = require('example.DataExample')
require("common.global")


local ziaoangTest = require("view.ZiaoangTest")


function test()

    -- local wordList = {'apple', 'tea', 'many'}
    -- local index = 1
    -- local total = #wordList
    -- if total > 0 then
    --     local downloadFunc
    --     downloadFunc = function ()
    --         s_HttpRequestClient.downloadWordSoundFile(wordList[index], function (objectId, filename, err, isSaved) 
    --             s_logd(string.format('%s, %s, %s, %s', tostring(objectId), tostring(filename), tostring(err), tostring(isSaved)))
    --             index = index + 1
    --             if index <= total then downloadFunc() end 
    --         end)
    --     end

    --     downloadFunc()
    -- end

    -- s_SCENE:logIn("yehanjie1", "222222")

    -- playWordSound('apple')
    -- s_HttpRequestClient.downloadWordSoundFile('great', function (objectId, filename, err, isSaved) 
    --     print(string.format('%s, %s, %s, %s', tostring(objectId), tostring(filename), tostring(err), tostring(isSaved)))
    -- end)
    print(loadXxteaFile('cfg/books.json'))

    -- s_HttpRequestClient.downloadFileFromAVOSWithObjectId('5430b806e4b0c0d48049e293', 
    --     function (objectId, filename, err, isSaved) 

    --     end)

-- s_SERVER.debugLocalHost = true
-- local function onSucceed (api, result) print_lua_table (result) end
-- local function onFailed (api, code, message, description) print (message) end
-- local sql = string.format('{"user":{"__type":"Pointer","className":"_User","objectId":"%s"}}', '54128e44e4b080380a47debc')
--     s_SERVER.searchRelations('_Followee', sql, 'followee', onSucceed, onFailed)
-- s_SERVER.search('classes/WMAV_LevelData?where={"userId":"' .. '54128e44e4b080380a47debc' .. '","bookKey":"' .. 'ncee' .. '"}', onSucceed, onFailed)
-- -- s_SERVER.searchCount('WMAV_DeviceData', '{"country":"US"}', onSucceed, onFailed)
-- s_SERVER.searchCount('_User', '{"username":"' .. 'yehanjie1' .. '"}', onSucceed, onFailed)

--local a = ziaoangTest.create()
--s_SCENE:replaceGameLayer(a)

--local corePlayManager = CorePlayManager.create()
-- s_SCENE.gameLayer:addChild(corePlayManager)

--cx.CXUtils:showMail('test', 'palyerName')
-- cx.CXStore:getInstance():requestProducts('com.beibei.wordmaster.ep30', function (ret, json)
--      s_logd('%d, %s', ret, json)
--      cx.CXStore:getInstance():payForProduct('com.beibei.wordmaster.ep30', function (ret, msg, json)
--          s_logd('%d, %s, %s', ret, msg, json)
--      end)
-- end)

--    playMusic(s_sound_bgm1, true)

    -- local IntroLayer = require('view.hud.RightTopNode')
-- local layer = PopupLoginSignup.create()
-- layer:setAnchorPoint(0.5,0)
-- s_SCENE:popup(layer)
    -- local introLayer = IntroLayer.create()
    -- s_SCENE:replaceGameLayer(introLayer)


    -- s_DATA_MANAGER.loadText()
    -- s_logdStr(s_DATA_MANAGER.getTextWithIndex(TEXT_ID_FEEDBACK_MAIL_SUGGESTION))
    -- s_logdStr(s_DATA_MANAGER.getTextWithKey('feedback_btn_bug'))
    
    -- s_DATA_MANAGER.loadBooks()
    -- s_DATA_MANAGER.loadChapters()
    -- s_DATA_MANAGER.loadDailyCheckIns()
    -- s_DATA_MANAGER.loadEnergy()
    -- s_DATA_MANAGER.loadItems()
    -- s_DATA_MANAGER.loadLevels(s_BOOK_KEY_NCEE)
    -- s_DATA_MANAGER.loadReviewBoss()
    -- s_DATA_MANAGER.loadStarRules()

    --   -- test -- ziaoang ------------------------------------------------------------------------------------
--    s_WordPool = s_DATA_MANAGER.loadAllWords()
--    s_CorePlayManager = require("controller.CorePlayManager")
--    s_CorePlayManager.create()
----    s_CorePlayManager.enterStudyLayer()
----    s_CorePlayManager.enterTestLayer()
----    s_CorePlayManager.enterReviewBossLayer()
----    s_CorePlayManager.enterIntroLayer()
----    s_CorePlayManager.enterBookLayer()
--    s_CorePlayManager.enterHomeLayer()

    -- -- print_lua_table(s_DATA_MANAGER.level_ncee)

    -- s_level = require('view/LevelLayer.lua')
    -- layer = s_level.create()
    --layer:setAnchorPoint(0.5,0)
    --layer:setPosition(s_LEFT_X, 0)
    -- s_SCENE:replaceGameLayer(layer)

    --logd('testSpine')
    --local main_back = sp.SkeletonAnimation:create(s_spineCoconutLightJson, s_spineCoconutLightAtalas, 0.5)
    --main_back:setPosition(50, 50)
    --layer:addChild(main_back)
    
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

--------------------------------------------------------------------------------
--    s_localSqlite = require("model.LocalDatabaseManager")
--    s_localSqlite.open()
--    s_localSqlite.initTables()
--    s_localSqlite.insertTable_Word_Prociency('apple', '4')
--    s_localSqlite.showTable_Word_Prociency()
--    s_localSqlite.close()

--    local function onBuyResult( code, msg, info )
--        print('store onBuyResult: ' .. tostring(code) .. ', ' .. msg)
--    end
--
--    local function onResult( pPlugin, code, msg )
--        print('store login: ' .. tostring(code) .. ', ' .. msg)
--        if code == 2 then
--            s_STORE.buy(onBuyResult)
--        end
--    end
--
--    s_STORE.init()    
--    s_STORE.login(onResult)
end

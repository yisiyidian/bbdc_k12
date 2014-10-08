require "Cocos2d"

local DataExample = require('example.DataExample')
require("common.global")

-- test layers
local StudyLayer = require('view.StudyLayer')
local TestLayer = require('view.TestLayer')

function test()
    --local testLayer = TestLayer.create()
    --s_SCENE:replaceGameLayer(testLayer)

    --local corePlayManager = CorePlayManager.create()
    -- s_SCENE.gameLayer:addChild(corePlayManager)

    s_CorePlayManager.enterStudyLayer()

    --logd('testSpine')
    --local main_back = sp.SkeletonAnimation:create(s_spineCoconutLightJson, s_spineCoconutLightAtalas, 0.5)
    --main_back:setPosition(50, 50)
    --layer:addChild(main_back)
    
--    local data = DataExample.create()
--    s_logd(data.des)
--
--    local function onSucceed(api, result)
--        s_logd('onSucceed:' .. api .. ', ' .. s_json.encode(result))
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
--    print(cc.FileUtils:getInstance():getWritablePath())
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
   --     s_logd('onSucceed:' .. api .. ', ' .. s_json.encode(result))
   -- end 
   -- local function onFailed(api, code, message)
   --     s_logd('onFailed:' ..  api .. ', ' .. code .. ', ' .. message)
   -- end
   -- s_funcLogin('yehanjie1', '111111', onSuccexed, onFailed)
   -- s_funcSignin('_test000', '111111', onSucceed, onFailed)


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
    -- s_json.decode(data)
    -- s_logd('end')
end

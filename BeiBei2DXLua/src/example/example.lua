require('cocos.init')

local DataExample = require('example.DataExample')
require("common.global")


local ziaoangTest       = require("view.ZiaoangTest")
local ScrollViewTest    = require("view.ScrollviewTest")

local ProtocolBase = require('server.protocol.ProtocolBase')
require('server.protocol.protocols')

function test()
    local urls = getWordSoundFileDownloadURLs('zoo')

    cx.CXUtils:getInstance():download(urls[1], cc.FileUtils:getInstance():getWritablePath(), urls[3])
    -- cx.CXUtils:getInstance():download(urls[2], cc.FileUtils:getInstance():getWritablePath() .. urls[4])

    -- local request = cx.CXAVCloud:new()
    -- request:searchUser('tester23', nil, function (response, error)
    --     print('request:searchUser response:' .. tostring(response))
    --     print('request:searchUser error:' .. tostring(error))
    -- end)

        -- local srcDateTime = 'Sun Mar 01 2015 07:56:45 GMT+0000 (CST)'
        -- -- 123456789012345678901234567890
        -- local Y  = string.sub(srcDateTime,  12,  15)  
        -- local M  = string.sub(srcDateTime,  5,  7)  
        -- local D  = string.sub(srcDateTime,  9, 10)  
        -- local H  = string.sub(srcDateTime, 17, 18)  
        -- local MM = string.sub(srcDateTime, 20, 21)  
        -- local SS = string.sub(srcDateTime, 23, 24) 
        -- local months = { Jan=1, Feb=2, Mar=3, Apr=4, May=5, Jun=6, Jul=7, Aug=8, Sep=9, Oct=10, Nov=11, Dec=12 }
        -- print_lua_table({year=Y, m=months[M], day=D, hour=H, min=MM, sec=SS} )
        -- local t = os.time{year=Y, month=months[M], day=D, hour=H, min=MM, sec=SS} 
        -- print(t)

    -- local WordDictionaryDatabase = require('model.WordDictionaryDatabase')
    -- WordDictionaryDatabase.init()
    -- print_lua_table( WordDictionaryDatabase.testGetWord('apple') )

    -- local username = 'tester112'
    -- isUsernameExist(username, function (exsit, error)
    --     if error == nil then
    --         print (username .. ' ' .. tostring(exsit))
    --     end
    -- end)
    -- local t = {'a', 'b' , 'g'}
    -- print(s_JSON.encode(t))

    -- local api = ''
    -- local serverRequestType = SERVER_REQUEST_TYPE_NORMAL
    -- local function cb (result, error)
    --     print('ProtocolBase >>')
    --     if error == nil then
    --         print_lua_table(error)
    --     else
    --         print('ProtocolBase')
    --     end
    --     print('ProtocolBase <<')
    -- end
    -- local protocol = ProtocolBase.create(api, serverRequestType, {['username']=username}, cb)
    -- protocol:request()

    -- cx.CXUtils:getInstance():_testCppApi_()
    
    --local test = ziaoangTest.create()
    --s_SCENE:replaceGameLayer(test)
    -- local testLayer = require('view.level.ChapterLayerBase')
    -- local chapterLayer = testLayer.create('chapter0','level0')
    -- s_SCENE.replaceGameLayer(chapterLayer)

--    s_UserBaseServer.logIn('tester112', 'qwerty', function (u, e, code) 
--        s_UserBaseServer.getFollowersAndFolloweesOfCurrentUser(
--        function (api, result, error)
--            print_lua_table (result)
--        end)
--        -- s_SERVER.follow(s_CURRENT_USER.objectId, '54814dc8e4b0413d0555ad30', 
--        --     function (api, result) print_lua_table (result) end, function (api, code, message, description) end)
--    end)

-- new study layer test begin
 -- local newStudyLayer = NewStudyLayer.create(1)
 -- s_SCENE:replaceGameLayer(newStudyLayer)
-- new study layer test end

    local circle = require('view.login.SignUpLayer').create()
    s_SCENE:replaceGameLayer(circle)
    -- local main_logic_mat = {}
    -- for i = 1,10 do
    --     main_logic_mat[i] = getRandomBossPath()
    --     -- local mat = {}
    --     -- for i = 1,5 do

    --     -- end
        
    -- end
    -- print_lua_table(main_logic_mat)
--    local layer = cc.Layer:create()
    -- s_HttpRequestClient.downloadWordSoundFile('apply', function (objectId, filename, err, isSaved) 
    --     print(string.format('%s, %s, %s, %s', tostring(objectId), tostring(filename), tostring(err), tostring(isSaved)))
    --     playWordSound('apply')
    -- end)


--    local TapMat = require("view.mat.TapMat")
--    local mat = TapMat.create("apple",4,4)
--    mat:setPosition(s_DESIGN_WIDTH/2, s_DESIGN_HEIGHT/2)
--    
--    layer:addChild(mat)
--    return layer
-- local IntroLayer = require("view.ScrollviewTest")
-- local introLayer = IntroLayer.create(s_DESIGN_WIDTH,s_DESIGN_HEIGHT,2 * s_DESIGN_HEIGHT)
-- s_SCENE:replaceGameLayer(introLayer) 
    
end

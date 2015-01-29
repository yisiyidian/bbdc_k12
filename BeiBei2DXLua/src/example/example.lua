require('cocos.init')

local DataExample = require('example.DataExample')
require("common.global")


local ziaoangTest       = require("view.ZiaoangTest")
local ScrollViewTest    = require("view.ScrollviewTest")

require('server.protocol.protocols')

function test()
    -- local username = 'tester112'
    -- isUsernameExist(username, function (exsit, error)
    --     if error == nil then
    --         print (username .. ' ' .. tostring(exsit))
    --     end
    -- end)
    local t = {'a', 'b' , 'g'}
    print(s_JSON.encode(t))

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

    local circle = require('view.MissionCompleteCircle').create()
    s_SCENE:replaceGameLayer(circle)



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

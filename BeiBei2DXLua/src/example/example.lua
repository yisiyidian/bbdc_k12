require "Cocos2d"

local json  = require('json')
local debugger = require("common.debugger")
local logd = debugger.logd
local DataExample = require('example.DataExample')
require("common.resource")
local server = require('server.Server')

function testSpine(layer)
    --require "model.randomMat"
    --randomMat(4, 4)

    --logd('testSpine')
    --local main_back = sp.SkeletonAnimation:create(s_spineCoconutLightJson, s_spineCoconutLightAtalas, 1)
    --main_back:setPosition(50, 50)
    --layer:addChild(main_back)

    --local node = s_flipNode.create("coconut_light", "a", 1, 2)
    --node:setPosition(100, 100)
    --layer:addChild(node)
    
    local mat = s_flipMat.create("apple", 4, 4)
    layer:addChild(mat)

    logd('testSpine')
    local main_back = sp.SkeletonAnimation:create(s_spineCoconutLightJson, s_spineCoconutLightAtalas, 0.5)
    main_back:setPosition(50, 50)
    layer:addChild(main_back)
    
    local data = DataExample.create()
    logd(data.des)

    local function onSucceed(api, result)
        logd('onSucceed:' .. api .. json.encode(result))
    end 
    local function onFailed(api, code, message)
        logd('onFailed:' ..  api .. code .. message)
    end
    server.request('apiLogIn', {['username']='Guo1', ['password']=111111}, onSucceed, onFailed)
    server.request('apiLogIn', {['username']='yehanjie1', ['password']=111111}, onSucceed, onFailed)
end

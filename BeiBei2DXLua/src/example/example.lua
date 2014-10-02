local json  = require('json')
local debugger = require("common.debugger")
local logd = debugger.logd
local DataExample = require('example.DataExample')
require("common.resource")
local server = require('server.Server')

function testSpine(layer)
    require "model.randomMat"
    randomMat(4, 4)

    logd('testSpine')
    local main_back = sp.SkeletonAnimation:create(s_spineCoconutLightJson, s_spineCoconutLightAtalas, 0.5)
    main_back:setPosition(50, 50)
    layer:addChild(main_back)
    
    local data = DataExample.create()
    logd(data.des)

    server.request('apiLogIn', {['username']='Guo1', ['password']=111111}, nil)
end
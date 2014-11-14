require("Cocos2d")
require("Cocos2dConstants")
require("common.global")

local FriendRequest = class("FriendRequest", function()
    return cc.Layer:create()
end)

function FriendRequest.create()
    local layer = FriendRequest.new()
    --layer.friend = friend
    return layer 
end

function FriendRequest:ctor()

end

return FriendRequest
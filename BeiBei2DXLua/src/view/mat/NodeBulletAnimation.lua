require("cocos.init")

local NodeBulletAnimation = class("NodeBulletAnimation", function()
    return cc.Layer:create()
end)

-- 子弹
function NodeBulletAnimation.create()

    local main = NodeBulletAnimation.new()

    main.bullet = sp.SkeletonAnimation:create("spine/summaryboss/zongjieboss_2_douzi_zhuan.json","spine/summaryboss/zongjieboss_2_douzi_zhuan.atlas",1)
    main.bullet:setAnimation(0,'animation',true)
    main:addChild(main.bullet)

    return main
end

return NodeBulletAnimation
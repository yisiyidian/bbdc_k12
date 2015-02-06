local MetaBean = class("MetaBean", function()
    return {}
end)

function MetaBean.create(day,reward)

    local obj = MetaBean.new()

    obj.day = day
    obj.reward = reward
    
    return obj
end

return MetaBean
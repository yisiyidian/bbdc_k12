require "model.randomMat"
local flipNode = require("model.flipNode")

local flipMat = class("flipMat", function()
return cc.Layer:create()
end)


function flipMat.create(word, m ,n)
    local size = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize()

    local main = flipMat.new()

    main.main_word = word
    main.main_m = m
    main.main_n = n
    
    main.charaster_set_filtered = {}
    for i = 1, 26 do
        local char = string.char(96+i)
        if string.find(main.main_word, char) == nil then
            main.charaster_set_filtered[#main.charaster_set_filtered+1] = char
        end
    end
    print(#main.charaster_set_filtered)

    gap = 132
    left = (size.width - (main.main_m-1)*gap) / 2
    bottom = left
    
    main.main_logic_mat = randomMat(main.main_m, main.main_n)
    math.randomseed(os.time())
    main.randomStartIndex = math.random(1, main.main_m*main.main_n)
    
    main.main_mat = {}
    for i = 1, main.main_m do
        main.main_mat[i] = {}
        for j = 1, main.main_n do
            local diff = main.main_logic_mat[i][j] - main.randomStartIndex
            local node = nil
            if diff >= 0 and diff < string.len(main.main_word) then
                node = flipNode.create("coconut_light", string.sub(main.main_word,diff+1,diff+1), i, j)
            else
                local randomIndex = math.random(1, #main.charaster_set_filtered)
                node = flipNode.create("coconut_light", main.charaster_set_filtered[randomIndex], i, j)
            end
            node:setPosition(left+gap*(i-1), bottom+gap*(j-1))
            main:addChild(node)
            main.main_mat[i][j] = node
        end
    end
    
    return main
end


return flipMat








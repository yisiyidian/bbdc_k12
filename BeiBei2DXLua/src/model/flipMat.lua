require "model/flipNode"
require "model/flipMat"

function filpMat(word, m, n)
    -- local variate
    local main_layer
    local main_word
    local charaster_set_filtered
    local main_m
    local main_n
    local main_logic_mat
    local main_node_mat
    local randomStartIndex

    -- local function
    local init

    -- function detail
    init = function ()
        main_layer = cc.Layer.create()
        main_word = word
        charaster_set_filtered = {}
        for i = 1, 26 do
            if string.char(97+i) 
        end
       
    	main_m = m
    	main_n = n
    	math.randomseed(os.time())
    	randomStartIndex = math.random(1, main_m*main_n)
    	
    	main_logic_mat = randomMat(main_m, main_n)
    	main_node_mat = {}
    	for i = 1, main_m do
    	   main_node_mat[i] = {}
    	   for j = 1, main_n do
    	       diff = main_logic_mat[i][j] - randomStartIndex
    	       if diff >= 0 and diff < string.len(main_word) then
    	           main_node_mat[i][j] = flipNode("coconut_font", string.sub(main_word[0], diff+1, diff+1), vec2_table(i, j))
    	       else
    	           math.randomseed(os.time())
                   main_node_mat[i][j] = flipNode("coconut_font", charaster_set[math.random(1, 26)], vec2_table(i, j))
    	       end
    	       
    	   end
    	end
    	
    end
    
end
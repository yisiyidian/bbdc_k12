require "model/flipNode"
require "model/flipMat"

function filpMat(m, n)
    -- local variate
    local main_m
    local main_n
    local main_logic_mat
    local main_node_mat
    local randomStartIndex

    -- local function
    local init

    -- function detail
    init = function ()
    	main_m = m
    	main_n = n
    	--randomStartIndex = 
    	
    	main_logic_mat = randomMat(main_m,main_n)
    	main_node_mat = {}
    	for i = 1, main_m do
    	   main_node_mat[i] = {}
    	   for j = 1, main_n do
    	       main_node_mat[i][j] = flipNode("image/coconut_font.png","a",vec2_table(i, j))
    	   end
    	end
    	
    end
    
end
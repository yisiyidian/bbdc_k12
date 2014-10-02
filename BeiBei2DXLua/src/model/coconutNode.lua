require "Cocos2d"

function flipNode(back, character, location)
    -- local variate
    local main_back
    local main_character_content
    local main_character_label
    local scroll_state
    local logic_location
    local hasSelected

    -- local function
    local init
    local printMat
    local randomPoint
    local disoriginizeDirction
    local randomPath

    -- function detail
    init = function()
        main_back = sp.SkeletonAnimation:create("coconut_light.json", "coconut_light.atlas", 0.5)
        main_character_content = character
        
        scroll_state = 0
        login_location = location
        hasSelected = false
        
        
        
        
    end
    
end
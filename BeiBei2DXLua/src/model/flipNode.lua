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

    -- function detail
    init = function()
        main_back = cc.Sprite:create("image/coconut_font.png")
        main_character_content = character
        main_character_label = cc.Label:createWithTTF(character)
        
        scroll_state = 0
        login_location = location
        hasSelected = false
    end
    
    
end

local json = require("json")

function ReadStarRule()
    StarRule = {}
    
    local content = cc.FileUtils:getInstance():getStringFromFile("file/starRule.json")

    local data = json.decode(content)
    
    
    for i = 1, #data do
        tmp = {}
        tmp[1] = data[i]["star_1"]
        tmp[2] = data[i]["star_2"]
        tmp[3] = data[i]["star_3"]
        StarRule[i] = tmp
    end
    
    return StarRule
end

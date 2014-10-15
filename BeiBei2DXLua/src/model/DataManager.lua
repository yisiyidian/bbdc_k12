local DataManager = {}

DataManager.text = nil
DataManager.books = nil

-- text -------------------------------------------------------------------

local function loadJsonFile(filepath)
    local path = cc.FileUtils:getInstance():fullPathForFilename(filepath)
    local data = cc.FileUtils:getInstance():getStringFromFile(path)
    local jsonObj = s_JSON.decode(data)
    return jsonObj
end

function DataManager.loadText()
    local jsonObj = loadJsonFile(s_text)
    DataManager.text = jsonObj['text']
end

function DataManager.getTextWithIndex(TEXT_ID_)
    if DataManager.text ~= nil and TEXT_ID_ > 0 and TEXT_ID_ <= #DataManager.text then
        return DataManager.text[TEXT_ID_]['cn']
    else
        return 'error: no text with ' .. TEXT_ID_
    end
end

function DataManager.getTextWithKey(key)
    if DataManager.text ~= nil then
        for i = 1, #DataManager.text do
            if DataManager.text[i]['key'] == key then
                return DataManager.text[i]['cn']
            end
        end
    end

    return 'error: no text with ' .. key
end

-- word -------------------------------------------------------------------

local function split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

function DataManager.readAllWord()
    local wordInfo = {}
    local content = cc.FileUtils:getInstance():getStringFromFile(s_allwords)
    local lines = split(content, "\n")
    local MetaWord = require("model.meta.MetaWord")

    for i = 1, #lines do
        local terms = split(lines[i], "\t")
        local word = MetaWord.create(terms[1], terms[2], terms[3], terms[4], terms[5], terms[6], terms[7])
        wordInfo[word.wordName] = word
    end

    return wordInfo
end

-- book -------------------------------------------------------------------

function DataManager.loadBooks()
    local jsonObj = loadJsonFile(s_books)
    local jsonArr = jsonObj['books']
    local MetaBook = require("model.meta.MetaBook")
    DataManager.books = {}
    for i = 1, #jsonArr do 
        local data = jsonArr[i]
        local book = MetaBook.create(data['key'],
                                    data['name'],
                                    data['words'],
                                    data['color_r'],
                                    data['color_g'],
                                    data['color_b'],
                                    data['figureName'],
                                    data['progressColor_r'],
                                    data['progressColor_g'],
                                    data['progressColor_b'])
        DataManager.books[data['key']] = book
    end
end

-- energy -------------------------------------------------------------------

function DataManager.loadEnergy()
    local jsonObj = loadJsonFile(s_energy)
    s_energyMaxCount = jsonObj['energyMaxCount'] 
    s_energyCoolDownSecs = jsonObj['energyCoolDownSecs'] 
    s_normal_level_energy_cost = jsonObj['normal_level_energy_cost'] 
    s_summary_boss_energy_cost = jsonObj['summary_boss_energy_cost'] 
    s_review_boss_energy_cost = jsonObj['review_boss_energy_cost'] 
    s_friend_request_max_count = jsonObj['friend_request_max_count'] 
    s_friend_max_count = jsonObj['friend_max_count'] 
end

return DataManager

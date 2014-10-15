local DataManager = {}

local MetaWord = require("model.meta.MetaWord")

DataManager.text = nil

-- text -------------------------------------------------------------------

function DataManager.loadText()
    local path = cc.FileUtils:getInstance():fullPathForFilename(s_text)
    local data = cc.FileUtils:getInstance():getStringFromFile(path)
    local text = s_JSON.decode(data)
    DataManager.text = text['text']
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

    for i = 1, #lines do
        local terms = split(lines[i], "\t")
        local word = MetaWord.create(terms[1], terms[2], terms[3], terms[4], terms[5], terms[6], terms[7])
        wordInfo[word.wordName] = word
    end

    return wordInfo
end

return DataManager

local DataManager = {}

DataManager.text = nil

function DataManager.loadText()
    local path = cc.FileUtils:getInstance():fullPathForFilename(s_text)
    local data = cc.FileUtils:getInstance():getStringFromFile(path)
    local text = s_JSON.decode(data)
    DataManager.text = text['text']
end

function DataManager.getTextWithIndex(TEXT_ID_)
    if DataManager.text ~= nil and TEXT_ID_ <= #DataManager.text then
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

return DataManager

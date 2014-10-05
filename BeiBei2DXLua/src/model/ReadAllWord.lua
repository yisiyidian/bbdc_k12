local Word = require("model.Word")

function Split(szFullString, szSeparator)
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

function getFile(file_name)
    -- local f = io.open(file_name, 'r')
    -- local string = f:read("*a")
    -- f:close()
    -- return string

    return cc.FileUtils:getInstance():getStringFromFile(file_name)
end

function ReadAllWord()
    WordInfo = {}
    local content = getFile("cfg/allwords")

    local lines = Split(content, "\n")

    for i = 1, #lines do
        local terms = Split(lines[i], "\t")
        local word = Word.create(terms[1], terms[2], terms[3], terms[4], terms[5], terms[6], terms[7])
        WordInfo[word.wordName] = word
    end

    return WordInfo
end

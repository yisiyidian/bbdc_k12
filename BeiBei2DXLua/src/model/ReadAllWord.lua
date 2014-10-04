require("common.global")

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
  local f = io.open(file_name, 'r')
  local string = f:read("*a")
  f:close()
  return string
end

function ReadAllWord()
	str = '{"A":1, "B":2}'
	j = s_json.decode(str)
	for k,v in pairs(j) do
	    s_logd(k..":"..v)
	end
	j['C']='c'
	new_str = s_json.encode(j)
	s_logd(new_str)


	--content = getFile(cc.FileUtils:getInstance():fullPathForFilename("file/lv_cet4.json"))
    --print(content)
    --print(string.sub(content,#content-10,#content))
	--a = s_json.decode('{"A":"哈哈", "B":2}')
    --a = s_json.decode(content)
    --print(a["apple"])


    WordInfo = {}
    local content = cc.FileUtils:getInstance():getStringFromFile("cfg/allwords")
    local lines = Split(content, "\n")
    s_logd(#lines)
    for i = 1, #lines do
        local tmp = {}
        local names = {"wordname","sound_en","sound_us","meaning","small_meaning","sentence_en","sentence_cn"}
        local word = Split(lines[i], "\t")
        for j = 2, #word do
            tmp[names[j]] = word[j]
        end
        WordInfo[word[1]] = tmp
    end

    s_logd(WordInfo["apple"]["sentence_en"])
end
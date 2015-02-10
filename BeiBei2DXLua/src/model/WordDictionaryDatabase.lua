local sqlite3 = require("lsqlite3")

local Manager = {}

WDD_NEXTFRAME_STATE__INIT = 0
WDD_NEXTFRAME_STATE__RM_LOAD = 1
WDD_NEXTFRAME_STATE__STARTLOADING = 2

Manager.database = nil
Manager.nextframe = WDD_NEXTFRAME_STATE__INIT
Manager.allwords = nil

function Manager.init()
    Manager.allwords = {}
    if IS_DEVELOPMENT_MODE then require('model.words.bbdxw') end

    -- local databasePath = cc.FileUtils:getInstance():fullPathForFilename('cfg/bbdxw.sqlite')
    -- print('databasePath:', databasePath)
    -- Manager.database = sqlite3.open(databasePath)
    -- print('Manager.database:', Manager.database)
    -- Manager.allwords = {}
    -- if Manager.database ~= nil then
    --     local DataWord = require('model.user.DataWord')
    --     for row in Manager.database:nrows("SELECT * FROM DataWord") do
    --         local word = DataWord.create()
    --         word.wordName           =   row.wordName
    --         word.wordSoundMarkEn    =   row.wordSoundMarkEn
    --         word.wordSoundMarkAm    =   row.wordSoundMarkAm
    --         word.wordMeaningSmall   =   row.wordMeaningSmall
    --         word.wordMeaning        =   row.wordMeaning
    --         word.sentenceEn         =   row.sentenceEn
    --         word.sentenceCn         =   row.sentenceCn
    --         word.sentenceEn2        =   row.sentenceEn2
    --         word.sentenceCn2        =   row.sentenceCn2
    --         Manager.allwords[word.wordName] = word
    --     end
    -- end

    -- local function loadXxteaFile(filepath)
    --     local str = cx.CXUtils:getInstance():decryptXxteaFile(filepath)
    --     return str
    --     -- if str ~= nil then
    --     --     local jsonObj = s_JSON.decode(str)
    --     --     return jsonObj
    --     -- else
    --     --     return {}
    --     -- end
    -- end

    -- local content= loadXxteaFile("cfg/newwords.json")
    -- local lines = split(content, "\n")
    -- Manager.allwords = {}
    -- local DataWord = require('model.user.DataWord')
    -- local file = ''
    -- for i = 1, #lines do
    --     local terms = split(lines[i], "\t")
    --     for i = 6, #terms do
    --         terms[i] = string.gsub(terms[i], "'", "\\'")
    --     end

    --     local word = DataWord.create()
    --     word.wordName           =   terms[1]
    --     word.wordSoundMarkEn    =   terms[2]
    --     word.wordSoundMarkAm    =   terms[3]
    --     word.wordMeaningSmall   =   terms[4]
    --     word.wordMeaning        =   terms[5]
    --     word.sentenceEn         =   terms[6]
    --     word.sentenceCn         =   terms[7]
    --     word.sentenceEn2        =   terms[8]
    --     word.sentenceCn2        =   terms[9]
    --     Manager.allwords[word.wordName] = word

    --     -- local str = string.format('Manager.allwords["%s"]={["wordName"]="%s",["wordSoundMarkEn"]="%s",["wordSoundMarkAm"]="%s",["wordMeaningSmall"]="%s",["wordMeaning"]=\'%s\',["sentenceEn"]=\'%s\',["sentenceCn"]=\'%s\',["sentenceEn2"]=\'%s\',["sentenceCn2"]=\'%s\'}',
    --         -- tostring(terms[1]), tostring(terms[1]), tostring(terms[2]), tostring(terms[3]), tostring(terms[4]), tostring(terms[5]), tostring(terms[6]), tostring(terms[7]), tostring(terms[8]), tostring(terms[9]))
    --     if terms[3] == nil then 
    --         local str = string.format('Manager.allwords["%s"]={"%s","%s","%s","%s",\'%s\',\'%s\',\'%s\',\'%s\',\'%s\'}',
    --             tostring(terms[1]), tostring(terms[1]), tostring(terms[2]), tostring(terms[2]), tostring(terms[4]), tostring(terms[5]), tostring(terms[6]), tostring(terms[7]), tostring(terms[8]), tostring(terms[9]))
    --         file = file .. str .. '\n'
    --     else
    --         local str = string.format('Manager.allwords["%s"]={"%s","%s","%s","%s",\'%s\',\'%s\',\'%s\',\'%s\',\'%s\'}',
    --             tostring(terms[1]), tostring(terms[1]), tostring(terms[2]), tostring(terms[3]), tostring(terms[4]), tostring(terms[5]), tostring(terms[6]), tostring(terms[7]), tostring(terms[8]), tostring(terms[9]))
    --         file = file .. str .. '\n'
    --     end
    -- end
    -- local path = cc.FileUtils:getInstance():getWritablePath() .. 'bbdxw.lua'
    -- local f = io.open(path, "w")
    -- f:write(file)
    -- f:close()
end

-- ONLY use this in example.lua
function Manager.testInsertWords()
    Manager.database:exec[[
        create table if not exists DataWord(
            wordName TEXT,
            wordSoundMarkEn TEXT,
            wordSoundMarkAm TEXT,
            wordMeaningSmall TEXT,
            wordMeaning TEXT,
            sentenceEn TEXT,
            sentenceCn TEXT,
            sentenceEn2 TEXT,
            sentenceCn2 TEXT
        );
    ]]

    local content= cc.FileUtils:getInstance():getStringFromFile("newword.json")
    local lines = split(content, "\n")
    for i = 1, #lines do
        local terms = split(lines[i], "\t")
        for i = 6, #terms do
            terms[i] = string.gsub(terms[i], "'", "''")
        end
        local query = string.format(
'INSERT INTO DataWord ' 
.. '(wordName, wordSoundMarkEn, wordSoundMarkAm, wordMeaningSmall, wordMeaning, sentenceEn, sentenceCn, sentenceEn2, sentenceCn2) '
.. 'VALUES '
.. '("%s",      "%s",            "%s",            "%s",            \'%s\',       \'%s\',      \'%s\',    \'%s\',       \'%s\')'
, terms[1], terms[2], terms[3], terms[4], terms[5], terms[6], terms[7], terms[8], terms[9])

        local result = Manager.database:exec(query)
        print(result, query)
    end
end

-- ONLY use this in example.lua
function Manager.testGetWord(wordName)
    local word = {}
    for row in Manager.database:nrows("SELECT * FROM DataWord WHERE wordName = '"..wordName.."' ;") do
        word.wordName           =   row.wordName
        word.wordSoundMarkEn    =   row.wordSoundMarkEn
        word.wordSoundMarkAm    =   row.wordSoundMarkAm
        word.wordMeaningSmall   =   row.wordMeaningSmall
        word.wordMeaning        =   row.wordMeaning
        word.sentenceEn         =   row.sentenceEn
        word.sentenceCn         =   row.sentenceCn
        word.sentenceEn2        =   row.sentenceEn2
        word.sentenceCn2        =   row.sentenceCn2
    end
    return word
end

return Manager
local sqlite3 = require("lsqlite3")

local Manager = {}

WDD_NEXTFRAME_STATE__INIT = 0
WDD_NEXTFRAME_STATE__RM_LOAD = 1
WDD_NEXTFRAME_STATE__STARTLOADING = 2

Manager.database = nil
Manager.nextframe = WDD_NEXTFRAME_STATE__INIT
Manager.allwords = nil

function Manager.init()
    local databasePath = cc.FileUtils:getInstance():fullPathForFilename('cfg/bbdxw.bin')
    print('databasePath:', databasePath)
    Manager.database = sqlite3.open(databasePath)

    Manager.allwords = {}
    if Manager.database ~= nil then
        local DataWord = require('model.user.DataWord')
        for row in Manager.database:nrows("SELECT * FROM DataWord") do
            local word = DataWord.create()
            word.wordName           =   row.wordName
            word.wordSoundMarkEn    =   row.wordSoundMarkEn
            word.wordSoundMarkAm    =   row.wordSoundMarkAm
            word.wordMeaningSmall   =   row.wordMeaningSmall
            word.wordMeaning        =   row.wordMeaning
            word.sentenceEn         =   row.sentenceEn
            word.sentenceCn         =   row.sentenceCn
            word.sentenceEn2        =   row.sentenceEn2
            word.sentenceCn2        =   row.sentenceCn2
            Manager.allwords[word.wordName] = word
        end
    end
    print('table.maxn - Manager.allwords:', table.getn(Manager.allwords))
    print_lua_table(Manager.allwords['apple'])
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
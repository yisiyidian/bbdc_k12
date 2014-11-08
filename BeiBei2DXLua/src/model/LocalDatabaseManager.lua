
require("lsqlite3")

-- define Manager
local Manager = {}

-- define Manager's variables
Manager.database = nil

-- update local database when app version changes
function updateLocalDatabase()
    Manager.database:exec[[
        -- ALTER TABLE XXX ADD XXX DEFAULT XX;
    ]]
end

-- connect local sqlite
function Manager.open()
    local sqlite3 = require("sqlite3")
    local databasePath = cc.FileUtils:getInstance():getWritablePath() .. "localDB.sqlite"
    Manager.database = sqlite3.open(databasePath)
    s_logd('databasePath:' .. databasePath)
    
    -- TODO
    -- check version update
    if s_APP_VERSION == 151 then
        updateLocalDatabase()
    end
end

-- close local sqlite
function Manager.close()
    Manager.database:close()
end

-- init data structure
function Manager.initTables()

    -- create table Word_Prociency
    Manager.database:exec[[        
        create table if not exists Word_Prociency(
            userId TEXT,
            bookKey TEXT,
            wordName TEXT,
            prociencyValue INTEGER,
            lastUpdate TEXT
        );
    ]]
   
    -- CREATE table Review boss Control
    Manager.database:exec[[
        create table if not exists RB_control(
            userId TEXT,
            bookKey TEXT,
            bossId INTEGER,
            wordCount INTEGER,
            appearCount INTEGER,
            lastUpdate TEXT
        ); 
    ]]

    -- create table Review boss Record
    Manager.database:exec[[
        create table if not exists RB_record(
            userId TEXT,
            bookKey TEXT,
            bossId INTEGER,
            insertDate TEXT,
            wordId INTEGER,
            wordName TEXT,
            lastUpdate TEXT
        );
    ]]

    -- create table database game design configuration
    Manager.database:exec[[
        create table if not exists DB_gameDesignConfiguration(
            books TEXT,
            booksV INTEGER,
            chapters TEXT,
            chaptersV INTEGER,
            dailyCheckIn TEXT,
            dailyCheckInV INTEGER,
            energy TEXT,
            energyV INTEGER,
            iaps TEXT,
            iapsV INTEGER,
            items TEXT,
            itemsV INTEGER,
            lv_cet4 TEXT,
            lv_cet4V INTEGER,
            lv_cet6 TEXT,
            lv_cet6V INTEGER,
            lv_ielts TEXT,
            lv_ieltsV INTEGER,
            lv_ncee TEXT,
            lv_nceeV INTEGER,
            lv_toefl TEXT,
            lv_toeflV INTEGER,
            review_boss TEXT,
            revew_bossV INTEGER,
            starRule TEXT
        );
    ]]

    -- create table db_userInfo
    Manager.database:exec[[
        create table if not exists DB_userInfo(
            checkInWord TEXT,
            checkInWordUpdateDate TEXT,
            lastLoginDate TEXT,
            nickName TEXT,
            objectId TEXT,
            password TEXT,
            signType INTEGER,
            username TEXT
       );
    ]]
   
    -- create table IC_loginDate
    Manager.database:exec[[
        create table if not exists IC_loginDate(
            monday TEXT,
            tuesday TEXT,
            wednesday TEXT,
            thursday TEXT,
            friday TEXT,
            saturday TEXT,
            sunday TEXT,
            userId TEXT,
            week INTEGER PRIMARY KEY
        );
    ]]
   
    -- create table IC_word_day
    Manager.database:exec[[
       create table if not exists IC_word_day(
           bookName TEXT,
           learnedDate TEXT,
           learnedWordCount INTEGER,
           userId TEXT
       );
    ]]
end


function Manager.insertTable_Word_Prociency(wordName, wordProciency)
    local num = 0
    for row in Manager.database:nrows("SELECT * FROM Word_Prociency WHERE wordName = '"..wordName.."'") do
        num = num + 1
    end
    
    if num == 0 then
        local query = "INSERT INTO Word_Prociency VALUES ('user1', 'book1', '"..wordName.."', "..wordProciency..", '2014-11-6');"
        Manager.database:exec(query)
        
        if wordProciency == 0 then
            Manager.insertTable_RB_record(wordName)
        end
    else
        print("word exists")
    end
end

function Manager.insertTable_RB_control()
    local query = "INSERT INTO RB_control VALUES ('user1', 'book1', 'boss1', '30', '2', '2014-11-6');"
    Manager.database:exec(query)
end

function Manager.insertTable_RB_record(wordName)
    local RBWORDNUM = 20

    local num = 0
    for row in Manager.database:nrows("SELECT * FROM RB_record") do
        num = num + 1
    end
    
    local wordID = num + 1
    local bossID = ((wordID - 1) / RBWORDNUM) + 1
    
    local query = "INSERT INTO RB_control VALUES ('user1', 'book1', '"..bossID.."', '2014-10-6', '"..wordID.."', '"..wordName.."', '2014-11-6');"
    Manager.database:exec(query)
    
    if wordID % RBWORDNUM == 0 then
        Manager.insertTable_RB_control()
    end
end

function Manager.showTable_Word_Prociency()
    s_logd("Word_Prociency ---------------------------")
    for row in Manager.database:nrows("SELECT * FROM Word_Prociency") do
        s_logd(row.wordName .. ',' .. row.prociencyValue)
    end
end

function Manager.showTable_RB_control()
    s_logd("RB_control -------------------------------")
    for row in Manager.database:nrows("SELECT * FROM RB_control") do
        s_logd(row.bossId .. ',' .. row.wordCount)
    end
end

function Manager.showTable_RB_record()
    s_logd("RB_record --------------------------------")
    for row in Manager.database:nrows("SELECT * FROM RB_record") do
        s_logd(row.bossId .. ',' .. row.wordId .. ',' .. row.wordName)
    end
end

---- UserDefault -----------------------------------------------------------

local is_sound_on_key = 'sound'
function Manager.isSoundOn() return cc.UserDefault:getInstance():getBoolForKey(is_sound_on_key, true) end
function Manager.setSoundOn(b) cc.UserDefault:getInstance():setBoolForKey(is_sound_on_key, b) end

local is_music_on_key = 'music'
function Manager.isMusicOn() return cc.UserDefault:getInstance():getBoolForKey(is_music_on_key, true) end
function Manager.setMusicOn(b) cc.UserDefault:getInstance():setBoolForKey(is_music_on_key, b) end

return Manager


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
    local databasePath = cc.FileUtils:getInstance():getWritablePath().."localDB.sqlite"
    Manager.database = sqlite3.open(databasePath)
    s_logd(databasePath)
    
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
   Manager.database:exec[[
        CREATE TABLE test(id INTEGER PRIMARY KEY, content);
        INSERT INTO test VALUES (NULL, 'Hello World');
        INSERT INTO test VALUES (NULL, 'Hello Lua');
        INSERT INTO test VALUES (NULL, 'Hello Sqlite3');
        INSERT INTO test VALUES (NULL, 'Hello Sqlite2');
   ]]
   
   -- CREATE table Review boss Control
   Manager.database:exec[[
        CREATE TABLE RB_control(
            bossId INTEGER PRIMARY KEY,
            userId INTEGER,
            bookKey TEXT,
            appearCount INTEGER,
            lastUpdate TEXT,
            wordCount INTEGER
        ); 
   ]]
   -- create table Review boss Record
   Manager.database:exec[[
        CREATE TABLE RB_record(
            bossId INTEGER PRIMARY KEY,
            userId INTEGER,
            bookKey TEXT,
            insertDate TEXT,
            wordId INTEGER,
            wordMeaning TEXT,
            wordName TEXT
        );
   ]]
   -- create table database game design configuration
   Manager.database:exec[[
        CREATE TABLE DB_gameDesignConfiguration(
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
   -- create table db_globalConfig
   Manager.database:exec[[
        CREATE TABLE DB_globalConfig(
            musicOn INTEGER,
            soundOn INTEGER
        );
   ]]
   -- create table db_userInfo
   Manager.database.exec[[
        CREATE TABLE DB_userInfo(
            checkInWord TEXT,
            checkInWordUpdateDate TEXT,
            lastLoginDate TEXT,
            nickName TEXT,
            objectId TEXT,
            password TEXT,
            signType INTEGER,
            userName TEXT
        );
   ]]
   -- create table IC_loginDate
   Manager.database.exec[[
        CREATE TABLE IC_loginDate(
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
  Manager.database.exec[[
        CREATE TABLE IC_word_day(
            bookName TEXT,
            learnedDate TEXT,
            learnedWordCount INTEGER,
            userId TEXT
        );
  ]]
  -- create table word_Prociency
  Manager.database.exec[[
        CREATE TABLE WORD_Prociency(
            bookKey TEXT,
            lastUpdate TEXT,
            prociencyValue INTEGER,
            userId TEXT,
            wordName TEXT
        );
  ]]
end

function Manager.showTables()
    for row in Manager.database:nrows("SELECT * FROM test") do
        s_logd('sqlite3:' .. row.id .. ', ' .. row.content)
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

local DataManager = {}

DataManager.text = nil
DataManager.books = nil
DataManager.chapters = nil
DataManager.starRules = nil
DataManager.dailyCheckIn = nil

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

-- chapter -------------------------------------------------------------------

function DataManager.loadChapters()
    local jsonObj = loadJsonFile(s_chapters)
    local jsonArr = jsonObj['Chapters']['Chapter']
    local MetaChapter = require("model.meta.MetaChapter")
    DataManager.chapters = {}
    for i = 1, #jsonArr do 
        local data = jsonArr[i]
        local chapter = MetaChapter.create(data['book_key'],
                                    data['chapter_key'],
                                    data['index'],
                                    data['ChapterImage'],
                                    data['BackImage'],
                                    data['NameImage'],
                                    data['Name'])
        DataManager.chapters[i] = chapter
    end
end

-- dailyCheckIn -------------------------------------------------------------------

function DataManager.loadDailyCheckIns()
    local jsonObj = loadJsonFile(s_daily)
    local jsonArr = jsonObj['dailyCheckIn']
    local MetaDailyCheckIn = require("model.meta.MetaDailyCheckIn")
    DataManager.dailyCheckIn = {}
    for i = 1, #jsonArr do 
        local data = jsonArr[i]
        local dailyCheckIn = MetaDailyCheckIn.create(data['day'],
                                    data['itemKey'],
                                    data['count'],
                                    data['default_word'])
        DataManager.dailyCheckIn[i] = dailyCheckIn
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

-- star rule -------------------------------------------------------------------

function DataManager.loadStarRules()
    local jsonObj = loadJsonFile(s_starRule)
    local jsonArr = jsonObj['starRule']
    local MetaStarRule = require("model.meta.MetaStarRule")
    DataManager.starRules = {}
    for i = 1, #jsonArr do 
        local data = jsonArr[i]
        local sr = MetaStarRule.create(data['word_num'],
                                    data['star_1'],
                                    data['star_2'],
                                    data['star_3'])
        DataManager.starRules[i] = sr
    end
end

return DataManager

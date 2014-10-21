local DataManager = {}

require('common.text')

---------------------------------------------------------------------------

s_BOOK_KEY_NCEE  = 'ncee'
s_BOOK_KEY_CET4  = 'cet4'
s_BOOK_KEY_CET6  = 'cet6'
s_BOOK_KEY_IELTS = 'ielts'
s_BOOK_KEY_TOEFL = 'toefl'

DataManager.text = nil
DataManager.books = nil
DataManager.chapters = nil
DataManager.items = nil
DataManager.level_ncee = nil
DataManager.level_cet4 = nil
DataManager.level_cet6 = nil
DataManager.level_ielts = nil
DataManager.level_toefl = nil
DataManager.reviewBoos = nil
DataManager.starRules = nil
DataManager.dailyCheckIn = nil

s_energyMaxCount = 4
s_energyCoolDownSecs = 1800
s_normal_level_energy_cost = 1
s_summary_boss_energy_cost = 1
s_review_boss_energy_cost = 1
s_friend_request_max_count = 30
s_friend_max_count = 50

s_allwords = "cfg/allwords"
s_books = 'cfg/books.json'
s_chapters = 'cfg/chapters.json'
s_daily = 'cfg/dailyCheckIn.json'
s_energy = 'cfg/energy.json'
s_items = 'cfg/items.json'
local getLevelConfigFilePath = function (bookkey) return string.format('cfg/lv_%s.json', bookkey) end
s_review_boos = 'cfg/review_boss.json'
s_starRule = 'cfg/starRule.json'
s_text = 'cfg/text.json'

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

function DataManager.loadAllWords()
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

-- items -------------------------------------------------------------------

function DataManager.loadItems()
    local jsonObj = loadJsonFile(s_items)
    local jsonArr = jsonObj['items']
    local MetaItem = require("model.meta.MetaItem")
    DataManager.items = {}
    for i = 1, #jsonArr do 
        local data = jsonArr[i]
        local items = MetaItem.create(data['key'], data['type'])
        DataManager.items[i] = items
    end
end

-- levels -------------------------------------------------------------------

function DataManager.loadLevels(bookkey)
    local jsonObj = loadJsonFile(getLevelConfigFilePath(bookkey))
    local jsonArr = jsonObj['Levels']['Level']
    local MetaLevel = require("model.meta.MetaLevel")
    local levels = {}
    for i = 1, #jsonArr do 
        local data = jsonArr[i]
        local lv = MetaLevel.create(data['index'], 
                                    data['word_content'],
                                    data['summary_boss_drop'], 
                                    data['chapter_key'], 
                                    data['book_key'], 
                                    data['summary_boss_time'], 
                                    data['summary_boss_word'],
                                    data['summary_boss_hp'], 
                                    data['summary_boss_stars'], 
                                    data['type'], 
                                    data['level_key'])
        levels[i] = lv
    end

    if bookkey == s_BOOK_KEY_NCEE then
        DataManager.level_ncee = levels
    elseif bookkey == s_BOOK_KEY_CET4 then
        DataManager.level_cet4 = levels
    elseif bookkey == s_BOOK_KEY_CET6 then
        DataManager.level_cet6 = levels
    elseif bookkey == s_BOOK_KEY_IELTS then
        DataManager.level_ielts = levels
    elseif bookkey == s_BOOK_KEY_TOEFL then
        DataManager.level_toefl = levels
    end
end

-- review boss -------------------------------------------------------------------

function DataManager.loadReviewBoss()
    local jsonObj = loadJsonFile(s_review_boos)
    DataManager.reviewBoos = {}
    DataManager.reviewBoos["review_boss_key"] = jsonObj["review_boss_key"]
    DataManager.reviewBoos["review_boss_type"] = jsonObj["review_boss_type"]
    DataManager.reviewBoos["review_boss_word_num"] = jsonObj["review_boss_word_num"]

    DataManager.reviewBoos["review_boss_drop_list"] = {}
    local jsonArr = jsonObj['review_boss_drop_list']
    for i = 1, #jsonArr do 
        local data = jsonArr[i]
        DataManager.reviewBoos["review_boss_drop_list"][i] = {["itemKey"]=data["itemKey"], ["count"]=data["count"]}
    end
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

-------------------------------------------------------------------

return DataManager
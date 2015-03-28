local DataManager = {}

---------------------------------------------------------------------------
local s_USE_XXTEA = true

---------------------------------------------------------------------------
-- DO NOT modify these below
g_BOOKS    = {'1',    '2',    '3',    '4',   '5',   '6',     '7',      '8',     '9',       '10',   '11',   '12',  '13'}
g_BOOKKEYS = {'cet4', 'cet6', 'gmat', 'gre', 'gse', 'ielts', 'middle', 'ncee',  'primary', 'pro4', 'pro8', 'sat', 'toefl'}

s_BOOK_KEY_CET4     = g_BOOKKEYS[1] -- 'cet4'
s_BOOK_KEY_CET6     = g_BOOKKEYS[2] -- 'cet6'
s_BOOK_KEY_GMAT     = g_BOOKKEYS[3] -- 'gmat'
s_BOOK_KEY_GRE      = g_BOOKKEYS[4] -- 'gre'
s_BOOK_KEY_GSE      = g_BOOKKEYS[5] -- 'gse'
s_BOOK_KEY_IELTS    = g_BOOKKEYS[6] -- 'ielts'
s_BOOK_KEY_MIDDLE   = g_BOOKKEYS[7] -- 'middle'
s_BOOK_KEY_NCEE     = g_BOOKKEYS[8] -- 'ncee'
s_BOOK_KEY_XPRIMARY = g_BOOKKEYS[9] -- 'primary'
s_BOOK_KEY_PRO4     = g_BOOKKEYS[10] -- 'pro4'
s_BOOK_KEY_PRO8     = g_BOOKKEYS[11] -- 'pro8'
s_BOOK_KEY_SAT      = g_BOOKKEYS[12] -- 'sat'
s_BOOK_KEY_TOEFL    = g_BOOKKEYS[13] -- 'toefl'
---------------------------------------------------------------------------

s_bean = {'1',    '5',    '3',    '4',   '5',   '6',     '7'}

function DataManager.clear()
    DataManager.configs = nil
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
    DataManager.product = nil
    DataManager.bean = nil
end

s_energyMaxCount = 8
s_energyCoolDownSecs = 1800
s_normal_level_energy_cost = 1
s_summary_boss_energy_cost = 1
s_review_boss_energy_cost = 1
s_friend_request_max_count = 30
s_friend_max_count = 50

s_books = 'cfg/books.json'
s_chapters = 'cfg/chapters.json'
s_energy = 'cfg/energy.json'
s_items = 'cfg/items.json'
local getLevelConfigFilePath = function (bookkey) return string.format('cfg/lv_%s.json', bookkey) end
s_review_boss = 'cfg/review_boss.json'
s_starRule = 'cfg/starRule.json'
s_product = 'cfg/product.json'

local function loadXxteaFile(filepath)
    local str = cx.CXUtils:getInstance():decryptXxteaFile(filepath)
    if str ~= nil then
        local jsonObj = s_JSON.decode(str)
        return jsonObj
    else
        return {}
    end
end

local function loadJsonFile(filepath)
    local filename = string.gsub(filepath, 'cfg/', '')
    local downloadpath = cc.FileUtils:getInstance():getWritablePath() .. filename
    if cc.FileUtils:getInstance():isFileExist(downloadpath) then
        filepath = downloadpath
        print ('downloadpath:' .. downloadpath)
    end

    if s_USE_XXTEA then
        return loadXxteaFile(filepath)
    else
        local path = cc.FileUtils:getInstance():fullPathForFilename(filepath)
        local data = cc.FileUtils:getInstance():getStringFromFile(path)
        local jsonObj = s_JSON.decode(data)
        return jsonObj
    end
end

-- text -------------------------------------------------------------------

function DataManager.getTextWithIndex(TEXT__)
    return TEXT__
end

-- word -------------------------------------------------------------------

function DataManager.loadBookWords()


    local bookWord = {}
    local bookName = {'cet4', 'cet6', 'gmat', 'gre', 'gse', 'ielts', 'middle', 'ncee', 'primary', 'pro4', 'pro8', 'sat', 'toefl'}
    for i = 1, #bookName do
        bookWord[bookName[i]] = {}
        local filepath = "cfg/" .. bookName[i] .. ".book"
        local content = cc.FileUtils:getInstance():getStringFromFile(filepath)
        local lines = split(content, "\n")
        for j = 1, #lines do
            if lines[j] ~= "" then
                table.insert(bookWord[bookName[i]], lines[j])
            end
        end
    end
    return bookWord
    
    
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
                                    data['progressColor_b'],
                                    data['music'])
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
                                    --data['index'],
                                    data['ChapterImage'],
                                    data['BackImage'],
                                    data['NameImage'],
                                    data['Name'])
        DataManager.chapters[i] = chapter
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
        local lv = MetaLevel.create(--data['index'], 
                                    data['word_content'],
                                    data['summary_boss_drop'], 
                                    data['chapter_key'], 
                                    data['book_key'], 
                                    data['word_num'],
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

function DataManager.getLevels( bookkey )
    if bookkey == s_BOOK_KEY_NCEE then
        return DataManager.level_ncee
    elseif bookkey == s_BOOK_KEY_CET4 then
        return DataManager.level_cet4
    elseif bookkey == s_BOOK_KEY_CET6 then
        return DataManager.level_cet6
    elseif bookkey == s_BOOK_KEY_IELTS then
        return DataManager.level_ielts
    elseif bookkey == s_BOOK_KEY_TOEFL then
        return DataManager.level_toefl
    end
    return nil
end

function DataManager.getLevelConfig(bookKey, chapterKey, levelKey)
    --print('getLeveLConfig:'..bookKey..chapterKey..levelKey..s_BOOK_KEY_IELTS)
    if bookKey == s_BOOK_KEY_NCEE then
        for i = 1, #DataManager.level_ncee do
            if DataManager.level_ncee[i]['chapter_key'] == chapterKey and DataManager.level_ncee[i]['level_key'] == levelKey then

--                 print(DataManager.level_ncee[i]['chapter_key'])
                 return DataManager.level_ncee[i]
            end
        end
    elseif bookKey == s_BOOK_KEY_CET4 then
        for i = 1, #DataManager.level_cet4 do
            if DataManager.level_cet4[i]['chapter_key'] == chapterKey and DataManager.level_cet4[i]['level_key'] == levelKey then
                return DataManager.level_cet4[i]
            end
        end
    elseif bookKey == s_BOOK_KEY_CET6 then
        for i = 1, #DataManager.level_cet6 do
            if DataManager.level_cet6[i]['chapter_key'] == chapterKey and DataManager.level_cet6[i]['level_key'] == levelKey then
                return DataManager.level_cet6[i]
            end
        end
    elseif bookKey == s_BOOK_KEY_IELTS then
        for i = 1, #DataManager.level_ielts do
            if DataManager.level_ielts[i]['chapter_key'] == chapterKey and DataManager.level_ielts[i]['level_key'] == levelKey then
                return DataManager.level_ielts[i]
            end
        end
    elseif bookKey == s_BOOK_KEY_TOEFL then
        for i = 1, #DataManager.level_toefl do
            if DataManager.level_toefl[i]['chapter_key'] == chapterKey and DataManager.level_toefl[i]['level_key'] == levelKey then
                return DataManager.level_toefl[i]
            end
        end
    end
end

function DataManager.getSummaryBossIncrementsOfChapter(chapterKey)
    local chapterIndex = string.sub(chapterKey, 8)
    local index = 0
    local increments = 0
    while index - chapterIndex < 0 do
        local chapterConfig = DataManager.getChapterConfig(s_CURRENT_USER.bookKey,'chapter'..index)
        local lastBossStar = 0
        for i = 1, #chapterConfig do
            if chapterConfig[i]['type'] == 1 then
                lastBossStar = chapterConfig[i]['summary_boss_stars']
                --print('bossStar:'..lastBossStar)
            end     
        end
        increments = increments + lastBossStar
        index = index + 1
    end
    return increments
end

function DataManager.getChapterConfig(bookKey, chapterKey)
    local chapterConfig = {}
    local index = 0
    if bookKey == s_BOOK_KEY_NCEE then
        for i = 1, #DataManager.level_ncee do
            if DataManager.level_ncee[i]['chapter_key'] == chapterKey then
                index = index + 1
                chapterConfig[index] = DataManager.level_ncee[i]
            end
        end
    elseif bookKey == s_BOOK_KEY_CET4 then
        for i = 1, #DataManager.level_cet4 do
            if DataManager.level_cet4[i]['chapter_key'] == chapterKey then
                index = index + 1
                chapterConfig[index] = DataManager.level_cet4[i]
            end
        end
    elseif bookKey == s_BOOK_KEY_CET6 then
        for i = 1, #DataManager.level_cet6 do
            if DataManager.level_cet6[i]['chapter_key'] == chapterKey then
                index = index + 1
                chapterConfig[index] = DataManager.level_cet6[i]
            end
        end
    elseif bookKey == s_BOOK_KEY_IELTS then
        for i = 1, #DataManager.level_ielts do
            if DataManager.level_ielts[i]['chapter_key'] == chapterKey then
                index = index + 1
                chapterConfig[index] = DataManager.level_ielts[i]
            end
        end
    elseif bookKey == s_BOOK_KEY_TOEFL then
        for i = 1, #DataManager.level_toefl do
            if DataManager.level_toefl[i]['chapter_key'] == chapterKey then
                index = index + 1
                chapterConfig[index] = DataManager.level_toefl[i]
            end
        end
    end
    return chapterConfig
end

-- review boss -------------------------------------------------------------------

function DataManager.loadReviewBoss()
    local jsonObj = loadJsonFile(s_review_boss)
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

-- product info -----------------------------------------------------------------
function DataManager.loadProduct()
    local jsonObj = loadJsonFile(s_product)
    local jsonArr = jsonObj
    local MetaProduct = require("model.meta.MetaProduct")
    DataManager.product = {}
    for i = 1, #jsonArr do 
        local data = jsonArr[i]
        local p = MetaProduct.create(data['productId'],
            data['productName'],
            data['productDescription'],
            data['productValue'])
        table.insert(DataManager.product, p)
    end
end

-- bean info -----------------------------------------------------------------
function DataManager.loadBean()
    local MetaBean = require("model.meta.MetaBean")
    DataManager.bean = {}
    for i = 1, 7 do 
        local p = MetaBean.create(i , s_bean[i])
        table.insert(DataManager.bean, p)
    end
end

return DataManager

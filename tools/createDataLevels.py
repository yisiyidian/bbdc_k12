
# python createDataLevels.py "54782687e4b0a08f8e75e298" 5 "ncee" "chapter0"

import pycurl, json, sys

def createDataLevel(userId, bookKey, chapterKey, levelKey):
    
    url = 'https://leancloud.cn/1.1/classes/DataLevel'

    header = ["X-AVOSCloud-Application-Id: gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn",
            "X-AVOSCloud-Application-Key: x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3",
            "Content-Type: application/json"]

    data = json.dumps({
        "isPassed":1,
        "isPlayed":1,
        "userId":userId,
        "isLevelUnlocked":1,
        "version":0,
        "stars":0,
        "chapterKey":chapterKey,
        "bookKey":bookKey,
        "levelKey":levelKey})

    c = pycurl.Curl()

    c.setopt(pycurl.URL,          url)
    c.setopt(pycurl.HTTPHEADER,   header) 
    c.setopt(pycurl.POST,         1)
    c.setopt(pycurl.POSTFIELDS,   data)

    c.perform()

    pass

# --------------------------------------------------------------------------------------------------------

if __name__ == "__main__":
    
    userId     = sys.argv[1]

    levelCount = sys.argv[2]
    bookKey    = sys.argv[3]
    chapterKey = sys.argv[4]

    for x in xrange(0, int(levelCount)):
        createDataLevel(userId, bookKey, chapterKey, 'level' + str(x))
        pass

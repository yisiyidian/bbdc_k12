
# username subfix range, chapter index, book key
# python createDataLevels.py 20 29 2 'ncee'

import pycurl, json, sys

chapter = 0
bookKey = 'ncee'

URL_CLS  = 'https://leancloud.cn/1.1/classes/'
URL_USER = 'https://leancloud.cn/1.1/users'
APP_ID   = "X-AVOSCloud-Application-Id: gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn"
APP_KEY  = "X-AVOSCloud-Application-Key: x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3"

def createDataLevel(userId, bookKey, chapterKey, levelKey):
    header = [APP_ID, APP_KEY, "Content-Type: application/json"]
    data = json.dumps({
        "isPassed":1,
        "isPlayed":1,
        "userId":userId,
        "isLevelUnlocked":1,
        "version":0,
        "stars":3,
        "chapterKey":chapterKey,
        "bookKey":bookKey,
        "levelKey":levelKey})

    c = pycurl.Curl()
    c.setopt(pycurl.URL,          URL_CLS + 'DataLevel')
    c.setopt(pycurl.HTTPHEADER,   header) 
    c.setopt(pycurl.POST,         1)
    c.setopt(pycurl.POSTFIELDS,   data)
    print('')
    c.perform()
    c.close()
    pass

def createDataLevels(userId, chapter):
    if chapter >= 0:
        for x in xrange(0, 12):
            createDataLevel(userId, bookKey, 'chapter0', 'level' + str(x))
            pass
    if chapter >= 1:            
        for x in xrange(0, 18):
            createDataLevel(userId, bookKey, 'chapter1', 'level' + str(x))
            pass
    if chapter >= 2:            
        for x in xrange(0, 38):
            createDataLevel(userId, bookKey, 'chapter2', 'level' + str(x))
            pass
    pass

def body_getUserData(buf):
    # Print body data to stdout
    # sys.stdout.write(buf)
    data = json.loads(buf)
    if len(data['results']) > 0:
        userId = data['results'][0]['objectId']
        print(userId)
        createDataLevels(userId, chapter)

def getUserData(username):
    print username
    c = pycurl.Curl()
    c.setopt(pycurl.URL,           URL_CLS + '_User?where={"username":"' + username + '"}')
    c.setopt(pycurl.HTTPHEADER,    [APP_ID, APP_KEY]) 
    # c.setopt(pycurl.GET,           1)
    c.setopt(pycurl.WRITEFUNCTION, body_getUserData)
    c.perform()
    c.close()
    pass

def updateUser(userId, sessionToken):
    header = [APP_ID, APP_KEY, "X-AVOSCloud-Session-Token: " + sessionToken, "Content-Type: application/json"]
    data = json.dumps({"isGuest":1})

    c = pycurl.Curl()
    c.setopt(pycurl.URL,           URL_USER + '/' + userId)
    c.setopt(pycurl.HTTPHEADER,    header) 
    c.setopt(pycurl.CUSTOMREQUEST, "PUT") 
    c.setopt(pycurl.POSTFIELDS,    data)
    c.perform()
    c.close()
    pass    

def body_createUser(buf):
    sys.stdout.write(buf)
    print('')
    data = json.loads(buf)
    userId = data['objectId']
    updateUser(userId, data['sessionToken'])
    createDataLevels(userId, chapter)
    pass    

def createUser(username, password):
    header = [APP_ID, APP_KEY, "Content-Type: application/json"]
    data = json.dumps({"username":username, "password":password})

    c = pycurl.Curl()
    c.setopt(pycurl.URL,           URL_USER)
    c.setopt(pycurl.HTTPHEADER,    header) 
    c.setopt(pycurl.POST,          1)
    c.setopt(pycurl.POSTFIELDS,    data)
    c.setopt(pycurl.WRITEFUNCTION, body_createUser)
    c.perform()
    c.close()
    pass

# --------------------------------------------------------------------------------------------------------

if __name__ == "__main__":
    chapter = int(sys.argv[3])
    bookKey = sys.argv[4]
    for x in xrange(int(sys.argv[1]), int(sys.argv[2]) + 1):
        print ('-----------------')
        un = 'tster' + str(x)
        print (un)
        createUser(un, 'qwerty')
        print ('-----------------')
        pass 

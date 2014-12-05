import pycurl, json, sys

chapter = 0
bookKey = 'ncee'

LEAN_URL      = 'https://leancloud.cn/1.1/'
LEAN_URL_CLS  = LEAN_URL + 'classes/'
LEAN_URL_USER = LEAN_URL + 'users'
LEAN_APP_ID   = "X-AVOSCloud-Application-Id: gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn"
LEAN_APP_KEY  = "X-AVOSCloud-Application-Key: x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3"

def getDataLevel(levelKey):
    def callback(buf):
        # sys.stdout.write(buf)
        data = json.loads(buf)
        print levelKey, data["count"]
        pass

    c = pycurl.Curl()
    c.setopt(pycurl.URL,           LEAN_URL_CLS + 'DataLevel?where={"levelKey":"' + levelKey + '"}&count=1&limit=0')
    c.setopt(pycurl.HTTPHEADER,    [LEAN_APP_ID, LEAN_APP_KEY]) 
    c.setopt(pycurl.WRITEFUNCTION, callback)
    c.perform()
    c.close()
    pass

def getUserTutorialStep(step):
    def callback(buf):
        # sys.stdout.write(buf)
        data = json.loads(buf)
        print step, data["count"]
        pass

    c = pycurl.Curl()
    c.setopt(pycurl.URL,           LEAN_URL_CLS + '_User?where={"tutorialStep":' + str(step) + '}&count=1&limit=0')
    c.setopt(pycurl.HTTPHEADER,    [LEAN_APP_ID, LEAN_APP_KEY]) 
    c.setopt(pycurl.WRITEFUNCTION, callback)
    c.perform()
    c.close()
    pass

# getDataLevel('level0')
# getUserTutorialStep(0)
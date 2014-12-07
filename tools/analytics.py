#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import pycurl, json, sys

chapter = 0
bookKey = 'ncee'

LEAN_URL      = 'https://leancloud.cn/1.1/'
LEAN_URL_CLS  = LEAN_URL + 'classes/'
LEAN_URL_USER = LEAN_URL + 'users'
LEAN_APP_ID   = "X-AVOSCloud-Application-Id: gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn"
LEAN_APP_KEY  = "X-AVOSCloud-Application-Key: x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3"

def getDataLevel(levelKey, dateCondition):
    def callback(buf):
        # sys.stdout.write(buf)
        data = json.loads(buf)
        print levelKey, data["count"]
        pass

    c = pycurl.Curl()
    c.setopt(pycurl.URL,           LEAN_URL_CLS + 'DataLevel?where={"levelKey":"%s"%s}&count=1&limit=0' % (levelKey, dateCondition))
    c.setopt(pycurl.HTTPHEADER,    [LEAN_APP_ID, LEAN_APP_KEY]) 
    c.setopt(pycurl.WRITEFUNCTION, callback)
    c.perform()
    c.close()
    pass

def getUserTutorialStep(step, dateCondition):
    def callback(buf):
        # sys.stdout.write(buf)
        data = json.loads(buf)
        print step, data["count"]
        pass

    c = pycurl.Curl()
    c.setopt(pycurl.URL,           LEAN_URL_CLS + '_User?where={"tutorialStep":%d%s}&count=1&limit=0' % (step, dateCondition))
    c.setopt(pycurl.HTTPHEADER,    [LEAN_APP_ID, LEAN_APP_KEY]) 
    c.setopt(pycurl.WRITEFUNCTION, callback)
    c.perform()
    c.close()
    pass

# $lt         小于
# $lte        小于等于
# $gt         大于
# $gte        大于等于
# $ne         不等于
# $in         包含
# $nin        不包含
# $exists     这个Key有值
# $select     匹配另一个查询的返回值
# $dontSelect 排除另一个查询的返回值
# $all        包括所有的给定的值
def createDateType(year, month, day):
    return '{"__type":"Date","iso":"%d-%02d-%02dT00:00:00.000Z"}' % (year, month, day)

def createDateWith1Condition(condition, year, month, day):
    return '{"%s":%s}' % (condition, createDateType(year, month, day))

def createDatesWith2Condition(condition0, year0, month0, day0, condition1, year1, month1, day1):
    return '{"%s":%s,"%s":%s}' % (condition0, createDateType(year0, month0, day0), condition1, createDateType(year1, month1, day1))

def getCreatedAt(date):
    return ',"createdAt":%s' % date

def getUpdatedAt(date):
    return ',"updatedAt":%s' % date

# getDataLevel('level0', ',"createdAt":{"$gte":{"__type":"Date","iso":"2014-12-01T00:00:00.000Z"}}')
# getUserTutorialStep(0, getUpdatedAt( createDatesWith2Condition('$gte', 2014, 9, 20, '$lte', 2014, 12, 21) ))

//
//  WMMailFeedBack.m
//  wordmaster3.1
//
//  Created by Bemoo on 8/20/14.
//  Copyright (c) 2014 wordmaster. All rights reserved.
//

#include "CXUtils.h"
#include "platform/android/jni/JniHelper.h"

//公司邮箱号
//beibeidanci@qq.com
//wordmaster721

void CXUtils::showMail(const char* mailTitle, const char* userName)
{
    if (!mailTitle || !userName) 
        return;

    cocos2d::JniMethodInfo t;
    if (cocos2d::JniHelper::getStaticMethodInfo(t, "com/beibei/wordmaster/AppActivity", "showMail", "(Ljava/lang/String;Ljava/lang/String;)V")) {
        jstring stringArg_mailTitle = t.env->NewStringUTF(mailTitle);
        jstring stringArg_userName = t.env->NewStringUTF(userName);

        t.env->CallStaticVoidMethod(t.classID, t.methodID, stringArg_mailTitle, stringArg_userName);

        t.env->DeleteLocalRef(stringArg_mailTitle);
        t.env->DeleteLocalRef(stringArg_userName);
        t.env->DeleteLocalRef(t.classID);
    }
}

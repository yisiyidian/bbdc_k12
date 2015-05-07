//
//  CXAvos.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#ifndef __BeiBei2DXLua__CXAvos__
#define __BeiBei2DXLua__CXAvos__

#include <stdio.h>
#include "cocos2d.h"

typedef int CXLUAFUNC;

class CXAvos : public cocos2d::Ref {
public:
    static CXAvos* getInstance();
    
    void downloadFile(const char* objectId, const char* savepath, CXLUAFUNC nHandler);
    void downloadConfigFiles(const char* objectIds, const char* path);
    void downloadWordSoundFiles(const char* prefix, const char* wordsList, const char* subfix, const char* path);
    void invokeLuaCallbackFunction_dl(const char* objectId, const char* filename, const char* error, bool isSaved);
    
    void signUp(const char* username, const char* password, CXLUAFUNC nHandler);
    void invokeLuaCallbackFunction_su(const char* objectjson, const char* error, int errorcode);
    
    void logIn(const char* username, const char* password, CXLUAFUNC nHandler);
    /*用手机号登陆*/
    void logInByPhoneNumber(const char* PhoneNumber, const char* password, CXLUAFUNC nHandler);
    void invokeLuaCallbackFunction_li(const char* objectjson, const char* error, int errorcode);
    /**请求短信验证码*/
    void requestSMSCode(const char* phoneNumber);
    /**验证短信验证码*/
    void verifySMSCode(const char* phoneNumber,const char* smsCode,CXLUAFUNC mHandler);
    /**验证之后的回调*/
    void invokeLuaCallBackFunction_vc(const char* error,int errorCode);
    
    /**修改密码*/
    void changePwd(const char* username,const char* oldPwd,const char* newPwd,CXLUAFUNC nHandler);
    /**修改密码完成的回调*/
    void invokeLuaCallbackFunction_cp(const char* error, int errorcode);
    
    void initTencentQQ(const char* appId, const char* appKey);
    void logInByQQ(CXLUAFUNC nHandler);
    void logInByQQAuthData(const char* openid, const char* access_token, const char* expires_in, CXLUAFUNC nHandler);
    void invokeLuaCallbackFunction_logInByQQ(const char* objectjson, const char* qqjson, const char* authjson, const char* error, int errorcode);
    
    void logOut();
    
private:
    static CXAvos* m_pInstance;
    CXAvos();
    void init();
    
    int mLuaHandlerId_dl;
    int mLuaHandlerId_signUp;
    int mLuaHandlerId_logIn;
    int mLuaHandlerId_vc;//短信验证在lua中的回调函数句柄
    int mLuaHandlerId_cp;//修改密码在lua中的回调函数句柄
    int mLuaHandlerId_logInByQQ;
};

#endif /* defined(__BeiBei2DXLua__CXAvos__) */

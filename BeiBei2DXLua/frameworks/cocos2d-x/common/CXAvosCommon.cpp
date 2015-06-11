//
//  CXAvos.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#include "CXAvos.h"
#include "CCLuaEngine.h"

using namespace cocos2d;

CXAvos* CXAvos::m_pInstance = nullptr;

CXAvos* CXAvos::getInstance() {
    if (!m_pInstance) {
        m_pInstance = new CXAvos();
    }
    return m_pInstance;
}

CXAvos::CXAvos()
: mLuaHandlerId_dl(0)
, mLuaHandlerId_signUp(0)
, mLuaHandlerId_logIn(0)
, mLuaHandlerId_vc(0)
, mLuaHandlerId_logInByQQ(0) {
    init();
}

void CXAvos::invokeLuaCallbackFunction_dl(const char* objectId, const char* filename, const char* error, bool isSaved)
{
    if (mLuaHandlerId_dl > 0)
    {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectId);
        stack->pushString(filename);
        stack->pushString(error);
        stack->pushBoolean(isSaved);
        stack->executeFunctionByHandler(mLuaHandlerId_dl, 4);
        stack->clean();
    }
}

/**
*   注册帐号回调
*   objectjson  用户数据的json
*   error       错误
*   errorcode   错误号
*/
void CXAvos::invokeLuaCallbackFunction_su(const char* objectjson, const char* error, int errorcode) {
    if (mLuaHandlerId_signUp > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(error);
        stack->pushInt(errorcode);
        stack->executeFunctionByHandler(mLuaHandlerId_signUp, 3);
        stack->clean();
    }
}

/**
 * 登陆回调
 * @param   objectjson  用户数据json
 * @param   error       错误信息
 * @param   errorCode   错误号
 */

void CXAvos::invokeLuaCallbackFunction_li(const char* objectjson, const char* error, int errorcode) {
    if (mLuaHandlerId_logIn > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(error);
        stack->pushInt(errorcode);
        stack->executeFunctionByHandler(mLuaHandlerId_logIn, 3);
        stack->clean();
    }
}

/**
 * 短信验证回调
 * error        错误信息
 * errorCode    错误号
 */
void CXAvos::invokeLuaCallBackFunction_vc(const char* error,int errorCode){
    if(mLuaHandlerId_vc > 0){
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(error);
        stack->pushInt(errorCode);
        stack->executeFunctionByHandler(mLuaHandlerId_vc,2);
        stack->clean();
    }
}
/**
 * 修改密码的回调
 * error        错误信息
 * errorCode    错误号
 */
void CXAvos::invokeLuaCallbackFunction_cp(const char* error,int errorCode){
    if(mLuaHandlerId_cp > 0){
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(error);
        stack->pushInt(errorCode);
        stack->executeFunctionByHandler(mLuaHandlerId_cp, 2);
        stack->clean();
    }
}

/**
 * 验证手机号码有效性  的回调
 */
void CXAvos::invokeLuaCallBackFunction_vp(const char* error,int errorCode){
    if(mLuaHandlerId_vp > 0){
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(error);
        stack->pushInt(errorCode);
        stack->executeFunctionByHandler(mLuaHandlerId_vp, 2);
        stack->clean();
    }
}

/**
 * 通过手机号码+验证码登陆回调
 */
void CXAvos::invokeLuaCallBackFunction_ls(const char* objectjson, const char* error, int errorcode){
    if (mLuaHandlerId_ls > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(error);
        stack->pushInt(errorcode);
        stack->executeFunctionByHandler(mLuaHandlerId_ls, 3);
        stack->clean();
    }
}


void CXAvos::invokeLuaCallbackFunction_logInByQQ(const char* objectjson, const char* qqjson, const char* authjson, const char* error, int errorcode) {
    if (mLuaHandlerId_logInByQQ > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(qqjson);
        stack->pushString(authjson);
        stack->pushString(error);
        stack->pushInt(errorcode);
        stack->executeFunctionByHandler(mLuaHandlerId_logInByQQ, 5);
        stack->clean();
    }
}

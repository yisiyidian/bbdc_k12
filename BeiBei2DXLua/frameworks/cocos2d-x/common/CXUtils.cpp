//
//  CXUtils.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/9/14.
//
//

#include "CXUtils.h"
#include "CCLuaEngine.h"
#include "PluginManager.h"
#include "ProtocolIAP.h"
#include "md5.h"

using namespace std;
using namespace cocos2d;
using namespace cocos2d::plugin;

// ------------------------------------------------------------------------

class _IAP : public PayResultListener {
public:
    static _IAP* getInstance() {
        if (!m_pInstance) {
            m_pInstance = new _IAP();
        }
        return m_pInstance;
    }
    
    // "com.beibei.wordmaster.ep30,com.beibei.wordmaster.b"
    void requestProducts(const char* productIds) {
        PluginParam productId(productIds);
        m_pProtocolIAP->callFuncWithParam("requestProducts", &productId, NULL);
    }
    
    virtual void onPayResult(PayResultCode ret, const char* msg, TProductInfo info) {
        
    }
    
    virtual void onRequestProductsResult(IAPProductRequest ret, TProductList info) {
        CXUtils::getInstance()->invokeLuaCallbackFunction(ret, "yes");
    }

private:
    _IAP() {
        string pluginName("IOSIAP");
        m_pProtocolIAP = dynamic_cast<ProtocolIAP*> (PluginManager::getInstance()->loadPlugin(pluginName.c_str()));
        m_pProtocolIAP->setResultListener(this);
    }
    
    static _IAP* m_pInstance;
    ProtocolIAP* m_pProtocolIAP;
};

_IAP* _IAP::m_pInstance = nullptr;

// ------------------------------------------------------------------------

CXUtils* CXUtils::m_pInstance = nullptr;

CXUtils* CXUtils::getInstance() {
    if (!m_pInstance) {
        m_pInstance = new CXUtils();
    }
    return m_pInstance;
}

CXUtils::CXUtils()
: mLuaHandlerId(0) {
    
}

int toMD5(char* dest, const char* src)
{
    md5_state_t state;
    md5_byte_t digest[16];
    md5_init(&state);
    md5_append(&state, (const md5_byte_t *)src, (int)strlen((char *)src));
    md5_finish(&state, digest);
    
    for (int di = 0; di < 16; ++di) {
        sprintf(dest + di * 2, "%02x", digest[di]);
    }
    return 0;
}

std::string& CXUtils::md5(const char* in, std::string& out)
{
    char md5str[33] = {0,};
    toMD5(md5str, in);
    out = md5str;
    _IAP::getInstance();
    return out;
}

void CXUtils::requestProducts(const char* productIds, int nHandler)
{
    mLuaHandlerId = nHandler;
    _IAP::getInstance()->requestProducts(productIds);
}

void CXUtils::invokeLuaCallbackFunction(int msgId, const char* text)
{
    if (mLuaHandlerId > 0)
    {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushInt(msgId);
        stack->pushString(text);
        stack->executeFunctionByHandler(mLuaHandlerId, 2);
        stack->clean();
    }
}


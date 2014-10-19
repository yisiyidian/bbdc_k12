//
//  CXStore.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/19/14.
//
//

#include "CXStore.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "CCLuaEngine.h"
#include "PluginManager.h"
#include "ProtocolIAP.h"

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
        CXStore::getInstance()->invokeLuaCallbackFunction_requestProducts(ret, "yes");
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
#endif

// ------------------------------------------------------------------------

CXStore* CXStore::m_pInstance = nullptr;

CXStore* CXStore::getInstance() {
    if (!m_pInstance) {
        m_pInstance = new CXStore();
    }
    return m_pInstance;
}

CXStore::CXStore()
: mLuaHandlerId_requestProducts(0) {
    
}

void CXStore::requestProducts(const char* productIds, int nHandler)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    mLuaHandlerId_requestProducts = nHandler;
    _IAP::getInstance()->requestProducts(productIds);
#endif
}

void CXStore::invokeLuaCallbackFunction_requestProducts(int msgId, const char* text)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    if (mLuaHandlerId_requestProducts > 0)
    {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushInt(msgId);
        stack->pushString(text);
        stack->executeFunctionByHandler(mLuaHandlerId_requestProducts, 2);
        stack->clean();
    }
#endif
}

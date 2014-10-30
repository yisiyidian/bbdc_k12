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
    
    // payForProduct
    void payForProduct(const char* productId) {
        StringMap info = {{"productId", productId}};
        PluginParam p(info);
        m_pProtocolIAP->callFuncWithParam("payForProduct", &p, NULL);
    }

#define TProductInfo2Json(json, _INFO_) \
    json += "{"; \
    int j = 0; \
    for (TProductInfo::iterator it = _INFO_.begin(); it != _INFO_.end(); it++) { \
        if (j > 0) json += ","; \
        json += "\""; \
        json += it->first; \
        json += "\":"; \
        json += "\""; \
        json += it->second; \
        json += "\""; \
        j++; \
    } \
    json += "}"; \

    virtual void onPayResult(PayResultCode ret, const char* msg, TProductInfo info) {
        string json("");
        TProductInfo2Json(json, info)
    }

    virtual void onRequestProductsResult(IAPProductRequest ret, TProductList info) {
        size_t size = info.size();
        //productName         The name of product
        //productPrice        The price of product(must can be parse to float)
        //productDesc         The description of product
        string json("{\"product\":[");
        for (size_t i = 0; i < size; i++) {
            if (i > 0) json += ",";
            TProductInfo2Json(json, info[i])
        }
        json += "}";
        CXStore::getInstance()->invokeLuaCallbackFunction_requestProducts(ret, json.c_str());
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
        m_pInstance->autorelease();
    }
    return m_pInstance;
}

CXStore::CXStore()
: mLuaHandlerId_requestProducts(0)
, mLuaHandlerId_payResult(0) {
    
}

void CXStore::requestProducts(const char* productIds, int nHandler)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    mLuaHandlerId_requestProducts = nHandler;
    _IAP::getInstance()->requestProducts(productIds);
#endif
}

void CXStore::invokeLuaCallbackFunction_requestProducts(int code, const char* json)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    if (mLuaHandlerId_requestProducts > 0)
    {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushInt(code);
        stack->pushString(json);
        stack->executeFunctionByHandler(mLuaHandlerId_requestProducts, 2);
        stack->clean();
    }
#endif
}

void CXStore::payForProduct(const char* productId, int nHandler)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    mLuaHandlerId_payResult = nHandler;
    _IAP::getInstance()->payForProduct(productId);
#endif
}

void CXStore::invokeLuaCallbackFunction_payForProduct(int code, const char* msg, const char* json)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    if (mLuaHandlerId_payResult > 0)
    {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushInt(code);
        stack->pushString(msg);
        stack->pushString(json);
        stack->executeFunctionByHandler(mLuaHandlerId_payResult, 3);
        stack->clean();
    }
#endif
}

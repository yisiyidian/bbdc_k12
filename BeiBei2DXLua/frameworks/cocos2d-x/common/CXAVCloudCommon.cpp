//
//  CXAVCloud.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/23/15.
//
//

#include "CXAVCloud.h"
#include "CCLuaEngine.h"

using namespace cocos2d;

CXAVCloud::CXAVCloud()
: m_callback(0) {
    
}

CXAVCloud::~CXAVCloud() {
    
}

void CXAVCloud::invokeCallback(const char* objectjson, const char* errorjson) {
    if (m_callback > 0) {
        auto engine = LuaEngine::getInstance();
        LuaStack* stack = engine->getLuaStack();
        stack->pushString(objectjson);
        stack->pushString(errorjson);
        stack->executeFunctionByHandler(m_callback, 2);
        stack->clean();
    }
}
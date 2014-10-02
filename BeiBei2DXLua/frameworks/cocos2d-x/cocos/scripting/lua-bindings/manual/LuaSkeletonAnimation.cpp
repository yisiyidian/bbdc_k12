/****************************************************************************
 Copyright (c) 2013      Edward Zhou
 Copyright (c) 2013-2014 Chukong Technologies Inc.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "LuaSkeletonAnimation.h"
#include "cocos2d.h"
#include "LuaScriptHandlerMgr.h"
#include "CCLuaStack.h"
#include "CCLuaEngine.h"

using namespace spine;
USING_NS_CC;

static int SendSpineEventToLua(int nHandler, spine::SkeletonAnimation* node, int trackIndex, spEventType type, spEvent* event, int loopCount)
{
    if (nHandler <= 0) {
        return 0;
    }
    
    if (NULL == ScriptEngineManager::getInstance()->getScriptEngine()) {
        return 0;
    }
    
    LuaStack *pStack = LuaEngine::getInstance()->getLuaStack();
    if (NULL == pStack) {
        return 0;
    }
    
    lua_State *tolua_s = pStack->getLuaState();
    if (NULL == tolua_s) {
        return 0;
    }
    
    int nRet = 0;
    
    spTrackEntry* entry = spAnimationState_getCurrent(node->getState(), trackIndex);
    std::string animationName = (entry && entry->animation) ? entry->animation->name : "";
    std::string eventType = "";
    
    switch (type) {
        case SP_ANIMATION_START:
            eventType = "start";
            break;
        case SP_ANIMATION_END:
            eventType = "end";
            break;
        case SP_ANIMATION_COMPLETE:
            eventType = "complete";
            break;
        case SP_ANIMATION_EVENT:
            eventType = "event";
            break;
    }
    
    LuaValueDict spineEvent;
    spineEvent.insert(spineEvent.end(), LuaValueDict::value_type("type", LuaValue::stringValue(eventType)));
    spineEvent.insert(spineEvent.end(), LuaValueDict::value_type("trackIndex", LuaValue::intValue(trackIndex)));
    spineEvent.insert(spineEvent.end(), LuaValueDict::value_type("animation", LuaValue::stringValue(animationName)));
    spineEvent.insert(spineEvent.end(), LuaValueDict::value_type("loopCount", LuaValue::intValue(loopCount)));
    
    if (NULL != event) {
        LuaValueDict eventData;
        eventData.insert(eventData.end(), LuaValueDict::value_type("name", LuaValue::stringValue(event->data->name)));
        eventData.insert(eventData.end(), LuaValueDict::value_type("intValue", LuaValue::intValue(event->intValue)));
        eventData.insert(eventData.end(), LuaValueDict::value_type("floatValue", LuaValue::floatValue(event->floatValue)));
        eventData.insert(eventData.end(), LuaValueDict::value_type("stringValue", LuaValue::stringValue(event->stringValue)));
        spineEvent.insert(spineEvent.end(), LuaValueDict::value_type("eventData", LuaValue::dictValue(eventData)));
    }
    
    pStack->pushLuaValueDict(spineEvent);
    nRet = pStack->executeFunctionByHandler(nHandler, 1);
    pStack->clean();
    return nRet;
    
}

LuaSkeletonAnimation::LuaSkeletonAnimation (const char* skeletonDataFile, const char* atlasFile, float scale)
: spine::SkeletonAnimation(skeletonDataFile, atlasFile, scale)
{
    // this->setAnimationListener(this, animationStateEvent_selector(LuaSkeletonAnimation::animationStateEvent));
    this->setStartListener( [this] (int trackIndex) {
        // spTrackEntry* entry = spAnimationState_getCurrent(skeletonNode->getState(), trackIndex);
        // const char* animationName = (entry && entry->animation) ? entry->animation->name : 0;
        // log("%d start: %s", trackIndex, animationName);
        
        int nHandler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)this, ScriptHandlerMgr::HandlerType::EVENT_SPINE);
        if (0 != nHandler) {
            SendSpineEventToLua(nHandler, this, trackIndex, SP_ANIMATION_START, NULL, 0);
        }
    });
    this->setEndListener( [this] (int trackIndex) {
        // log("%d end", trackIndex);
        
        int nHandler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)this, ScriptHandlerMgr::HandlerType::EVENT_SPINE);
        if (0 != nHandler) {
            SendSpineEventToLua(nHandler, this, trackIndex, SP_ANIMATION_END, NULL, 0);
        }
    });
    this->setCompleteListener( [this] (int trackIndex, int loopCount) {
        // log("%d complete: %d", trackIndex, loopCount);
        int nHandler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)this, ScriptHandlerMgr::HandlerType::EVENT_SPINE);
        if (0 != nHandler) {
            SendSpineEventToLua(nHandler, this, trackIndex, SP_ANIMATION_COMPLETE, NULL, loopCount);
        }
    });
    this->setEventListener( [this] (int trackIndex, spEvent* event) {
        // log("%d event: %s, %d, %f, %s", trackIndex, event->data->name, event->intValue, event->floatValue, event->stringValue);
        int nHandler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)this, ScriptHandlerMgr::HandlerType::EVENT_SPINE);
        if (0 != nHandler) {
            SendSpineEventToLua(nHandler, this, trackIndex, SP_ANIMATION_EVENT, event, 0);
        }
    });
}


LuaSkeletonAnimation::~LuaSkeletonAnimation()
{
    ScriptHandlerMgr::getInstance()->removeObjectAllHandlers((void*)this);
}

LuaSkeletonAnimation* LuaSkeletonAnimation::createWithFile (const char* skeletonDataFile, const char* atlasFile, float scale)
{
    LuaSkeletonAnimation* node = new LuaSkeletonAnimation(skeletonDataFile, atlasFile, scale);
    node->autorelease();
    return node;
}

// void LuaSkeletonAnimation::animationStateEvent (spine::SkeletonAnimation* node, int trackIndex, spEventType type, spEvent* event, int loopCount)
// {
// int nHandler = ScriptHandlerMgr::getInstance()->getObjectHandler((void*)this, ScriptHandlerMgr::HandlerType::EVENT_SPINE);
// if (0 != nHandler) {
// SendSpineEventToLua(nHandler, node, trackIndex, type, event, loopCount);
// }
// }
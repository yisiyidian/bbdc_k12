//
//  CXAvos.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#include "CXAvos.h"
#import <AVOSCloud/AVOSCloud.h>
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
: mLuaHandlerId_dl(0) {
    
}

void CXAvos::downloadFile(const char* objectId, const char* savepath, CXLUAFUNC nHandler) {
    mLuaHandlerId_dl = nHandler;
    [AVFile getFileWithObjectId:[NSString stringWithUTF8String:objectId] withBlock:^(AVFile *file, NSError *error) {
        if (!file || error) {
            invokeLuaCallbackFunction_dl(objectId, file ? file.name.UTF8String : "", error ? error.localizedDescription.UTF8String : "get file object error", false);
            return;
        }
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                invokeLuaCallbackFunction_dl(objectId, file.name.UTF8String, error.localizedDescription.UTF8String, false);
            } else {
                NSString *filePath = [[NSString stringWithUTF8String:savepath] stringByAppendingPathComponent:file.name];
                [data writeToFile:filePath atomically:YES];
                invokeLuaCallbackFunction_dl(objectId, file.name.UTF8String, "save file succeed", true);
            }
        } progressBlock:^(NSInteger percentDone) {
            //
        }];
    }];
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
//
//  CXAVCloud.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/23/15.
//
//

#include "CXAVCloud.h"
#import <AVOSCloud/AVOSCloud.h>
#include "CXUtils_iOS.h"

void CXAVCloud::callAVCloudFunction(const std::string& func, const std::string& parameters/*json*/, CXLUAFUNC callback) {
    NSString* avcloudFunc = [NSString stringWithUTF8String:func.c_str()];
    
    NSString* jsonString = [NSString stringWithUTF8String:parameters.c_str()];
    NSError* error_json = nil;
    NSDictionary* parsedData = JSONStringToNSDictionary(jsonString, &error_json);
    
    m_callback = callback;
    
    retain();
#if (COCOS2D_DEBUG > 0)
    NSString* funcx = [NSString stringWithUTF8String:func.c_str()];
    NSString* parametersx = [NSString stringWithUTF8String:parameters.c_str()];
#endif
    if (error_json == nil) {
        [AVCloud callFunctionInBackground:avcloudFunc withParameters:parsedData block:^(id object, NSError *error) {
            if (error) {
#if (COCOS2D_DEBUG > 0)
                CCLOG("funcx:%s", funcx.UTF8String);
                CCLOG("parametersx:%s", parametersx.UTF8String);
#endif
                NSString* errorjson = NSErrorToJSONString(error);
                invokeCallback(nullptr, errorjson.UTF8String);
            } else {
                NSString* objectjson = NSDictionaryToJSONString(object);
                invokeCallback(objectjson.UTF8String, nullptr);
            }
            release();
        }];
    } else {
        NSString* errorjson = NSErrorToJSONString(error_json);
        invokeCallback(nullptr, errorjson.UTF8String);
        release();
    }
}
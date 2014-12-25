//
//  CXAvos.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#include "CXAvos.h"
#include "CCLuaEngine.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import <AVOSCloudSNS/AVUser+SNS.h>
#import "CXTencentSDKCall.h"

NSString* NSDictionaryToJSONString(NSDictionary* json) {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        CCLOG("AVUserToJsonStr Got an error: %s", error.localizedDescription.UTF8String);
        return @"{}";
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

NSString* AVUserToJsonStr(AVUser* user) {
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    
    json[@"objectId"] = user.objectId;
    json[@"username"] = user.username;
    json[@"sessionToken"] = user.sessionToken;
    json[@"createdAt"] = @([user.createdAt timeIntervalSince1970]);
    json[@"updatedAt"] = user.updatedAt ? @([user.updatedAt timeIntervalSince1970]) : json[@"createdAt"];
    for (NSString* key in user.allKeys) {
        id obj = [user objectForKey:key];
        if ([obj isKindOfClass:[NSString class]]) {
            json[key] = ((NSString*)obj);
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            json[key] = ((NSNumber*)obj);
        }
    }
    
    return NSDictionaryToJSONString(json);
}

#pragma mark -

@interface CXTencentSDKCallObserver : NSObject 
@end

@implementation CXTencentSDKCallObserver

static CXTencentSDKCallObserver* cxTencentSDKCallObserver = nil;

+ (CXTencentSDKCallObserver*)getInstance {
    @synchronized([CXTencentSDKCallObserver class]) {
        if (cxTencentSDKCallObserver == nil) {
            cxTencentSDKCallObserver = [[self alloc] init];
        }
    }
    return cxTencentSDKCallObserver;
}

- (id) init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:[CXTencentSDKCall getinstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:[CXTencentSDKCall getinstance]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo:) name:kGetUserInfoResponse object:[CXTencentSDKCall getinstance]];
    }
    return self;
}

- (void)loginSuccessed {
    TencentOAuth* oauth = [CXTencentSDKCall getinstance].oauth;
    BOOL isGotUserInfo = [oauth getUserInfo];
    if (isGotUserInfo == NO) {
        CXAvos::getInstance()->invokeLuaCallbackFunction_logInByQQ(nullptr, nullptr, nullptr, "QQ log in error", 0);
    }
}

- (void)loginFailed {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

- (void)getUserInfo:(NSNotification*)info {
    NSDictionary* userinfo = [info userInfo];
    APIResponse* response = userinfo != nil ? userinfo[kResponse] : nil;
    TencentOAuth* oauth = [CXTencentSDKCall getinstance].oauth;
    NSDictionary* authData = @{@"openid":oauth.openId,
                               @"access_token":oauth.accessToken,
                               @"expires_in":[NSString stringWithFormat:@"%ld", (long)oauth.expirationDate.timeIntervalSince1970]};
    [AVUser loginWithAuthData:authData
                     platform:AVOSCloudSNSPlatformQQ
                        block:^(AVUser *user, NSError *error) {
        CXAvos::getInstance()->invokeLuaCallbackFunction_logInByQQ(user ? AVUserToJsonStr(user).UTF8String : nullptr,
                                                                   response ? [response message].UTF8String : nullptr,
                                                                   NSDictionaryToJSONString(authData).UTF8String,
                                                                   error ? error.localizedDescription.UTF8String : nullptr,
                                                                   error ? (int)error.code : 0);
    }];
}

@end

#pragma mark -

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
, mLuaHandlerId_logInByQQ(0) {
    [CXTencentSDKCallObserver getInstance];
}

void CXAvos::downloadFile(const char* objectId, const char* savepath, CXLUAFUNC nHandler) {
    NSString* oID = [NSString stringWithUTF8String:objectId];
    NSString* path = [NSString stringWithUTF8String:savepath];
    mLuaHandlerId_dl = nHandler;
    
    [AVFile getFileWithObjectId:oID withBlock:^(AVFile *file, NSError *error) {
        if (!file || error) {
            invokeLuaCallbackFunction_dl(oID.UTF8String, file ? file.name.UTF8String : "", error ? error.localizedDescription.UTF8String : "get file object error", false);
            return;
        }
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                invokeLuaCallbackFunction_dl(oID.UTF8String, file.name.UTF8String, error.localizedDescription.UTF8String, false);
            } else {
                NSString *filePath = [path stringByAppendingPathComponent:file.name];
                [data writeToFile:filePath atomically:YES];
                invokeLuaCallbackFunction_dl(oID.UTF8String, file.name.UTF8String, "save file succeed", true);
            }
        } progressBlock:^(NSInteger percentDone) {
            //
        }];
    }];
}

void CXAvos::downloadConfigFiles(const char* objectIds, const char* path) {
    
}

void CXAvos::downloadWordSoundFiles(const char* prefix, const char* wordsList, const char* subfix, const char* path) {
    
}

void CXAvos::invokeLuaCallbackFunction_dl(const char* objectId, const char* filename, const char* error, bool isSaved) {
    if (mLuaHandlerId_dl > 0) {
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

void CXAvos::signUp(const char* username, const char* password, CXLUAFUNC nHandler) {
    mLuaHandlerId_signUp = nHandler;
    AVUser* user = [AVUser user];
    user.username = [NSString stringWithUTF8String:username];
    user.password = [NSString stringWithUTF8String:password];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        const char* objson = nullptr;
        if (user && user.objectId) {
            objson = AVUserToJsonStr(user).UTF8String;
        }
        invokeLuaCallbackFunction_su(objson, error ? error.localizedDescription.UTF8String : nullptr, error ? (int)error.code : 0);
    }];
}

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

void CXAvos::logIn(const char* username, const char* password, CXLUAFUNC nHandler) {
    mLuaHandlerId_logIn = nHandler;
    [AVUser logInWithUsernameInBackground:[NSString stringWithUTF8String:username] password:[NSString stringWithUTF8String:password] block:^(AVUser *user, NSError *error) {
        invokeLuaCallbackFunction_li(user ? AVUserToJsonStr(user).UTF8String : nullptr, error ? error.localizedDescription.UTF8String : nullptr, error ? (int)error.code : 0);
    }];
}

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

void CXAvos::logInByQQ(CXLUAFUNC nHandler) {
    mLuaHandlerId_logInByQQ = nHandler;
    [[CXTencentSDKCall getinstance] login];
}

void CXAvos::logInByQQAuthData(const char* openid, const char* access_token, const char* expires_in, CXLUAFUNC nHandler) {
    mLuaHandlerId_logInByQQ = nHandler;
    NSDictionary* authData = @{@"openid":[NSString stringWithUTF8String:openid],
                               @"access_token":[NSString stringWithUTF8String:access_token],
                               @"expires_in":[NSString stringWithUTF8String:expires_in]};
    [AVUser loginWithAuthData:authData
                     platform:AVOSCloudSNSPlatformQQ
                        block:^(AVUser *user, NSError *error) {
        invokeLuaCallbackFunction_logInByQQ(user ? AVUserToJsonStr(user).UTF8String : nullptr,
                                            nullptr,
                                            nullptr,
                                            error ? error.localizedDescription.UTF8String : nullptr,
                                            error ? (int)error.code : 0);
    }];
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

void CXAvos::logOut() {
    [AVUser logOut];
}

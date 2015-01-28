//
//  CXUtils_iOS.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/23/15.
//
//

#include "CXUtils_iOS.h"
#include "cocos2d.h"
#import <AVOSCloud/AVOSCloud.h>

NSString* NSDictionaryToJSONString(NSDictionary* json) {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        CCLOG("NSDictionaryToJSONString Got an error: %s", error.localizedDescription.UTF8String);
        return @"{}";
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

NSDictionary* JSONStringToNSDictionary(NSString* jsonString, NSError** error) {
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:error];
    return parsedData;
}

NSString* NSErrorToJSONString(NSError* error) {
    NSString* description = [error.description stringByReplacingOccurrencesOfString:@"\"" withString:@"\'"];
    NSString* ret = [NSString stringWithFormat:@"{\"code\":%ld,\"message\":\"%@\",\"description\":\"%@\"}", (long)error.code, description, error.localizedDescription];
    return ret;
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

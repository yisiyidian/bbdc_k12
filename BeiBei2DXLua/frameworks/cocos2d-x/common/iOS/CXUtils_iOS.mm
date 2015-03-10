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

NSString * NSObjectToJSONString(id theData) {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        CCLOG("NSObjectToJSONData Got an error: %s", error ? error.localizedDescription.UTF8String : "length == 0");
        return @"{}";    }
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
    
    if (user.objectId) json[@"objectId"] = user.objectId;
    if (user.username) json[@"username"] = user.username;
    if (user.sessionToken) json[@"sessionToken"] = user.sessionToken;
    if (user.createdAt) json[@"createdAt"] = @([user.createdAt timeIntervalSince1970]);
    if (user.createdAt) json[@"updatedAt"] = user.updatedAt ? @([user.updatedAt timeIntervalSince1970]) : json[@"createdAt"];
    for (NSString* key in user.allKeys) {
        id obj = [user objectForKey:key];
        if (obj && [obj isKindOfClass:[NSString class]]) {
            json[key] = ((NSString*)obj);
        } else if (obj && [obj isKindOfClass:[NSNumber class]]) {
            json[key] = ((NSNumber*)obj);
        }
    }
    
    return NSObjectToJSONString(json);
}

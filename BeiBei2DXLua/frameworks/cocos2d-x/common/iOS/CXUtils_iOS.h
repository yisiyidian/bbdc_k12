//
//  CXUtils_iOS.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 1/23/15.
//
//

#ifndef __BeiBei2DXLua__CXUtils_iOS__
#define __BeiBei2DXLua__CXUtils_iOS__

#include <stdio.h>

@class AVUser;

NSString* NSObjectToJSONString(id json);
NSDictionary* JSONStringToNSDictionary(NSString* jsonString, NSError** error);
NSString* NSErrorToJSONString(NSError* error);

NSString* AVUserToJsonStr(AVUser* user);

#pragma mark - FileDownloader

@interface FileDownloader : NSObject <NSURLConnectionDelegate>
{
    NSMutableData* fileData;
    NSString* savePath;
}

-(void)download:(NSString*)url saveTo:(NSString*)path;

@end

#endif /* defined(__BeiBei2DXLua__CXUtils_iOS__) */

//
//  CXUtils.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/9/14.
//
//

#include "CXUtils.h"
#import "CXTencentSDKCall.h"
#import "WXApi.h"

void CXUtils::shareImageToQQFriend(const std::string& path, const std::string& title, const std::string& desc) {
    [[CXTencentSDKCall getInstance] shareImageToQQFriend:[NSString stringWithUTF8String:path.c_str()]
                                                   title:[NSString stringWithUTF8String:title.c_str()]
                                                    desc:[NSString stringWithUTF8String:desc.c_str()]];
}

void CXUtils::shareImageToWeiXin(const std::string& path, const std::string& title, const std::string& desc) {
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"Icon-72.png"]];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = [NSData dataWithContentsOfFile:[NSString stringWithUTF8String:path.c_str()]];
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_APP";
    message.title = [NSString stringWithUTF8String:title.c_str()];
    message.description = [NSString stringWithUTF8String:desc.c_str()];
    message.messageExt = [NSString stringWithUTF8String:title.c_str()];
    message.messageAction = @"<action>dotalist</action>";
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];

}

void CXUtils::addImageToGallery(const std::string& filePath) {
    NSString* path = [NSString stringWithUTF8String:filePath.c_str()];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    });
}

//std::string CXUtils::getExternalStorageDirectory() {
//    return cocos2d::FileUtils::getInstance()->getWritablePath();
//}

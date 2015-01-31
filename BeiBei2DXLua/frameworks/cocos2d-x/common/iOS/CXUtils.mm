//
//  CXUtils.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/9/14.
//
//

#include "CXUtils.h"
#import "CXTencentSDKCall.h"

void CXUtils::shareImageToQQFriend(const std::string& path, const std::string& title, const std::string& desc) {
    [[CXTencentSDKCall getInstance] shareImageToQQFriend:[NSString stringWithUTF8String:path.c_str()]
                                                   title:[NSString stringWithUTF8String:title.c_str()]
                                                    desc:[NSString stringWithUTF8String:desc.c_str()]];
}

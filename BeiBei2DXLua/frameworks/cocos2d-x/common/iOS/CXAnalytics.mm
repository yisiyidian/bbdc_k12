//
//  CXAnalytics.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 10/8/14.
//
//

#include "CXAnalytics.h"
#import <AVOSCloud/AVOSCloud.h>

void CXAnalytics::beginLog(const char* pageName) {
    [AVAnalytics beginLogPageView:[NSString stringWithUTF8String:pageName]];
}

void CXAnalytics::endLog(const char* pageName) {
    [AVAnalytics endLogPageView:[NSString stringWithUTF8String:pageName]];
}

void CXAnalytics::logEventAndLabel(const char* event, const char* label) {
    [AVAnalytics event:[NSString stringWithUTF8String:event]
                 label:[NSString stringWithUTF8String:label]];
}
//
//  CXProgressHUD.cpp
//  BeiBei2DXLua
//
//  Created by Bemoo on 11/23/14.
//
//

#include "CXProgressHUD.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD/MBProgressHUD.h"

static UIWindow* _window = nullptr;

void CXProgressHUD::setupWindow(void* uiWindow) {
    _window = (UIWindow*)uiWindow;
}

void CXProgressHUD::show(const char* content) {
    CXProgressHUD::hide();
    if (_window) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_window animated:YES];
        hud.labelText = [NSString stringWithUTF8String:(content ? content : "")];
    }
}

void CXProgressHUD::hide() {
    if (_window) {
        [MBProgressHUD hideHUDForView:_window animated:YES];
    }
}

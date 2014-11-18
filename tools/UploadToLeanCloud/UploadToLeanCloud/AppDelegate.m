//
//  AppDelegate.m
//  UploadToLeanCloud
//
//  Created by Bemoo on 11/18/14.
//  Copyright (c) 2014 BBDC. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>

#define LEAN_CLOUD_ID_TEST   @"gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn"
#define LEAN_CLOUD_KEY_TEST  @"x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3"

#define LEAN_CLOUD_ID        @"94uw2vbd553rx8fa6h5kt2y1w07p0x2ekwusf4w88epybnrp"
#define LEAN_CLOUD_KEY       @"lqsgx6mtmj65sjgrekfn7e5c28xc7koptbk9mqag2oraagdz"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
#ifdef DEBUG
#if DEBUG_APPSTORE_SERVER == 0
    [AVOSCloud setApplicationId:LEAN_CLOUD_ID_TEST
                      clientKey:LEAN_CLOUD_KEY_TEST];
#else
    [AVOSCloud setApplicationId:LEAN_CLOUD_ID
                      clientKey:LEAN_CLOUD_KEY];
#endif
    [AVCloud setProductionMode:NO];
#else
    [AVOSCloud setApplicationId:LEAN_CLOUD_ID
                      clientKey:LEAN_CLOUD_KEY];
    [AVCloud setProductionMode:YES];
#endif
    
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end

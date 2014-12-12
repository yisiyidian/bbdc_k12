/****************************************************************************
 Copyright (c) 2010-2013 cocos2d-x.org
 Copyright (c) 2013-2014 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#import "AppController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "platform/ios/CCEAGLView-ios.h"

#import <AVOSCloud/AVOSCloud.h>
#include "CXProgressHUD.h"

@implementation AppController

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

#define LEAN_CLOUD_ID_TEST   @"gqzttdmaxmb451s2ypjkkdj91a0m9izsk069hu4wji3tuepn"
#define LEAN_CLOUD_KEY_TEST  @"x6uls40kqxb3by8uig1b42v9m6erd2xd6xqtw1z3lpg4znb3"

#define LEAN_CLOUD_ID        @"94uw2vbd553rx8fa6h5kt2y1w07p0x2ekwusf4w88epybnrp"
#define LEAN_CLOUD_KEY       @"lqsgx6mtmj65sjgrekfn7e5c28xc7koptbk9mqag2oraagdz"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    
//    [AVOSCloud setApplicationId:LEAN_CLOUD_ID
//                      clientKey:LEAN_CLOUD_KEY];
//    [AVCloud setProductionMode:YES];
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();

    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    CCEAGLView *eaglView = [CCEAGLView viewWithFrame: [window bounds]
                                     pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
                                     depthFormat: cocos2d::GLViewImpl::_depthFormat
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples: 0 ];

    [eaglView setMultipleTouchEnabled:NO];
    
    //
    CXProgressHUD::setupWindow(window);
    
    // Use RootViewController manage CCEAGLView
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;
    viewController.view = eaglView;

    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:viewController];
    }
    
    [window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarHidden: YES];
    
    // Notifications
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }

    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);

    app->run();
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    cocos2d::Director::getInstance()->pause();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    cocos2d::Director::getInstance()->resume();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
    
    [self pushNotification:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
     cocos2d::Director::getInstance()->purgeCachedData();
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -

-(RootViewController*) getViewController {
    return viewController;
}

#pragma mark - push notification

NSInteger getCurrentCalendarHour(NSDate* d)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componets = [calendar components: NSHourCalendarUnit fromDate: d];
    return componets.hour;
}

-(void)pushNotification:(UIApplication *)application
{
    int ONE_HOUR_SECONDS = 60 * 60;
    int applicationIconBadgeNumber = 0;
    
    NSDate * now = [NSDate date];
    NSInteger hourNow = getCurrentCalendarHour(now);
    NSInteger offsetTomorrow12 = 12 - hourNow + 24;
    
    NSInteger offsetTomorrow20 = 20 - hourNow + 24;
    NSInteger offsetDayAfterTomorrow20 = 20 - hourNow + 48;
    
    NSString* TEXT_ID_PUSH_A = @"救命啊！有怪兽！";
    NSString* TEXT_ID_PUSH_B = @"又在刷朋友圈，还不赶紧来贝贝单词？";
    NSString* TEXT_ID_PUSH_C = @"没时间解释了！快点来帮帮我！";
    NSString* TEXT_ID_PUSH_2DAYS = @"好久不见啦，贝贝想你啦！";
    
    NSString* textsA[] = {TEXT_ID_PUSH_A, TEXT_ID_PUSH_C};
    NSString* textsB[] = {TEXT_ID_PUSH_B, TEXT_ID_PUSH_A};
    NSString* textsC[] = {TEXT_ID_PUSH_C, TEXT_ID_PUSH_B};
    
    NSString* * texts = textsA;
    int value = (arc4random() % 300) + 1;
    if (value > 200)
    {
        texts = textsB;
    }
    else if (value > 100 && value <= 200)
    {
        texts = textsC;
    }
    
#define DEBUG_PUSH 0
#if DEBUG_PUSH == 1
    ONE_HOUR_SECONDS = 1;
    offsetTomorrow12 = 1;
    
    offsetTomorrow20 = 3;
    offsetDayAfterTomorrow20 = 4;
#endif
    
    //
    BOOL fired = [self fireNotification:application
                                fromNow:now
                           afterSeconds:ONE_HOUR_SECONDS * offsetTomorrow12
                            badgeNumber:applicationIconBadgeNumber + 1
                              alertBody:texts[0]
                                   info:@"not_login_today_12_00"];
    if (fired)
        applicationIconBadgeNumber++;
    else
        return;
    
    //
    fired = [self fireNotification:application
                           fromNow:now
                      afterSeconds:ONE_HOUR_SECONDS * offsetTomorrow20
                       badgeNumber:applicationIconBadgeNumber + 1
                         alertBody:texts[1]
                              info:@"not_login_today_20_00"];
    if (fired)
        applicationIconBadgeNumber++;
    
    //
    fired = [self fireNotification:application
                           fromNow:now
                      afterSeconds:ONE_HOUR_SECONDS * offsetDayAfterTomorrow20
                       badgeNumber:applicationIconBadgeNumber + 1
                         alertBody:TEXT_ID_PUSH_2DAYS
                              info:@"not_login_2_days"];
    if (fired)
        applicationIconBadgeNumber++;
}

- (BOOL)fireNotification:(UIApplication *)application
                 fromNow:(NSDate*)now
            afterSeconds:(NSTimeInterval)seconds
             badgeNumber:(int)num
               alertBody:(NSString*)alertBody
                    info:(NSString*)info
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (!notification) return NO;
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = [now dateByAddingTimeInterval:seconds];
    notification.applicationIconBadgeNumber = num;
    notification.alertBody = alertBody;
    
    //    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:info forKey:NOTIFICATION_USERINFO_KEY];
    //    notification.userInfo = infoDict;
    
    [application scheduleLocalNotification:notification];
    
    return YES;
}

@end


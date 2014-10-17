//
//  WMMailFeedBack.m
//  wordmaster3.1
//
//  Created by Bemoo on 8/20/14.
//  Copyright (c) 2014 wordmaster. All rights reserved.
//

#include "CXUtils.h"

#import "AppController.h"
#import "RootViewController.h"
#include "cocos2d.h"

//公司邮箱号
//beibeidanci@qq.com
//wordmaster721

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface WMMailFeedBack : NSObject <MFMailComposeViewControllerDelegate>

+(instancetype)sharedWMMailFeedBack;
-(void)showMail:(NSString*)mailTitle userName:(NSString*)userName;

@end

@implementation WMMailFeedBack

+(instancetype)sharedWMMailFeedBack
{
    static dispatch_once_t once;
    static id _sharedWMMailFeedBack;
    dispatch_once(&once, ^{
        _sharedWMMailFeedBack = [[self alloc] init];
    });
    return _sharedWMMailFeedBack;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (controller)
        [controller dismissViewControllerAnimated:YES completion:^{
        }];
    if (error)
        CCLOG("%s", error.localizedDescription.UTF8String);
}

-(void)showMail:(NSString*)mailTitle userName:(NSString*)userName
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:@[@"beibeidanci@qq.com"]];
    [controller setSubject:[NSString stringWithFormat:@"%@:%@", mailTitle, userName]];
    [controller setMessageBody:@"" isHTML:NO];
    
    UIApplication *app = [UIApplication sharedApplication];
    AppController* c = (AppController*)app.delegate;
    if (c && controller) [[c getViewController] presentViewController:controller animated:YES completion:^{
    }];
}

@end

void CXUtils::showMail(const char* mailTitle, const char* userName)
{
    [[WMMailFeedBack sharedWMMailFeedBack] showMail:[NSString stringWithUTF8String:mailTitle]
                                           userName:[NSString stringWithUTF8String:userName]];
}

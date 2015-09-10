//
//  CXTencentSDKCall.h
//  BeiBei2DXLua
//
//  Created by Bemoo on 12/20/14.
//
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

#import "AppVersionInfo.h"

//response
#define kCGIRequest @"kTencentCGIRequest"
#define kResponse @"kResponse"
#define kTencentOAuth @"oauth"
#define kUIViewController @"UIViewController"
#define kTencentRespObj @"kTencentRespObj"

//delagate

//login
#define kLoginSuccessed @"loginSuccessed"
#define kLoginFailed    @"loginFailed"

#define kLogLogOut @"logOut"

//qzone
#define kGetUserInfoResponse @"getUserInfoResponse"
#define kAddShareResponse @"addShareResponse"
#define kUploadPicResponse @"uploadPicResponse"
#define kGetListAlbumResponse @"getListResponse"
#define kGetListPhotoResponse @"getListPhotoResponse"
#define kAddTopicResponse @"addTopicResponse"
#define kChangePageFansResponse @"changePageFansResponse"
#define kAddAlbumResponse @"kAddAlbumResponse"
#define kAddOneBlogResponse @"kAddOneBlogResponse"
#define kSetUserHeadPicResponse @"kSetUserHeadPicResponse"
#define kGetVipInfoResponse @"kGetVipInfoResponse"
#define kGetVipRichInfoResponse @"kGetVipRichInfoResponse"
#define kSendStoryResponse @"kSendStoryResponse"
#define kCheckPageFansResponse @"kCheckPageFansResponse"

//微博
#define kMatchNickTipsResponse @"kMatchNickTipsResponse"
#define kGetIntimateFriendsResponse @"kGetIntimateFriendResponse"

//TCAPIRequest
#define kTencentCGIRequest     @"kTencentCGIRequest"

//tencentApi
#define kTencentApiResp @"kTencentApiResp"

//????
#define kCloseWnd @"kCloseWnd"

@interface CXTencentSDKCall : NSObject<TencentSessionDelegate, TencentApiInterfaceDelegate, TCAPIRequestDelegate>

@property (nonatomic, retain)TencentOAuth *oauth;

+ (CXTencentSDKCall *)getInstance;
+ (void)resetSDK;

+ (void)showInvalidTokenOrOpenIDMessage;

- (void)setAppId:(NSString*)appid appKey:(NSString*)appKey;
- (void)login;
- (void)logout;

- (void)shareImageToQQFriend:(NSString*)path title:(NSString*)title desc:(NSString*)desc;
- (void)shareURLToQQFriend:(NSString*)path title:(NSString*)title desc:(NSString*)desc;
@end

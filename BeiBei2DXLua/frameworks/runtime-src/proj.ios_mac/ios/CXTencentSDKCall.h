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

#define TENCENT_APP_ID @"1103783596"

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

+ (CXTencentSDKCall *)getinstance;
+ (void)resetSDK;

+ (void)showInvalidTokenOrOpenIDMessage;

- (void)login;

@end
//
//  CXTencentSDKCall.m
//  BeiBei2DXLua
//
//  Created by Bemoo on 12/20/14.
//
//

#import "CXTencentSDKCall.h"

@implementation CXTencentSDKCall

static CXTencentSDKCall *g_instance = nil;
@synthesize oauth = _oauth;

+ (CXTencentSDKCall *)getInstance {
    @synchronized(self) {
        if (nil == g_instance) {
            g_instance = [[super allocWithZone:nil] init];
        }
    }
    
    return g_instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self getInstance] retain];
}

+ (void)showInvalidTokenOrOpenIDMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"api调用失败"
                                                    message:@"可能授权已过期，请重新获取"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

+ (void)resetSDK {
    g_instance = nil;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)setAppId:(NSString*)appid appKey:(NSString*)appKey {
    _oauth = [[TencentOAuth alloc] initWithAppId:appid andDelegate:self];
}

- (void)login {
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                            kOPEN_PERMISSION_ADD_ALBUM,
//                            kOPEN_PERMISSION_ADD_IDOL,
//                            kOPEN_PERMISSION_ADD_ONE_BLOG,
//                            kOPEN_PERMISSION_ADD_PIC_T,
//                            kOPEN_PERMISSION_ADD_SHARE,
//                            kOPEN_PERMISSION_ADD_TOPIC,
//                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
//                            kOPEN_PERMISSION_DEL_IDOL,
//                            kOPEN_PERMISSION_DEL_T,
//                            kOPEN_PERMISSION_GET_FANSLIST,
//                            kOPEN_PERMISSION_GET_IDOLLIST,
//                            kOPEN_PERMISSION_GET_INFO,
//                            kOPEN_PERMISSION_GET_OTHER_INFO,
//                            kOPEN_PERMISSION_GET_REPOST_LIST,
//                            kOPEN_PERMISSION_LIST_ALBUM,
//                            kOPEN_PERMISSION_UPLOAD_PIC,
//                            kOPEN_PERMISSION_GET_VIP_INFO,
//                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
//                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
//                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];
    
    [_oauth authorize:permissions inSafari:NO];
}

- (void)logout {
    [_oauth logout:self];
}

#pragma mark -

- (void)tencentDidLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessed object:self];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self];
}

- (void)tencentDidNotNetWork {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailed object:self];
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams {
    return nil;
}

- (void)tencentDidLogout {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogLogOut object:self];
}

- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions {
    return YES;
}

- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth {
    return YES;
}

- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth {
}

- (void)tencentFailedUpdate:(UpdateFailType)reason {
}

- (void)getUserInfoResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetUserInfoResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)getListAlbumResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetListAlbumResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)getListPhotoResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetListPhotoResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)checkPageFansResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCheckPageFansResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)addShareResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddShareResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)addAlbumResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddAlbumResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)uploadPicResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kUploadPicResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)addOneBlogResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddOneBlogResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)addTopicResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddTopicResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)setUserHeadpicResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSetUserHeadPicResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)getVipInfoResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetVipInfoResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)getVipRichInfoResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetVipRichInfoResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)matchNickTipsResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMatchNickTipsResponse object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)getIntimateFriendsResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetIntimateFriendsResponse object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)sendStoryResponse:(APIResponse*) response {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSendStoryResponse object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, kResponse, nil]];
}

- (void)tencentOAuth:(TencentOAuth *)tencentOAuth didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite userData:(id)userData {
    
}

- (void)tencentOAuth:(TencentOAuth *)tencentOAuth doCloseViewController:(UIViewController *)viewController {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:tencentOAuth, kTencentOAuth,
                              viewController, kUIViewController, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloseWnd object:self  userInfo:userInfo];
}

- (BOOL)onTencentReq:(TencentApiReq *)req {
    
    return YES;
}

- (void)shareImageToQQFriend:(NSString*)path title:(NSString*)title desc:(NSString*)desc {
    
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    QQApiImageObject* img = [QQApiImageObject objectWithData:data previewImageData:data title:title description:desc];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)shareURLToQQFriend:(NSString*)path title:(NSString*)title desc:(NSString*)desc {
    NSString *utf8String = path;
    NSString *previewImageUrl = @"http://yisiyidian.com/doubi/html5/logo.jpg";
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String] title:title description:desc previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        default:
        {
            break;
        }
    }
}

@end

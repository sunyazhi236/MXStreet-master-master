//
//  CheckParam.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/25.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "CustomUtil.h"
#import "TabBarController.h"
#import "WeiboUser.h"
#import "PhoneBookViewController.h"
#import "MainPageTabBarController.h"
#import "MBProgressHUD.h"
#import "IMPointLoadingView.h"

#define LOADING_VIEW_TEXT                   @"加载中..."

@implementation CustomUtil

// ProgressHUD使用
static MBProgressHUD * _loadingHUD;
static MBProgressHUD * _hintHUD;

static CGFloat keyBoardMoveHeight = 0;
static TencentOAuth *_tencentOAuth= nil;
static NSString *openId = nil; //腾讯登录openId

//获取单例对象
+ (instancetype)shareInstance
{
    static CustomUtil *shareInstance = nil;

    @synchronized(self) {
        if (!shareInstance) {
            shareInstance = [[super alloc] init];
        }
    }
    
    return shareInstance;
}

//检查参数是否为空
+ (BOOL)CheckParam:(NSString *)paramStr
{
    if ((YES == [@"" isEqualToString:paramStr]) || (YES == ([@"" isEqualToString:paramStr] || (nil == paramStr))) || (NULL == paramStr) || ([@"<null>" isEqualToString:paramStr])) {
        return YES;
    }

    return NO;
}

//自定义AlertView（iOS8以上）
+ (void)showCustomAlertView:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftHandle:(void (^)(UIAlertAction *action))leftHandle rightHandle:(void (^)(UIAlertAction *action))rightHandle target:(UIViewController *)target btnCount:(int)btnCount;
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:leftHandle];
    [alertCtrl addAction:leftAction];
    if (btnCount > 1) {
        UIAlertAction *rightAction = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleDefault handler:rightHandle];
        [alertCtrl addAction:rightAction];
    }

    [target presentViewController:alertCtrl animated:YES completion:nil];
}

//检查手机号是否合法
+ (BOOL)CheckPhoneNumber:(NSString *)phoneNum viewCtrl:(UIViewController *)viewCtrl
{
    //检查是否为空
    if ([CustomUtil CheckParam:phoneNum]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"请输入手机号" leftTitle:@"确定" rightTitle:@"" leftHandle:nil rightHandle:nil target:viewCtrl btnCount:1];
        return NO;
    }
    
    //检查手机号是否有效
    NSString *regex = @"^((13[0-9])|(17[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNum];
    if (!isMatch) {
        //弹出对话框
        [self showCustomAlertView:@"提示" message:@"请输入正确的手机号码" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:viewCtrl btnCount:1];
        return NO;
    }
    return YES;
}

//注册KeyBoard显示或隐藏时的通知
- (void)registerKeyBoardNotification
{
    //注册KeyBoard显示时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册KeyBoard隐藏时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

//移除KeyBoard显示或隐藏时的通知
- (void)removeKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//KeyBoard将要显示时的处理
- (void)keyboardShow:(NSNotification *)aNotification
{
    CGFloat height = [self getKeyBoradHeight:aNotification];
    //调整所在视图
    CGRect viewFrame = self.view.frame;
    if ((0 == viewFrame.origin.y) || (64 == viewFrame.origin.y)) {
        viewFrame.origin.y -= (int)(height/4);
        keyBoardMoveHeight = (int)(height/4);
        self.view.frame = viewFrame;
    }
}

//KeyBoard将要隐藏时的处理
- (void)keyboardHide:(NSNotification *)aNotification
{
    //调整所在视图
    CGRect viewFrame = self.view.frame;
    //if (viewFrame.origin.y < 0) {
    viewFrame.origin.y += keyBoardMoveHeight;
    self.view.frame = viewFrame;
    //}
}

- (CGFloat)getKeyBoradHeight:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    return keyboardRect.size.height;
}

//模型转字典
+ (NSMutableDictionary *)modelToDictionary:(id)entity
{
    Class clazz = [entity class];
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i=0; i<count; i++) {
        objc_property_t prop = properties[i];
        const char *propertyName = property_getName(prop);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        id value = [entity performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
        if (nil == value) {
            [valueArray addObject:@""];
        } else {
            if ([value isKindOfClass:[NSString class]]) {
                [valueArray addObject:[NSString stringWithUTF8String:[value UTF8String]]];
            } else {
                [valueArray addObject:value];
            }
        }
    }
    free(properties);
    
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    
    return returnDic;
}

//MD5加密
+ (NSString *)md5HexDigest:(NSString *)inputStr
{
    const char *str = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X", result[i]];
    }
    return ret;
}

//拼接图片绝对路径
+ (NSString *)getPhotoPath:(NSString*)path
{
    if ([CustomUtil CheckParam:path]) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@%@", BASE_URL, path];
}

//返回图片NSURL对象
+ (NSURL *)getPhotoURL:(NSString *)path
{
    if ([CustomUtil CheckParam:path]) {
        return nil;
    }
    NSURL *imageUrl;
    if ([path hasPrefix:@"http"]) {
        imageUrl = [NSURL URLWithString:path];
    } else {
        imageUrl = [NSURL URLWithString:[CustomUtil getPhotoPath:path]];
    }
    return imageUrl;
}

//显示纯文本Toast框
+ (void)showToastWithText:(NSString *)text view:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text2 = text;

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if ([CustomUtil CheckParam:text2]) {
            text2 = @"网络异常，请稍后再试";
        }
        hud.labelText = text2;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        //hud.yOffset += (int)(view.frame.size.height/2) - 40;
        [hud hide:YES afterDelay:2];
    });
}

//显示纯文本Toast框
+ (void)showToast:(NSString *)detailStr view:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = detailStr;

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        if ([CustomUtil CheckParam:text]) {
            text = @"网络异常，请稍后再试";
        }
        hud.labelText = text;
        hud.margin = 8.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    });
}

/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGRect) heightForString:(NSString *)orignStr width:(int)width
{
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *fnt = [UIFont systemFontOfSize:15.0f];
    NSDictionary *fontDict = [[NSDictionary alloc] initWithObjectsAndKeys:fnt, NSFontAttributeName, nil];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    CGRect rect = [orignStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
    
    return rect;
}

//获取文字高度
+(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return deSize.height;
}

//获取文字高度
+(float)heightForString:(NSString *)value font:(UIFont *)font andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = font;
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return deSize.height;
}

//获取文字宽度
+(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(CGFLOAT_MAX, height)];
    return deSize.width;
}

//获取UTF8字符串
+ (NSString *)getUTF8String:(NSString *)str
{
    NSString *tempStr1 = [str stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                        mutabilityOption:NSPropertyListImmutable
                                                                    format:NULL
                                                          errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

#pragma mark -地图功能
+(void)getLocationInfo:(void (^)(AMapLocationReGeocode *regoCode, CLLocation *position))block
{
    static AMapLocationManager *locationManager = nil;
    //获取定位信息
    [AMapLocationServices sharedServices].apiKey = GAODEDITU_APPKEY;
    if (!locationManager) {
        locationManager = [[AMapLocationManager alloc] init];
    }
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //返回地理信息
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            if (error.code == AMapLocationErrorLocateFailed) {
                //[CustomUtil showToastWithText:error.description view:kWindow];
                return;
            }
        }
        if (regeocode) {
            block(regeocode, location);
        } else {
            //[CustomUtil showToastWithText:@"定位失败" view:kWindow];
        }
    }];
}
//------------------------短信-------------------------------------------------------------
//短消息代理
//内容及收件人列表
+(void)sendSMS:(UIViewController *)viewCtrl bodyMesage:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *ctrl = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        ctrl.body = bodyOfMessage;
        ctrl.recipients = recipients;
        ctrl.messageComposeDelegate = [CustomUtil shareInstance];
        [viewCtrl presentViewController:ctrl animated:YES completion:nil];
    }
}

//发送完成
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [[CustomUtil shareInstance].viewCtrl dismissViewControllerAnimated:YES completion:nil];
    if (MessageComposeResultCancelled == result) {
        DLog(@"Message cancelled");
    } else if (MessageComposeResultSent == result) {
        DLog(@"Message send");
        [CustomUtil share];
    } else {
        DLog(@"Message failed");
    }
}

#pragma mark -第三方分享
//获取邀请信息
+(void)getInviteUserMessage:(void(^)(NSString *shareMsg, NSString *shareUrl))block
{
    __block NSString *inviteUserMessage = @"";
    __block NSString *inviteUserUrl = @"";
    [InviteUserInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[InviteUserInput shareInstance]];
    [[NetInterface shareInstance] inviteUser:@"inviteUser" param:dict successBlock:^(NSDictionary *responseDict) {
        InviteUser *returnData = [InviteUser modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            inviteUserMessage = returnData.inviteLink;
            inviteUserUrl = returnData.url;
            block(inviteUserMessage, inviteUserUrl);
        }
    } failedBlock:^(NSError *err) {
    }];
}

//分享增加积分
+(void)share
{
    [ShareInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ShareInput shareInstance]];
    [[NetInterface shareInstance] share:@"share" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        //[CustomUtil showToastWithText:@"分享成功" view:kWindow];
    } failedBlock:^(NSError *err) {
    }];
}

//获取分享图片
+(UIImage *)getShareImage:(NSString *)imagePath
{
    NSURL *imageUrl = [CustomUtil getPhotoURL:imagePath];
    UIImage *resultImage;
    NSData *data = [NSData dataWithContentsOfURL:imageUrl];
    resultImage = [UIImage imageWithData:data];
    return resultImage;
}

#pragma mark -第三方登录
//--------------------第三方登录--------------------------
//qq
+(void)qqLogin:(BOOL)shareFlag personOrZone:(BOOL)personOrZone inviteUser:(BOOL)inviteUser imagePath:(NSString *)imagePath shareContent:(NSString *)shareContent
{
    [CustomUtil shareInstance].qqShareFlag = shareFlag;
    [CustomUtil shareInstance].qqPersonOrZone = personOrZone;
    [CustomUtil shareInstance].inviteUser = inviteUser;
    [CustomUtil shareInstance].shareImagePath = imagePath;
    [CustomUtil shareInstance].shareContent = shareContent;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"TKQQLogin.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [TKQQLogin shareInstance].openId = [dict objectForKey:@"openId"];
    [TKQQLogin shareInstance].token = [dict objectForKey:@"token"];
    [TKQQLogin shareInstance].expirationDate = [dict objectForKey:@"expirationDate"];
    if (![CustomUtil CheckParam:[TKQQLogin shareInstance].openId] &&
        ![CustomUtil CheckParam:[TKQQLogin shareInstance].token]) {
        if (!_tencentOAuth) {
            _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:[CustomUtil shareInstance]];
            [CustomUtil shareInstance].oAuth = _tencentOAuth;
        }
        _tencentOAuth.redirectURI = @"www.qq.com";
        _tencentOAuth.openId = [TKQQLogin shareInstance].openId;
        _tencentOAuth.expirationDate = [TKQQLogin shareInstance].expirationDate;
        _tencentOAuth.accessToken = [TKQQLogin shareInstance].token;
        [_tencentOAuth getUserInfo];
    } else {
        if (!_tencentOAuth) {
            _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:[CustomUtil shareInstance]];
            [CustomUtil shareInstance].oAuth = _tencentOAuth;
        }
        _tencentOAuth.redirectURI = @"www.qq.com";
        //授权
        NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,
                                 kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                 kOPEN_PERMISSION_ADD_SHARE,
                                 nil];
        [_tencentOAuth authorize:_permissions inSafari:NO];
    }
}

//代理-登录成功
-(void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0!=[_tencentOAuth.accessToken length]) {
        //记录登录用户的OpenID、Token以及过期时间
        [TKQQLogin shareInstance].openId = _tencentOAuth.openId;
        [TKQQLogin shareInstance].token = _tencentOAuth.accessToken;
        [TKQQLogin shareInstance].expirationDate = _tencentOAuth.expirationDate;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndexCheck:0];
        NSString *filePath = [path stringByAppendingPathComponent:@"TKQQLogin.plist"];
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[TKQQLogin shareInstance]];
        [dict writeToFile:filePath atomically:YES];
        [_tencentOAuth getUserInfo];
    } else {
        //[CustomUtil showToastWithText:@"登录失败" view:kWindow];
    }
}

//获取用户信息代理
-(void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED) {
        NSDictionary *dict = response.jsonResponse;
        DLog(@"dict = %@", dict);
        /*
        if ([CustomUtil shareInstance].inviteUser) { //邀请用户
            [CustomUtil getInviteUserMessage:^(NSString *shareMsg, NSString *shareUrl) {
                [_tencentOAuth sendAppInvitationWithDescription:shareMsg imageURL:[CustomUtil getPhotoPath:SHARE_IMAGE] source:@"3"];
            }];
         */
        if ([CustomUtil shareInstance].qqShareFlag) { //分享
            [CustomUtil getInviteUserMessage:^(NSString *returnStr, NSString *shareUrl) {
                /*
                if (![QQApiInterface isQQInstalled]) {
                    [CustomUtil showToastWithText:@"您还未安装QQ" view:kWindow];
                    return;
                }
                 */
                if ([CustomUtil shareInstance].qqPersonOrZone) {  //分享个人
                    //验证成功后分享信息
                    NSString *previewImageUrl = [CustomUtil getPhotoPath:[CustomUtil shareInstance].shareImagePath];
                    NSURL *shareUrlAddress;
                    NSString *shareText;
                    if (YES == [CustomUtil shareInstance].inviteUser) {
                        shareUrlAddress = [NSURL URLWithString:shareUrl];
                        shareText = returnStr;
                    } else {
                        shareUrlAddress = [NSURL URLWithString:SHARE_URL];
                        if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                            shareText = @"";
                        } else {
                            shareText = [CustomUtil shareInstance].shareContent;
                        }
                    }
                    QQApiNewsObject *newsObj = [QQApiNewsObject
                                                objectWithURL:shareUrlAddress
                                                title: @"毛线街"
                                                description:shareText
                                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
                    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
                    QQApiSendResultCode send = [QQApiInterface sendReq:req];
                    if (EQQAPISENDSUCESS != send) {
                        //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
                    } else {
                        [CustomUtil share];
                    }
                } else { //分享朋友圈
                    //QZone分享
                    //分享图预览图URL地址
                    NSString *previewImageUrl = [CustomUtil getPhotoPath:[CustomUtil shareInstance].shareImagePath];
                    NSString *shareText;
                    if (YES == [CustomUtil shareInstance].inviteUser) {
                        shareText = returnStr;
                    } else {
                        if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                            shareText = @"";
                        } else {
                            shareText = [CustomUtil shareInstance].shareContent;
                        }
                    }
                    QQApiNewsObject *newsObj = [QQApiNewsObject
                                                objectWithURL:[NSURL URLWithString:SHARE_URL]
                                                title: @"毛线街"
                                                description:shareText
                                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
                    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
                    //将内容分享到qzone
                    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                    if (EQQAPISENDSUCESS != sent) {
                        //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
                    } else {
                        [CustomUtil share];
                    }
                }
            }];
        } else {
            //调用登录接口
            [[CustomUtil shareInstance] clearLoginData];
            [LoginInput shareInstance].qqNumber = [TKQQLogin shareInstance].openId;
            [LoginInput shareInstance].phoneType = @"0";
            [LoginInput shareInstance].userName = [CustomUtil getThirdPlatFormNickName:[dict objectForKey:@"nickname"]];
            // app版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            [LoginInput shareInstance].verison=app_Version;
            DLog(@"registerIdQQ = %@", [LoginInput shareInstance].registerId);
            NSMutableDictionary *loginDict = [CustomUtil modelToDictionary:[LoginInput shareInstance]];
            [CustomUtil showLoading:@"正在登录中..."];
            [[NetInterface shareInstance] login:@"login" param:loginDict successBlock:^(NSDictionary *responseDict) {
                
                LoginModel *loginResutl = [LoginModel modelWithDict:responseDict];
                if (RETURN_SUCCESS(loginResutl.status)) {
                    //保存用户名
                    if ([CustomUtil CheckParam:loginResutl.userName]) {
                        [LoginModel shareInstance].userName = [LoginInput shareInstance].userName;
                    }
                    if ([CustomUtil CheckParam:loginResutl.image]) {
                        [LoginModel shareInstance].image = [dict objectForKey:@"figureurl_qq_1"];
                    }
                    //设定前次登录类型
                    [CustomUtil writeLoginState:2];
                    //注册推送
                    [[NSUserDefaults standardUserDefaults] setObject:[LoginModel shareInstance].userDoorId forKey:@"userId"];
                    NSMutableArray *tagArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"tagArray"];
                    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
                    if (!tagArray && userId) {
                        tagArray = [NSMutableArray array];
                        NSArray *maoTagArray = [[NSMutableArray alloc]initWithObjects:@"maoxj_1",@"maoxj_2",@"maoxj_3",@"maoxj_4",@"maoxj_5",@"maoxj_6",@"maoxj_7", nil];
                        [maoTagArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (idx == 0) {
                                [tagArray addObject:maoTagArray[0]];
                            } else {
                                [tagArray addObject:[NSString stringWithFormat:@"%@_%@", maoTagArray[idx], userId]];
                            }
                        }];
                        [[NSUserDefaults standardUserDefaults] setObject:tagArray forKey:@"tagArray"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerPushDelay:) userInfo:tagArray repeats:NO];
                    
                    
                    //跳转至首页
                    TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                    MainPageTabBarController *mainPageViewCtrl = (MainPageTabBarController *)[[tabBarCtrl viewControllers] objectAtIndexCheck:0];
                    mainPageViewCtrl.loginFlag = YES;
                    UINavigationController *naviCtrl = (UINavigationController *)(kWindow.rootViewController);
                    [naviCtrl setNavigationBarHidden:YES];
                    [naviCtrl pushViewController:tabBarCtrl animated:YES];
                } else {
                    [CustomUtil showToastWithText:loginResutl.msg view:kWindow];
                }
            } failedBlock:^(NSError *err) {
            }];
        }
    }
}

- (void)timerPushDelay:(NSTimer *)timer
{
    [JPUSHService setTags:[NSSet setWithArray:timer.userInfo] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [[UIApplication sharedApplication] endBackgroundTask:UIBackgroundTaskInvalid];
}

//- (void)pushDelay:(NSArray *)tagArray
//{
//    [JPUSHService setTags:[NSSet setWithArray:tagArray] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    if (iResCode != 0) {
        NSLog(@"设置失败");
        [JPUSHService setTags:tags callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    } else {
        NSLog(@"设置成功");
        NSLog(@"%@", tags);
        return;
    }
}

-(void)responseDidReceived:(APIResponse *)response forMessage:(NSString *)message
{
    
}

//非网络错误导致登录失败
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        //[CustomUtil showToastWithText:@"用户取消登录" view:kWindow];
    } else {
        //[CustomUtil showToastWithText:@"登录失败" view:kWindow];
    }
}

//网络错误导致登录失败
-(void)tencentDidNotNetWork
{
    [CustomUtil showToastWithText:@"无网络连接，请设置网络" view:kWindow];
}
//--------------------------------------------------
//微信
+(void)weixinLogin:(UIViewController *)viewCtrl shareFlag:(BOOL)shareFlag personOrZone:(BOOL)personOrZone inviteUser:(BOOL)inviteUser image:(UIImage *)image shareContent:(NSString *)shareContent
{
    [CustomUtil shareInstance].shareFlag = shareFlag;
    [CustomUtil shareInstance].personOrZone = personOrZone;
    [CustomUtil shareInstance].shareImage = image;
    [CustomUtil shareInstance].weixinInviteUser = inviteUser;
    [CustomUtil shareInstance].shareContent = shareContent;
    
    //读取微信授权plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"TKWeixinLogin.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [TKWeixinLogin shareInstance].openId = [dict objectForKey:@"openId"];
    [TKWeixinLogin shareInstance].token = [dict objectForKey:@"token"];
    
    if ((![CustomUtil CheckParam:[TKWeixinLogin shareInstance].openId]) &&
        (![CustomUtil CheckParam:[TKWeixinLogin shareInstance].token])) {
        if (YES == [CustomUtil shareInstance].shareFlag) {
            [[CustomUtil shareInstance] getWeixinToken:^{
                //发送分享内容
                __block BOOL weiXinFlagSelf = [CustomUtil shareInstance].personOrZone;
                [CustomUtil getInviteUserMessage:^(NSString *returnStr, NSString *shareUrl) {
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.openID = [TKWeixinLogin shareInstance].openId;
                    if ([CustomUtil shareInstance].shareFlag) {
                        req.bText = NO;
                        WXMediaMessage *message = [[WXMediaMessage alloc] init];
                        NSString *shareText;
                        if (YES == [CustomUtil shareInstance].weixinInviteUser) {
                            shareText = returnStr;
                        } else {
                            if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                                shareText = @"";
                            } else {
                                shareText = [CustomUtil shareInstance].shareContent;
                            }
                        }
                        message.description = shareText;
                        message.title = @"毛线街";
                        UIImage *orginalImage = [CustomUtil shareInstance].shareImage;
                        UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
                        NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
                        UIImage *finishImage = [UIImage imageWithData:targetImageData];
                        [message setThumbImage:finishImage];
                        WXWebpageObject *webPageExt = [WXWebpageObject object];
                        if (YES == [CustomUtil shareInstance].weixinInviteUser) {
                            webPageExt.webpageUrl = shareUrl;
                        } else {
                            webPageExt.webpageUrl = SHARE_URL;
                        }
                        message.mediaObject = webPageExt;
                        req.message = message;
                    } else {
                        req.bText = YES;        //仅发送文本
                        if ([CustomUtil shareInstance].weixinInviteUser) {
                            req.text = returnStr;
                        } else {
                            if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                                req.text = @"";
                            } else {
                                req.text = [CustomUtil shareInstance].shareContent;
                            }
                        }
                    }
                    if (YES == weiXinFlagSelf) {
                        req.scene = 0;          //发送至个人
                    } else {
                        req.scene = 1;          //发送至朋友圈
                    }
                    [WXApi sendReq:req];
                }];
            }];
        } else {
            //获取微信token、openId及用户信息
            [[CustomUtil shareInstance] getWeixinToken:^{
                //调用登录接口
                [[CustomUtil shareInstance] clearLoginData];
                [LoginInput shareInstance].webchatId = [TKWeixinLogin shareInstance].openId;  //微信用户标记
                [LoginInput shareInstance].phoneType = @"0";
                [LoginInput shareInstance].userName = [CustomUtil getThirdPlatFormNickName:[TKWeixinLogin shareInstance].nickName];
                // app版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                [LoginInput shareInstance].verison=app_Version;
                NSMutableDictionary *loginDict = [CustomUtil modelToDictionary:[LoginInput shareInstance]];
                [CustomUtil showLoading:@"正在登录中..."];
                [[NetInterface shareInstance] login:@"login" param:loginDict successBlock:^(NSDictionary *responseDict) {
                    LoginModel *loginResutl = [LoginModel modelWithDict:responseDict];
                    if (RETURN_SUCCESS(loginResutl.status)) {
                        if ([CustomUtil CheckParam:loginResutl.userName]) {
                            [LoginModel shareInstance].userName = [LoginInput shareInstance].userName;
                        }
                        if ([CustomUtil CheckParam:loginResutl.image]) {
                            [LoginModel shareInstance].image = [TKWeixinLogin shareInstance].headimgurl;
                        }
                        [CustomUtil writeLoginState:3];
                        //注册推送
                        [[NSUserDefaults standardUserDefaults] setObject:[LoginModel shareInstance].userDoorId forKey:@"userId"];

                        NSMutableArray *tagArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"tagArray"];
                        NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
                        if (!tagArray && userId) {
                            tagArray = [NSMutableArray array];
                            NSArray *maoTagArray = [[NSMutableArray alloc]initWithObjects:@"maoxj_1",@"maoxj_2",@"maoxj_3",@"maoxj_4",@"maoxj_5",@"maoxj_6",@"maoxj_7", nil];
                            [maoTagArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (idx == 0) {
                                    [tagArray addObject:maoTagArray[0]];
                                } else {
                                    [tagArray addObject:[NSString stringWithFormat:@"%@_%@", maoTagArray[idx], userId]];
                                }
                            }];
                            [[NSUserDefaults standardUserDefaults] setObject:tagArray forKey:@"tagArray"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        [JPUSHService setTags:[NSSet setWithArray:tagArray] aliasInbackground:nil];
                        //跳转至首页
                        TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                        MainPageTabBarController *mainPageViewCtrl = (MainPageTabBarController *)[[tabBarCtrl viewControllers] objectAtIndexCheck:0];
                        mainPageViewCtrl.loginFlag = YES;
                        UINavigationController *naviCtrl = (UINavigationController *)(kWindow.rootViewController);
                        [naviCtrl setNavigationBarHidden:YES];
                        [naviCtrl pushViewController:tabBarCtrl animated:YES];
                    } else {
                        [CustomUtil showToastWithText:loginResutl.msg view:kWindow];
                    }
                } failedBlock:^(NSError *err) {
                }];
            }];
        }
    } else {
        //请求授权
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
        req.state = @"123";
        //req.openID = WEIXIN_APPKEY;
        [WXApi sendAuthReq:req viewController:viewCtrl delegate:[CustomUtil shareInstance]];
    }
}

//微信响应代理
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp *)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PAY_NOTICE" object:@"0"];
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PAY_NOTICE" object:[NSString stringWithFormat:@"%d", resp.errCode]];
                break;
        }
    }
    else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
        if (sendResp.errCode == WXSuccess) { //分享成功
            //增加积分
            [CustomUtil share];
        } else {
            //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == WXSuccess) {
            [TKWeixinLogin shareInstance].code = authResp.code;
            if (YES == [CustomUtil shareInstance].shareFlag) {
                //获取微信token、openId及用户信息
                [[CustomUtil shareInstance] getWeixinToken:^{
                    //发送分享内容
                    __block BOOL weiXinFlagSelf = [CustomUtil shareInstance].personOrZone;
                    [CustomUtil getInviteUserMessage:^(NSString *returnStr, NSString *shareUrl) {
                        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                        if ([CustomUtil shareInstance].shareFlag) {
                            req.bText = NO;
                            WXMediaMessage *message = [[WXMediaMessage alloc] init];
                            NSString *shareText;
                            if (YES == [CustomUtil shareInstance].weixinInviteUser) {
                                shareText = returnStr;
                            } else {
                                if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                                    shareText = @"";
                                } else {
                                    shareText = [CustomUtil shareInstance].shareContent;
                                }
                            }
                            message.description = shareText;
                            message.title = @"毛线街";
                            UIImage *orginalImage = [CustomUtil shareInstance].shareImage;
                            UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
                            NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
                            UIImage *finishImage = [UIImage imageWithData:targetImageData];
                            [message setThumbImage:finishImage];
                            WXWebpageObject *webPageExt = [WXWebpageObject object];
                            if (YES == [CustomUtil shareInstance].weixinInviteUser) {
                                webPageExt.webpageUrl = shareUrl;
                            } else {
                                webPageExt.webpageUrl = SHARE_URL;
                            }
                            message.mediaObject = webPageExt;
                            req.message = message;
                        } else {
                            req.bText = YES;        //仅发送文本
                            if ([CustomUtil shareInstance].weixinInviteUser) {
                                req.text = returnStr;
                            } else {
                                if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                                    req.text = @"";
                                } else {
                                    req.text = [CustomUtil shareInstance].shareContent;
                                }
                            }
                        }
                        if (YES == weiXinFlagSelf) {
                            req.scene = 0;          //发送至个人
                        } else {
                            req.scene = 1;          //发送至朋友圈
                        }
                        [WXApi sendReq:req];
                    }];
                }];
            } else {
                //获取微信token、openId及用户信息
                [[CustomUtil shareInstance] getWeixinToken:^{
                    //调用登录接口
                    [[CustomUtil shareInstance] clearLoginData];
                    [LoginInput shareInstance].webchatId = [TKWeixinLogin shareInstance].openId;  //微信用户标记
                    [LoginInput shareInstance].phoneType = @"0";
                    [LoginInput shareInstance].userName = [CustomUtil getThirdPlatFormNickName:[TKWeixinLogin shareInstance].nickName];
                    // app版本
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                    [LoginInput shareInstance].verison=app_Version;
                    NSMutableDictionary *loginDict = [CustomUtil modelToDictionary:[LoginInput shareInstance]];
                    [CustomUtil showLoading:@"正在登录中..."];
                    [[NetInterface shareInstance] login:@"login" param:loginDict successBlock:^(NSDictionary *responseDict) {
                        LoginModel *loginResutl = [LoginModel modelWithDict:responseDict];
                        if (RETURN_SUCCESS(loginResutl.status)) {
                            if ([CustomUtil CheckParam:loginResutl.userName]) {
                                [LoginModel shareInstance].userName = [LoginInput shareInstance].userName;
                            }
                            if ([CustomUtil CheckParam:loginResutl.image]) {
                                [LoginModel shareInstance].image = [TKWeixinLogin shareInstance].headimgurl;
                            }
                            [CustomUtil writeLoginState:3];
                            //注册推送
                            NSMutableArray *tagArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"tagArray"];
                            NSString *userId = [LoginModel shareInstance].userDoorId;
                            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                            if (tagArray.count == 0 && userId) {
                                tagArray = [NSMutableArray array];
                                NSArray *maoTagArray = [[NSMutableArray alloc]initWithObjects:@"maoxj_1",@"maoxj_2",@"maoxj_3",@"maoxj_4",@"maoxj_5",@"maoxj_6",@"maoxj_7",@"maoxj_8", nil];
                                [maoTagArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    if (idx == 0) {
                                        [tagArray addObject:maoTagArray[0]];
                                    } else {
                                        [tagArray addObject:[NSString stringWithFormat:@"%@_%@", maoTagArray[idx], userId]];
                                    }
                                }];
                                [[NSUserDefaults standardUserDefaults] setObject:tagArray forKey:@"tagArray"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                            }
                            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                            
                            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerPushDelay:) userInfo:tagArray repeats:NO];
                            //跳转至首页
                            TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                            MainPageTabBarController *mainPageViewCtrl = (MainPageTabBarController *)[[tabBarCtrl viewControllers] objectAtIndexCheck:0];
                            mainPageViewCtrl.loginFlag = YES;
                            UINavigationController *naviCtrl = (UINavigationController *)(kWindow.rootViewController);
                            [naviCtrl setNavigationBarHidden:YES];
                            [naviCtrl pushViewController:tabBarCtrl animated:YES];
                        } else {
                            [CustomUtil showToastWithText:loginResutl.msg view:kWindow];
                        }
                    } failedBlock:^(NSError *err) {
                    }];
                }];
            }
        } else {
            //[CustomUtil showToastWithText:@"授权失败" view:kWindow];
        }
    }
}

//获取微信Token及OpenId
-(void)getWeixinToken:(void(^)())block
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WEIXIN_APPKEY, WEIXIN_SECRET,[TKWeixinLogin shareInstance].code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (![CustomUtil CheckParam:[dic objectForKey:@"access_token"]]) {
                    [TKWeixinLogin shareInstance].token = [dic objectForKey:@"access_token"];
                }
                if (![CustomUtil CheckParam:[dic objectForKey:@"openid"]]) {
                    [TKWeixinLogin shareInstance].openId = [dic objectForKey:@"openid"];
                }
                
                //将数据写入plist文件
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [paths objectAtIndexCheck:0];
                NSString *filePath = [path stringByAppendingPathComponent:@"TKWeixinLogin.plist"];
                NSMutableDictionary *writeDict = [CustomUtil modelToDictionary:[TKWeixinLogin shareInstance]];
                [writeDict writeToFile:filePath atomically:YES];
                
                //获取微信用户信息
                [[CustomUtil shareInstance] getWeixinUserInfo:^{
                    block();
                }];
            }
        });
    });
}



//获取微信用户信息
-(void)getWeixinUserInfo:(void(^)())block
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[TKWeixinLogin shareInstance].token,[TKWeixinLogin shareInstance].openId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [TKWeixinLogin shareInstance].nickName = [dic objectForKey:@"nickname"];
                [TKWeixinLogin shareInstance].headimgurl = [dic objectForKey:@"headimgurl"];
                block();
            }
        });
    });
}

//---------------------------------------------------

//新浪微博
+(void)sinaLogin:(BOOL)shareFlag viewCtrl:(NSString *)viewCtrlName personOrZone:(BOOL)personOrZone
      inviteUser:(BOOL)inviteUser imagePath:(NSString *)imagePath shareContent:(NSString *)shareContent
{
    [CustomUtil shareInstance].weiBoShareFlag = shareFlag;
    [CustomUtil shareInstance].weiBoPersonOrZone = personOrZone;
    [CustomUtil shareInstance].shareImagePath = imagePath;
    [CustomUtil shareInstance].weiboInviteUser = inviteUser;
    [CustomUtil shareInstance].shareContent = shareContent;
    
    //读取微博账户plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"TKWeiboLogin.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [TKWeiboLogin shareInstance].uid = [dict objectForKey:@"uid"];
    [TKWeiboLogin shareInstance].token = [dict objectForKey:@"token"];
    if ([WeiboSDK isWeiboAppInstalled]) {
        DLog(@"已安装");
    } else {
        DLog(@"未安装");
    }
    if (![CustomUtil CheckParam:[TKWeiboLogin shareInstance].uid] &&
        ![CustomUtil CheckParam:[TKWeiboLogin shareInstance].token]) {
        //获取用户信息
        [WBHttpRequest requestForUserProfile:[TKWeiboLogin shareInstance].uid withAccessToken:[TKWeiboLogin shareInstance].token andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            DLog(@"result = %@", result);
            WeiboUser *user = (WeiboUser *)result;
            [TKWeiboLogin shareInstance].name = user.name;
            [TKWeiboLogin shareInstance].image = user.avatarHDUrl;
            
            if ([CustomUtil shareInstance].weiBoShareFlag) { //分享
                if (NO == [CustomUtil shareInstance].weiBoPersonOrZone) {
                    [CustomUtil getInviteUserMessage:^(NSString *returnStr, NSString *shareUrl) {
                        WBMessageObject *object = [[WBMessageObject alloc] init];
                        WBImageObject *imageObject = [[WBImageObject alloc] init];
                        NSURL *url = [CustomUtil getPhotoURL:[CustomUtil shareInstance].shareImagePath];
                        NSData *imageData = [NSData dataWithContentsOfURL:url];
                        imageObject.imageData = imageData;
                        if ([CustomUtil shareInstance].weiboInviteUser) {
                            object.text = returnStr;
                        } else {
                            //if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                            object.text = [CustomUtil shareInstance].shareContent;
                            //} //else {
                                //object.text = [CustomUtil shareInstance].shareContent;
                            //}
                        }
                        object.imageObject = imageObject;
                        /*
                         WBAuthorizeRequest *wbAuthorRequest = [WBAuthorizeRequest request];
                         wbAuthorRequest.redirectURI = XINLANGWEIBO_REDIRECTURL;
                         wbAuthorRequest.scope = @"all";
                         wbAuthorRequest.userInfo = @{@"SSO_From": @"",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
                         wbAuthorRequest.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
                         */
                        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:object authInfo:nil access_token:[TKWeiboLogin shareInstance].token];
                        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
                        BOOL result = [WeiboSDK sendRequest:request];
                        if (!result) {
                            //[CustomUtil showToastWithText:@"微博分享失败" view:kWindow];
                        } else {
                            [CustomUtil share];
                        }
                    }];
                } else { //获取好友列表
                    NSMutableDictionary* extraParaDict = [NSMutableDictionary dictionary];
                    [extraParaDict setObject:@"0" forKey:@"cursor"];
                    [extraParaDict setObject:@"100" forKey:@"count"];
                    [WBHttpRequest requestForFriendsListOfUser:[TKWeiboLogin shareInstance].uid withAccessToken:[TKWeiboLogin shareInstance].token andOtherProperties:extraParaDict queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                        if (error) {
                            //[CustomUtil showToastWithText:[error description] view:kWindow];
                        } else {
                            DLog(@"result = %@", result);
                            NSMutableArray *resultArray = [result objectForKey:@"users"];
                            NSMutableArray *usersArray = [[NSMutableArray alloc] init];
                            for (WeiboUser *user in resultArray) {
                                [usersArray addObject:user];
                            }
                            [TKWeiboLogin shareInstance].userArray = usersArray;
                            UINavigationController *naviCtrl = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                            PhoneBookViewController *viewCtrl = [[PhoneBookViewController alloc] initWithNibName:@"PhoneBookViewController" bundle:nil];
                            viewCtrl.intoFlag = 1; //微博好友进入
                            [naviCtrl pushViewController:viewCtrl animated:YES]; //进入通讯录界面
                            /*
                             NSArray* uids = nil;
                             WBSDKAppRecommendRequest *request = [WBSDKAppRecommendRequest requestWithUIDs:uids access_token:XINLANGWEIBO_APPSECRET];
                             request.userInfo = @{@"ShareMessageFrom": @"SearchFriendViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
                             [WeiboSDK sendRequest:request];
                             */
                            //+ (void)inviteFriend:(NSString* )data withUid:(NSString *)uid withToken:(NSString *)access_token delegate:(id<WBHttpRequestDelegate>)delegate withTag:(NSString*)tag;
                        }
                    }];
                }
            } else { //登录
                //调用登录接口
                [[CustomUtil shareInstance] clearLoginData];
                [LoginInput shareInstance].sinaBlog = [TKWeiboLogin shareInstance].uid;
                [LoginInput shareInstance].phoneType = @"0";
                [LoginInput shareInstance].userName = [CustomUtil getThirdPlatFormNickName:[TKWeiboLogin shareInstance].name];
                // app版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                [LoginInput shareInstance].verison=app_Version;
                NSMutableDictionary *loginDict = [CustomUtil modelToDictionary:[LoginInput shareInstance]];
                [CustomUtil showLoading:@"正在登录中..."];
                [[NetInterface shareInstance] login:@"login" param:loginDict successBlock:^(NSDictionary *responseDict) {
                    LoginModel *loginResutl = [LoginModel modelWithDict:responseDict];
                    if (RETURN_SUCCESS(loginResutl.status)) {
                        [LoginModel shareInstance].userId = loginResutl.userId;
                        if ([CustomUtil CheckParam:[LoginModel shareInstance].userName]) {
                            [LoginModel shareInstance].userName = [LoginInput shareInstance].userName;
                        }
                        if ([CustomUtil CheckParam:[LoginModel shareInstance].image]) {
                            [LoginModel shareInstance].image = [TKWeiboLogin shareInstance].image;
                        }
                        [CustomUtil writeLoginState:4];
                        //注册推送
                        [[NSUserDefaults standardUserDefaults] setObject:[LoginModel shareInstance].userDoorId forKey:@"userId"];

                        NSMutableArray *tagArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"tagArray"];
                        NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
                        if (!tagArray && userId) {
                            tagArray = [NSMutableArray array];
                            NSArray *maoTagArray = [[NSMutableArray alloc]initWithObjects:@"maoxj_1",@"maoxj_2",@"maoxj_3",@"maoxj_4",@"maoxj_5",@"maoxj_6",@"maoxj_7", nil];
                            [maoTagArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (idx == 0) {
                                    [tagArray addObject:maoTagArray[0]];
                                } else {
                                    [tagArray addObject:[NSString stringWithFormat:@"%@_%@", maoTagArray[idx], userId]];
                                }
                            }];
                            [[NSUserDefaults standardUserDefaults] setObject:tagArray forKey:@"tagArray"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        [JPUSHService setTags:[NSSet setWithArray:tagArray] aliasInbackground:nil];
                        //跳转至首页
                        TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                        MainPageTabBarController *mainPageViewCtrl = (MainPageTabBarController *)[[tabBarCtrl viewControllers] objectAtIndexCheck:0];
                        mainPageViewCtrl.loginFlag = YES;
                        UINavigationController *naviCtrl = (UINavigationController *)(kWindow.rootViewController);
                        [naviCtrl setNavigationBarHidden:YES];
                        [naviCtrl pushViewController:tabBarCtrl animated:YES];
                    } else {
                        [CustomUtil showToastWithText:loginResutl.msg view:kWindow];
                    }
                } failedBlock:^(NSError *err) {
                }];
            }
        }];
    } else {
        //SSO微博客户端授权认证
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = XINLANGWEIBO_REDIRECTURL;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": viewCtrlName,
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];
    }
}

- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

//客户端认证结果回调
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if (WeiboSDKResponseStatusCodeSuccess == response.statusCode) {
        //获取微博用户信息WBAuthorizeResponse
        if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
            //获取token和uid
            [TKWeiboLogin shareInstance].token = [response.userInfo objectForKey:@"access_token"];
            [TKWeiboLogin shareInstance].uid = [response.userInfo objectForKey:@"uid"];
            //将微博数据写入文件
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndexCheck:0];
            NSString *filePath = [path stringByAppendingPathComponent:@"TKWeiboLogin.plist"];
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[TKWeiboLogin shareInstance]];
            [dict writeToFile:filePath atomically:YES];
            
            //获取用户信息
            [WBHttpRequest requestForUserProfile:[TKWeiboLogin shareInstance].uid withAccessToken:[TKWeiboLogin shareInstance].token andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                DLog(@"result = %@", result);
                WeiboUser *user = (WeiboUser *)result;
                [TKWeiboLogin shareInstance].name = user.name;
                [TKWeiboLogin shareInstance].image = user.avatarHDUrl;
                
                if ([CustomUtil shareInstance].weiBoShareFlag) { //分享
                    if (NO == [CustomUtil shareInstance].weiBoPersonOrZone) {
                        [CustomUtil getInviteUserMessage:^(NSString *returnStr, NSString *shareUrl) {
                            WBMessageObject *object = [[WBMessageObject alloc] init];
                            WBImageObject *imageObject = [[WBImageObject alloc] init];
                            NSURL *url = [CustomUtil getPhotoURL:[CustomUtil shareInstance].shareImagePath];
                            NSData *imageData = [NSData dataWithContentsOfURL:url];
                            imageObject.imageData = imageData;
                            if ([CustomUtil shareInstance].weiboInviteUser) {
                                object.text = returnStr;
                            } else {
                                //if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                                object.text = [CustomUtil shareInstance].shareContent;
                                //} else {
                                  //  object.text = [CustomUtil shareInstance].shareContent;
                                //}
                            }
                            object.imageObject = imageObject;
                            /*
                             WBAuthorizeRequest *wbAuthorRequest = [WBAuthorizeRequest request];
                             wbAuthorRequest.redirectURI = XINLANGWEIBO_REDIRECTURL;
                             wbAuthorRequest.scope = @"all";
                             wbAuthorRequest.userInfo = @{@"SSO_From": @"",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
                             wbAuthorRequest.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
                             */
                            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:object authInfo:nil access_token:[TKWeiboLogin shareInstance].token];
                            request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
                            BOOL result = [WeiboSDK sendRequest:request];
                            if (!result) {
                                //[CustomUtil showToastWithText:@"微博分享失败" view:kWindow];
                            } else {
                                [CustomUtil share];
                            }
                        }];
                    } else { //获取好友列表
                        NSMutableDictionary* extraParaDict = [NSMutableDictionary dictionary];
                        [extraParaDict setObject:@"0" forKey:@"cursor"];
                        [extraParaDict setObject:@"100" forKey:@"count"];
                        [WBHttpRequest requestForFriendsListOfUser:[TKWeiboLogin shareInstance].uid withAccessToken:[TKWeiboLogin shareInstance].token andOtherProperties:extraParaDict queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                            if (error) {
                                //[CustomUtil showToastWithText:[error description] view:kWindow];
                            } else {
                                DLog(@"result = %@", result);
                                NSMutableArray *resultArray = [result objectForKey:@"users"];
                                NSMutableArray *usersArray = [[NSMutableArray alloc] init];
                                for (WeiboUser *user in resultArray) {
                                    [usersArray addObject:user];
                                }
                                [TKWeiboLogin shareInstance].userArray = usersArray;
                                UINavigationController *naviCtrl = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                                PhoneBookViewController *viewCtrl = [[PhoneBookViewController alloc] initWithNibName:@"PhoneBookViewController" bundle:nil];
                                viewCtrl.intoFlag = 1; //微博好友进入
                                [naviCtrl pushViewController:viewCtrl animated:YES]; //进入通讯录界面
                                /*
                                 NSArray* uids = nil;
                                 WBSDKAppRecommendRequest *request = [WBSDKAppRecommendRequest requestWithUIDs:uids access_token:XINLANGWEIBO_APPSECRET];
                                 request.userInfo = @{@"ShareMessageFrom": @"SearchFriendViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
                                 [WeiboSDK sendRequest:request];
                                 */
                                //+ (void)inviteFriend:(NSString* )data withUid:(NSString *)uid withToken:(NSString *)access_token delegate:(id<WBHttpRequestDelegate>)delegate withTag:(NSString*)tag;
                            }
                        }];
                    }
                } else { //登录
                    //调用登录接口
                    [[CustomUtil shareInstance] clearLoginData];
                    [LoginInput shareInstance].sinaBlog = [TKWeiboLogin shareInstance].uid;
                    [LoginInput shareInstance].phoneType = @"0";
                    [LoginInput shareInstance].userName = [CustomUtil getThirdPlatFormNickName:[TKWeiboLogin shareInstance].name];
                    // app版本
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                    [LoginInput shareInstance].verison=app_Version;
                    NSMutableDictionary *loginDict = [CustomUtil modelToDictionary:[LoginInput shareInstance]];
                    [CustomUtil showLoading:@"正在登录中..."];
                    [[NetInterface shareInstance] login:@"login" param:loginDict successBlock:^(NSDictionary *responseDict) {
                        LoginModel *loginResutl = [LoginModel modelWithDict:responseDict];
                        if (RETURN_SUCCESS(loginResutl.status)) {
                            [LoginModel shareInstance].userId = loginResutl.userId;
                            if ([CustomUtil CheckParam:[LoginModel shareInstance].userName]) {
                                [LoginModel shareInstance].userName = [LoginInput shareInstance].userName;
                            }
                            if ([CustomUtil CheckParam:[LoginModel shareInstance].image]) {
                                [LoginModel shareInstance].image = [TKWeiboLogin shareInstance].image;
                            }
                            [CustomUtil writeLoginState:4];
                            //注册推送
                            [[NSUserDefaults standardUserDefaults] setObject:[LoginModel shareInstance].userDoorId forKey:@"userId"];

                            NSMutableArray *tagArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"tagArray"];
                            NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
                            if (!tagArray && userId) {
                                tagArray = [NSMutableArray array];
                                NSArray *maoTagArray = [[NSMutableArray alloc]initWithObjects:@"maoxj_1",@"maoxj_2",@"maoxj_3",@"maoxj_4",@"maoxj_5",@"maoxj_6",@"maoxj_7", nil];
                                [maoTagArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    if (idx == 0) {
                                        [tagArray addObject:maoTagArray[0]];
                                    } else {
                                        [tagArray addObject:[NSString stringWithFormat:@"%@_%@", maoTagArray[idx], userId]];
                                    }
                                }];
                                [[NSUserDefaults standardUserDefaults] setObject:tagArray forKey:@"tagArray"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                            }
//                            [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerPushDelay:) userInfo:tagArray repeats:NO];
                            //跳转至首页
                            
                            TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                            MainPageTabBarController *mainPageViewCtrl = (MainPageTabBarController *)[[tabBarCtrl viewControllers] objectAtIndexCheck:0];
                            mainPageViewCtrl.loginFlag = YES;
                            UINavigationController *naviCtrl = (UINavigationController *)(kWindow.rootViewController);
                            [naviCtrl setNavigationBarHidden:YES];
                            [naviCtrl pushViewController:tabBarCtrl animated:YES];
                        } else {
                            [CustomUtil showToastWithText:loginResutl.msg view:kWindow];
                        }
                    } failedBlock:^(NSError *err) {
                    }];
                }
            }];
        }
    } else {
        //[CustomUtil showToastWithText:@"操作失败" view:kWindow];
    }
}

//获取第三方平台用户昵称
+(NSString *)getThirdPlatFormNickName:(NSString *)nickName
{
    NSString *resultStr = @"";
    if ([CustomUtil CheckParam:nickName]) {
        resultStr = [[CustomUtil createFourLenthString] substringToIndex:4];
    } else {
        //提取有效字符（中英文、数字、下划线）
        NSString *regex = @"[A-Za-z0-9\u4e00-\u9fa5_]+";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        NSInteger chineseCharCount = [CustomUtil chineseCountOfString:nickName];
        NSInteger charCount = [CustomUtil characterCountOfString:nickName];
        for (int j=0; j<(chineseCharCount + charCount); j++) {
            unichar c = [nickName characterAtIndex:j];
            if (c >=0x4E00 && c <=0x9FA5) {
                j++;
                resultStr = [NSString stringWithFormat:@"%@%@", resultStr, [NSString stringWithCharacters:&c length:1]];
                if (j < (chineseCharCount + charCount)) {
                    unichar secondeChar = [nickName characterAtIndex:j];
                    resultStr = [NSString stringWithFormat:@"%@%@", resultStr, [NSString stringWithCharacters:&secondeChar length:1]];
                }
            } else {
                if ([pred evaluateWithObject:[nickName substringWithRange:NSMakeRange(j, 1)]]) {
                    resultStr = [NSString stringWithFormat:@"%@%@", resultStr, [nickName substringWithRange:NSMakeRange(j, 1)]];
                }
            }
        }
        //位数不足4位，返回有效字符+4位自动生成的数字字母作为昵称
        chineseCharCount = [CustomUtil chineseCountOfString:resultStr];
        charCount = [CustomUtil characterCountOfString:resultStr];
        NSInteger strLenth = chineseCharCount*2 + charCount;
        if (strLenth < 4) {
            resultStr = [NSString stringWithFormat:@"%@%@", resultStr, [[CustomUtil createFourLenthString] substringToIndex:4]];
        }
    }
    
    return resultStr;
}

//获取四位随机字母数字组合
+(NSString *)createFourLenthString
{
    //自动生成四位数字字母组合
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890";
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform(numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:numberOfCharacters];
    free(characters);
    
    return result;
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

#pragma mark -共通方法
//清除登录模型请求数据
-(void)clearLoginData
{
    [LoginInput shareInstance].phoneNumber = @"";
    [LoginInput shareInstance].qqNumber = @"";
    [LoginInput shareInstance].sinaBlog = @"";
    [LoginInput shareInstance].webchatId = @"";
    [LoginInput shareInstance].userPassword = @"";
}

//设置ImageView圆角
+(void)setImageViewCorner:(EGOImageView *)imageView
{
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.masksToBounds = YES;
}

//保存Image图片到沙盒
+(void)saveImageToSandBox:(NSDictionary *)info fileName:(NSString *)fileName block:(void(^)(UIImage *sandBoxImage, NSString *filePath))block
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    UIImage *targetImage = [CustomUtil compressImageForWidth:image targetWidth:512];
    NSData *data = nil;
    data = UIImageJPEGRepresentation(targetImage, 1);
    //保存图片至沙盒
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]] contents:data attributes:nil];
    //得到沙盒图片路径
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@/%@", DocumentsPath, fileName];
    block(image, filePath);
}

+(void)saveHeadImageToSandBox:(UIImage *)image fileName:(NSString *)fileName block:(void(^)(UIImage *sandBoxImage, NSString *filePath))block
{
    UIImage *targetImage = [CustomUtil compressImageForWidth:image targetWidth:512];
    NSData *data = nil;
    data = UIImageJPEGRepresentation(targetImage, 1);
    //保存图片至沙盒
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]] contents:data attributes:nil];
    //得到沙盒图片路径
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@/%@", DocumentsPath, fileName];
    block(image, filePath);
}

//获取ALAssetLibrary的单例
+(ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

//压缩图片
+(UIImage *)compressImageForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) *height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//判断是否为中文
+(BOOL)isChinesecharacter:(NSString *)string
{
    if (string.length == 0) {
        return NO;
    }
    unichar c = [string characterAtIndex:0];
    if (c >=0x4E00 && c <=0x9FA5) {
        return YES; //汉字
    } else {
        return NO;  //英文
    }
}

//计算汉字的个数
+(NSInteger)chineseCountOfString:(NSString *)string
{
    int ChineseCount = 0;
    
    if (string.length == 0) {
        return 0;
    }
    for (int i = 0; i < string.length; i++) {
        unichar c = [string characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5) {
            ChineseCount++; //汉字
        }
    }
    return ChineseCount;
}

//计算字母的个数
+(NSInteger)characterCountOfString:(NSString *)string
{
    int characterCount = 0;
    
    if (string.length == 0) {
        return 0;
    }
    for (int i = 0; i < string.length; i++) {
        unichar c = [string characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5) {
            
        } else {
            characterCount++; //英文
        }
    }
    return characterCount;
}

//判断字符串长度及内容是否符合要求
+(BOOL)isInputStrValid:(NSString *)str minLength:(int)minLength maxLength:(int)maxLength
{
    //判断字符串的长度
    NSInteger chineseCharCount = [self chineseCountOfString:str]; //中文个数
    NSInteger charactCount = [self characterCountOfString:str];         //中文以外文字个数
    int inputLength = chineseCharCount * 2 + charactCount;        //输入文字的位数
    if ((inputLength < minLength) ||
        (inputLength > maxLength)) {
        [CustomUtil showToastWithText:[NSString stringWithFormat:@"%d-%d位中英文、数字和下划线", minLength, maxLength] view:kWindow];
        return NO;
    }
    NSString *regex = @"[A-Za-z0-9\u4e00-\u9fa5_]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:str]) {
        [CustomUtil showToastWithText:@"仅能输入中文、字母、数字及下划线" view:kWindow];
        return NO;
    }
    return YES;
}

//获取网络图片的尺寸（JPG）
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest *)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

//通过网络请求获取图片的尺寸（PNG）
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //if(data.length == 8)
    //{
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    //}
    //return CGSizeZero;
}

//通过网络请求获取图片的尺寸
+(CGSize)getPhotoSizeWithURLStr:(NSString *)urlStr
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[CustomUtil getPhotoURL:urlStr]];
    NSString *pathExtendsion = [[CustomUtil getPhotoURL:urlStr].pathExtension lowercaseString];
    CGSize size = CGSizeZero;
    if ([pathExtendsion isEqualToString:@"png"]) {
        size = [CustomUtil getPNGImageSizeWithRequest:request];
    } else if ([pathExtendsion isEqualToString:@"gif"]) {
        //TODO 扩展功能
    } else if ([pathExtendsion isEqualToString:@"jpg"]) {
        size = [CustomUtil getJPGImageSizeWithRequest:request];
    }
    
    return size;
}

//获取单个文件的容量大小
+(long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manger = [NSFileManager defaultManager];
    if ([manger fileExistsAtPath:filePath]) {
        return [[manger attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//获取文件夹的容量大小（单位：MB）
+(float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while (nil != (fileName = [childFilesEnumerator nextObject])) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

//获取调整方向的image
+(UIImage *)normalizedImage:(UIImage *)image {
    if (!image.imageOrientation) {
        return image;
    }
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}


+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImg;
}

//将定位信息写入文件
+(void)saveLocationInfo:(NSString *)cityName
{
    //获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"Location.plist"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSMutableDictionary *dict;
    if ([fileManger fileExistsAtPath:filePath]) {
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    } else {
        dict = [[NSMutableDictionary alloc] init];
    }
    [dict setValue:cityName forKey:@"cityName"];
    [dict writeToFile:filePath atomically:YES];
}

//读取文件中上次的定位信息
+(NSString *)readLocationInfo
{
    //获取沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"Location.plist"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSMutableDictionary *dict;
    NSString *cityName = @"";
    if ([fileManger fileExistsAtPath:filePath]) {
        dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        cityName = [dict objectForKey:@"cityName"];
    }
    
    return cityName;
}

//增加水印
+(void)addWaterMark
{
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WaterMark"]];
    CGRect rect = CGRectMake(0, kWindow.frame.size.height - 20, kWindow.frame.size.width, 20);
    iv.frame = rect;
    [kWindow addSubview:iv];
}

//去除字符串中的空白字符及换行符
+(NSString *)deleteBlankAndNewlineChar:(NSString *)orginStr
{
    NSString *str = [orginStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return str;
}

//记录上次的登录状态
+(void)writeLoginState:(int)loginType
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"loginType.plist"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:filePath]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *state = [NSString stringWithFormat:@"%d", loginType];
        [dict setObject:state forKey:@"loginType"];
        [dict writeToFile:filePath atomically:YES];
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        NSString *state = [NSString stringWithFormat:@"%d", loginType];
        [dict setObject:state forKey:@"loginType"];
        [dict writeToFile:filePath atomically:YES];
    }
}

//读取上次的登录状态
+(int)readLoginState
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"loginType.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    NSString *loginState = [dict objectForKey:@"loginType"];
    
    return [loginState intValue];
}


+ (void)showLoadingInView:(UIView *)parentView hintText:(NSString *)hintText
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect theFrame = parentView.frame;
        if (_loadingHUD)
        {
            [_loadingHUD removeFromSuperview];
            _loadingHUD = nil;
        }
        _loadingHUD = [[MBProgressHUD alloc] initWithFrame:theFrame];
        //    _loadingHUD.labelText = hintText;
        _loadingHUD.labelText = LOADING_VIEW_TEXT;
        [parentView addSubview:_loadingHUD];
        
        _loadingHUD.mode = MBProgressHUDModeCustomView;
        _loadingHUD.customView = [IMPointLoadingView viewWithPointLoading];
        [((IMPointLoadingView *)_loadingHUD.customView) startAnimating];
        
        [_loadingHUD setColor:[UIColor colorWithHexString:@"#000000" alpha:0.55]];
        [_loadingHUD setTextColor:[UIColor colorWithHexString:@"#ffffff" alpha:1.0]];
        [_loadingHUD setDimBackground:NO];
        
        [_loadingHUD show:YES];
    });
}

+ (void)showLoading:(NSString *)hintText
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *theWindow = [UIApplication sharedApplication].delegate.window;
        CGRect theFrame = theWindow.frame;
        if (_loadingHUD)
        {
            [_loadingHUD removeFromSuperview];
            _loadingHUD = nil;
        }
        _loadingHUD = [[MBProgressHUD alloc] initWithFrame:theFrame];
        //    _loadingHUD.labelText = hintText;
        if (![self CheckParam:hintText]) {
            _loadingHUD.labelText = hintText;
        }
        else {
            _loadingHUD.labelText = LOADING_VIEW_TEXT;
        }
        [theWindow addSubview:_loadingHUD];
        
        [theWindow addSubview:_loadingHUD];
        
        _loadingHUD.mode = MBProgressHUDModeCustomView;
        _loadingHUD.customView = [IMPointLoadingView viewWithPointLoading];
        [((IMPointLoadingView *)_loadingHUD.customView) startAnimating];
        
        [_loadingHUD setColor:[UIColor colorWithHexString:@"#000000" alpha:0.55]];
        [_loadingHUD setTextColor:[UIColor colorWithHexString:@"#ffffff" alpha:1.0]];
        [_loadingHUD setDimBackground:NO];
        
        [_loadingHUD show:YES];

    });
}

+ (void)hideLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [((IMPointLoadingView *)_loadingHUD.customView) stopAnimating];
        [_loadingHUD removeFromSuperview];
        _loadingHUD = nil;
    });
}


/**
 *  时刻转成时间间隔
 *
 *  @param timeStr 时刻
 *
 *  @return 时间间隔
 */
+ (NSString *)timeSpaceWithTimeStr:(NSString *)timeStr isBigPhoto:(BOOL)isBigPhoto
{
    /** 规则如下：
     * 
     街拍的时间显示：一分钟内显示【刚刚】；
     1分钟-1小时内，显示【N分钟前】；
     1小时-1天内显示【N小时前】；
     超过一天，在本年度的，显示【2月18日】；
     去年以及更早的显示【2015-02-09】；
     
     大图详情页：
     一分钟内显示【刚刚】；
     1分钟-1小时内，显示【N分钟前】；
     1小时-1天内显示【N小时前】；
     超过一天，在本年度的，显示【3月13日 14:15】；
     去年以及更早的显示【2015-02-09 15:28】"
     */
    
    if ([CustomUtil CheckParam:timeStr] || timeStr.length < 19) {
        // 字符串为空或位数不足 直接返回
        return timeStr;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 时间转时间戳
    NSDate *date = [dateFormat dateFromString:timeStr];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *theDay = [dateFormatter stringFromDate:date];             //要比较的年月日
//    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *theYear = [dateFormatter stringFromDate:date];             //要比较年
    NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];//当前年

    
    NSInteger timeInterval = -[date timeIntervalSinceNow];
    if (timeInterval < 60) {
        //1分钟内
        return @"刚刚";
    }
    else if (timeInterval < 3600) {
        //1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)timeInterval / 60];
    }
    else if (timeInterval < 86400) {
        //6小时内
        return [NSString stringWithFormat:@"%d小时前", (int)timeInterval / 3600];
    }
//    else if ([theDay isEqualToString:currentDay]) {
//        //今天
//        return [NSString stringWithFormat:@"%d小时前", (int)timeInterval / 3600];
//    }
    else if ([theYear isEqualToString:currentYear]) {
        //今年
        if (isBigPhoto) {
            // 大图
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        }
        else {
            // 小图
            [dateFormatter setDateFormat:@"MM-dd"];
        }
        return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    }
    else {
        //去年以前
        if (isBigPhoto) {
            // 大图
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
        else {
            // 小图
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    }
}

@end



@implementation UIImage(private)

+ (UIImage *)imageFromSource:(NSString *)imgName Type:(NSString *)imgType
{
    NSString *imgString = [[NSBundle mainBundle] pathForResource:imgName ofType:imgType];
    return [UIImage imageWithContentsOfFile:imgString];
}

+ (UIImage *)vertorImageWithName:(NSString *)imgName withTop:(CGFloat)top withLeft:(CGFloat)left withBottom:(CGFloat)bottom withRight:(CGFloat)right
{
    UIImage *img = [UIImage imageNamed:imgName];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImg;
}

-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 *  裁剪图片
 *
 *  @param radius圆的半径
 *
 ***/
- (UIImage*)cutImageWithRadius:(int)radius
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0;
    float y1 = 0;
    float x2 = x1+self.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+self.size.height;
    float x4 = x1;
    float y4 = y3;
    radius = radius*2;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, self.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

@end



//
//  AppDelegate.m
//  mxj
//
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
//#import "WelcomePageViewController.h"
#import "MyStreetPhotoViewController.h"
#import "TabBarController.h"
#import "MessageViewController.h"
//#import "LoginViewController.h"
#import "LoginVC.h"
#import "MainPageTabBarController.h"
#import "StreetPhotoViewController.h"
#import "StreetPhotoDetailViewController.h"
#import <Bugly/Bugly.h>
#import "LoginModel.h"
#import "StreetPhotoDetailViewController.h"
#import "SearchFriendViewController.h"
#import "PublishViewController.h"
#import "NewMyVC.h"

#define BUGLY_APP_ID @"900029804"
@interface AppDelegate () <BuglyDelegate>
{
    NSTimer *timer; //密码修改监听用定时器
    NSTimer *messageTimer; //是否收到消息的监听定时器
    UIBackgroundTaskIdentifier  taskID;
    
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    //删除storyboard后的附加处理
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigationCtrl = [[UINavigationController alloc] init];
    //设置导航栏为透明
    [self.window setRootViewController:navigationCtrl];
    //获取定位信息
    //注册
    [MAMapServices sharedServices].apiKey = GAODEDITU_APPKEY;
    [AMapSearchServices sharedServices].apiKey = GAODEDITU_APPKEY;
    //开启定位
    [CustomUtil getLocationInfo:^(AMapLocationReGeocode *regoCode, CLLocation *position) {
        //获取当前城市
        if ([CustomUtil CheckParam:regoCode.city]) {
            [TKLoginPosition shareInstance].cityName = regoCode.province;
        } else {
            [TKLoginPosition shareInstance].cityName = regoCode.city;
        }
    }];
    
    //启动画面完成后的首个页面-根据条件判断是否显示引导页
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"AppConfig.plist"];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSMutableDictionary *configDict = [[NSMutableDictionary alloc] init];
        [configDict setObject:@"0" forKey:@"isFirstLogin"];
        [configDict writeToFile:filePath atomically:YES];
        //创建登录状态记录文件
        [CustomUtil writeLoginState:0]; //无登录状态
    }
    NSMutableDictionary *appConfigDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    if ([[appConfigDict objectForKey:@"isFirstLogin"] isEqualToString:@"0"]) {
        GuideViewController *guideViewCtrl = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
        [navigationCtrl pushViewController:guideViewCtrl animated:YES];
        [appConfigDict setObject:@"1" forKey:@"isFirstLogin"];
        [appConfigDict writeToFile:filePath atomically:YES];
    } else {
        //跳转至欢迎页面
//        WelcomePageViewController *viewCtrl = [[WelcomePageViewController alloc] initWithNibName:@"WelcomePageViewController" bundle:nil];
        LoginVC *viewCtrl = [[LoginVC alloc] init];
        [navigationCtrl pushViewController:viewCtrl animated:YES];
        
        //读取registerId
        NSArray *registerPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *registerPath = [registerPaths lastObject];
        NSString *registerInfoPath = [registerPath stringByAppendingPathComponent:@"registerId.plist"];
        NSFileManager *registerFileManager = [[NSFileManager alloc] init];
        if ([registerFileManager fileExistsAtPath:registerInfoPath]) {
            NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithContentsOfFile:registerInfoPath];
            [LoginModel shareInstance].registerId = [userInfoDict objectForKey:@"registerId"];
            [LoginInput shareInstance].registerId = [userInfoDict objectForKey:@"registerId"];
        } else {
            [LoginModel shareInstance].registerId = @"";
            [LoginInput shareInstance].registerId = @"";
        }
        //判断上次的登录状态
        int loginType = [CustomUtil readLoginState];
        switch (loginType) {
            case 0: //无登录状态
            {
                
            }
                break;
            case 1: //常规登录
            {
                //读取登录账户信息
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *path = [paths lastObject];
                NSString *userInfoPath = [path stringByAppendingPathComponent:@"userInfo.plist"];
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                if ([fileManager fileExistsAtPath:userInfoPath]) {
                    NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithContentsOfFile:userInfoPath];
                    [TKLoginAccount shareInstance].phoneNum = [userInfoDict objectForKey:@"phoneNum"];
                    [TKLoginAccount shareInstance].password = [userInfoDict objectForKey:@"password"];
                } else {
                    [TKLoginAccount shareInstance].phoneNum = @"";
                    [TKLoginAccount shareInstance].password = @"";
                }
                //调用登录接口
                [[CustomUtil shareInstance] clearLoginData];
                [LoginInput shareInstance].phoneNumber = [TKLoginAccount shareInstance].phoneNum;
                [LoginInput shareInstance].userPassword = [CustomUtil md5HexDigest:[TKLoginAccount shareInstance].password];
                [LoginInput shareInstance].registerId = [LoginModel shareInstance].registerId;
                [LoginInput shareInstance].phoneType = @"0"; //iOS设备
                // app版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                [LoginInput shareInstance].verison=app_Version;

                NSMutableDictionary *dict = [CustomUtil modelToDictionary:[LoginInput shareInstance]];
                [CustomUtil showLoading:@"正在登录中..."];
                [[NetInterface shareInstance] login:@"login" param:dict successBlock:^(NSDictionary *responseDict) {
                    [CustomUtil hideLoading];
                    LoginModel *loginModel = [LoginModel modelWithDict:responseDict];
                    if (RETURN_SUCCESS(loginModel.status)) {
#ifdef CACHE_SWITCH
                        [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:responseDict flag:0 imageFlag:100];
#endif
                        [ModifyUserDataInput shareInstance].userId = loginModel.userId;
                        [GetUserInfoInput shareInstance].userId = loginModel.userId;
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *path = [paths lastObject];
                        NSString *userInfoPath = [path stringByAppendingPathComponent:@"userInfo.plist"];
                        NSFileManager *fileManger = [[NSFileManager alloc] init];
                        NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
                        [userInfoDict setValue:[TKLoginAccount shareInstance].phoneNum forKey:@"phoneNum"];
                        [userInfoDict setValue:[TKLoginAccount shareInstance].password forKey:@"password"];
                        if (![fileManger fileExistsAtPath:userInfoPath]) {
                            [fileManger createFileAtPath:userInfoPath contents:nil attributes:nil];
                        }
                        //更新内容
                        [userInfoDict writeToFile:userInfoPath atomically:YES];
                        [CustomUtil writeLoginState:1];
                        //注册推送
                        NSMutableArray *tagArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"tagArray"];
                        NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
                        if (!tagArray && userId) {
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
                        taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerPushDelay:) userInfo:tagArray repeats:NO];
                        //跳转至主页
                        TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                        MainPageTabBarController *mainPageViewCtrl = (MainPageTabBarController *)[[tabBarCtrl viewControllers] objectAtIndexCheck:0];
                        mainPageViewCtrl.loginFlag = YES; //login进入
                        [navigationCtrl setNavigationBarHidden:YES];
                        [navigationCtrl pushViewController:tabBarCtrl animated:YES];
                    } else {
                        [CustomUtil showToastWithText:loginModel.msg view:kWindow];
                        return;
                    }
                } failedBlock:^(NSError *err) {
#ifdef CACHE_SWITCH
                    if ((-1009) == [err code]) { //网络连接中断
                        [CustomUtil showToastWithText:@"网络中断，启用缓存数据" view:kWindow];
                        NSMutableDictionary *dict = (NSMutableDictionary *)[CacheService readCacheData:VIEWCONTROLLER_NAME flag:0];
                        LoginModel *loginModel = [LoginModel modelWithDict:dict];
                        [ModifyUserDataInput shareInstance].userId = loginModel.userId;
                        [GetUserInfoInput shareInstance].userId = loginModel.userId;
                        //跳转至主页
                        TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                        [navigationCtrl setNavigationBarHidden:YES];
                        [navigationCtrl pushViewController:tabBarCtrl animated:YES];
                    }
#endif
                }];
            }
                break;
            case 2: //qq登录
            {
                [CustomUtil qqLogin:NO personOrZone:NO inviteUser:NO imagePath:nil shareContent:@""];
            }
                break;
            case 3: //微信登录
            {
                [CustomUtil weixinLogin:viewCtrl shareFlag:NO personOrZone:NO inviteUser:NO image:nil shareContent:@""];
            }
                break;
            case 4: //微博登录
            {
//                [CustomUtil sinaLogin:NO viewCtrl:@"WelcomePageViewController" personOrZone:NO inviteUser:NO imagePath:nil shareContent:@""];
                [CustomUtil sinaLogin:NO viewCtrl:@"LoginVC" personOrZone:NO inviteUser:NO imagePath:nil shareContent:@""];
            }
                break;
            default:
                break;
        }
    }

    [self.window makeKeyAndVisible];
#ifdef PACKAGEFORTEST
#else
    [NSThread sleepForTimeInterval:3.0]; //设置启动页面时间
#endif
    
    //注册新浪微博
    [WeiboSDK enableDebugMode:YES]; //TODO 开启debug模式
    [WeiboSDK registerApp:XINLANGWEIBO_APPKEY];
    //注册微信
    [WXApi registerApp:WEIXIN_APPKEY];
    //注册短信
    [SMSSDK registerApp:DUANXINYANZHENG_APPKEY withSecret:DUANXINYANZHENG_SECRET];
    //注册bugly
    [self setupBugly];

    //注册推送
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JPushRegisterNotification:) name:kJPFNetworkDidLoginNotification object:nil];
    
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    [JPUSHService setupWithOption:launchOptions];
    
    //启动监听，每5分钟检查一次登录用户密码是否变更
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(checkPassword) userInfo:nil repeats:YES];
    }
    
    //启动监听，每5分钟检查一次登录用户是否收到新消息
    if (!messageTimer) {
        messageTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(checkMessage) userInfo:nil repeats:YES];
    }
    
    //增加水印
    //[CustomUtil addWaterMark];
    
    return YES;
}



- (void)setupBugly
{
    // Get the default config
    BuglyConfig * config = [BuglyConfig defaultConfig];
    
    config.delegate = self;
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    // 开启非正常退出统计
    config.unexpectedTerminatingDetectionEnable = YES;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    [Bugly setTag:1799];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
//    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
//    [self performSelector:@selector(testLogOnBackground) withObject:nil afterDelay:10];
}

- (void)testLogOnBackground {
    
    NSString *str = nil;
    [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
}

//- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception
//{
//    NSMutableString * additionInfo = [[NSMutableString alloc] init];
//
//    [additionInfo appendString:[NSString stringWithFormat:@"exception name:%@;reason:%@;userInfo:%@\n", exception.name, exception.reason, exception.userInfo]];
//    
//    [additionInfo appendString:[NSString stringWithFormat:@"crashType:%@\n", [Bugly getCrashType]]];
//    //    [additionInfo appendString:[NSString stringWithFormat:@"crashLog:%@\n", [[CrashReporter sharedInstance] getCrashLog]]];
//    [additionInfo appendString:[NSString stringWithFormat:@"crashStack:%@\n", [Bugly getCrashStack]]];
//
//    return @"1";
//}

//极光推送广播
-(void)JPushRegisterNotification:(NSNotification *)notification
{
    NSString *registerId;
//    if (![JPUSHService registrationID]) {
        registerId = [JPUSHService registrationID];
//    }
    LoginModel *loginModel = [[LoginModel alloc] initWithDict:nil];
    DLog(@"%@", loginModel);
    [LoginModel shareInstance].registerId = registerId;
    [LoginInput shareInstance].registerId = registerId;
    DLog(@"[LoginInput shareInstance].registerId = %@", registerId);
    [RegisterInput shareInstance].registerId = registerId;
    //将RegisterId写入文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    NSString *userInfoPath = [path stringByAppendingPathComponent:@"registerId.plist"];
    NSFileManager *fileManger = [[NSFileManager alloc] init];
    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
    [userInfoDict setValue:registerId forKey:@"registerId"];
    if (![fileManger fileExistsAtPath:userInfoPath]) {
        [fileManger createFileAtPath:userInfoPath contents:nil attributes:nil];
    }
    //更新内容
    [userInfoDict writeToFile:userInfoPath atomically:YES];
    
//    //注册推送
//    NSMutableArray *tagArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"tagArray"];
//    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
//    if (!tagArray && userId) {
//        tagArray = [NSMutableArray array];
//        NSArray *maoTagArray = [[NSMutableArray alloc]initWithObjects:@"maoxj_1",@"maoxj_2",@"maoxj_3",@"maoxj_4",@"maoxj_5",@"maoxj_6",@"maoxj_7",@"maoxj_8", nil];
//        [maoTagArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (idx == 0) {
//                [tagArray addObject:maoTagArray[0]];
//            } else {
//                [tagArray addObject:[NSString stringWithFormat:@"%@_%@", maoTagArray[idx], userId]];
//            }
//        }];
//        [[NSUserDefaults standardUserDefaults] setObject:tagArray forKey:@"tagArray"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    [self performSelector:@selector(pushDelay:) withObject:tagArray afterDelay:1];
}

- (void)timerPushDelay:(NSTimer *)timer1
{
    [JPUSHService setTags:[NSSet setWithArray:timer1.userInfo] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
    [[UIApplication sharedApplication] endBackgroundTask:taskID];
//    [self endba]

}

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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [[UIApplication sharedApplication] endBackgroundTask:UIBackgroundTaskInvalid];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if (timer) {
        [timer invalidate];
    }
}

//检查password是否修改
-(void)checkPassword
{
    if (![CustomUtil CheckParam:[TKLoginAccount shareInstance].phoneNum]) {
        [CheckPasswordInput shareInstance].phoneNumber = [TKLoginAccount shareInstance].phoneNum;
        [CheckPasswordInput shareInstance].userPassword = [CustomUtil md5HexDigest:[TKLoginAccount shareInstance].password];
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[CheckPasswordInput shareInstance]];
        [[NetInterface shareInstance] checkPassword:@"checkPassword" param:dict successBlock:^(NSDictionary *responseDict) {
            CheckPassword *returnData = [[CheckPassword alloc] initWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                if ([@"0" isEqualToString:returnData.flag]) { //密码已更新
                    //弹出对话框
                    [CustomUtil showCustomAlertView:@"" message:returnData.msg leftTitle:@"确定" rightTitle:@"" leftHandle:^(UIAlertAction *action) {
                        [TKLoginAccount shareInstance].password = @"";
                        //跳转至登录界面
                        for (UIViewController *viewCtrl in [(UINavigationController *)_window.rootViewController viewControllers]) {
//                            if ([viewCtrl isKindOfClass:[LoginViewController class]]) {
                              if ([viewCtrl isKindOfClass:[LoginVC class]]) {
                                    
                                [viewCtrl.navigationController setNavigationBarHidden:NO];
                                [(UINavigationController *)_window.rootViewController popToViewController:viewCtrl animated:YES];
                            }
                        }
                    } rightHandle:nil target:[[(UINavigationController *)_window.rootViewController viewControllers] objectAtIndexCheck:0] btnCount:1];
                }
            }
        } failedBlock:^(NSError *err) {
        }];
    }
}

//检查登录用户是否收到消息
-(void)checkMessage
{
    if (![CustomUtil CheckParam:[LoginModel shareInstance].userId]) {
        [GetUnreadNumInput shareInstance].userId = [LoginModel shareInstance].userId;
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUnreadNumInput shareInstance]];
        [[NetInterface shareInstance] getUnreadNum:@"getUnreadNum" param:dict successBlock:^(NSDictionary *responseDict) {
            GetUnreadNum *unreadNumData = [GetUnreadNum modelWithDict:responseDict];
            if (RETURN_SUCCESS(unreadNumData.status)) {
                //设置消息圆点
                if (([unreadNumData.commentNum intValue] > 0) ||
                    ([unreadNumData.noticeNum intValue] > 0)  ||
                    ([unreadNumData.messageNum intValue] > 0) ||
                    ([unreadNumData.praiseNum intValue] > 0)) {
                    for (UIViewController *viewCtrl in [(UINavigationController *)_window.rootViewController viewControllers]) {
                        if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                            TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                            [tabBarCtrl.pointImageView setHidden:NO];
                        }
                    }
                } else {
                    for (UIViewController *viewCtrl in [(UINavigationController *)_window.rootViewController viewControllers]) {
                        if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                            TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                            [tabBarCtrl.pointImageView setHidden:YES];
                        }
                    }
                }
                //设置桌面图标右上角的数字
                NSInteger badgeNum = [unreadNumData.commentNum intValue] + [unreadNumData.noticeNum intValue] + [unreadNumData.messageNum intValue] + [unreadNumData.praiseNum intValue];
                [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNum;
                [JPUSHService setBadge:badgeNum];
            }
        } failedBlock:^(NSError *err) {
        }];
    }
}

#pragma mark -极光推送
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    DLog(@"userInfo = %@", userInfo);
    /*
     "_j_msgid" = 3422408256;
     aps =     {
     alert = "\U963f\U65af\U987f\U53d1\U9001\U5230";
     badge = 6;
     sound = default;
     };
     type = 0;
     
     */
    /*
     {
     "_j_msgid" = 271314097;
     aps =     {
     alert = "\U4e00\U53f6\U77e5\U79cb\U53d1\U4e86\U65b0\U7684\U8857\U62cd";
     badge = 1;
     sound = "";
     };
     streetsnapId = "b5728190-eaba-43bd-9162-10d72b40eb3e";
     type = 2;
     }
     */
    NSLog(@"%@", userInfo);
    NSString *type = [userInfo objectForKey:@"type"];
    if (UIApplicationStateActive == application.applicationState) {
        DLog(@"应用进入前台");
    } else if(UIApplicationStateInactive == application.applicationState) {
        if (![CustomUtil CheckParam:[LoginModel shareInstance].userId]) {

            if (![type isEqualToString:@"2"] && ![type isEqualToString:@"8"] && ![type isEqualToString:@"6"] && ![type isEqualToString:@"5"] && ![type isEqualToString:@"1"]) {
                //跳转至通知列表或私信列表界面
                for (UIViewController *viewCtrl in [(UINavigationController *)_window.rootViewController viewControllers]) {
                    if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                        TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                        [tabBarCtrl setSelectedIndex:3];
                        tabBarCtrl.intoStreetFlag = 3;
                        
                        for (UIViewController *vc in tabBarCtrl.viewControllers) {
                            if (vc.navigationController.viewControllers.count > 2) {
                                NSInteger n = 1;
                                for (UIViewController *childVC in vc.navigationController.viewControllers) {
                                    if ([childVC isKindOfClass:[GuideViewController class]]) {
                                        n = 2;
                                        break;
                                    } else {
                                        n = 1;
                                    }
                                }
                                [vc.navigationController popToViewController:vc.navigationController.viewControllers[n] animated:NO];
                            }
                        }
//
                        MessageViewController *messageViewCtrl = [tabBarCtrl.viewControllers objectAtIndexCheck:3];
                        if ([type isEqualToString:@"3"]) {
                            [messageViewCtrl buttonClickWithType:0];
                        } else if ([type isEqualToString:@"7"]) {
                            [messageViewCtrl buttonClickWithType:1];
                        } else if ([type isEqualToString:@"4"]) {
                            [messageViewCtrl buttonClickWithType:2];
                        }
                    }
                }
            } else if ([type isEqualToString:@"8"] || [type isEqualToString:@"1"]) {
                //跳首页
                for (UIViewController *viewCtrl in [(UINavigationController *)_window.rootViewController viewControllers]) {
                    if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                        TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                        [tabBarCtrl setSelectedIndex:0];
                        tabBarCtrl.intoStreetFlag = 2;
                        for (UIViewController *vc in tabBarCtrl.viewControllers) {
                            if (vc.navigationController.viewControllers.count > 2) {
                                [vc.navigationController popToViewController:vc.navigationController.viewControllers[1] animated:NO];
                            }
                        }
                        MainPageTabBarController *mainPageTabBarController = [tabBarCtrl.viewControllers objectAtIndexCheck:0];
                        [mainPageTabBarController.menuBtnCell btnClickWithTag:1];
                    }
                }
            } else if ([type isEqualToString:@"5"]) {
                //跳个人页面
                for (UIViewController *viewCtrl in [(UINavigationController *)_window.rootViewController viewControllers]) {
                    if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                        TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                        [tabBarCtrl setSelectedIndex:4];
                        tabBarCtrl.intoStreetFlag = 4;
                        NewMyVC *vc = [tabBarCtrl.viewControllers objectAtIndexCheck:4];
                        
                        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
                        NSString *userID = [userInfo valueForKey:@"userId"];
                        //传参数
                        viewCtrl.userId = userID;
                        viewCtrl.type = 1;
                        [vc.navigationController pushViewController:viewCtrl animated:YES];
                    }
                }
            }
            else {
                //跳转至街拍详情列表界面
                for (UIViewController *viewCtrl in [(UINavigationController *)_window.rootViewController viewControllers]) {
                    if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                        TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                        [tabBarCtrl setSelectedIndex:1];
                        tabBarCtrl.intoStreetFlag = 1;
                        StreetPhotoViewController *streetPhotoViewCtrl = [tabBarCtrl.viewControllers objectAtIndexCheck:1];
                        StreetPhotoDetailViewController *streetPhotoDetailViewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
                        streetPhotoDetailViewCtrl.intoFlag = NO;
                        streetPhotoDetailViewCtrl.streetsnapId = [userInfo objectForKey:@"streetsnapId"];
                        [streetPhotoViewCtrl.navigationController pushViewController:streetPhotoDetailViewCtrl animated:YES];
                    }
                }
            }
        }
    }
}

#pragma mark -qq分享功能
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DLog(@"url.scheme = %@", url.scheme);
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@", QQ_APPKEY]]) {
        return [TencentOAuth HandleOpenURL:url];
    } else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@", XINLANGWEIBO_APPKEY]]) {
        return [WeiboSDK handleOpenURL:url delegate:[CustomUtil shareInstance]];
    } else if ([url.scheme isEqualToString:WEIXIN_APPKEY]) {
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        NSString *detailString =[userDefault objectForKey:@"StreetPhoto"];
        if (detailString) {
            [userDefault removeObjectForKey:@"StreetPhoto"];
            [userDefault synchronize];
            StreetPhotoDetailViewController *detail=[[StreetPhotoDetailViewController alloc]init];
            return [WXApi handleOpenURL:url delegate:detail];
        }
        NSUserDefaults *userDefault2=[NSUserDefaults standardUserDefaults];
        NSString *searchString =[userDefault2 objectForKey:@"SearchFriend"];
        if (searchString) {
            [userDefault2 removeObjectForKey:@"SearchFriend"];
            [userDefault2 synchronize];
            SearchFriendViewController *search=[[SearchFriendViewController alloc]init];
            return [WXApi handleOpenURL:url delegate:search];
        }
        NSUserDefaults *userDefault3=[NSUserDefaults standardUserDefaults];
        NSString *publishString =[userDefault3 objectForKey:@"PublishVC"];
        if (publishString) {
            [userDefault3 removeObjectForKey:@"PublishVC"];
            [userDefault3 synchronize];
            PublishViewController *publish=[[PublishViewController alloc]init];
            return [WXApi handleOpenURL:url delegate:publish];
        }
        else{
             return [WXApi handleOpenURL:url delegate:[CustomUtil shareInstance]];
        }
    }
    
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@", QQ_APPKEY]]) {
        return [TencentOAuth HandleOpenURL:url];
    } else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@", XINLANGWEIBO_APPKEY]]) {
        return [WeiboSDK handleOpenURL:url delegate:[CustomUtil shareInstance]];
    } else if ([url.scheme isEqualToString:WEIXIN_APPKEY]) {
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        NSString *detailString =[userDefault objectForKey:@"StreetPhoto"];
        if (detailString) {
            [userDefault removeObjectForKey:@"StreetPhoto"];
            [userDefault synchronize];
            StreetPhotoDetailViewController *detail=[[StreetPhotoDetailViewController alloc]init];
            return [WXApi handleOpenURL:url delegate:detail];
        }
        NSUserDefaults *userDefault2=[NSUserDefaults standardUserDefaults];
        NSString *searchString =[userDefault2 objectForKey:@"SearchFriend"];
        if (searchString) {
            [userDefault2 removeObjectForKey:@"SearchFriend"];
            [userDefault2 synchronize];
            SearchFriendViewController *search=[[SearchFriendViewController alloc]init];
            return [WXApi handleOpenURL:url delegate:search];
        }
        NSUserDefaults *userDefault3=[NSUserDefaults standardUserDefaults];
        NSString *publishString =[userDefault3 objectForKey:@"PublishVC"];
        if (publishString) {
            [userDefault3 removeObjectForKey:@"PublishVC"];
            [userDefault3 synchronize];
            PublishViewController *publish=[[PublishViewController alloc]init];
            return [WXApi handleOpenURL:url delegate:publish];
        }
        else{
            return [WXApi handleOpenURL:url delegate:[CustomUtil shareInstance]];
        }
    }
    
    return YES;
}

@end

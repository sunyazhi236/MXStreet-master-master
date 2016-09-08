//
//  SetViewController.m
//  mxj
//  P12设置
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "SetViewController.h"
#import "guanYuWoMenViewController.h"
#import "HelpViewController.h"
#import "FeedBackViewController.h"
#import "ChangePasswordViewController.h"
#import "MyLevelViewController.h"
#import "PersonDocViewController.h"
#import "BlackListViewController.h"
#import "NoticeVCViewController.h"

//#import "LoginViewController.h"
#import "LoginVC.h"
//#import "RegisterViewController.h"

@interface SetViewController ()


@end

@implementation SetViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"设置"];
    self.setTableView.delegate = self;
    self.setTableView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9; //10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
//        case 0:
//        case 4:
//        case 6:
//        case 10:
        case 0:
            return 44;
            break;
        case 2:
        case 4:

            return 54;
            break;
        default:
            return 44;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
//        case 0:
//            return self.geRenZiliaoCell;
//            break;
//        case 1:
//            return self.woDeDengJiCell;
//            break;
        case 0:
            return self.xiuGaiMiMaCell;
            break;
        case 1:
            return self.heiMingDanCell;
            break;
        case 2:
            return self.xiaoXiTuiSongCell;
            break;
        case 3:
        {
#ifdef CACHE_SWITCH
            //获取缓存文件夹路径(自定义文件夹）
            NSString *cachePath = CACHE_PATH;
            //获取文件夹容量大小
            float folderSize = [CustomUtil folderSizeAtPath:cachePath];
            //获取EGO缓存文件夹路径
            NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString* oldCachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"fsCachedData"] copy];
            float fsOldFolderSize = 0;
            if([[NSFileManager defaultManager] fileExistsAtPath:oldCachesDirectory]) {
                fsOldFolderSize = [CustomUtil folderSizeAtPath:oldCachesDirectory];
            }
            
            NSString *oldEGODirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"EGOCache"] copy];
            float oldEGOFolderSize = 0;
            if([[NSFileManager defaultManager] fileExistsAtPath:oldCachesDirectory]) {
                oldEGOFolderSize = [CustomUtil folderSizeAtPath:oldEGODirectory];
            }
            
            float fsCacheFolderSize = 0;
            NSString *newFsForder = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"fsCachedData"] copy];
            if ([[NSFileManager defaultManager] fileExistsAtPath:newFsForder]) {
                fsCacheFolderSize = [CustomUtil folderSizeAtPath:newFsForder];
            }
            
            float newEGOFolderSize = 0;
            NSString *newPath = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"EGOCache"] copy];
            if ([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
                newEGOFolderSize = [CustomUtil folderSizeAtPath:newPath];
            }
            
            float totalSize = folderSize + fsOldFolderSize + oldEGOFolderSize + fsCacheFolderSize + newEGOFolderSize;
            //设置缓存显示大小
            if (0 == totalSize) {
                _cacheSizeLabel.text = @"0MB";
            } else {
                _cacheSizeLabel.text = [NSString stringWithFormat:@"%0.2fMB", totalSize];
            }
#else
            _cacheSizeLabel.text = @"0MB";
#endif
        }
            return self.qingChuHuanCunCell;
            break;
        case 4:
            return self.yiJianFanKuiCell;
            break;
        case 5:
            return self.guanYuWoMenCell;
            break;
        case 6:
            return self.bangZhuZhongXinCell;
            break;
        case 7:
            return self.geiHaoPingCell;
            break;
        case 8:
            //return self.banBenGengXinCell;
            return self.keFuReXianCell;
            break;
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
//        case 0: //个人资料
//        {
//            PersonDocViewController *personDocViewCtrl = [[PersonDocViewController alloc] initWithNibName:@"PersonDocViewController" bundle:nil];
//            personDocViewCtrl.queryUserId = [LoginModel shareInstance].userId;
//            [self.navigationController pushViewController:personDocViewCtrl animated:YES];
//        }
//            break;
//        case 1: //我的等级
//        {
//            MyLevelViewController *myLevelViewCtrl = [[MyLevelViewController alloc] initWithNibName:@"MyLevelViewController" bundle:nil];
//            [self.navigationController pushViewController:myLevelViewCtrl animated:YES];
//        }
//            break;
        case 0: //修改密码
        {
            ChangePasswordViewController *changePasswordViewCtrl = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
            [self.navigationController pushViewController:changePasswordViewCtrl animated:YES];
        }
            break;
        case 1: //黑名单
        {
            BlackListViewController *blackListViewCtrl = [[BlackListViewController alloc] initWithNibName:@"BlackListViewController" bundle:nil];
            [self.navigationController pushViewController:blackListViewCtrl animated:YES];
        }
            break;
        case 2:{ //消息通知
            NoticeVCViewController *noticeVC = [NoticeVCViewController shareViewController];
            [self.navigationController pushViewController:noticeVC animated:YES];
        }
            break;
        case 3: //清除缓存
        {
            [CustomUtil showCustomAlertView:nil message:@"确定清除缓存吗？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
                //清空缓存
                [CacheService removeCacheData];
                _cacheSizeLabel.text = @"0MB";
            } target:self btnCount:2];
        }
            break;
        case 4:  //意见反馈
        {
            FeedBackViewController *feedBackViewCtrl = [[FeedBackViewController alloc] initWithNibName:@"FeedBackViewController" bundle:nil];
            [self.navigationController pushViewController:feedBackViewCtrl animated:YES];
        }
            break;
        case 5:   //关于我们
        {
            guanYuWoMenViewController *guanYuWoMenViewCtrl = [[guanYuWoMenViewController alloc] initWithNibName:@"guanYuWoMenViewController" bundle:nil];
            [self.navigationController pushViewController:guanYuWoMenViewCtrl animated:YES];
        }
            break;
        case 6: //帮助中心
        {
            HelpViewController *helpViewCtrl = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
            [self.navigationController pushViewController:helpViewCtrl animated:YES];
        }
            break;
        case 7:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=964371298"]];
        }
            break;
        case 8: //客服热线
        {
            //打电话
            NSString *phoneNum = @"0319-2292528"; //电话号码
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNum]];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
            [self.view addSubview:webView];
        }
            break;
        case 10: //版本更新
        {
            //苹果不需要此功能
        }
            break;
            
        default:
            break;
    }
}


//退出登录按钮点击事件
- (IBAction)logoutBtnClick:(id)sender {
    //调用退出登录接口
    [LogoutInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[LogoutInput shareInstance]];
    [[NetInterface shareInstance] logout:@"logout" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [CustomUtil writeLoginState:0];
            [TKLoginAccount shareInstance].phoneNum = @"";
        } else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
    }];
    
    NSArray *viewCtrlsArray = self.navigationController.viewControllers;
    BOOL registerPageIsExist = NO;
    for (UIViewController *viewCtrl in viewCtrlsArray) {
        //            if ([viewCtrl isKindOfClass:[RegisterViewController class]]) {
        if ([viewCtrl isKindOfClass:[LoginVC class]]) {
            
            //删除自动登录用用户信息文件
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths lastObject];
            NSString *userInfoPath = [path stringByAppendingPathComponent:@"userInfo.plist"];
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            if ([fileManager fileExistsAtPath:userInfoPath]) {
                NSError *error;
                BOOL result = [fileManager removeItemAtPath:userInfoPath error:&error];
                if (!result) {
                    [CustomUtil showToastWithText:[error localizedDescription] view:kWindow];
                }
            }//删除qq自动登录的用户信息
            NSString *userInfoPath1 = [path stringByAppendingPathComponent:@"TKQQLogin.plist"];
            NSFileManager *fileManager1 = [[NSFileManager alloc] init];
            if ([fileManager1 fileExistsAtPath:userInfoPath1]) {
                NSError *error1;
                BOOL result1 = [fileManager1 removeItemAtPath:userInfoPath1 error:&error1];
                if (!result1) {
                    [CustomUtil showToastWithText:[error1 localizedDescription] view:kWindow];
                }
            }//删除微信自动登录的用户信息
            NSString *userInfoPath2 = [path stringByAppendingPathComponent:@"TKWeixinLogin.plist"];
            NSFileManager *fileManager2 = [[NSFileManager alloc] init];
            if ([fileManager2 fileExistsAtPath:userInfoPath2]) {
                NSError *error2;
                BOOL result2 = [fileManager2 removeItemAtPath:userInfoPath2 error:&error2];
                if (!result2) {
                    [CustomUtil showToastWithText:[error2 localizedDescription] view:kWindow];
                }
            }//删除新浪微博自动登录的用户信息
            NSString *userInfoPath3 = [path stringByAppendingPathComponent:@"TKWeiboLogin.plist"];
            NSFileManager *fileManager3 = [[NSFileManager alloc] init];
            if ([fileManager3 fileExistsAtPath:userInfoPath3]) {
                NSError *error3;
                BOOL result3 = [fileManager3 removeItemAtPath:userInfoPath3 error:&error3];
                if (!result3) {
                    [CustomUtil showToastWithText:[error3 localizedDescription] view:kWindow];
                }
            }
            registerPageIsExist = YES;
            [JPUSHService setTags:[NSSet set] aliasInbackground:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tagArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popToViewController:viewCtrl animated:YES];
            break;
        }
    }
    if (NO == registerPageIsExist) {
//        RegisterViewController *viewCtrl = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        LoginVC *viewCtrl = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
        viewCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
}

@end

//
//  SearchFriendViewController.m
//  mxj
//  P7-5-1搜索好友
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "PhoneBookViewController.h"
#define SHARE_CONTENT @"毛线街——记录我的毛线·生活"
#define SHARE_TITLE @"我已加入[毛线街]，你也赶快一起狂街吧！"
@interface SearchFriendViewController ()
{
    TencentOAuth *oAuth;
}
@end

@implementation SearchFriendViewController
static TencentOAuth *_tencentOAuth= nil;
NSString *new_url;//分享图片的地址链接

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.searchFriendTableView.delegate = self;
    self.searchFriendTableView.dataSource = self;
    [self.navigationItem setTitle:@"邀请好友"];
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
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 54;
    }
    
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return self.weiboCell;
            break;
        case 1:
            return self.weixinCell;
        case 2:
            return self.qqCell;
        case 3:
            return self.tongxunluCell;
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: //微博好友
        {
            [CustomUtil sinaLogin:YES viewCtrl:@"SearchFriendViewController" personOrZone:YES inviteUser:YES imagePath:SHARE_IMAGE shareContent:@""];
        }
            break;
        case 1: //微信好友
        {
            NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
            [userdefault setObject:@"search" forKey:@"SearchFriend"];
            [userdefault synchronize];
            [CustomUtil shareInstance].shareFlag=YES;//是否为分享
            NSString *string=[NSString stringWithFormat:@"place=%@&cityFlag=%@&current=%@&userId=%@&pagesize=%@&type=%@", [GetStreetsnapListInput shareInstance].place, [GetStreetsnapListInput shareInstance].cityFlag, [GetStreetsnapListInput shareInstance].current, [GetStreetsnapListInput shareInstance].userId, [GetStreetsnapListInput shareInstance].pagesize, [GetStreetsnapListInput shareInstance].type];
            
            NSString *string2=[NSString stringWithFormat:@"%@%@%@%@",@"http://",NET_BASE_URL,@"/maoxj/views/html5page/personal-center.html?",string];
            new_url=[string2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //读取微信授权plist文件
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndexCheck:0];
            NSString *filePath = [path stringByAppendingPathComponent:@"TKWeixinLogin.plist"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
            [TKWeixinLogin shareInstance].openId = [dict objectForKey:@"openId"];
            [TKWeixinLogin shareInstance].token = [dict objectForKey:@"token"];
            
            if ((![CustomUtil CheckParam:[TKWeixinLogin shareInstance].openId]) &&
                (![CustomUtil CheckParam:[TKWeixinLogin shareInstance].token])) {
                [[CustomUtil shareInstance] getWeixinToken:^{
                    //发送分享内容
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.openID = [TKWeixinLogin shareInstance].openId;
                    req.bText = NO;
                    WXMediaMessage *message = [[WXMediaMessage alloc] init];
                    
                    message.description = SHARE_CONTENT;
                    message.title = SHARE_TITLE;
                    UIImage *orginalImage = [UIImage imageNamed:@"icon_80*80"];
                    UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
                    NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
                    UIImage *finishImage = [UIImage imageWithData:targetImageData];
                    [message setThumbImage:finishImage];
                    
                    WXWebpageObject *webPageExt = [WXWebpageObject object];
                    
                    webPageExt.webpageUrl = new_url;
                    
                    message.mediaObject = webPageExt;
                    req.message = message;
                    req.scene = 0;          //发送至个人
                    [WXApi sendReq:req];
                }];
                
            } else {
                //请求授权
                SendAuthReq *req = [[SendAuthReq alloc] init];
                req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
                req.state = @"123";
                //req.openID = WEIXIN_APPKEY;
                [WXApi sendAuthReq:req viewController:self delegate:self];
            }
        }
            break;
        case 2:
        {
            //跳转至QQ好友邀请列表
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
                    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:self];
                    [CustomUtil shareInstance].oAuth = _tencentOAuth;
                }
                _tencentOAuth.redirectURI = @"www.qq.com";
                _tencentOAuth.openId = [TKQQLogin shareInstance].openId;
                _tencentOAuth.expirationDate = [TKQQLogin shareInstance].expirationDate;
                _tencentOAuth.accessToken = [TKQQLogin shareInstance].token;
                [_tencentOAuth getUserInfo];
            } else {
                if (!_tencentOAuth) {
                    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:self];
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
            break;
        case 3:
        {
            //跳转至通讯录好友页面
            PhoneBookViewController *phoneBookViewCtrl = [[PhoneBookViewController alloc] initWithNibName:@"PhoneBookViewController" bundle:nil];
            phoneBookViewCtrl.intoFlag = 4;
            [self.navigationController pushViewController:phoneBookViewCtrl animated:YES];
        }
            break;
        default:
            break;
    }
}
//微信响应代理
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
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
                            message.description = SHARE_CONTENT;
                            message.title = SHARE_TITLE;
                            UIImage *orginalImage = [UIImage imageNamed:@"icon_80*80"];
                            UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
                            NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
                            UIImage *finishImage = [UIImage imageWithData:targetImageData];
                            [message setThumbImage:finishImage];
                            WXWebpageObject *webPageExt = [WXWebpageObject object];
                            webPageExt.webpageUrl = new_url;
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
                        req.scene = 0;          //发送至个人

                        [WXApi sendReq:req];
                    }];
                }];
            }
        } else {
            //[CustomUtil showToastWithText:@"授权失败" view:kWindow];
        }
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
-(void)getUserInfoResponse:(APIResponse *)response{
    if (response.retCode == URLREQUEST_SUCCEED) {
        //分享QQ
        NSString *string=[NSString stringWithFormat:@"place=%@&cityFlag=%@&current=%@&userId=%@&pagesize=%@&type=%@", [GetStreetsnapListInput shareInstance].place, [GetStreetsnapListInput shareInstance].cityFlag, [GetStreetsnapListInput shareInstance].current, [GetStreetsnapListInput shareInstance].userId, [GetStreetsnapListInput shareInstance].pagesize, [GetStreetsnapListInput shareInstance].type];
        
        NSString *string2=[NSString stringWithFormat:@"%@%@%@%@",@"http://",NET_BASE_URL,@"/maoxj/views/html5page/personal-center.html?",string];
        NSString *new_url=[string2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
            QQApiURLObject *object = [QQApiURLObject objectWithURL:[NSURL URLWithString:new_url] title:SHARE_TITLE description:SHARE_CONTENT previewImageURL:nil targetContentType:QQApiURLTargetTypeNews];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
            QQApiSendResultCode send = [QQApiInterface sendReq:req];
            if (EQQAPISENDSUCESS == send) {
                //                [CustomUtil showToastWithText:@"分享成功" view:kWindow];
            }
            else {
                //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
            }

    }
}
@end

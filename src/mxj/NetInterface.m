//
//  NetInterface.m
//  mxj
//  网络请求接口
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//
#import "NetInterface.h"

#define RETURN_CODE_SUCCESS 1  //返回成功时的状态码
#define RETURN_CODE_FAILED  0  //返回失败时的状态码

@implementation NetInterface : NSObject

//获取NetInterface的单例
+(NetInterface *)shareInstance
{
    static NetInterface *shareInstance = nil;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

//0 校验是否已经注册 checkRegister
-(void)checkRegister:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//1 用户获取验证码 getAuthCode
-(void)getAuthCode:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    //TODO 调用第三方接口
    //[[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//1.1 校验验证码 checkAuthCode
-(void)checkAuthCode:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:
(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    //TODO 调用第三方接口
    //[[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//2 用户注册 register
-(void)registerUser:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//3 用户登录 login
-(void)login:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//4 修改密码 modifyPassword
-(void)modifyPassword:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//5 用户修改信息 modifyUserData
-(void)modifyUserData:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitWithImage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//6 街拍列表 getStreetsnapList
-(void)getStreetsnapList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//7 收藏列表 getCollectionList
-(void)getCollectionList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//8 关注的人列表 getFollowList
-(void)getFollowList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//9 粉丝列表 getFansList
-(void)getFansList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//10 查询用户信息 getUserInfo
-(void)getUserInfo:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//11 查询成长值规则 getUserLevelInfo
-(void)getUserLevelInfo:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//12 保存反馈意见 saveFeedback
-(void)saveFeedback:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//13 查询黑名单 getBlacklist
-(void)getBlacklist:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//14 更新黑名单 updateBlacklist
-(void)updateBlacklist:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//15 更新关注 updateFollow
-(void)updateFollow:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//16 查询新消息数
-(void)getUnreadNum:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForMessage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//17 评论列表
-(void)getCommentList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForMessage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//18 通知列表
-(void)getNoticeList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForMessage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//19 私信列表
-(void)getMessageList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForMessage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//20 私信内容
-(void)getMessage:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForMessage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//21 发送私信
-(void)sendMessage:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForMessage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//22 赞我列表
-(void)getPraiseList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForMessage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//23 广告banner
-(void)getBannerList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//24 用户及标签
-(void)search:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//25 标签查询列表
-(void)searchByTag:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//26 查询标签使用用户数
-(void)getTagUserNum:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//27 标签热门标签列表
-(void)getPopTagList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//28 添加标签
-(void)addTag:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//29 发布街拍
-(void)publishStreetsnap:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnapWithImage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//30 创建街拍标签关系
-(void)addStreetsnapTag:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//31 查询街拍详情
-(void)getStreetsnapDetail:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//32 查询是否加入毛线街
-(void)checkMaoxjStatus:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//33 发表评论 publishComment
-(void)publishComment:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//34 更新邀请履历 inviteUser
-(void)inviteUser:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//35 查询省份列表 getProvinceList
-(void)getProvinceList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//36 查询城市列表 getCityList
-(void)getCityList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//37 分享增加积分 share
-(void)share:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//38 点赞 publishPraise
-(void)publishPraise:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//39 收藏 collection
-(void)collection:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//40 删除评论 deleteComment
-(void)deleteComment:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//41 删除街拍 deleteStreetsnap
-(void)deleteStreetsnap:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForSnap:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//42 查询国家列表 getCountryList
-(void)getCountryList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//43 清空通知 deleteNotice
-(void)deleteNotice:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForMessage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//44 退出登录logout
-(void)logout:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//46 校验密码是否变更 checkPassword
-(void)checkPassword:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKit:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//47 删除私信 deleteMessage
-(void)deleteMessage:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initNetWrokKitForMessage:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}

//新版请求
-(void)requestNetWork:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    [[NetInterface shareInstance] initBaseNetWrok:interfaceName param:dict successBlock:successBlock failedBlock:failedBlock];
}


#pragma mark -共通方法
//接口共通调用
- (void)initNetWrokKit:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    //判断参数是否为空
    if ((YES == [interfaceName isEqualToString:@""]) || (nil == interfaceName) || (NULL == interfaceName) || (0 == interfaceName.length)) {
        DLog(@"未传入接口名称");
        return;
    }
    /*
    if ((nil == dict) || (NULL == dict) || (0 == dict.count)) {
        DLog(@"未传入参数");
        return;
    }
     */
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:TEST_BASE_URL customHeaderFields:nil];
    
    MKNetworkOperation *op = [engine operationWithPath:interfaceName params:dict httpMethod:@"POST" ssl:NO];
    if (![CustomUtil CheckParam:[dict objectForKey:@"image"]]) {
        [op addFile:[dict objectForKey:@"image"] forKey:@"image" mimeType:@"jpg"];
    }
    /*
    MBProgressHUD *hud;
    if (![interfaceName isEqualToString:@"checkPassword"]) {
        if (!kWindow) {
        } else {
            hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
            hud.mode = MBProgressHUDAnimationFade;
            hud.removeFromSuperViewOnHide = YES;
        }
    }
     */
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        [CustomUtil hideLoading];
        
        NSDictionary *responseDict = [op responseJSON];
        successBlock(responseDict);
        /*
        if (![interfaceName isEqualToString:@"checkPassword"]) {
            if (hud) {
                [hud removeFromSuperview];
            }
        }
         */
    } onError:^(NSError *error) {
        [CustomUtil hideLoading];
        
        DLog(@"%@", [error localizedDescription]);
        failedBlock(error);
        /*
        if (![interfaceName isEqualToString:@"checkPassword"]) {
            if (hud) {
                [hud removeFromSuperview];
            }
        }
         */
        if ((-1009 != [error code])) {
            MBProgressHUD *errorHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            errorHud.mode = MBProgressHUDModeText;
            NSString *errorMsg = [error localizedDescription];
            errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"。" withString:@""];
            errorHud.labelText = errorMsg;
            errorHud.margin = 10.f;
            errorHud.removeFromSuperViewOnHide = YES;
            [errorHud hide:YES afterDelay:2];
        }
    }];
    
    [engine enqueueOperation:op];
}

- (void)initNetWrokKitForMessage:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    //判断参数是否为空
    if ((YES == [interfaceName isEqualToString:@""]) || (nil == interfaceName) || (NULL == interfaceName) || (0 == interfaceName.length)) {
        DLog(@"未传入接口名称");
        return;
    }
    /*
    if ((nil == dict) || (NULL == dict) || (0 == dict.count)) {
        DLog(@"未传入参数");
        return;
    }
     */
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:TEST_BASE_URL_FOR_MESSAGE customHeaderFields:nil];
    
    MKNetworkOperation *op = [engine operationWithPath:interfaceName params:dict httpMethod:@"POST" ssl:NO];
    /*
    MBProgressHUD *hud;
    if ([interfaceName isEqualToString:@"getUnreadNum"] ||
        [interfaceName isEqualToString:@"getCommentList"] ||
        [interfaceName isEqualToString:@"getNoticeList"] ||
        [interfaceName isEqualToString:@"getMessageList"] ||
        [interfaceName isEqualToString:@"getPraiseList"] ||
        [interfaceName isEqualToString:@"getMessage"]) {
    } else {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.removeFromSuperViewOnHide = YES;
    }
     */
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        [CustomUtil hideLoading];

        NSDictionary *responseDict = [op responseJSON];
        successBlock(responseDict);
        /*
         @"getCommentList"
         @"getNoticeList"
         @"getMessageList"
         @"getPraiseList"
         */
        /*
        if ((![interfaceName isEqualToString:@"getUnreadNum"]) &&
            (![interfaceName isEqualToString:@"getCommentList"]) &&
            (![interfaceName isEqualToString:@"getNoticeList"]) &&
            (![interfaceName isEqualToString:@"getPraiseList"]) &&
            (![interfaceName isEqualToString:@"getMessage"])) {
            [hud removeFromSuperview];
        }
         */
    } onError:^(NSError *error) {
        [CustomUtil hideLoading];

        DLog(@"%@", [error localizedDescription]);
        failedBlock(error);
        /*
        if ((![interfaceName isEqualToString:@"getUnreadNum"]) &&
            (![interfaceName isEqualToString:@"getCommentList"]) &&
            (![interfaceName isEqualToString:@"getNoticeList"]) &&
            (![interfaceName isEqualToString:@"getPraiseList"]) &&
            (![interfaceName isEqualToString:@"getMessage"])) {
            [hud removeFromSuperview];
        }
         */
        if ((-1009 != [error code])) {
            if ((![interfaceName isEqualToString:@"getUnreadNum"]) &&
                (![interfaceName isEqualToString:@"getCommentList"]) &&
                (![interfaceName isEqualToString:@"getNoticeList"]) &&
                (![interfaceName isEqualToString:@"getPraiseList"]) &&
                (![interfaceName isEqualToString:@"getMessage"])) {
                MBProgressHUD *errorHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                errorHud.mode = MBProgressHUDModeText;
                NSString *errorMsg = [error localizedDescription];
                errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"。" withString:@""];
                errorHud.labelText = errorMsg;
                errorHud.margin = 10.f;
                errorHud.removeFromSuperViewOnHide = YES;
                [errorHud hide:YES afterDelay:3];
            }
        }
    }];
    
    [engine enqueueOperation:op];
}

- (void)initNetWrokKitForSnap:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    //判断参数是否为空
    if ((YES == [interfaceName isEqualToString:@""]) || (nil == interfaceName) || (NULL == interfaceName) || (0 == interfaceName.length)) {
        DLog(@"未传入接口名称");
        return;
    }
    /*
    if ((nil == dict) || (NULL == dict) || (0 == dict.count)) {
        DLog(@"未传入参数");
        return;
    }
     */
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:TEST_BASE_URL_FOR_SNAP customHeaderFields:nil];
    
    MKNetworkOperation *op = [engine operationWithPath:interfaceName params:dict httpMethod:@"POST" ssl:NO];
    /*
    MBProgressHUD *hud;
    if ([interfaceName isEqualToString:@"getBannerList"] || [interfaceName isEqualToString:@"getStreetsnapList"]) {
    } else {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.removeFromSuperViewOnHide = YES;
    }
     */
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        [CustomUtil hideLoading];

        NSDictionary *responseDict = [op responseJSON];
        successBlock(responseDict);
        /*
        if (hud) {
            [hud removeFromSuperview];
        }
         */
    } onError:^(NSError *error) {
        [CustomUtil hideLoading];

        DLog(@"%@", [error localizedDescription]);
        failedBlock(error);
        /*
        if (hud) {
            [hud removeFromSuperview];
        }
         */
        if ((-1009 != [error code])) {
            MBProgressHUD *errorHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            errorHud.mode = MBProgressHUDModeText;
            NSString *errorMsg = [error localizedDescription];
            errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"。" withString:@""];
            errorHud.labelText = errorMsg;
            errorHud.margin = 10.f;
            errorHud.removeFromSuperViewOnHide = YES;
            [errorHud hide:YES afterDelay:3];
        }
    }];
    
    [engine enqueueOperation:op];
}

- (void)initNetWrokKitForSnapWithImage:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    //判断参数是否为空
    if ((YES == [interfaceName isEqualToString:@""]) || (nil == interfaceName) || (NULL == interfaceName) || (0 == interfaceName.length)) {
        DLog(@"未传入接口名称");
        return;
    }
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:TEST_BASE_URL_FOR_SNAP customHeaderFields:nil];
    NSMutableDictionary *textDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    if ([[textDict allKeys] containsObject:@"photo1"]) {
        [textDict removeObjectForKey:@"photo1"];
    }
    if ([[textDict allKeys] containsObject:@"photo2"]) {
        [textDict removeObjectForKey:@"photo2"];
    }
    if ([[textDict allKeys] containsObject:@"photo3"]) {
        [textDict removeObjectForKey:@"photo3"];
    }
    if ([[textDict allKeys] containsObject:@"photo4"]) {
        [textDict removeObjectForKey:@"photo4"];
    }
    MKNetworkOperation *op = [engine operationWithPath:interfaceName params:textDict httpMethod:@"POST" ssl:NO];
    if (![CustomUtil CheckParam:[dict objectForKey:@"photo1"]]) {
        [op addFile:[dict objectForKey:@"photo1"] forKey:@"photo1" mimeType:@"jpg"];
    }
    if (![CustomUtil CheckParam:[dict objectForKey:@"photo2"]]) {
        [op addFile:[dict objectForKey:@"photo2"] forKey:@"photo2" mimeType:@"jpg"];
    }
    if (![CustomUtil CheckParam:[dict objectForKey:@"photo3"]]) {
        [op addFile:[dict objectForKey:@"photo3"] forKey:@"photo3" mimeType:@"jpg"];
    }
    if (![CustomUtil CheckParam:[dict objectForKey:@"photo4"]]) {
        [op addFile:[dict objectForKey:@"photo4"] forKey:@"photo4" mimeType:@"jpg"];
    }
    /*
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.removeFromSuperViewOnHide = YES;
     */
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        [CustomUtil hideLoading];

        NSDictionary *responseDict = [op responseJSON];
        successBlock(responseDict);
        //[hud removeFromSuperview];
    } onError:^(NSError *error) {
        [CustomUtil hideLoading];

        DLog(@"%@", [error localizedDescription]);
        failedBlock(error);
        //[hud removeFromSuperview];
        if ((-1009 != [error code])) {
            MBProgressHUD *errorHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            errorHud.mode = MBProgressHUDModeText;
            NSString *errorMsg = [error localizedDescription];
            errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"。" withString:@""];
            errorHud.labelText = errorMsg;
            errorHud.margin = 10.f;
            errorHud.removeFromSuperViewOnHide = YES;
            [errorHud hide:YES afterDelay:3];
        }
    }];
    
    [engine enqueueOperation:op];
}

-(void)initNetWrokKitWithImage:(NSString *)interfaceName param:(NSMutableDictionary*)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    //判断参数是否为空
    if ((YES == [interfaceName isEqualToString:@""]) || (nil == interfaceName) || (NULL == interfaceName) || (0 == interfaceName.length)) {
        DLog(@"未传入接口名称");
        return;
    }
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:TEST_BASE_URL customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:interfaceName params:dict httpMethod:@"POST" ssl:NO];
    if (![CustomUtil CheckParam:[dict objectForKey:@"image"]]) {
        [op addFile:[dict objectForKey:@"image"] forKey:@"image" mimeType:@"jpg"];
    }
    if (![CustomUtil CheckParam:[dict objectForKey:@"backgroundImage"]]) {
        [op addFile:[dict objectForKey:@"backgroundImage"] forKey:@"backgroundImage" mimeType:@"jpg"];
    }
    /*
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.removeFromSuperViewOnHide = YES;
     */
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        [CustomUtil hideLoading];

        NSDictionary *responseDict = [op responseJSON];
        successBlock(responseDict);
        //[hud removeFromSuperview];
    } onError:^(NSError *error) {
        [CustomUtil hideLoading];

        DLog(@"%@", [error localizedDescription]);
        failedBlock(error);
        //[hud removeFromSuperview];
        if ((-1009 != [error code])) {
            MBProgressHUD *errorHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            errorHud.mode = MBProgressHUDModeText;
            NSString *errorMsg = [error localizedDescription];
            errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"。" withString:@""];
            errorHud.labelText = errorMsg;
            errorHud.margin = 10.f;
            errorHud.removeFromSuperViewOnHide = YES;
            [errorHud hide:YES afterDelay:3];
        }
    }];
    
    [engine enqueueOperation:op];
}

- (void)initBaseNetWrok:(NSString *)interfaceName param:(NSMutableDictionary*)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock
{
    //判断参数是否为空
    if ((YES == [interfaceName isEqualToString:@""]) || (nil == interfaceName) || (NULL == interfaceName) || (0 == interfaceName.length)) {
        DLog(@"未传入接口名称");
        return;
    }
    /*
     if ((nil == dict) || (NULL == dict) || (0 == dict.count)) {
     DLog(@"未传入参数");
     return;
     }
     */
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:NET_BASE_URL customHeaderFields:nil];
    
    MKNetworkOperation *op = [engine operationWithPath:interfaceName params:dict httpMethod:@"POST" ssl:NO];
    if (![CustomUtil CheckParam:[dict objectForKey:@"image"]]) {
        [op addFile:[dict objectForKey:@"image"] forKey:@"image" mimeType:@"jpg"];
    }
    /*
     MBProgressHUD *hud;
     if (![interfaceName isEqualToString:@"checkPassword"]) {
     if (!kWindow) {
     } else {
     hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
     hud.mode = MBProgressHUDAnimationFade;
     hud.removeFromSuperViewOnHide = YES;
     }
     }
     */
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        [CustomUtil hideLoading];

        NSDictionary *responseDict = [op responseJSON];
        successBlock(responseDict);
        /*
         if (![interfaceName isEqualToString:@"checkPassword"]) {
         if (hud) {
         [hud removeFromSuperview];
         }
         }
         */
    } onError:^(NSError *error) {
        [CustomUtil hideLoading];

        DLog(@"%@", [error localizedDescription]);
        failedBlock(error);
        /*
         if (![interfaceName isEqualToString:@"checkPassword"]) {
         if (hud) {
         [hud removeFromSuperview];
         }
         }
         */
        if ((-1009 != [error code])) {
//            MBProgressHUD *errorHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            errorHud.mode = MBProgressHUDModeText;
//            NSString *errorMsg = [error localizedDescription];
//            errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"。" withString:@""];
//            errorHud.labelText = errorMsg;
//            errorHud.margin = 10.f;
//            errorHud.removeFromSuperViewOnHide = YES;
//            [errorHud hide:YES afterDelay:2];
        }
    }];
    
    [engine enqueueOperation:op];
}

@end


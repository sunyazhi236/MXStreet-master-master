//
//  NetInterface.h
//  mxj
//  网络请求接口
//  Created by 齐乐乐 on 15/11/23.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

//-------------------- 科匠地址 -------------------------------------------------------------------
//#define BASE_URL @"http://112.64.173.178" //基地址
//#define NET_BASE_URL @"112.64.173.178" //基地址
//#define TEST_BASE_URL @"112.64.173.178/maoxj/appUser/manager"             //基地址（appUser用）
//#define TEST_BASE_URL_FOR_MESSAGE @"112.64.173.178/maoxj/message"         //基地址（message用）
//#define TEST_BASE_URL_FOR_SNAP @"112.64.173.178/maoxj/streetsnap/manager" //基地址（streetsnap用）
//#define DEV_BASE_URL @"112.64.173.178/maoxj/appUser/manager"           //基地址（外网）

//-------------------- 发布地址 -------------------------------------------------------------------
//#define BASE_URL @"http://www.maoxianjie.cn" //基地址
//#define NET_BASE_URL @"www.maoxianjie.cn" //基地址
//#define TEST_BASE_URL @"www.maoxianjie.cn/maoxj/appUser/manager"             //基地址（appUser用）
//#define TEST_BASE_URL_FOR_MESSAGE @"www.maoxianjie.cn/maoxj/message"         //基地址（message用）
//#define TEST_BASE_URL_FOR_SNAP @"www.maoxianjie.cn/maoxj/streetsnap/manager" //基地址（streetsnap用）
//#define DEV_BASE_URL @"www.maoxianjie.cn/maoxj/appUser/manager"           //基地址（外网）

//-------------------- 发布地址 -------------------------------------------------------------------
//#define BASE_URL @"http://123.57.177.128:8080" //基地址
//#define NET_BASE_URL @"123.57.177.128:8080" //基地址
//#define TEST_BASE_URL @"123.57.177.128:8080/maoxj/appUser/manager"             //基地址（appUser用）
//#define TEST_BASE_URL_FOR_MESSAGE @"123.57.177.128:8080/maoxj/message"         //基地址（message用）
//#define TEST_BASE_URL_FOR_SNAP @"123.57.177.128:8080/maoxj/streetsnap/manager" //基地址（streetsnap用）
//#define DEV_BASE_URL @"123.57.177.128:8080/maoxj/appUser/manager"           //基地址（外网）

//192.168.1.115:8181    115便于本地测试
//-------------------- 测试服务器(调试用) -------------------------------------------------------------------
#warning shanpengtao_test
#define BASE_URL @"http://123.57.152.239:8080" //基地址
#define NET_BASE_URL @"123.57.152.239:8080" //基地址
#define TEST_BASE_URL @"123.57.152.239:8080/maoxj/appUser/manager"             //基地址（appUser用）
#define TEST_BASE_URL_FOR_MESSAGE @"123.57.152.239:8080/maoxj/message"         //基地址（message用）
#define TEST_BASE_URL_FOR_SNAP @"123.57.152.239:8080/maoxj/streetsnap/manager" //基地址（streetsnap用）
#define DEV_BASE_URL @"123.57.152.239:8080/maoxj/appUser/manager"           //基地址（外网）

//-------------------- 花生壳(调试用) -------------------------------------------------------------------
//#define BASE_URL @"http://15e2091z08.imwork.net:14780" //基地址
//#define NET_BASE_URL @"15e2091z08.imwork.net:14780" //基地址
//#define TEST_BASE_URL @"15e2091z08.imwork.net:14780/maoxj/appUser/manager"             //基地址（appUser用）
//#define TEST_BASE_URL_FOR_MESSAGE @"15e2091z08.imwork.net:14780/maoxj/message"         //基地址（message用）
//#define TEST_BASE_URL_FOR_SNAP @"15e2091z08.imwork.net:14780/maoxj/streetsnap/manager" //基地址（streetsnap用）
//#define DEV_BASE_URL @"15e2091z08.imwork.net:14780/maoxj/appUser/manager"           //基地址（外网）


typedef void (^SuccessBlock)(NSDictionary *responseDict); //网络请求成功时的block处理
typedef void (^FailedBlock)(NSError *err);      //网络请求失败时的block处理

@interface NetInterface : NSObject

//获取NetInterface的单例
+(NetInterface *)shareInstance;

//0 校验是否已经注册 checkRegister
-(void)checkRegister:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//0 校验是否已经注册 checkMoble
-(void)checkMoble:(NSString *)interfaceName param:(NSDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//1 用户获取验证码 getAuthCode TODO 应从短信接口获取验证码
-(void)getAuthCode:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//1.1 校验验证码 checkAuthCode TODO 从短信接口校验验证码
-(void)checkAuthCode:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:
(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//2 用户注册 register
-(void)registerUser:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//3 用户登录 login
-(void)login:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//4 修改密码 modifyPassword
-(void)modifyPassword:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//5 用户修改信息 modifyUserData
-(void)modifyUserData:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//6 街拍列表 getStreetsnapList
-(void)getStreetsnapList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//7 收藏列表 getCollectionList
-(void)getCollectionList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//8 关注的人列表 getFollowList
-(void)getFollowList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//9 粉丝列表 getFansList
-(void)getFansList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//10 查询用户信息 getUserInfo
-(void)getUserInfo:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//11 查询成长值规则 getUserLevelInfo
-(void)getUserLevelInfo:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//12 保存反馈意见 saveFeedback
-(void)saveFeedback:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//13 查询黑名单 getBlacklist
-(void)getBlacklist:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//14 更新黑名单 updateBlacklist
-(void)updateBlacklist:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//15 更新关注 updateFollow
-(void)updateFollow:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//16 查询新消息数
-(void)getUnreadNum:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//17 评论列表
-(void)getCommentList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//18 通知列表
-(void)getNoticeList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//19 私信列表
-(void)getMessageList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//20 私信内容
-(void)getMessage:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//21 发送私信
-(void)sendMessage:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//22 赞我列表
-(void)getPraiseList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//23 广告banner
-(void)getBannerList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//24 用户及标签
-(void)search:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//25 标签查询列表
-(void)searchByTag:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//26 查询标签使用用户数
-(void)getTagUserNum:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//27 标签热门标签列表
-(void)getPopTagList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//28 添加标签
-(void)addTag:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//29 发布街拍
-(void)publishStreetsnap:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//30 创建街拍标签关系
-(void)addStreetsnapTag:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//31 查询街拍详情
-(void)getStreetsnapDetail:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//32 查询是否加入毛线街
-(void)checkMaoxjStatus:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//33 发表评论 publishComment
-(void)publishComment:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//34 更新邀请履历 inviteUser
-(void)inviteUser:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//35 查询省份列表 getProvinceList
-(void)getProvinceList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//36 查询城市列表 getCityList
-(void)getCityList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//37 分享增加积分 share
-(void)share:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//38 点赞 publishPraise
-(void)publishPraise:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//39 收藏 collection
-(void)collection:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//40 删除评论 deleteComment
-(void)deleteComment:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//41 删除街拍 deleteStreetsnap
-(void)deleteStreetsnap:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//42 查询国家列表 getCountryList
-(void)getCountryList:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//43 清空通知 deleteNotice
-(void)deleteNotice:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//44 退出登录logout
-(void)logout:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//46 校验密码是否变更 checkPassword
-(void)checkPassword:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//47 删除私信 deleteMessage
-(void)deleteMessage:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;

//新版本请求
-(void)requestNetWork:(NSString *)interfaceName param:(NSMutableDictionary *)dict successBlock:(SuccessBlock)successBlock failedBlock:(FailedBlock)failedBlock;


@end
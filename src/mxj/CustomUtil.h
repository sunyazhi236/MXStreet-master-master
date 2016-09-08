//
//  CheckParam.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/25.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <AMapLocationKit/AMapLocationCommonObj.h>

@interface CustomUtil : NSObject<TencentSessionDelegate, WeiboSDKDelegate,WBHttpRequestDelegate, WXApiDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UIView *view; //键盘显示或隐藏时所调整的视图

//微信
@property (nonatomic, assign) BOOL shareFlag; //是否分享标记
@property (nonatomic, assign) BOOL personOrZone; //微信分享至朋友圈或个人
@property (nonatomic, strong) UIImage *shareImage; //分享的图片
@property (nonatomic, assign) UIViewController *viewCtrl;  //当前viewController
@property (nonatomic, assign) BOOL weixinInviteUser; //微信邀请标记

//微博
@property (nonatomic, assign) BOOL weiBoShareFlag; //是否分享标记
@property (nonatomic, assign) BOOL weiBoPersonOrZone; //分享至个人或微博
@property (nonatomic, assign) BOOL weiboInviteUser;   //微博邀请标记


//QQ
@property (nonatomic, assign) BOOL qqShareFlag;    //是否分享
@property (nonatomic, assign) BOOL qqPersonOrZone; //分享个人或朋友圈标记
@property (nonatomic, assign) BOOL inviteUser;     //邀请好友标记
@property (nonatomic, strong) TencentOAuth *oAuth; //腾讯登录审核实例
@property (nonatomic, strong) NSString *shareImagePath; //分享图片的地址
@property (nonatomic, strong) NSString *shareContent;   //分享的内容

+ (instancetype)shareInstance; //获取单例对象

//检查参数是否为空字符串或空指针 YES:为空 NO:不为空
+ (BOOL)CheckParam:(NSString *)paramStr;

//显示自定义AlertView（iOS8以上）
+ (void)showCustomAlertView:(NSString *)title message:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftHandle:(void (^)(UIAlertAction *action))leftHandle rightHandle:(void (^)(UIAlertAction *action))rightHandle target:(UIViewController *)target btnCount:(int)btnCount;

//注册KeyBoard显示隐藏时的通知
- (void)registerKeyBoardNotification;
//移除KeyBoard显示隐藏时的通知
- (void)removeKeyBoardNotification;

//检查手机号是否合法
+ (BOOL)CheckPhoneNumber:(NSString *)phoneNum viewCtrl:(UIViewController *)viewCtrl;

//模型转字典
+ (NSMutableDictionary *)modelToDictionary:(id)entity;

//MD5加密
+ (NSString *)md5HexDigest:(NSString *)inputStr;

//拼接图片绝对路径
+ (NSString *)getPhotoPath:(NSString*)path;

//返回图片NSURL对象
+ (NSURL *)getPhotoURL:(NSString *)path;

//显示纯文本Toast框
+ (void)showToastWithText:(NSString *)text view:(UIView *)view;

//显示纯文本Toast框
+ (void)showToast:(NSString *)detailStr view:(UIView *)view;

/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGRect) heightForString:(NSString *)orignStr width:(int)width;

//获取文字高度
+(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;

+(float)heightForString:(NSString *)value font:(UIFont *)font andWidth:(float)width;

//获取文字宽度
+(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;

//获取UTF8字符串
+ (NSString *)getUTF8String:(NSString *)str;

//--------------------地图功能---------------------------
//获取定位信息
+(void)getLocationInfo:(void (^)(AMapLocationReGeocode *regoCode, CLLocation *position))block;

//--------------------短信功能----------------------------
//发送短信
//内容及收件人列表
+(void)sendSMS:(UIViewController *)viewCtrl bodyMesage:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients;

//--------------------第三方分享--------------------------
//获取邀请信息
+(void)getInviteUserMessage:(void(^)(NSString *shareMsg, NSString *shareUrl))block;
//分享增加积分
+(void)share;

//获取分享图片
+(UIImage *)getShareImage:(NSString *)imagePath;

//获取微信Token及OpenId
-(void)getWeixinToken:(void(^)())block;

//--------------------第三方登录--------------------------
//qq
+(void)qqLogin:(BOOL)shareFlag personOrZone:(BOOL)personOrZone inviteUser:(BOOL)inviteUser imagePath:(NSString *)imagePath shareContent:(NSString *)shareContent;

//微信
+(void)weixinLogin:(UIViewController *)viewCtrl shareFlag:(BOOL)shareFlag personOrZone:(BOOL)personOrZone inviteUser:(BOOL)inviteUser image:(UIImage *)image shareContent:(NSString *)shareContent;

//新浪微博 shareFlag:   YES:分享  NO:不分享
+(void)sinaLogin:(BOOL)shareFlag viewCtrl:(NSString *)viewCtrlName personOrZone:(BOOL)personOrZone
      inviteUser:(BOOL)inviteUser imagePath:(NSString *)imagePath shareContent:(NSString *)shareContent;

//获取第三方平台用户昵称
+(NSString *)getThirdPlatFormNickName:(NSString *)nickName;

//获取四位随机字母数字组合
+(NSString *)createFourLenthString;

// 图片旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

#pragma mark -共通方法
//清空Login模型
-(void)clearLoginData;

//设置ImageView圆角
+(void)setImageViewCorner:(EGOImageView *)imageView;

//保存Image图片到沙盒
+(void)saveImageToSandBox:(NSDictionary *)info fileName:(NSString *)fileName block:(void(^)(UIImage *sandBoxImage, NSString *filePath))block;

//获取ALAssetLibrary的单例
+(ALAssetsLibrary *)defaultAssetsLibrary;


//压缩图片
+(UIImage *)compressImageForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth;

//计算汉字的个数
+(NSInteger)chineseCountOfString:(NSString *)string;

//计算字母的个数
+(NSInteger)characterCountOfString:(NSString *)string;

//判断字符串长度及内容是否符合要求
+(BOOL)isInputStrValid:(NSString *)str minLength:(int)minLength maxLength:(int)maxLength;

//获取网络图片的尺寸（JPG）
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest *)request;

//通过网络请求获取图片的尺寸（PNG）
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request;

//通过网络请求获取图片的尺寸
+(CGSize)getPhotoSizeWithURLStr:(NSString *)urlStr;

//获取单个文件的容量大小
+(long long)fileSizeAtPath:(NSString *)filePath;

//获取文件夹的容量大小（单位：MB）
+(float)folderSizeAtPath:(NSString *)folderPath;

//获取调整方向的image
+(UIImage *)normalizedImage:(UIImage *)image;

//颜色转图片的方法
+ (UIImage *)imageFromColor:(UIColor *)color;

//将定位信息写入文件
+(void)saveLocationInfo:(NSString *)cityName;

//读取文件中上次的定位信息
+(NSString *)readLocationInfo;

//增加水印
+(void)addWaterMark;

//去除字符串中的空白字符及换行符
+(NSString *)deleteBlankAndNewlineChar:(NSString *)orginStr;

//记录上次的登录状态
+(void)writeLoginState:(int)loginType;

//读取上次的登录状态
+(int)readLoginState;

//保存图片头像
+(void)saveHeadImageToSandBox:(UIImage *)image fileName:(NSString *)fileName block:(void(^)(UIImage *sandBoxImage, NSString *filePath))block;

/**
 *  显示等候提示框，与+ (void)hideLoading配合使用
 *
 *  @param hintText 等候提示框提示文字，可为空
 */
+ (void)showLoading:(NSString *)hintText;

/**
 *  在指定View上显示等候提示框，与+ (void)hideLoading配合使用
 *
 *  @param parentView 父View
 *  @param hintText   等候提示框提示文字，可为空
 */
+ (void)showLoadingInView:(UIView *)parentView hintText:(NSString *)hintText;

/**
 *  隐藏等候提示框，与+ (void)showLoading:(NSString *)hintText配合使用
 */
+ (void)hideLoading;


/**
 *  时刻转成时间间隔
 *
 *  @param timeStr 时刻
 *  @param isBigPhoto 是不是大图
 *
 *  @return 时间间隔
 */
+ (NSString *)timeSpaceWithTimeStr:(NSString *)timeStr isBigPhoto:(BOOL)isBigPhoto;

@end

#pragma mark - UIImage Category
@interface UIImage (privateImage)

/**
 *  以pathForResource方式读取资源文件
 *
 *  @param imgName 资源文件名
 *  @param imgType 资源文件扩展名
 *
 *  @return 资源图片
 */
+ (UIImage *)imageFromSource:(NSString *)imgName Type:(NSString *)imgType;

/**
 *  获取矢量图片
 *
 *  @param imgName 资源图片名
 *  @param top     矢量缩放区域top
 *  @param left    矢量缩放区域left
 *  @param bottom  矢量缩放区域bottom
 *  @param right   矢量缩放区域right
 *
 *  @return 矢量图片
 */
+ (UIImage *)vertorImageWithName:(NSString *)imgName
                         withTop:(CGFloat)top
                        withLeft:(CGFloat)left
                      withBottom:(CGFloat)bottom
                       withRight:(CGFloat)right;

/**
 *  生成一张纯色的图片
 *
 *  @param color 图片颜色
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromColor:(UIColor *)color;


/**
 *缩放图片
 *@param 缩放比例
 *
 **/
- (UIImage *)scaleToSize:(CGSize)size;

/**
 *  裁剪图片
 *
 *  @param radius圆的半径
 *
 ***/
- (UIImage *)cutImageWithRadius:(int)radius;

@end


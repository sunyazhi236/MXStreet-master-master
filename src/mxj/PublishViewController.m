//
//  PublishViewController.m
//  mxj
//  P7-3发布街拍
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PublishViewController.h"
#import "PublishStreetPhotoViewController.h"
#import "PositionSetViewController.h"
#import "StreetPhotoDetailViewController.h"
#import "EditPhotoViewController.h"
#import "TabBarController.h"
#import "AppDelegate.h"

#define COMPRESSION_QUALITY 0.1f   //图片压缩比率
#define kMaxCharLength 140 //街拍最大文字长度
#define SHARE_TITLE @"刚刚在［毛线街］分享了自己的街拍，快来看看吧！"
static TencentOAuth *_tencentOAuth= nil;
@interface PublishViewController ()
{
    UIButton *forthDelBtn;          //第四幅图的删除按钮
    UIImageView *forthImageView;    //第四幅图的图片
    NSMutableArray *photoDataNameArray;  //图片存入沙盒后的名称
    NSString *streetsnapId;         //街拍id
    
    AMapLocationManager *locationManager; //地图定位实例
    NSMutableArray *_allPhotoArray;
    
    BOOL weixinBtnFlag;  //微信选择标志
    BOOL qzoneBtnFlag;   //Qzone选择标志
    BOOL weiboBtnFlag;   //微博选择标志
}
@end
NSString *new_url2;
NSString *photo1Path = @"";
@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    photoDataNameArray = [[NSMutableArray alloc] init];
    _inputTextView.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(positionClick:)];
    [self.positionSetImagView addGestureRecognizer:tapGestureRecognizer];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageClick)];
    [self.view addGestureRecognizer:gesture];
    
    weixinBtnFlag = NO;
    qzoneBtnFlag = NO;
    weiboBtnFlag = NO;
    [TKPublishPosition shareInstance].positionName = @"位置";
    
    [self initView];
}

- (void)initView
{
    
    CGFloat tmpY = SCREENHEIGHT - 35 - GetHeight(_publishBtn);
    
    _publishBtn.frame = CGRectMake(22, tmpY, SCREENWIDTH - 44, GetHeight(_publishBtn));
    
    _publishBtn.layer.cornerRadius = GetHeight(_publishBtn) / 2;
    
    CGFloat tmpW = GetWidth(_weixinBtn);
    
    tmpY = tmpY - 25 - tmpW;
    
    CGFloat offsetX = (SCREENWIDTH - tmpW * 3) / 4;
    
    CGFloat tmpX = offsetX;
    
    _weixinBtn.frame = CGRectMake(tmpX, tmpY, tmpW, tmpW);
    
    tmpX = tmpX + tmpW + offsetX;
    
    _weiboBtn.frame = CGRectMake(tmpX, tmpY, tmpW, tmpW);
    
    tmpX = tmpX + tmpW + offsetX;
    
    _qZoneBtn.frame = CGRectMake(tmpX, tmpY, tmpW, tmpW);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 145 + 13, SCREENWIDTH, 30)];
    [self.view addSubview:view];
    
    CGFloat buttonOffsetX = 10;
    
    CGFloat buttonW = 60;
    
    NSArray *array = @[@"棒针",@"钩针",@"缝纫",@"工具"];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonOffsetX + (buttonOffsetX + buttonW) * i, 0, buttonW, 30);
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = FONT(15);
        button.layer.cornerRadius = GetHeight(button) / 2;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#a3a3a3"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#ee3e2f"] forState:UIControlStateSelected];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    _positionSetImagView.frame = CGRectMake(10, GetHeight(view) + GetY(view) + 14, 70, 30);
    _positionSetImagView.layer.cornerRadius = GetHeight(_positionSetImagView) / 2;
    _positionSetImagView.layer.masksToBounds = YES;
    
    _localImagView.frame = CGRectMake(8, (GetHeight(_positionSetImagView) - GetHeight(_localImagView))/2, GetWidth(_localImagView), GetHeight(_localImagView));
    
    
    _positionLabel.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
    
    [_positionSetImagView addSubview:_localImagView];
    [_positionSetImagView addSubview:_positionLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillDisplay:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _positionLabel.text = [TKPublishPosition shareInstance].positionName ? [TKPublishPosition shareInstance].positionName : @"位置";
    
    float width = [CustomUtil widthForString:_positionLabel.text fontSize:_positionLabel.font.pointSize andHeight:GetHeight(_positionLabel)];
    
    _positionLabel.frame = CGRectMake(GetX(_localImagView) + GetWidth(_localImagView) + 5, 0, width, GetHeight(_positionSetImagView));
    
    CGRect rect = _positionSetImagView.frame;
    rect.size.width = width + GetX(_positionLabel) + GetX(_localImagView);
    _positionSetImagView.frame = rect;
    
    _allPhotoArray = _photoArray;
    [self setImageViewAndBtnPosition];
    //设置发布按钮为可用状态
    [_publishBtn setEnabled:YES];
    
    _inputTextView.frame = CGRectMake(10, GetY(_inputTextView), SCREENWIDTH - 20, GetHeight(_inputTextView));
    [_inputTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_inputTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//背景点击事件
-(void)backImageClick
{
    [_inputTextView resignFirstResponder];
}

//键盘弹出事件
-(void)keyBoardWillDisplay:(NSNotification *)aNotification
{
    if ([_inputTextView.text isEqualToString:@"说点什么（140个字以内）"]) {
        _inputTextView.text = @"";
        _inputTextView.textColor = [UIColor blackColor];
    }
}

//键盘隐藏事件
-(void)keyBoardWillHide:(NSNotification *)aNotification
{
    if ([CustomUtil CheckParam:_inputTextView.text]) {
        _inputTextView.text = @"说点什么（140个字以内）";
        _inputTextView.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
    }
}

#pragma mark -TextView代理方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark -按钮点击事件处理
- (void)chooseType:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:300 + i];
        button.selected = NO;
    }
    
    btn.selected = !btn.selected;
}

//返回按钮点击事件
- (IBAction)backBtnClick:(id)sender {
    //弹出确认对话框
    [CustomUtil showCustomAlertView:nil message:@"确定要放弃此次街拍吗？\n(如重新编辑，请点击照片)" leftTitle:@"取消" rightTitle:@"确认" leftHandle:nil rightHandle:^(UIAlertAction *action) {
        for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
            if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                int streetIntoFlag = tabBarCtrl.intoStreetFlag;
                PublishStreetPhotoViewController *publishStreetPhotoViewCtrl = (PublishStreetPhotoViewController *)[tabBarCtrl.viewControllers objectAtIndexCheck:2];
                [publishStreetPhotoViewCtrl.selectPhotoArray removeAllObjects];
                [publishStreetPhotoViewCtrl.labelArray removeAllObjects];
                publishStreetPhotoViewCtrl.photoIndex = 0;
                [tabBarCtrl setSelectedIndex:streetIntoFlag];
                [self.navigationController popToViewController:viewCtrl animated:YES];
            }
        }
    } target:self btnCount:2];
}

//发布按钮点击事件
- (IBAction)publishBtnClick:(id)sender {
    //设置发布按钮为不可用状态
    [_publishBtn setEnabled:NO];
    //检查输入的文本长度
    NSInteger chineseCount = [CustomUtil chineseCountOfString:_inputTextView.text];
    NSInteger charCount = [CustomUtil characterCountOfString:_inputTextView.text];
    NSInteger totalCount = chineseCount + charCount;
    if (totalCount > kMaxCharLength) {
        [_publishBtn setEnabled:YES];
        [CustomUtil showToastWithText:@"街拍文字不能超过140字" view:kWindow];
        return;
    }
    //检查是否添加了标签
    if ((0 == _photo1PositionArray.count) &&
        (0 == _photo2PositionArray.count) &&
        (0 == _photo3PositionArray.count) &&
        (0 == _photo4PositionArray.count)) {
        [_publishBtn setEnabled:YES];
        [CustomUtil showToastWithText:@"未添加标签" view:kWindow];
        return;
    }
    //调用接口发布街拍
    [photoDataNameArray removeAllObjects];
    for (int i=0; i<_allPhotoArray.count; i++) {
        ALAsset *asset = [_allPhotoArray objectAtIndexCheck:i];
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        //uint8_t *buffer = (Byte *)malloc(representation.size);
        //NSUInteger length = [representation getBytes:buffer fromOffset:0.0 length:representation.size error:nil];
        //NSData *orginData = [[NSData alloc] initWithBytesNoCopy:buffer length:representation.size freeWhenDone:YES];
        //UIImage *photoImage = [UIImage imageWithData:orginData];
        //UIImage *photoImage = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:1 orientation:representation.orientation];
        UIImage *photoImage = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)representation.orientation];
        DLog(@"width = %f, height = %f", photoImage.size.width, photoImage.size.height);
        photoImage = [CustomUtil normalizedImage:photoImage];
        DLog(@"width = %f, height = %f", photoImage.size.width, photoImage.size.height);
        Byte *buffer = (Byte*)malloc(representation.size);
        NSUInteger buffered = [representation getBytes:buffer fromOffset:0.0 length:representation.size error:nil];
        NSData *photoData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        //NSData *photoData = UIImageJPEGRepresentation(photoImage, 1);
        //原图尺寸
        int orginPhotoWidth = photoImage.size.width;
        int orginPhotoHeight = photoImage.size.height;
        CGFloat compression = 1.0f;
        CGFloat maxCompression = 0.1f;
        UIImage *targetImage = photoImage;
        if ([photoData length] > (200 * 1024)) { //图片大于200k
            if (photoImage.size.width >= (SCREEN_WIDTH * SCREEN_SCALE)) {
                targetImage = [CustomUtil compressImageForWidth:photoImage targetWidth:SCREEN_WIDTH * SCREEN_SCALE];
            } else if (photoImage.size.width > SCREEN_WIDTH) {
                targetImage = [CustomUtil compressImageForWidth:photoImage targetWidth:SCREEN_WIDTH];
            } else {
                targetImage = photoImage;
            }
            //压缩图像
            NSData *tempData = UIImageJPEGRepresentation(targetImage, compression);
            UIImage *tempImage = [UIImage imageWithData:tempData];
            while (([tempData length] > (200 * 1024)) && (compression > maxCompression)) {
                compression -= 0.01f;
                tempImage = [UIImage imageWithData:tempData];
            }

            photoData = tempData;
        }
        
        //计算压缩比率
        float xCompress = targetImage.size.width * 1.0f/orginPhotoWidth;
        float yCompress = targetImage.size.height * 1.0f/orginPhotoHeight;
        //调整标签坐标
        NSMutableArray *postionArray = nil;
        switch (i) {
            case 0:
            {
                postionArray = _photo1PositionArray;
            }
                break;
            case 1:
            {
                postionArray = _photo2PositionArray;
            }
                break;
            case 2:
            {
                postionArray = _photo3PositionArray;
            }
                break;
            case 3:
            {
                postionArray = _photo4PositionArray;
            }
                break;
            default:
                break;
        }
        
        if (postionArray.count > 0) {
            for (TouchPositionModel *model in postionArray) {
                model.changeHorizontal = [NSString stringWithFormat:@"%d", (int)([model.changeHorizontal intValue] * xCompress)];
                model.changeVertical = [NSString stringWithFormat:@"%d", (int)([model.changeVertical intValue] * yCompress)];
            }
        }
        
        NSString *createFileName = [representation.url.absoluteString substringWithRange:NSMakeRange(36, 36)];
        NSString *fileName = [self writeDataToBox:photoData fileName:createFileName];
        DLog(@"%llu", [[[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:nil] fileSize]);
        if (!fileName) {
            [CustomUtil showToastWithText:@"发布失败" view:self.view];
            [_publishBtn setEnabled:YES];
            return;
        }
        [photoDataNameArray addObject:fileName];
    }
    //发布前清空四幅图的沙盒地址
    [PublishStreetsnapInput shareInstance].photo1 = @"";
    [PublishStreetsnapInput shareInstance].photo2 = @"";
    [PublishStreetsnapInput shareInstance].photo3 = @"";
    [PublishStreetsnapInput shareInstance].photo4 = @"";
    if (photoDataNameArray.count > 0) {
        [PublishStreetsnapInput shareInstance].photo1 = [photoDataNameArray objectAtIndexCheck:0];
    }
    if (photoDataNameArray.count > 1) {
        [PublishStreetsnapInput shareInstance].photo2 = [photoDataNameArray objectAtIndexCheck:1];
    }
    if (photoDataNameArray.count > 2) {
        [PublishStreetsnapInput shareInstance].photo3 = [photoDataNameArray objectAtIndexCheck:2];
    }
    if (photoDataNameArray.count > 3) {
        [PublishStreetsnapInput shareInstance].photo4 = [photoDataNameArray objectAtIndexCheck:3];
    }
    if ([@"说点什么（140个字以内）" isEqualToString:_inputTextView.text]) {
        [PublishStreetsnapInput shareInstance].streetsnapContent = @"";
        _inputTextView.textColor = [UIColor blackColor];
    } else {
        [PublishStreetsnapInput shareInstance].streetsnapContent = _inputTextView.text;
        _inputTextView.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
    }
    [PublishStreetsnapInput shareInstance].userId = [LoginModel shareInstance].userId;
    if ([_positionLabel.text isEqualToString:@"位置"]) {
        [PublishStreetsnapInput shareInstance].publishPlace = @"";
        [PublishStreetsnapInput shareInstance].city = @"";
    } else {
        [PublishStreetsnapInput shareInstance].publishPlace = [TKPublishPosition shareInstance].positionName;
        [PublishStreetsnapInput shareInstance].city = [TKPublishPosition shareInstance].cityName;
    }
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[PublishStreetsnapInput shareInstance]];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:100 + i];
        if (button.selected) {
            [dict setValue:@(button.tag - 100 + 1) forKey:@"categoryType"] ;
            break;
        }
    }
    
    [[NetInterface shareInstance] publishStreetsnap:@"publishStreetsnap" param:dict successBlock:^(NSDictionary *responseDict) {
        [_publishBtn setEnabled:YES];
        
        PublishStreetsnap *returnData = [PublishStreetsnap modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            
            [CustomUtil showToast:[NSString stringWithFormat:@"%@", returnData.msg ? returnData.msg : @"发布成功"] view:self.view];
            //清空相机胶卷选中的图片
            DLog(@"%@", [self.navigationController viewControllers]);
            for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
                if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                    TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                    PublishStreetPhotoViewController *publishViewCtrl = [tabBarCtrl.viewControllers objectAtIndexCheck:2];
                    publishViewCtrl.photoIndex = 0;
                    [publishViewCtrl.imageViewArray removeAllObjects];
                    [publishViewCtrl.labelArray removeAllObjects];
                    [publishViewCtrl.selectPhotoArray removeAllObjects];
                }
            }
            streetsnapId = returnData.streetsnapId; //获取街拍Id
            //创建街拍与标签关系
            [self createPhotoAndLabelRelation:_photo1PositionArray photoNo:@"1" block:^{
                [self createPhotoAndLabelRelation:_photo2PositionArray photoNo:@"2" block:^{
                    [self createPhotoAndLabelRelation:_photo3PositionArray photoNo:@"3" block:^{            [self createPhotoAndLabelRelation:_photo4PositionArray photoNo:@"4" block:^{
                        
                        //                        StreetPhotoDetailViewController *detailViewCtrl = [[StreetPhotoDetailViewController alloc] initWithNibName:@"StreetPhotoDetailViewController" bundle:nil];
                        //                        //进入详情页面
                        //                        detailViewCtrl.intoFlag = YES;
                        //                        detailViewCtrl.streetsnapId = streetsnapId;
                        //                        [self.navigationController pushViewController:detailViewCtrl animated:YES];
                        
                        UIViewController *rootVC = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
                        
                        TabBarController *mainTabVC;
                        
                        for (id viewController in rootVC.childViewControllers) {
                            
                            if ([viewController isKindOfClass:[TabBarController class]]) {
                                
                                mainTabVC = (TabBarController *)viewController;
                            }
                        }
                        
                        //                        NSUInteger idx = 1;
                        //
                        //                        for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
                        //                            if ([NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:i] class]) isEqualToString:@"PublishStreetPhotoViewController"]) {
                        //                                idx = i;
                        //                                break;
                        //                            }
                        //                        }
                        
                        for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
                            if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                                TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                                int streetIntoFlag = tabBarCtrl.intoStreetFlag;
                                PublishStreetPhotoViewController *publishStreetPhotoViewCtrl = (PublishStreetPhotoViewController *)[tabBarCtrl.viewControllers objectAtIndexCheck:2];
                                [publishStreetPhotoViewCtrl.selectPhotoArray removeAllObjects];
                                [publishStreetPhotoViewCtrl.labelArray removeAllObjects];
                                publishStreetPhotoViewCtrl.photoIndex = 0;
                                [tabBarCtrl setSelectedIndex:streetIntoFlag];
                                [self.navigationController popToViewController:viewCtrl animated:YES];
                            }
                        }
                        
                        //                        [mainTabVC setSelectedIndex:mainTabVC.intoStreetFlag];
                        
                        //                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:idx]  animated:NO];
                        
                        NSString *string=[NSString stringWithFormat:@"streetsnapId=%@&place=%@&cityFlag=%@&current=%@&userId=%@&pagesize=%@&type=%@",streetsnapId, [GetStreetsnapListInput shareInstance].place, [GetStreetsnapListInput shareInstance].cityFlag, [GetStreetsnapListInput shareInstance].current, [GetStreetsnapListInput shareInstance].userId, [GetStreetsnapListInput shareInstance].pagesize, [GetStreetsnapListInput shareInstance].type];
                        
                        NSString *string2=[NSString stringWithFormat:@"%@%@%@%@",@"http://",NET_BASE_URL,@"/maoxj/views/html5page/details.html?",string];
                        new_url2=[string2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
//                        __block NSString *photo1Path = @"";
                        //查询街拍信息
                        [GetStreetsnapDetailInput shareInstance].streetsnapId = streetsnapId;
                        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapDetailInput shareInstance]];
                        [[NetInterface shareInstance] getStreetsnapDetail:@"getStreetsnapDetail" param:dict successBlock:^(NSDictionary *responseDict) {
                            GetStreetsnapDetail *returnData = [GetStreetsnapDetail modelWithDict:responseDict];
                            if (RETURN_SUCCESS(returnData.status)) {
                                StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:returnData.streetsnapInfo];
                                photo1Path = info.photo1;
                                if (weixinBtnFlag) {
                                    //发布至微信朋友圈
                                   //分享内容存入NSUserdefault
                                    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
                                    [userdefault setObject:@"publish" forKey:@"PublishVC"];
                                    [userdefault synchronize];
                                    [CustomUtil shareInstance].shareFlag=YES;//是否为分享
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
                                            message.description = _inputTextView.text;
                                            message.title = [NSString stringWithFormat:@"%@%@",[LoginModel shareInstance].userName,SHARE_TITLE];
                                            NSString *str=[NSString stringWithFormat:@"%@%@%@",@"http://",NET_BASE_URL,photo1Path];
                                            NSURL *url=[NSURL URLWithString:str];
                                            NSData *data=[NSData dataWithContentsOfURL:url];
                                            UIImage *orginalImage = [UIImage imageWithData:data];
                                            UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
                                            NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
                                            UIImage *finishImage = [UIImage imageWithData:targetImageData];
                                            [message setThumbImage:finishImage];
                                            WXWebpageObject *webPageExt = [WXWebpageObject object];
                                            webPageExt.webpageUrl = new_url2;
                                            message.mediaObject = webPageExt;
                                            req.message = message;
                                            req.scene = 1;          //发送至朋友圈
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
                                if (qzoneBtnFlag) {
                                    //发布至Qzone
                                    //                                    [CustomUtil qqLogin:YES personOrZone:NO inviteUser:NO imagePath:photo1Path shareContent:new_url];
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
                                if (weiboBtnFlag) {
                                    //发布至微博
                                    NSString *message=[NSString stringWithFormat:@"%@%@",@"毛线街－记录我的毛线·生活",new_url2];
                                    [CustomUtil sinaLogin:YES viewCtrl:@"StreetPhotoDetailViewController" personOrZone:NO inviteUser:NO imagePath:photo1Path shareContent:message];
                                }
                            } else {
                                [CustomUtil showToastWithText:returnData.msg view:kWindow];
                            }
                        } failedBlock:^(NSError *err) {
                        }];
                    }];
                    }];
                }];
            }];
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
        [_publishBtn setEnabled:YES];
    }];
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
                            message.description = _inputTextView.text;
                            message.title = [NSString stringWithFormat:@"%@%@",[LoginModel shareInstance].userName,SHARE_TITLE];
                            NSString *str=[NSString stringWithFormat:@"%@%@%@",@"http://",NET_BASE_URL,photo1Path];
                            NSURL *url=[NSURL URLWithString:str];
                            NSData *data=[NSData dataWithContentsOfURL:url];
                            UIImage *orginalImage = [UIImage imageWithData:data];
                            UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
                            NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
                            UIImage *finishImage = [UIImage imageWithData:targetImageData];
                            [message setThumbImage:finishImage];
                            WXWebpageObject *webPageExt = [WXWebpageObject object];
                            webPageExt.webpageUrl = new_url2;
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
            }
        } else {
            //[CustomUtil showToastWithText:@"授权失败" view:kWindow];
        }
    }
}


//获取用户信息代理
-(void)getUserInfoResponse:(APIResponse *)response{
    if (response.retCode == URLREQUEST_SUCCEED) {
        NSDictionary *dict = response.jsonResponse;
        DLog(@"dict = %@", dict);
        //分享QQ
        NSString *string=[NSString stringWithFormat:@"streetsnapId=%@&place=%@&cityFlag=%@&current=%@&userId=%@&pagesize=%@&type=%@",streetsnapId, [GetStreetsnapListInput shareInstance].place, [GetStreetsnapListInput shareInstance].cityFlag, [GetStreetsnapListInput shareInstance].current, [GetStreetsnapListInput shareInstance].userId, [GetStreetsnapListInput shareInstance].pagesize, [GetStreetsnapListInput shareInstance].type];
        
        NSString *string2=[NSString stringWithFormat:@"%@%@%@%@",@"http://",NET_BASE_URL,@"/maoxj/views/html5page/details.html?",string];
        new_url2=[string2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //QZone分享
        UIImage *orginalImage = _firstImageView.image;
        UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
        NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:new_url2]
                                    title:[NSString stringWithFormat:@"%@%@", [LoginModel shareInstance].userName,SHARE_TITLE]
                                    description:_inputTextView.text
                                    previewImageData:targetImageData];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
        if (EQQAPISENDSUCESS == sent) {
            //                [CustomUtil showToastWithText:@"分享成功" view:kWindow];
        }
        else {
            //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
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

//添加照片按钮点击事件
- (IBAction)plusBtnClick:(id)sender {
    //进入手机相册页面
    PublishStreetPhotoViewController *publishStreetPhotoViewCtrl  = [[PublishStreetPhotoViewController alloc] initWithNibName:@"PublishStreetPhotoViewController" bundle:nil];
    publishStreetPhotoViewCtrl.intoFlag = 0;
    publishStreetPhotoViewCtrl.selectPhotoArray = [_allPhotoArray mutableCopy];
    publishStreetPhotoViewCtrl.photo1LabelArray = [NSMutableArray arrayWithArray:_photo1PositionArray];
    publishStreetPhotoViewCtrl.photo2LabelArray = [NSMutableArray arrayWithArray:_photo2PositionArray];
    publishStreetPhotoViewCtrl.photo3LabelArray = [NSMutableArray arrayWithArray:_photo3PositionArray];
    publishStreetPhotoViewCtrl.photo4LabelArray = [NSMutableArray arrayWithArray:_photo4PositionArray];
    publishStreetPhotoViewCtrl.photoIndex = [publishStreetPhotoViewCtrl.selectPhotoArray count];
    for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
        if ([viewCtrl isKindOfClass:[TabBarController class]]) {
            TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
            PublishStreetPhotoViewController *streetPhotoViewCtrl = [[tabBarCtrl viewControllers] objectAtIndexCheck:2];
            publishStreetPhotoViewCtrl.labelArray = streetPhotoViewCtrl.labelArray;
        }
    }
    [self.navigationController pushViewController:publishStreetPhotoViewCtrl animated:YES];
}

//位置设置Cell点击事件
-(void)positionClick:(id)sender
{
    PositionSetViewController *positionSetViewCtrl = [[PositionSetViewController alloc] initWithNibName:@"PositionSetViewController" bundle:nil];
    [self.navigationController pushViewController:positionSetViewCtrl animated:YES];
}

//小图片点击事件
-(void)minImageViewClick:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    CGFloat imageX = gesture.view.frame.origin.x;
    int index = 0;
    if (imageX <= SCREEN_WIDTH/4) {
        index = 0;
    } else if (imageX <= SCREEN_WIDTH/2) {
        index = 1;
    } else if (imageX <= SCREEN_WIDTH/4*3) {
        index = 2;
    } else {
        index = 3;
    }
    EditPhotoViewController *viewCtrl = [[EditPhotoViewController alloc] initWithNibName:@"EditPhotoViewController" bundle:nil];
    viewCtrl.intoFlag = NO;
    viewCtrl.editImageArray = _allPhotoArray;
    viewCtrl.photo1LabelCoordinateArray = _photo1PositionArray;
    viewCtrl.photo2LabelCoordinateArray = _photo2PositionArray;
    viewCtrl.photo3LabelCoordinateArray = _photo3PositionArray;
    viewCtrl.photo4LabelCoordinateArray = _photo4PositionArray;
    viewCtrl.selectImageFlag = index; //当前选中的图片
    [self.navigationController pushViewController:viewCtrl animated:YES];
    /*
     for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
     if ([viewCtrl isKindOfClass:[EditPhotoViewController class]]) {
     ((EditPhotoViewController *)viewCtrl).intoFlag = NO;
     [self.navigationController popToViewController:viewCtrl animated:YES];
     }
     }
     */
}

//删除按钮点击事件
-(void)delBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [_allPhotoArray removeObjectAtIndex:(button.tag - 1)];
    PublishStreetPhotoViewController *streetPhotoViewCtrl;
    for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
        if ([viewCtrl isKindOfClass:[TabBarController class]]) {
            TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
            streetPhotoViewCtrl = [[tabBarCtrl viewControllers] objectAtIndexCheck:2];
        }
    }
    switch (button.tag) {
        case 1:
        {
            [_photo1PositionArray removeAllObjects];
        }
            break;
        case 2:
        {
            [_photo2PositionArray removeAllObjects];
        }
            break;
        case 3:
        {
            [_photo3PositionArray removeAllObjects];
        }
            break;
        case 4:
        {
            [_photo4PositionArray removeAllObjects];
            
        }
            break;
        default:
            break;
    }
    [self setImageViewAndBtnPosition]; //调整按钮位置
    [streetPhotoViewCtrl.labelArray removeObjectAtIndex:(button.tag - 1)];
    //调整标签数字
    //调整图片下标显示数字
    for (MyLabel *label in streetPhotoViewCtrl.labelArray) {
        if ((label.labelNum > 1) &&
            (label.labelNum > button.tag)) {
            [label setText:[NSString stringWithFormat:@"%ld", label.labelNum - 1]];
            label.labelNum--;
        }
    }
}

//微信朋友圈按钮点击事件
- (IBAction)weixinBtnClick:(id)sender {
    
    weixinBtnFlag = !weixinBtnFlag;
    //刷新按钮图片
    if (weixinBtnFlag) {
        [_weixinBtn setBackgroundImage:[UIImage imageNamed:@"weixin7_3_2"] forState:UIControlStateNormal];
    } else {
        [_weixinBtn setBackgroundImage:[UIImage imageNamed:@"weixin7_3"] forState:UIControlStateNormal];
    }
}

//QZone按钮点击事件
- (IBAction)qZoneBtnClick:(id)sender {
    qzoneBtnFlag = !qzoneBtnFlag;
    if (qzoneBtnFlag) {
        [_qZoneBtn setBackgroundImage:[UIImage imageNamed:@"pengyq7_3_2"] forState:UIControlStateNormal];
    } else {
        [_qZoneBtn setBackgroundImage:[UIImage imageNamed:@"pengyq7_3"] forState:UIControlStateNormal];
    }
}

//微博按钮点击事件
- (IBAction)weiboBtnClick:(id)sender {
    weiboBtnFlag = !weiboBtnFlag;
    if (weiboBtnFlag) {
        [_weiboBtn setBackgroundImage:[UIImage imageNamed:@"weibo7_3_2"] forState:UIControlStateNormal];
    } else {
        [_weiboBtn setBackgroundImage:[UIImage imageNamed:@"weibo7_3"] forState:UIControlStateNormal];
    }
}

#pragma mark -共通方法
//设置图片及按钮位置
-(void)setImageViewAndBtnPosition
{
    int imageOffsetX = 0;
    imageOffsetX = (int)((SCREEN_WIDTH - _firstImageView.frame.size.width * 4)/5);
    ALAsset *asset = nil;
    if (0 == _allPhotoArray.count) {
        [_firstImageView setHidden:YES];
        [_secondeImageView setHidden:YES];
        [_thirdImageView setHidden:YES];
        [forthImageView setHidden:YES];
        [_firstDelBtn setHidden:YES];
        [_secondeDelBtn setHidden:YES];
        [_thirdDelBtn setHidden:YES];
        [forthDelBtn setHidden:YES];
        CGRect rect = _firstImageView.frame;
        [_addBtn setHidden:NO];
        _addBtn.frame = rect;
    } else if (1 == _allPhotoArray.count) {
        //调整照片布局
        CGRect rect = _firstImageView.frame;
        rect.origin.x = imageOffsetX;
        _firstImageView.frame = rect;
        rect = _secondeImageView.frame;
        rect.origin.x = imageOffsetX * 2 + _firstImageView.frame.size.width;
        _addBtn.frame = rect;
        [_secondeImageView setHidden:YES];
        [_thirdImageView setHidden:YES];
        [forthImageView setHidden:YES];
        
        rect = _firstDelBtn.frame;
        rect.origin.x = imageOffsetX + (_firstImageView.frame.size.width - (int)(_firstDelBtn.frame.size.width/2));
        _firstDelBtn.frame = rect;
        [_secondeDelBtn setHidden:YES];
        [_thirdDelBtn setHidden:YES];
        [forthDelBtn setHidden:YES];
        UITapGestureRecognizer *guesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [_firstImageView setUserInteractionEnabled:YES];
        [_firstImageView addGestureRecognizer:guesture1];
        
        asset = [_allPhotoArray objectAtIndexCheck:0];
        _firstImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        _firstDelBtn.tag = 1;
        [_firstDelBtn setHidden:NO];
        [_firstImageView setHidden:NO];
        [_addBtn setHidden:NO];
    } else if (2 == _allPhotoArray.count) {
        CGRect rect = _firstImageView.frame;
        rect.origin.x = imageOffsetX;
        _firstImageView.frame = rect;
        rect = _secondeImageView.frame;
        rect.origin.x = imageOffsetX * 2 + _firstImageView.frame.size.width;
        _secondeImageView.frame = rect;
        rect = _thirdImageView.frame;
        rect.origin.x = imageOffsetX * 3 + _firstImageView.frame.size.width * 2;
        _thirdImageView.frame = rect;
        _addBtn.frame = rect;
        [_thirdImageView setHidden:YES];
        [_thirdDelBtn setHidden:YES];
        [forthImageView setHidden:YES];
        [forthDelBtn setHidden:YES];
        
        rect = _firstDelBtn.frame;
        rect.origin.x = imageOffsetX + (_firstImageView.frame.size.width - (int)(_firstDelBtn.frame.size.width/2));
        _firstDelBtn.frame = rect;
        rect = _secondeDelBtn.frame;
        rect.origin.x = _firstDelBtn.frame.origin.x + imageOffsetX + _firstImageView.frame.size.width;
        _secondeDelBtn.frame = rect;
        
        UITapGestureRecognizer *guesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [_firstImageView setUserInteractionEnabled:YES];
        [_firstImageView addGestureRecognizer:guesture1];
        UITapGestureRecognizer *guesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [_secondeImageView setUserInteractionEnabled:YES];
        [_secondeImageView addGestureRecognizer:guesture2];
        
        asset = [_allPhotoArray objectAtIndexCheck:0];
        _firstImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        asset = [_allPhotoArray objectAtIndexCheck:1];
        _secondeImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        
        _firstDelBtn.tag = 1;
        _secondeDelBtn.tag = 2;
        [_firstImageView setHidden:NO];
        [_firstDelBtn setHidden:NO];
        [_secondeDelBtn setHidden:NO];
        [_secondeImageView setHidden:NO];
        [_addBtn setHidden:NO];
    } else if (3 == _allPhotoArray.count) {
        //调整照片布局
        CGRect rect = _firstImageView.frame;
        rect.origin.x = imageOffsetX;
        _firstImageView.frame = rect;
        rect = _secondeImageView.frame;
        rect.origin.x = imageOffsetX * 2 + _firstImageView.frame.size.width;
        _secondeImageView.frame = rect;
        rect = _thirdImageView.frame;
        rect.origin.x = imageOffsetX * 3 + _firstImageView.frame.size.width * 2;
        _thirdImageView.frame = rect;
        
        rect = _firstDelBtn.frame;
        rect.origin.x = imageOffsetX + (_firstImageView.frame.size.width - (int)(_firstDelBtn.frame.size.width/2));
        _firstDelBtn.frame = rect;
        rect = _secondeDelBtn.frame;
        rect.origin.x = _firstDelBtn.frame.origin.x + imageOffsetX + _firstImageView.frame.size.width;
        _secondeDelBtn.frame = rect;
        rect = _thirdDelBtn.frame;
        rect.origin.x = _secondeDelBtn.frame.origin.x + imageOffsetX + _firstImageView.frame.size.width;
        _thirdDelBtn.frame =rect;
        
        rect = _addBtn.frame;
        rect.origin.x = imageOffsetX * 4 + _firstImageView.frame.size.width * 3;
        _addBtn.frame = rect;
        
        UITapGestureRecognizer *guesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [_firstImageView setUserInteractionEnabled:YES];
        [_firstImageView addGestureRecognizer:guesture1];
        UITapGestureRecognizer *guesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [_secondeImageView setUserInteractionEnabled:YES];
        [_secondeImageView addGestureRecognizer:guesture2];
        UITapGestureRecognizer *guesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [_thirdImageView setUserInteractionEnabled:YES];
        [_thirdImageView addGestureRecognizer:guesture3];
        
        asset = [_allPhotoArray objectAtIndexCheck:0];
        _firstImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        asset = [_allPhotoArray objectAtIndexCheck:1];
        _secondeImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        asset = [_allPhotoArray objectAtIndexCheck:2];
        _thirdImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        
        _firstDelBtn.tag = 1;
        _secondeDelBtn.tag = 2;
        _thirdDelBtn.tag = 3;
        
        [forthDelBtn setHidden:YES];
        [forthImageView setHidden:YES];
        [_firstImageView setHidden:NO];
        [_secondeImageView setHidden:NO];
        [_thirdImageView setHidden:NO];
        [_firstDelBtn setHidden:NO];
        [_secondeDelBtn setHidden:NO];
        [_thirdDelBtn setHidden:NO];
        [_addBtn setHidden:NO];
    } else if (4 == _allPhotoArray.count) {
        CGRect rect = _firstImageView.frame;
        rect.origin.x = imageOffsetX;
        _firstImageView.frame = rect;
        
        rect = _secondeImageView.frame;
        rect.origin.x = imageOffsetX * 2 + _firstImageView.frame.size.width;
        _secondeImageView.frame = rect;
        
        rect = _thirdImageView.frame;
        rect.origin.x = imageOffsetX * 3 + _firstImageView.frame.size.width * 2;
        _thirdImageView.frame = rect;
        
        if (!forthImageView) {
            forthImageView = [[EGOImageView alloc] init];
            [self.view addSubview:forthImageView];
        }
        rect = _thirdImageView.frame;
        rect.origin.x = imageOffsetX + rect.size.width + rect.origin.x;
        rect.origin.y = _thirdImageView.frame.origin.y;
        forthImageView.frame = rect;
        
        rect = _firstDelBtn.frame;
        rect.origin.x = imageOffsetX + (_firstImageView.frame.size.width - (int)(_firstDelBtn.frame.size.width/2));
        _firstDelBtn.frame = rect;
        
        rect = _secondeDelBtn.frame;
        rect.origin.x = _firstDelBtn.frame.origin.x + imageOffsetX + _firstImageView.frame.size.width;
        _secondeDelBtn.frame = rect;
        
        rect = _thirdDelBtn.frame;
        rect.origin.x = _secondeDelBtn.frame.origin.x + imageOffsetX + _firstImageView.frame.size.width;
        _thirdDelBtn.frame =rect;
        
        if(!forthDelBtn) {
            forthDelBtn = [[UIButton alloc] init];
            rect.origin.x = _thirdDelBtn.frame.origin.x + imageOffsetX + _firstImageView.frame.size.width;
            forthDelBtn.frame = rect;
            [forthDelBtn setBackgroundImage:[UIImage imageNamed:@"delete7_3"] forState:UIControlStateNormal];
            [self.view addSubview:forthDelBtn];
        }
        [forthDelBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setHidden:YES];
        
        UITapGestureRecognizer *guesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [_firstImageView setUserInteractionEnabled:YES];
        [_firstImageView addGestureRecognizer:guesture1];
        UITapGestureRecognizer *guesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [_secondeImageView setUserInteractionEnabled:YES];
        [_secondeImageView addGestureRecognizer:guesture2];
        UITapGestureRecognizer *guesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [_thirdImageView setUserInteractionEnabled:YES];
        [_thirdImageView addGestureRecognizer:guesture3];
        UITapGestureRecognizer *guesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minImageViewClick:)];
        [forthImageView setUserInteractionEnabled:YES];
        [forthImageView addGestureRecognizer:guesture4];
        
        asset = [_allPhotoArray objectAtIndexCheck:0];
        _firstImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        asset = [_allPhotoArray objectAtIndexCheck:1];
        _secondeImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        asset = [_allPhotoArray objectAtIndexCheck:2];
        _thirdImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        asset = [_allPhotoArray objectAtIndexCheck:3];
        forthImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
        
        _firstDelBtn.tag = 1;
        _secondeDelBtn.tag = 2;
        _thirdDelBtn.tag = 3;
        forthDelBtn.tag = 4;
        
        [_firstImageView setHidden:NO];
        [_secondeImageView setHidden:NO];
        [_thirdImageView setHidden:NO];
        [forthImageView setHidden:NO];
        [_firstDelBtn setHidden:NO];
        [_secondeDelBtn setHidden:NO];
        [_thirdDelBtn setHidden:NO];
        [forthDelBtn setHidden:NO];
    }
    [_firstDelBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_secondeDelBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_thirdDelBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

//将NSData数据写入沙盒
-(NSString *)writeDataToBox:(NSData *)writeData fileName:(NSString *)fileName
{
    NSString *tmpDir = NSTemporaryDirectory();
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@photo", tmpDir]]) {  //目录不存在
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@photo", tmpDir] withIntermediateDirectories:YES attributes:nil error:nil]; //创建文件夹
    }
    
    BOOL result = [writeData writeToFile:[NSString stringWithFormat:@"%@photo/%@.jpg", tmpDir, fileName] atomically:YES];
    if (!result) {
        [CustomUtil showToastWithText:@"图片保存失败" view:self.view];
        return nil;
    } else {
        return [NSString stringWithFormat:@"%@photo/%@.jpg", tmpDir, fileName];
    }
}

//创建街拍与标签关系
-(void)createPhotoAndLabelRelation:(NSMutableArray *)positionArray photoNo:(NSString *)photoNo block:(void(^)())block
{
    TouchPositionModel *model = nil;
    for (int i=0; i<positionArray.count; i++) {
        model = [positionArray objectAtIndexCheck:i];
        //创建街拍标签关系
        AddStreetsnapTagInput *input = [[AddStreetsnapTagInput alloc] initWithNull];
        input.streetsnapId = streetsnapId;
        input.tagId = model.tagId;
        input.photoNo = photoNo;
        input.horizontal = model.changeHorizontal;
        input.vertical = model.changeVertical;
        input.link = model.link;
        NSMutableDictionary *tagDict = [CustomUtil modelToDictionary:input];
        [[NetInterface shareInstance] addStreetsnapTag:@"addStreetsnapTag" param:tagDict successBlock:^(NSDictionary *responseDict) {
            AddStreetsnapTag *returnData = [AddStreetsnapTag modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
            } else {
                [CustomUtil showToastWithText:returnData.msg view:self.view];
            }
        } failedBlock:^(NSError *err) {
        }];
    }
    block();
}

@end

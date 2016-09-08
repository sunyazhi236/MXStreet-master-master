//
//  PhotoDetailViewController.m
//  mxj
//  P7-4-1照片详情
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "LabelDetailViewController.h"

@interface PhotoDetailViewController ()
{
    int photoCount;  //图片数量
    CGFloat offset;
}
@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;

    [self.navigationItem setTitle:@"照片详情"];
    
    _pageBackImage.hidden = YES;
    _currentPageNum.hidden = YES;
    _totalPageNum.hidden = YES;
    _spliteText.hidden = YES;
    
    offset = 0.0;
    
    //设置背景图尺寸
    CGRect rect = _backImageView.frame;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    _backImageView.frame = rect;
    
    //if (![TKLoginType shareInstance].loginType) {
      //  [_zanBtn setEnabled:NO];
       // [_downLoadBtn setEnabled:NO];
    //}
    
    StreetsnapInfo *snapInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    photoCount = 0;
    if (![CustomUtil CheckParam:snapInfo.photo1]) {
        photoCount++;
    }
    if (![CustomUtil CheckParam:snapInfo.photo2]) {
        photoCount++;
    }
    if (![CustomUtil CheckParam:snapInfo.photo3]) {
        photoCount++;
    }
    if (![CustomUtil CheckParam:snapInfo.photo4]) {
        photoCount++;
    }
//    _totalPageNum.text = [NSString stringWithFormat:@"%d", photoCount];
    
    self.title = [NSString stringWithFormat:@"%d/%d", (int)(fabs(_phontoDetailScrollView.contentOffset.x/SCREEN_WIDTH)) + 1, photoCount];

    //设置页面控件的位置
//    CGRect customFrame = _currentPageNum.frame;
//    customFrame.origin.y = SCREEN_HEIGHT - 64 - 79;
//    customFrame.origin.x = SCREEN_WIDTH - 27 - 10;
//    _currentPageNum.frame = customFrame;
//    
//    customFrame = _totalPageNum.frame;
//    customFrame.origin.y = SCREEN_HEIGHT - 64 - 78;
//    customFrame.origin.x = SCREEN_WIDTH - 12 - 8;
//    _totalPageNum.frame = customFrame;
//    
//    customFrame = _spliteText.frame;
//    customFrame.origin.y = SCREEN_HEIGHT - 64 - 80;
//    customFrame.origin.x = SCREEN_WIDTH - 18 - 8;
//    _spliteText.frame = customFrame;
//    
//    customFrame = _pageBackImage.frame;
//    customFrame.origin.y = SCREEN_HEIGHT -64 - 84;
//    customFrame.origin.x = SCREEN_WIDTH - 8 -32;
//    _pageBackImage.frame = customFrame;
    
    CGRect customFrame = _zanBtn.frame;
    customFrame.origin.y = SCREEN_HEIGHT - 32;
    customFrame.origin.x = SCREEN_WIDTH - 8 - 23;
    customFrame.size.width = _downLoadBtn.frame.size.width;
    customFrame.size.height = _downLoadBtn.frame.size.height;
    _zanBtn.frame = customFrame;
    
    if ([snapInfo.praiseFlag isEqualToString:@"0"]) { //未赞
        [_zanBtn setBackgroundImage:[UIImage imageNamed:@"zan7-4-1"] forState:UIControlStateNormal];
    } else if ([snapInfo.praiseFlag isEqualToString:@"1"]) { //已赞
        [_zanBtn setBackgroundImage:[UIImage imageNamed:@"zan02-7-4"] forState:UIControlStateNormal];
    }
    
    customFrame = _downLoadBtn.frame;
    customFrame.origin.y = SCREEN_HEIGHT - 32;
    _downLoadBtn.frame = customFrame;
    
    customFrame = _footImage.frame;
    customFrame.origin.y = SCREEN_HEIGHT - 44;
    customFrame.size.width = SCREEN_WIDTH;
    _footImage.frame = customFrame;
    
    _phontoDetailScrollView.delegate = self;
    //设置最大伸缩比例
    [_phontoDetailScrollView setMaximumZoomScale:2.0f];
    //设置最小伸缩比例
    [_phontoDetailScrollView setMinimumZoomScale:0.5f];
    _phontoDetailScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_phontoDetailScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*photoCount, SCREEN_HEIGHT)];
    for (int i=0; i<photoCount; i++) {
       // UIImage *preImage =[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[CustomUtil getPhotoURL:[((NSDictionary *)_streetsnapInfo) objectForKey:[NSString stringWithFormat:@"photo%d", (i+1)]]]]];
       // CGSize imageSize = preImage.size;
//        EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, ((SCREEN_HEIGHT - 64 - SCREEN_WIDTH - 64)/2), SCREEN_WIDTH, SCREEN_WIDTH)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        [s setZoomScale:1.0];
        
        EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.tag = i+1;
        
        [imageView setAutoresizesSubviews:NO];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        imageView.imageURL = [CustomUtil getPhotoURL:[((NSDictionary *)_streetsnapInfo) objectForKey:[NSString stringWithFormat:@"photo%d", (i+1)]]];
        [imageView setUserInteractionEnabled:YES];
        //获取原图的宽高
        int orginWidth = [[((NSDictionary *)_streetsnapInfo) objectForKey:[NSString stringWithFormat:@"width%d", (i+1)]] intValue];
        int orginHeight = [[((NSDictionary *)_streetsnapInfo) objectForKey:[NSString stringWithFormat:@"height%d", (i+1)]] floatValue];
        //根据图片大小获取imageView的尺寸(像素尺寸）
        CGFloat imageViewWidth = imageView.frame.size.width;
        CGFloat imageViewHeight = imageView.frame.size.height;
        CGFloat viewWidth = imageViewWidth;    //压缩后的imageView宽度
        CGFloat viewHeight = imageViewHeight;  //压缩后的imageView高度
        //if (orginWidth > viewWidth) {
            viewWidth = imageViewWidth;
            viewHeight = orginHeight * 1.0f/orginWidth * viewWidth;
        //} //else if(orginWidth < viewWidth) {
            //viewWidth = orginWidth;
            //viewHeight = orginHeight * 1.0f/orginWidth * viewWidth;
        //}
        
        if (viewHeight > imageViewHeight) {
            viewWidth = imageViewHeight * 1.0f/(viewHeight * 1.0f/viewWidth);
            viewHeight = imageViewHeight;
        }
        //调整imageView位置
        float imageViewOffsetX = (imageView.frame.size.width - viewWidth)/2.0f;
        float imageViewOffsetY = (imageView.frame.size.height - viewHeight)/2.0f;
        UIView *viewMask = [[UIView alloc] initWithFrame:CGRectMake(imageViewOffsetX, imageViewOffsetY, viewWidth, viewHeight)];
        [viewMask setBackgroundColor:[UIColor clearColor]];
        [imageView addSubview:viewMask];
        //设置标签
        for (int j=0; j<_tagInfoArray.count; j++) {
            NSDictionary *infoDict = [_tagInfoArray objectAtIndexCheck:j];
            TagInfo *info = [[TagInfo alloc] initWithDict:infoDict];
            if ([info.photoNo isEqualToString:[NSString stringWithFormat:@"%d", (i+1)]]) {
                float xPostion = [info.horizontal floatValue];
                float yPostion = [info.vertical floatValue];
                //获取标签文本尺寸
                CGSize labelTextSize = [info.tagName sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                //判断标签是否超出显示区域，超出时进行微调
                float labelX = xPostion * (viewWidth/orginWidth);
                float labelY = yPostion * (viewHeight/orginHeight);

                UIImage *backImage = [UIImage imageNamed:@"黑点"];
                
                UIImageView *backView = [[UIImageView alloc] init];
                backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
                backView.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
                backView.layer.cornerRadius = backImage.size.width / 2;
                backView.layer.masksToBounds = YES;
                [viewMask addSubview:backView];
                
                UIImage *redImage = [UIImage imageNamed:@"红点-单独"];
                
                UIImageView *labelPointImageView = [[UIImageView alloc] initWithImage:redImage];

                //添加小红点
//                UIImageView *labelPointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yuan_8"]];
                if (labelX > (viewMask.frame.size.width - 4.5)) {
                    labelX = viewMask.frame.size.width - 4.5;
                }
                if (labelY > (viewMask.frame.size.height - 25 / 2)) {
                    labelY = viewMask.frame.size.height - 25 / 2;
                }
                if (labelY < 25/2.0f) { //上部超出，移动标签
                    labelY = 25/2.0f;
                }
                CGRect rect = labelPointImageView.frame;
                rect.size.width = 9;
                rect.size.height = 9;
                labelPointImageView.frame = rect;
                [labelPointImageView setCenter:CGPointMake(labelX, labelY)];
                backView.center = labelPointImageView.center;
                [viewMask addSubview:labelPointImageView];
                
                //调整label的位置
                float labelXPostion = labelX + 8;
                float labelYPostion = labelY - 25/2.0f;
                
                if (labelX > (viewMask.frame.size.width - labelPointImageView.frame.size.width - 8 - labelTextSize.width - 30)) { //右侧超出，将标签显示在左侧
                    labelXPostion = labelX - 8 - labelTextSize.width - 30;
                }
                if (labelY < 25/2.0f) { //上部超出，移动标签
                    labelYPostion = 25/2.0f;
                }
                if (labelY > (viewMask.frame.size.height - 25/2.0f)) { //下部超出，移动标签
                    labelYPostion = viewMask.frame.size.height - 25;
                }

                UIButton *labelButton = [[UIButton alloc] initWithFrame:CGRectMake(labelXPostion, labelYPostion, labelTextSize.width + 30, 25)];
                [labelButton setTintColor:[UIColor whiteColor]];
                [labelButton setTitle:info.tagName forState:UIControlStateNormal];
//                UIImage *buttonBackImage = [UIImage imageNamed:@"rabel7-4-1"];
                UIImage *buttonBackImage = [UIImage imageNamed:@"标签-通用"];
                /*
                 if ([CustomUtil CheckParam:info.link]) {
                 buttonBackImage = [UIImage imageNamed:@"标签-通用"];
                 [labelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                 }
                 else {
                 buttonBackImage = [UIImage imageNamed:@"链接-通用"];
                 [labelButton setTitleColor:RGB(21, 161, 173, 1) forState:UIControlStateNormal];
                 [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
                 }
                 */
                if ([CustomUtil CheckParam:info.link]) {
                    //                                [backView.layer removeAllAnimations];
                }
                else {
                    [self shakeToShow:backView];
                }
                
                [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];

                UIEdgeInsets insets = UIEdgeInsetsMake(0, 30, 0, 5);

                if (labelX > (viewMask.frame.size.width - labelPointImageView.frame.size.width - 8 - labelTextSize.width - 30)) { //右侧超出，将标签显示在左侧
                    
                    buttonBackImage = [CustomUtil image:buttonBackImage rotation:UIImageOrientationDown];
                    
                    [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
                    
                    insets = UIEdgeInsetsMake(0, 5, 0, 30);
                }
                
                buttonBackImage = [buttonBackImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
                [labelButton setBackgroundImage:buttonBackImage forState:UIControlStateNormal];
                
                [labelButton addTarget:self action:@selector(labelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                labelButton.tag = j;
                [labelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
//                [labelButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
                [labelButton setTitle:info.tagName forState:UIControlStateNormal];
                [viewMask addSubview:labelButton];
            }
        }
        //添加图片的缩放控制
        [imageView setMultipleTouchEnabled:YES];
        [imageView addGestureRecognizer:doubleTap];
        [s addSubview:imageView];
        [_phontoDetailScrollView addSubview:s];
    }
    [_phontoDetailScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*_currentPageIndex, 0) animated:NO];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  = 1;
    [_phontoDetailScrollView addGestureRecognizer:singleTapGesture];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:[[UIColor redColor] colorWithAlphaComponent:0]] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//用于去除导航栏的底线
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:nil];//用于显示导航栏的底线
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.title = [NSString stringWithFormat:@"%d/%d", (int)(fabs(_phontoDetailScrollView.contentOffset.x/SCREEN_WIDTH)) + 1, photoCount];
    
    _currentPageNum.text = [NSString stringWithFormat:@"%d", (int)(fabs(_phontoDetailScrollView.contentOffset.x/SCREEN_WIDTH)) + 1];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    DLog(@"%@", scrollView);
    for (UIView *v in scrollView.subviews){
        for (UIView *t in v.subviews) {
            if (scrollView.zoomScale != 1.0f) {
                [t setHidden:YES];
            } else {
                [t setHidden:NO];
            }
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _phontoDetailScrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x == offset){
        } else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                }
            }
        }
    }
}

-(void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark - custommethod
- (void)shakeToShow:(UIView *)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.7;
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:0];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

#pragma mark -按钮点击
//标签按钮点击事件
-(void)labelBtnClick:(UIButton *)sender
{
    NSDictionary *dict = [_tagInfoArray objectAtIndexCheck:sender.tag];
    TagInfo *info = [[TagInfo alloc] initWithDict:dict];
    if ([CustomUtil CheckParam:info.link]) {
        LabelDetailViewController *viewCtrl = [[LabelDetailViewController alloc] init];
        viewCtrl.tagId = info.tagId;
        viewCtrl.tagName = info.tagName;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    } else {
        NSString *urlAddress = @"";
        if ((info.link.length > 7) && [[info.link substringToIndex:7] isEqualToString:@"http://"]) {
            urlAddress = info.link;
        } else if ((info.link.length > 8) && [[info.link substringToIndex:8] isEqualToString:@"https://"]) {
            urlAddress = info.link;
        } else {
            urlAddress = [NSString stringWithFormat:@"http://%@", info.link];
        }
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress]]) {
            [CustomUtil showToastWithText:@"无效的网址" view:kWindow];
        }
    }
}

//下载按钮点击事件
- (IBAction)downLoadBtnClick:(id)sender {
    //获取当前显示图片的下标
    int currentPhotoIndex = [_currentPageNum.text intValue];
    //判断是否已经下载过
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *downLoadListPath = [path stringByAppendingPathComponent:@"downloadList.plist"];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if (![fileManager fileExistsAtPath:downLoadListPath]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict writeToFile:downLoadListPath atomically:YES];
    }
    NSMutableDictionary *plistContentDic = [[NSMutableDictionary alloc] initWithContentsOfFile:downLoadListPath];
    NSString *imageFileStr = [((NSDictionary *)_streetsnapInfo) objectForKey:[NSString stringWithFormat:@"photo%d", currentPhotoIndex]];
    //判断是否文件中已有记录
    for (NSString *imagePath in [plistContentDic allValues]) {
        if ([imagePath isEqualToString:imageFileStr]) {
            [CustomUtil showToastWithText:@"已下载过" view:kWindow];
            return;
        }
    }
    
    //下载至相册
    NSURL *url = [CustomUtil getPhotoURL:[((NSDictionary *)_streetsnapInfo) objectForKey:[NSString stringWithFormat:@"photo%d", currentPhotoIndex]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            DLog(@"%@", connectionError.description);
        } else {
            NSMutableData *imageData =[[NSMutableData alloc] init];
            //清空图片数据
            [imageData setLength:0];
            NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
            float imageLenth = [[resp.allHeaderFields objectForKey:@"Content-Length"] floatValue];
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [imageData appendData:data];
            UIImage *image = [UIImage imageWithData:imageData];
            //保存至本地相册
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotoAlbum:didFinishSavingWithError:contextInfo:), nil);
            [plistContentDic setObject:imageFileStr forKey:[NSString stringWithFormat:@"photo%d", plistContentDic.count]];
            [plistContentDic writeToFile:downLoadListPath atomically:YES];
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

- (void)imageSavedToPhotoAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = @"";
    if (!error) {
        msg = @"保存相册成功";
    } else {
        msg = [error localizedDescription];
    }
    DLog(@"%@", msg);
    [CustomUtil showToastWithText:msg view:kWindow];
}

//赞按钮点击事件
- (IBAction)zanBtnClick:(id)sender {
    StreetsnapInfo *snapInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    
    [PublishPraiseInput shareInstance].streetsnapId = snapInfo.streetsnapId;
    [PublishPraiseInput shareInstance].streetsnapUserId = snapInfo.userId;
    [PublishPraiseInput shareInstance].userId = [LoginModel shareInstance].userId;
    [PublishPraiseInput shareInstance].flag = snapInfo.praiseFlag;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[PublishPraiseInput shareInstance]];
    [[NetInterface shareInstance] publishPraise:@"publishPraise" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            //重新获取街拍信息
            [GetStreetsnapDetailInput shareInstance].streetsnapId = snapInfo.streetsnapId;
            [GetStreetsnapDetailInput shareInstance].userId = [LoginModel shareInstance].userId;
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapDetailInput shareInstance]];
            [[NetInterface shareInstance] getStreetsnapDetail:@"getStreetsnapDetail" param:dict successBlock:^(NSDictionary *responseDict) {
                GetStreetsnapDetail *returnData = [GetStreetsnapDetail modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    _streetsnapInfo = returnData.streetsnapInfo;
                    [self reloadData];
                } else {
                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                }
            } failedBlock:^(NSError *err) {
            }];
        }
        //[CustomUtil showToastWithText:returnData.msg view:kWindow];
    } failedBlock:^(NSError *err) {
    }];
}

//加载数据
-(void)reloadData
{
    StreetsnapInfo *snapInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    if ([snapInfo.praiseFlag isEqualToString:@"0"]) { //未赞
        [_zanBtn setBackgroundImage:[UIImage imageNamed:@"zan7-4-1"] forState:UIControlStateNormal];
    } else if ([snapInfo.praiseFlag isEqualToString:@"1"]) { //已赞
        [_zanBtn setBackgroundImage:[UIImage imageNamed:@"zan02-7-4"] forState:UIControlStateNormal];
    }
}

-(void)handleSingleTap
{
    [self.navigationController popViewControllerAnimated:NO];
}

@end

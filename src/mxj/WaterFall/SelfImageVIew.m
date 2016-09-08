//
//  SelfImageVIew.m
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import "SelfImageVIew.h"

@implementation SelfImageVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;

        
    }
    return self;
}


-(id)initWithImageInfo:(ImageInfo*)imageInfo y:(float)y  withA:(int)a intoFlag:(int)intoFlag
{
    float imageW = imageInfo.width;
    float imageH = imageInfo.height;
    //缩略图宽度和高度（等比缩放）
    //float width = WIDTH - SPACE;
    //float height = width * imageH / imageW;

    //self = [super initWithFrame:CGRectMake(0, y, WIDTH, height + SPACE)];
    self = [super initWithFrame:CGRectMake(0, y, imageW, imageH)];
    if (self) {
        self.data = imageInfo;
        
        self.type = intoFlag;
        
        ListImageView *listImageView = nil;
        
        if (intoFlag == 0 || intoFlag == 1) {
            // 首页或者街拍进入
            listImageView = [[ListImageView alloc] init];
            [(ListImageView *)listImageView initData:imageInfo withType:intoFlag];
            CGRect rect = self.frame;
            rect.size.height = listImageView.frame.size.height + SPACE;
            self.frame = rect;
        }
        
        [self addSubview:listImageView];

        return self;
        
#ifdef OPEN_NET_INTERFACE
        if (0 == intoFlag) { //首页或街拍进入
            //UIView dequeueReusableCellWithIdentifier
            listImageView = [[[NSBundle mainBundle] loadNibNamed:@"ListImageView" owner:self options:nil] objectAtIndex:1];
            
#else
        if (0 == intoFlag) { //首页或街拍进入
            if (241 == imageH) { //以文字高度区分
                listImageView = [[[NSBundle mainBundle] loadNibNamed:@"ListImageView" owner:self options:nil] objectAtIndex:0];
            } else if(218 == imageH) {
                listImageView = [[[NSBundle mainBundle] loadNibNamed:@"ListImageView" owner:self options:nil] objectAtIndex:1];
            }
#endif
#ifdef OPEN_NET_INTERFACE
            float contentHeight = 0;
            CGRect baseRect = CGRectZero; //街拍图片基准rect
            for (UIView *view in listImageView.subviews) {
                if (1 == view.tag) { //街拍图片
                    EGOImageView *photoImageView = (EGOImageView *)view;
                    baseRect = photoImageView.frame;
                    baseRect.size.width = imageW;
                    baseRect.size.height = imageH;
                    photoImageView.frame = baseRect;
                    [photoImageView setBackgroundColor:[UIColor grayColor]];
                    UIImage *cacheImage = [[EGOImageLoader sharedImageLoader] imageForURL:[CustomUtil getPhotoURL:imageInfo.photo1] shouldLoadWithObserver:nil];
                    if(cacheImage) {
                        photoImageView.image = cacheImage;
                    } else {
                        photoImageView.imageURL = [CustomUtil getPhotoURL:imageInfo.photo1];
                    }
                } else if (4 == view.tag) { //内容
                    UITextView *contentLabel = (UITextView *)view;
                    //获取文字高度
                    contentHeight = [CustomUtil heightForString:imageInfo.streetsnapContent fontSize:13.0f andWidth:contentLabel.frame.size.width];
                    NSString *displayStr = @"";
                    if (contentHeight > 63) {
                        contentHeight = 63;
                        if (imageInfo.streetsnapContent.length <= 33) {
                            displayStr = imageInfo.streetsnapContent;
                        } else {
                            displayStr = [NSString stringWithFormat:@"%@...", [imageInfo.streetsnapContent substringToIndex:32]];
                        }
                    } else {
                        displayStr = imageInfo.streetsnapContent;
                    }
                    contentLabel.text = displayStr;
                }
            }
            //调整瀑布流控件大小
            [listImageView setFrame:CGRectMake(SPACE/2, SPACE/2, imageW, imageH + 68 - 26 + contentHeight)];
            CGRect rect = self.frame;
            rect.size.height = imageH + 68 - 26 + contentHeight;
            self.frame = rect;
            
            for (UIView *view in listImageView.subviews) {
               if (2 == view.tag) { //个人头像
                    EGOImageView *personImageView = (EGOImageView *)view;
                    [CustomUtil setImageViewCorner:personImageView];
                    UIImage *cacheImage = [[EGOImageLoader sharedImageLoader] imageForURL:[CustomUtil getPhotoURL:imageInfo.image] shouldLoadWithObserver:nil];
                    if(cacheImage) {
                        personImageView.image = cacheImage;
                    } else {
                        personImageView.imageURL = [CustomUtil getPhotoURL:imageInfo.image];
                    }
                    CGRect rect = personImageView.frame;
                    rect.origin.y = baseRect.size.height - rect.size.height - 11;
                    personImageView.frame = rect;
                } else if (3 == view.tag) { //个人名称
                    UILabel *personName = (UILabel *)view;
                    personName.text = imageInfo.userName;
                    CGRect rect = personName.frame;
                    rect.origin.y = baseRect.size.height - rect.size.height - 25;
                    personName.frame = rect;
                } else if (4 == view.tag) { //内容
                    UITextView *contentLabel = (UITextView *)view;
                    CGRect rect = contentLabel.frame;
                    rect.origin.y = baseRect.size.height + 20;
                    rect.size.height = contentHeight;
                    contentLabel.frame = rect;
                } else if (5 == view.tag) { //点赞数
                    UILabel *praiseNum = (UILabel *)view;
                    praiseNum.text = imageInfo.praiseNum;
                } else if (6 == view.tag) { //评论数
                    UILabel *commentNum = (UILabel *)view;
                    commentNum.text = imageInfo.commentNum;
                } else if (7 == view.tag) { //发布位置
                    UILabel *publishPlace = (UILabel *)view;
                    publishPlace.textColor = [UIColor colorWithHexString:@"#d8d8d8"];
                    publishPlace.text = imageInfo.publishPlace;
                } else if (8 == view.tag) { //位置图标
                    UIImageView *placeImageView = (UIImageView *)view;
                    if ([CustomUtil CheckParam:imageInfo.publishPlace]) {
                        [placeImageView setHidden:YES];
                    } else {
                        [placeImageView setHidden:NO];
                    }
                } else if (9 == view.tag) { //发布时间
                    UILabel *publishPlace = (UILabel *)view;
                    publishPlace.textColor = [UIColor colorWithHexString:@"#d8d8d8"];
                    publishPlace.text = imageInfo.publishTime;
                }
            }
        } else if (1 == intoFlag) { //我的收藏进入
            listImageView = [[[NSBundle mainBundle] loadNibNamed:@"FavoriteView" owner:self options:nil] objectAtIndex:1];
            //获取文字高度
            float contentHeight = 0;
            float contentViewHeight = 0;
            for (UIView *view in listImageView.subviews) {
                if (2 == view.tag) {
                    UITextView *contentTextView = (UITextView *)view;
                    if (![imageInfo.streetsnapContent1 isEqualToString:@""]) {
                        contentHeight = [CustomUtil heightForString:imageInfo.streetsnapContent1 fontSize:13.0f andWidth:imageW];
                    }
                    NSString *displayStr = @"";
                    if (contentHeight >= 63) {
                        contentHeight = 63;
                        if (imageInfo.streetsnapContent1.length <= 33) {
                            displayStr = imageInfo.streetsnapContent1;
                        } else {
                            displayStr = [NSString stringWithFormat:@"%@...", [imageInfo.streetsnapContent1 substringToIndex:32]];
                        }
                    } else {
                        displayStr = imageInfo.streetsnapContent1;
                    }
                    contentTextView.text = displayStr;
                    CGRect rect = contentTextView.frame;
                    contentViewHeight = rect.size.height;
                    rect.size.height = contentHeight;
                    contentTextView.frame = rect;
                }
                else if (9 == view.tag) {
                    UILabel *publishPlace = (UILabel *)view;
                    publishPlace.textColor = [UIColor colorWithHexString:@"#d8d8d8"];
                    publishPlace.text = imageInfo.publishTime1;
                }
            }
            
            CGRect rect = listImageView.frame;
            rect.origin.x = SPACE/2;
            rect.origin.y = SPACE/2;
            rect.size.width = imageW;
            rect.size.height = imageH + 53 - contentViewHeight + contentHeight;
            listImageView.frame = rect;
            rect = self.frame;
            rect.size.height = listImageView.frame.size.height;
            self.frame = rect;
#else
        } else if (1 == intoFlag) { //我的收藏进入
            if (203 == imageH) { //以文字高度区分
                listImageView = [[[NSBundle mainBundle] loadNibNamed:@"FavoriteView" owner:self options:nil] objectAtIndex:0];

            } else if (202.5 == imageH) {
                listImageView = [[[NSBundle mainBundle] loadNibNamed:@"FavoriteView" owner:self options:nil] objectAtIndex:1];
            }
#endif
#ifdef OPEN_NET_INTERFACE
            for (UIView *view in listImageView.subviews) {
                if (1 == view.tag) { //街拍图片
                    EGOImageView *photoImageView = (EGOImageView *)view;
                    [photoImageView setBackgroundColor:[UIColor grayColor]];
                    UIImage *cacheImage = [[EGOImageLoader sharedImageLoader] imageForURL:[CustomUtil getPhotoURL:imageInfo.photo12] shouldLoadWithObserver:nil];
                    if(cacheImage) {
                        photoImageView.image = cacheImage;
                    } else {
                        photoImageView.imageURL = [CustomUtil getPhotoURL:imageInfo.photo12];
                    }
                    //设置街拍图片尺寸
                    CGRect rect = photoImageView.frame;
                    rect.size.width = imageW;
                    rect.size.height = imageH;
                    photoImageView.frame = rect;
                } else if (2 == view.tag) { //内容
                    UITextView *contentLabel = (UITextView *)view;
                    CGRect rect = contentLabel.frame;
                    rect.origin.y = imageH + 2;
                    contentLabel.frame = rect;
                } else if (3 == view.tag) { //发布时间
                    UILabel *timeLabel = (UILabel *)view;
                    timeLabel.text = imageInfo.publishTime1;
                }
            }
#endif
        }

        [self addSubview:listImageView];
    }
    return self;
}
    
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self handleSingleTap];
    return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self];
    
    if (touch.tapCount == 1) {
        NSLog(@"单击");

        // 单击
        [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:0.3];
    }else if(touch.tapCount == 2)
    {
        NSLog(@"双击");
        // 双击
        if ([self.delegate respondsToSelector:@selector(doubleClickImage:)]) {
            [self.delegate doubleClickImage:self.data];
        }
        
//        [PublishPraiseInput shareInstance].streetsnapId = _type == 1 ? _data.streetsnapId1 : _data.streetsnapId;
//        [PublishPraiseInput shareInstance].streetsnapUserId = _data.userId;
//        [PublishPraiseInput shareInstance].userId = [LoginModel shareInstance].userId;
//        [PublishPraiseInput shareInstance].flag = info.praiseFlag;
//        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[PublishPraiseInput shareInstance]];
//        [[NetInterface shareInstance] publishPraise:@"publishPraise" param:dict successBlock:^(NSDictionary *responseDict) {
//            BaseModel *returnData = [BaseModel modelWithDict:responseDict];
//            if (RETURN_SUCCESS(returnData.status)) {
//                //更新点赞按钮状态
//                StreetsnapInfo *publishInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
//                if ([publishInfo.praiseFlag isEqualToString:@"0"]) { //未赞
//                    // 取消点赞
//                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
//                    
//                } else if ([publishInfo.praiseFlag isEqualToString:@"1"]) { //已赞
//                    [self showZanAnimation];
//                    
//                }
//
//            }
//            else {
//                [CustomUtil showToastWithText:returnData.msg view:kWindow];
//            }
//        } failedBlock:^(NSError *err) {
//        }];
    }

}
    
- (void)handleSingleTap
{
    [self.delegate clickImage:self.data];
}

@end

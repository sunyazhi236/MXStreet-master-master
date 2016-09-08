//
//  ListImageView.m
//  mxj
//
//  Created by 单鹏涛 on 16/5/14.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "ListImageView.h"

#define MAIN_WIDTH WIDTH - SPACE

@implementation ListImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.coverImageView];
    [self.backImageView addSubview:self.headImageView];
    [self.backImageView addSubview:self.nameLabel];
    [self.backImageView addSubview:self.locationImgBtn];
    [self.backImageView addSubview:self.locationLabel];
    [self.backImageView addSubview:self.publishTimeLabel];
    
    [self addSubview:self.contentLabel];
    [self addSubview:self.praiseImgBtn];
    [self addSubview:self.praiseLabel];
    [self addSubview:self.commentImgBtn];
    [self addSubview:self.commentLabel];
}

#pragma mark - GET
- (EGOImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 180)];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.layer.masksToBounds = YES;
        _backImageView.clipsToBounds = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}

- (EGOImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[EGOImageView alloc] init];
        _headImageView.frame = CGRectMake(0, 0, HEADER_IMAGE_LENGTH, HEADER_IMAGE_LENGTH);
        _headImageView.layer.cornerRadius = HEADER_IMAGE_LENGTH / 2;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 180)];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleToFill;
        UIImage *image =[UIImage imageNamed:@"mengban"];//原图
//        UIEdgeInsets edge = UIEdgeInsetsMake(0, 10, 0,10);
//        image = [image resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        _coverImageView.image = image;
    }
    return _coverImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.font = FONT(12);
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UILabel *)publishTimeLabel
{
    if (!_publishTimeLabel) {
        _publishTimeLabel = [[UILabel alloc] init];
        _publishTimeLabel.textColor = [UIColor colorWithHexString:@"#d8d8d8"];
        _publishTimeLabel.font = FONT(9);
    }
    return _publishTimeLabel;
}

- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [UIColor colorWithHexString:@"#d8d8d8"];
        _locationLabel.font = FONT(9);
    }
    return _locationLabel;
}


- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.font = FONT(12);
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}

- (UIButton *)locationImgBtn
{
    if (!_locationImgBtn) {
        _locationImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationImgBtn setImage:[UIImage imageNamed:@"add_7"] forState:UIControlStateNormal];
    }
    return _locationImgBtn;
}

- (UILabel *)praiseLabel
{
    if (!_praiseLabel) {
        _praiseLabel = [[UILabel alloc] init];
        _praiseLabel.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
        _praiseLabel.font = FONT(9);
        _praiseLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _praiseLabel;
}

- (UIButton *)praiseImgBtn
{
    if (!_praiseImgBtn) {
        _praiseImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseImgBtn setImage:[UIImage imageNamed:@"zan_7"] forState:UIControlStateNormal];
    }
    return _praiseImgBtn;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
        _commentLabel.font = FONT(9);
        _commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _commentLabel;
}

- (UIButton *)commentImgBtn
{
    if (!_commentImgBtn) {
        _commentImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentImgBtn setImage:[UIImage imageNamed:@"ping_7"] forState:UIControlStateNormal];
    }
    return _commentImgBtn;
}

#pragma mark - initData

- (void)initData:(ImageInfo *)imageInfo withType:(NSInteger)type
{
    float imageW = imageInfo.width;
    float imageH = imageInfo.height; // 180;

    NSString *backImageStr = imageInfo.photo1;
    NSString *contentStr = imageInfo.streetsnapContent;
    NSString *publishTimeStr = imageInfo.publishTime;

    if (type == 1) {
        backImageStr = imageInfo.photo12;
        contentStr = imageInfo.streetsnapContent1;
        publishTimeStr = imageInfo.publishTime1;
    }
    
    CGRect baseRect = CGRectZero; //街拍图片基准rect
    if (backImageStr) {
        baseRect = self.backImageView.frame;
        baseRect.size.width = imageW;
        baseRect.size.height = imageH;
        self.backImageView.frame = baseRect;
        UIImage *cacheImage = [[EGOImageLoader sharedImageLoader] imageForURL:[CustomUtil getPhotoURL:backImageStr] shouldLoadWithObserver:nil];
        if(cacheImage) {
            self.backImageView.image = cacheImage;
        }
        else {
            self.backImageView.imageURL = [CustomUtil getPhotoURL:backImageStr];
        }
        
        self.coverImageView.frame = CGRectMake(0, baseRect.size.height - 65, WIDTH, 65);
    }
    
    if (imageInfo.image) {
        UIImage *cacheImage = [[EGOImageLoader sharedImageLoader] imageForURL:[CustomUtil getPhotoURL:imageInfo.image] shouldLoadWithObserver:nil];
        if(cacheImage) {
            self.headImageView.image = cacheImage;
        } else {
            self.headImageView.imageURL = [CustomUtil getPhotoURL:imageInfo.image];
        }
        CGRect rect = self.headImageView.frame;
        rect.origin.x = 9;
        rect.origin.y = baseRect.size.height - rect.size.height - 8;
        self.headImageView.frame = rect;
        [CustomUtil setImageViewCorner:self.headImageView];
    }
    
    if (imageInfo.userName) {

        self.nameLabel.frame = CGRectMake(18 + HEADER_IMAGE_LENGTH, baseRect.size.height - self.headImageView.frame.size.height - 8, MAIN_WIDTH - HEADER_IMAGE_LENGTH - 20, HEADER_IMAGE_LENGTH / 2);
        self.nameLabel.text = imageInfo.userName;
    }
    
    CGFloat tmp_x = 18 + HEADER_IMAGE_LENGTH;
    
    publishTimeStr = [CustomUtil timeSpaceWithTimeStr:publishTimeStr isBigPhoto:NO];
    
    if (publishTimeStr) {
        CGSize size = [publishTimeStr sizeWithFont:self.publishTimeLabel.font maxSize:CGSizeMake(MAIN_WIDTH - 5, HEADER_IMAGE_LENGTH / 2)];
        
        // 发布时间
        self.publishTimeLabel.frame = CGRectMake(tmp_x, GetBottom(self.nameLabel) + 4, size.width + 1, size.height);
        self.publishTimeLabel.text = publishTimeStr;
        
        
        tmp_x = tmp_x + size.width + 1 + 5;
        
        //        self.locationLabel.frame = CGRectMake(45, baseRect.size.height - self.headImageView.frame.size.height - 4 + HEADER_IMAGE_LENGTH / 2, MAIN_WIDTH - 45 - 5, HEADER_IMAGE_LENGTH / 2);
        //
        //        self.locationLabel.text = publishTimeStr;
        //
        //        self.locationLabel.textAlignment = NSTextAlignmentRight;
    }
    
    if (imageInfo.publishPlace.length && [imageInfo.publishPlace isKindOfClass:[NSString class]]) {
        self.locationImgBtn.frame = CGRectMake(tmp_x, GetBottom(self.nameLabel) + 4, 9, 11);

        self.locationLabel.frame = CGRectMake(GetX(self.locationImgBtn) + GetWidth(self.locationImgBtn) + 4, GetY(self.locationImgBtn), MAIN_WIDTH - HEADER_IMAGE_LENGTH - 20 - 17, 11);
        
        self.locationLabel.text = imageInfo.publishPlace;
    }

    
    float contentHeight = 0;
    if (contentStr.length && [contentStr isKindOfClass:[NSString class]]) {
        //获取文字高度
        contentHeight = [CustomUtil heightForString:contentStr font:self.contentLabel.font andWidth:self.contentLabel.frame.size.width];
        NSString *displayStr = @"";
        if (contentHeight > 63) {
            contentHeight = 63;
            if (contentStr.length <= 33) {
                displayStr = contentStr;
            } else {
                displayStr = [NSString stringWithFormat:@"%@...", [contentStr substringToIndex:32]];
            }
        } else {
            displayStr = contentStr;
        }
        
        self.contentLabel.frame = CGRectMake(9, baseRect.size.height, MAIN_WIDTH - 18, contentHeight);
        self.contentLabel.text = displayStr;
    }
    
    float tmpY = baseRect.size.height + contentHeight;
    
    float tmpX = 9;
    
    float tmpHeight = 0;

    if (imageInfo.praiseNum.length && [imageInfo.praiseNum isKindOfClass:[NSString class]]) {

        self.praiseImgBtn.frame = CGRectMake(tmpX, tmpY, 13, 22);
        
        tmpX = tmpX + 13 + 3;
        
        self.praiseLabel.frame = CGRectMake(tmpX, tmpY, 28, 22);

        self.praiseLabel.text = [NSString stringWithFormat:@"%@", imageInfo.praiseNum];
        
        tmpHeight = 22;
    }
    
    if (imageInfo.commentNum.length && [imageInfo.commentNum isKindOfClass:[NSString class]]) {
        
        tmpX = tmpX + 25 + 4;
        
        self.commentImgBtn.frame = CGRectMake(tmpX, tmpY, 13, 22);
        
        tmpX = tmpX + 13 + 3;
        
        self.commentLabel.frame = CGRectMake(tmpX, tmpY, 30, 22);
        
        self.commentLabel.text = [NSString stringWithFormat:@"%@", imageInfo.commentNum];
        
        tmpHeight = 22;
    }
    
    [self setFrame:CGRectMake(SPACE / 2, SPACE / 2, imageW, imageH + contentHeight + tmpHeight)];
}

@end

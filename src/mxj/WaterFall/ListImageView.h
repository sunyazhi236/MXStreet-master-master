//
//  ListImageView.h
//  mxj
//
//  Created by 单鹏涛 on 16/5/14.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"
#import "UIImageView+WebCache.h"

#define HEADER_IMAGE_LENGTH 35

#define WIDTH [UIScreen mainScreen].applicationFrame.size.width/2

//间距
#define SPACE 10

@interface ListImageView : UIView

// 背景
//@property (nonatomic, strong) UIView *backView;
// 蒙层
@property (nonatomic, strong) UIImageView *coverImageView;
// 背景图
@property (nonatomic, strong) EGOImageView *backImageView;
// 头像
@property (nonatomic, strong) EGOImageView *headImageView;
// 名字
@property (nonatomic, strong) UILabel *nameLabel;
// 发布时间标题
@property (nonatomic, strong) UILabel *publishTimeLabel;
// 定位
@property (nonatomic, strong) UILabel *locationLabel;
// 定位图标
@property (nonatomic, strong) UIButton *locationImgBtn;
// 赞个数
@property (nonatomic, strong) UILabel *praiseLabel;
// 赞图标
@property (nonatomic, strong) UIButton *praiseImgBtn;
// 评论
@property (nonatomic, strong) UILabel *commentLabel;
// 评论图标
@property (nonatomic, strong) UIButton *commentImgBtn;
// 主要内容
@property (nonatomic, strong) UILabel *contentLabel;

// type: 0=普通 1=收藏
- (void)initData:(ImageInfo *)imageInfo withType:(NSInteger)type;

@end

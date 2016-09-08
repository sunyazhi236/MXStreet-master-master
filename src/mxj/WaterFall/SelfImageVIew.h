//
//  SelfImageVIew.h
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"
#import "UIImageView+WebCache.h"
#import "ListImageView.h"


@protocol ImageDelegate<NSObject>
-(void)clickImage:(ImageInfo*)data;


@optional
// 图片双击处理
- (void)doubleClickImage:(ImageInfo *)data;

@end

@interface SelfImageVIew : UIView
@property (nonatomic,weak)id<ImageDelegate> delegate;
@property (nonatomic,strong)ImageInfo *data;
@property (nonatomic,assign)int type;

//intoFlag入口参数 0:首页或街拍画面 1:我的收藏
-(id)initWithImageInfo:(ImageInfo*)imageInfo y:(float)y withA:(int)a intoFlag:(int)intoFlag;

@end

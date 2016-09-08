//
//  ImageFilterItem.h
//  ImageFilter
//
//  Created by shanpengtao on 16/5/16.
//  Copyright (c) 2016年 shanpengtao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FILTERIMAGE_Y_OFFSET 15

#define FILTERIMAGE_WIDTH 60

#define FILTERIMAGE_HEIGHT 80

#define NORMAL_BACK_COLOR [UIColor whiteColor]

#define SELECT_BACK_COLOR [UIColor orangeColor]

#define NORMAL_TEXT_COLOR [UIColor blackColor]

#define SELECT_TEXT_COLOR [UIColor whiteColor]

@class ImageFilterItem;

typedef void(^IconClick)(ImageFilterItem *item);

@interface ImageFilterItem : UIView

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *titleLabel;
//@property (weak, nonatomic) UIButton *btn_click;
@property (copy, nonatomic) IconClick iconClick;

@property (assign, nonatomic) BOOL select;

//- (IBAction)btn_itemClick:(id)sender;

@end
//
//  ImageFilterItem.m
//  ImageFilter
//
//  Created by shanpengtao on 16/5/16.
//  Copyright (c) 2016年 shanpengtao. All rights reserved.
//

#import "ImageFilterItem.h"

@implementation ImageFilterItem

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
    self.backgroundColor = NORMAL_BACK_COLOR;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    self.frame = CGRectMake(0, FILTERIMAGE_Y_OFFSET, FILTERIMAGE_WIDTH, FILTERIMAGE_HEIGHT);
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FILTERIMAGE_WIDTH, FILTERIMAGE_WIDTH)];
    _icon.userInteractionEnabled = YES;
    [self addSubview:_icon];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, FILTERIMAGE_WIDTH, FILTERIMAGE_WIDTH, FILTERIMAGE_HEIGHT - FILTERIMAGE_WIDTH)];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)tap:(id)sender {
    if (_iconClick) {
        _iconClick(self);
    }
}

- (void)setSelect:(BOOL)isSelect
{
    self.backgroundColor = isSelect ? SELECT_BACK_COLOR : NORMAL_BACK_COLOR;
    
    self.titleLabel.textColor = isSelect ? SELECT_TEXT_COLOR : NORMAL_TEXT_COLOR;
}

@end
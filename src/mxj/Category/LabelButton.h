//
//  LabelButton.h
//  mxj
//  标签按钮
//  Created by 齐乐乐 on 15/12/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelButton : UIButton

@property(nonatomic, assign) TouchPositionModel *model;
@property(nonatomic, assign) UIImageView *pointImageView; //标签前的小红点

@property(nonatomic, assign) UIImageView *backImageView; //标签前的小红点下面的黑背景

@end

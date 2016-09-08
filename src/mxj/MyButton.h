//
//  MyButton.h
//  mxj
//  相机胶卷中带有标签的图片按钮对象
//  Created by 齐乐乐 on 16/1/12.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton

@property(nonatomic, assign) int labelNum; //右上角标签的数字

-(instancetype)initWithFrame:(CGRect)frame;

@end

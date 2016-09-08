//
//  MyTextField.m
//  mxj
//
//  Created by 齐乐乐 on 15/12/22.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
    return rect;
}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
    return rect;
}

@end

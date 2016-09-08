//
//  LineTextField.m
//  mxj
//
//  Created by MQ-MacBook on 16/5/15.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "LineTextField.h"
#import "Macro.h"

@implementation LineTextField

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#a3a3a3"].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

//位置，右缩30
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+30, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}


@end

//
//  LineTF.m
//  mxj
//
//  Created by MQ-MacBook on 16/5/15.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "LineTF.h"

@implementation LineTF
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#a3a3a3"].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}
@end

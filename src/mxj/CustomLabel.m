//
//  CustomLabel.m
//  mxj
//
//  Created by 齐乐乐 on 16/2/16.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

//可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copyStr:));
}

//copy方法的实现
-(void)copyStr:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

//UILabel的touch事件
-(void)attachTapHandler
{
    self.userInteractionEnabled = YES;
    //添加长按事件
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    longPressGR.minimumPressDuration = 0.5;
    
    [self addGestureRecognizer:longPressGR];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self attachTapHandler];
}

-(void)handleTap:(UIGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyStr:)];
        [[UIMenuController sharedMenuController] setMenuItems:@[copyLink]];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

@end

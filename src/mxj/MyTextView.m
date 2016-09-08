//
//  MyTextView.m
//  mxj
//
//  Created by 齐乐乐 on 16/2/21.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView

- (BOOL)canBecameFirstResponder {
    return YES;
}

//可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyStr:)) {
        return YES;
    }
    return NO;
}

//copy方法的实现
-(void)copyStr:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

//UITextView的touch事件
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
        CGRect viewRect = self.frame;
        viewRect.size.width = 20;
        [[UIMenuController sharedMenuController] setTargetRect:viewRect inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

@end

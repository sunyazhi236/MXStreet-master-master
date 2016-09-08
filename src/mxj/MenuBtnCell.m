//
//  MenuBtnCell.m
//  mxj
//  主界面菜单按钮用Cell
//  Created by 齐乐乐 on 15/11/26.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "MenuBtnCell.h"

@implementation MenuBtnCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithDelegate:(id<MenuBtnClickDelegate>)menuBtnDelegate
{
    self = [super init];
    if (self) {
        _menuBtnDelegate = menuBtnDelegate;
        [self initView];
    }
    return self;
}

- (void)initView
{
    _menuBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MENU_CELL_HEIGHT)];
    _menuBackImageView.userInteractionEnabled = YES;
    [self addSubview:_menuBackImageView];
//    [_menuBackImageView setImage:[UIImage imageNamed:@"left_7"]];

    NSArray *images = @[@"gaunzhu_7", @"renqi_7", @"tongc_7"];
    NSArray *images2 = @[@"gaunzhu02_7", @"renqi02_7", @"tongc02_7"];
    
    NSArray *names = @[@"街蜜", @"街红", @"街坊"];
    
    CGFloat width = SCREEN_WIDTH/3.0;
    for(int i = 0; i < images.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * i, 0, width, MENU_CELL_HEIGHT);
        button.tag = i + 1;
        button.selected = NO;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_menuBackImageView addSubview:button];
        
        UIImage *image = [UIImage imageNamed:images[i]];
        UIImage *image2 = [UIImage imageNamed:images2[i]];

        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image2 forState:UIControlStateSelected];

        [button setImageEdgeInsets:UIEdgeInsetsMake(-25, 0, 0, 0)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, width, 15)];
        label.textColor = [UIColor colorWithHexString:@"#a7a7a7"];
        label.tag = 100 + i + 1;
        label.font = [UIFont systemFontOfSize:12];
        label.text = names[i];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];

        if (i == 0) {
            _guanzhuBtn = button;
        }
        else if (i == 1) {
            _renqiBtn = button;
        }
        else {
            _tongchengBtn = button;
        }
    }
    
    
    UIButton *btn = [self viewWithTag:MENU_FLAG + 1];
    [self btnClick:btn];
}
//tag从0开始
- (void)btnClickWithTag:(NSInteger)tag
{
    UIButton *btn = [self viewWithTag:MENU_FLAG + tag];
    [self btnClick:btn];
}

- (void)btnClick:(UIButton *)sender {
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [self viewWithTag:i + 100 + 1];
        label.textColor = [UIColor colorWithHexString:@"#a7a7a7"];

        if (i == sender.tag - 1) {
            UILabel *label = [self viewWithTag:sender.tag + 100];
            label.textColor = [UIColor redColor];
        }
    }
    
    UIImage *image;

    switch (((UIButton *)sender).tag) {
        case 1:
        {
            [_guanzhuBtn setSelected:YES];
            [_renqiBtn setSelected:NO];
            [_tongchengBtn setSelected:NO];
            
            image = [UIImage imageNamed:@"left_7"];
        }
            break;
        case 2:
        {
            [_guanzhuBtn setSelected:NO];
            [_renqiBtn setSelected:YES];
            [_tongchengBtn setSelected:NO];
            
            image = [UIImage imageNamed:@"middle_7"];
        }
            break;
        case 3:
        {
            [_guanzhuBtn setSelected:NO];
            [_renqiBtn setSelected:NO];
            [_tongchengBtn setSelected:YES];
            
            image = [UIImage imageNamed:@"right_7"];
        }
            break;
        default:
            break;
    }
    
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 10, 0)];
    [_menuBackImageView setImage:image];
    
    if ([self.menuBtnDelegate respondsToSelector:@selector(menuBtnClick:)]) {
        [self.menuBtnDelegate menuBtnClick:(int)(((UIButton *)sender).tag)];
    }
}

#pragma mark -代理方法
-(void)changeBtnStatus:(int)flag
{
    for (int i = 0; i < 3; i++) {
        UILabel *label = [self viewWithTag:i + 100 + 1];
        label.textColor = [UIColor colorWithHexString:@"#a7a7a7"];
        
        if (i == flag) {
            UILabel *label = [self viewWithTag:flag + 100 + 1];
            label.textColor = [UIColor redColor];
        }
    }
    
    UIImage *image;
    switch (flag) {
        case 0:
        {
            [_guanzhuBtn setSelected:YES];
            [_renqiBtn setSelected:NO];
            [_tongchengBtn setSelected:NO];
            image = [UIImage imageNamed:@"left_7"];
        }
            break;
        case 1:
        {
            [_guanzhuBtn setSelected:NO];
            [_renqiBtn setSelected:YES];
            [_tongchengBtn setSelected:NO];
            image = [UIImage imageNamed:@"middle_7"];
        }
            break;
        case 2:
        {
            [_guanzhuBtn setSelected:NO];
            [_renqiBtn setSelected:NO];
            [_tongchengBtn setSelected:YES];
            image = [UIImage imageNamed:@"right_7"];
        }
            break;
        default:
            break;
    }
    
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 10, 0)];
    
    [_menuBackImageView setImage:image];
}

@end

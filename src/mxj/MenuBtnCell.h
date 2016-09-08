//
//  MenuBtnCell.h
//  mxj
//  主界面菜单按钮用Cell
//  Created by 齐乐乐 on 15/11/26.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENU_CELL_HEIGHT 60

// 默认选择按钮
#define MENU_FLAG 1

@protocol MenuBtnClickDelegate <NSObject>

-(void)menuBtnClick:(int)flag; //菜单按钮点击时的响应

@end

@interface MenuBtnCell : UIView<ScrollViewChangeBtnDelegate>


@property (strong, nonatomic) UIButton *guanzhuBtn; //关注按钮
@property (strong, nonatomic) UIButton *renqiBtn;   //人气按钮
@property (strong, nonatomic) UIButton *tongchengBtn; //同城按钮
@property (strong, nonatomic) UIImageView *menuBackImageView; //背景imageView

@property(nonatomic, weak) id<MenuBtnClickDelegate> menuBtnDelegate; //按钮点击事件代理
//@property (weak, nonatomic) IBOutlet UILabel *leftLineLabel; //左侧分割线
//@property (weak, nonatomic) IBOutlet UILabel *rightLineLable; //右侧分割线

- (instancetype)initWithDelegate:(id<MenuBtnClickDelegate>)menuBtnDelegate;

- (void)btnClickWithTag:(NSInteger)tag;


@end

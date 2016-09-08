//
//  userImageViewClickProtocol.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/20.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

//Cell上用户头像点击的事件代理
@protocol UserImageViewClickProtocol <NSObject>

//cell上用户头像按钮点击事件
-(void)imageViewClick:(id)sender;

@end

//ScrollView滑动时改变菜单按钮状态代理
@protocol ScrollViewChangeBtnDelegate <NSObject>

-(void)changeBtnStatus:(int)flag; //修改按钮状态

@end

//我的粉丝页面加关注按钮点击事件代理
@protocol FansAddContanctBtnDelegate <NSObject>

-(void)addContanctBtnClick:(NSInteger)index; //按钮点击事件

@end

//通讯录邀请按钮点击事件代理
@protocol InvisteUserBtnDelegate <NSObject>

-(void)invisteUserBtnClick:(id)sender;

@end

//街拍详情页面点击删除按钮事件代理
@protocol DeleteCommentBtnClickDelegate <NSObject>

//删除评论按钮点击代理方法
-(void)deleteCommentBtnClick:(id)sender;

@end

//我的粉丝首行关注按钮代理
@protocol GuanZhuBtnClickDelegate <NSObject>

-(void)guanZhuCellBtnClick:(id)sender;

@end

//我的关注首行关注按钮代理
@protocol myContactManGuanZhuBtnClickDelegate <NSObject>

-(void)gzBtnClick:(id)sender;

@end


//
//  ConcernManTableCellOne.h
//  mxj
//  P10关注的人-已关注TableCell用头文件
//  Created by 齐乐乐 on 15/11/15.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserImageViewClickProtocol.h"

@interface ConcernManTableCellOne : UITableViewCell

@property (strong, nonatomic) id<UserImageViewClickProtocol> delegate;
@property (strong, nonatomic) IBOutlet UIButton *alreadyConcernBtn; //已关注按钮
@property (strong, nonatomic) id<myContactManGuanZhuBtnClickDelegate>gzBtnDelegate; //关注按钮代理
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel; //用户名
@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //用户头像

@end

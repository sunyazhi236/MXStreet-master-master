//
//  ConcernManTableViewCell.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/15.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserImageViewClickProtocol.h"


@interface ConcernManTableViewCell : UITableViewCell

@property (strong, nonatomic) id<UserImageViewClickProtocol> delegate; //个人头像代理
@property (strong, nonatomic) IBOutlet UIButton *alreadyConcernBtn;
@property (strong, nonatomic) id<myContactManGuanZhuBtnClickDelegate> gzDelegate; //关注按钮代理
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel; //用户名
@property (weak, nonatomic) IBOutlet EGOImageView *personImageView;

@end

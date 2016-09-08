//
//  MeFansTableViewTwoCell.h
//  mxj
//  P11我的粉丝首行以外的TableCell
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserImageViewClickProtocol.h"

@interface MeFansTableViewTwoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *fansBtn; //关注按钮
@property (strong, nonatomic) id<UserImageViewClickProtocol> delegate;
@property (assign, nonatomic) int index; //cell编号
@property (weak, nonatomic) IBOutlet UILabel *userName; //用户名
@property (weak, nonatomic) IBOutlet EGOImageView *userImageView;
@property (nonatomic, strong) id<GuanZhuBtnClickDelegate> guanzhuBtnDelegate; //关注按钮代理

@end

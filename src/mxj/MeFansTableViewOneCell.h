//
//  MeFansTableViewOneCell.h
//  mxj
//  P11我的粉丝首行TableCell
//  Created by 齐乐乐 on 15/11/16.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserImageViewClickProtocol.h"

@interface MeFansTableViewOneCell : UITableViewCell

@property (nonatomic, strong) id<UserImageViewClickProtocol> delegate;
@property (nonatomic, assign) NSInteger indexNum; //cell的编号
@property (weak, nonatomic) IBOutlet UILabel *userName; //用户名
@property (weak, nonatomic) IBOutlet UIButton *guanZhuBtn; //关注按钮
@property (weak, nonatomic) IBOutlet EGOImageView *userImageView; //用户头像

@property (nonatomic, strong) id<GuanZhuBtnClickDelegate> guanzhuBtnDelegate; //关注按钮代理


@end

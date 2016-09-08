//
//  PhoneBookTableTwoCell.h
//  mxj
//  P7-5-1-1手机通讯录用第二类Cell
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneBookTableTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet EGOImageView *personImageView; //个人头像
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;      //名字
@property (nonatomic, strong) id<InvisteUserBtnDelegate> invisteUserBtnDelegate; //邀请按钮代理

@end

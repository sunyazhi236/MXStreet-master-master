//
//  StreetPhotoDetailCell.h
//  mxj
//  P7-4街拍详情用Cell
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreetPhotoDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *personBackImageView;  //个人头像

@property (weak, nonatomic) IBOutlet EGOImageView *personImageView;  //个人头像
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;       //个人名称
@property (weak, nonatomic) IBOutlet MyTextView *commentContextLabel;   //评论内容
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;      //评论时间
@property (nonatomic, strong) id<UserImageViewClickProtocol> imageClickDelegate; //头像点击事件代理
@property (strong, nonatomic) UIView *lineView;   //评论内容

@property (weak, nonatomic) IBOutlet UIButton *personBtn;            //个人主页按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteCommentBtn;     //删除评论按钮
@property (nonatomic, strong) id<DeleteCommentBtnClickDelegate> deleteCommentDelegate; //删除评论代理

@end

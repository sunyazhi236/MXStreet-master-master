//
//  StreetPhotoViewController.h
//  mxj
//  P7-5街拍
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageWaterView.h"
#import "JSONKit.h"

@interface StreetPhotoViewController : BaseViewController<imageViewClickDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ImageWaterView *waterView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;  //顶部背景头视图

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;  //顶部背景头视图

@property (weak, nonatomic) IBOutlet UIImageView *inviteUserImageView;  //邀请好友图标
@property (weak, nonatomic) IBOutlet UIButton *inviteUserBtn;           //邀请好友按钮

@end

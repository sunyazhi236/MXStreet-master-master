//
//  PublishViewController.h
//  mxj
//  P7-3发布街拍
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishViewController : BaseViewController<UITextViewDelegate,TencentSessionDelegate, WXApiDelegate>


@property (weak, nonatomic) IBOutlet UIButton *publishBtn;                //发布按钮
@property (strong, nonatomic) IBOutlet UIImageView *positionSetImagView;  //位置设置ImageView

@property (strong, nonatomic) IBOutlet UIImageView *localImagView;  //位置ImageView
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;     //第一张图片
@property (weak, nonatomic) IBOutlet UIButton *firstDelBtn;           //第一个删除按钮
@property (weak, nonatomic) IBOutlet UIImageView *secondeImageView;   //第二张图片
@property (weak, nonatomic) IBOutlet UIButton *secondeDelBtn;         //第二个删除按钮
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;     //第三张图片
@property (weak, nonatomic) IBOutlet UIButton *thirdDelBtn;           //第三个删除按钮
@property (weak, nonatomic) IBOutlet UIButton *addBtn;                //添加图片按钮
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;       //输入TextView

@property (nonatomic, strong) NSMutableArray *photo1PositionArray; //第一幅图片标签数组
@property (nonatomic, strong) NSMutableArray *photo2PositionArray; //第二幅图片标签数组
@property (nonatomic, strong) NSMutableArray *photo3PositionArray; //第三幅图片标签数组
@property (nonatomic, strong) NSMutableArray *photo4PositionArray; //第四幅图片标签数组
@property (nonatomic, strong) NSMutableArray *photoArray;          //待发布图片数组

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;     //位置标签

@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;        //微信按钮
@property (weak, nonatomic) IBOutlet UIButton *qZoneBtn;         //QZone按钮
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;         //微博按钮

@end

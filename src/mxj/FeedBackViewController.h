//
//  FeedBackViewController.h
//  mxj
//  P12-4意见反馈头文件
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedBackViewController : BaseViewController<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView; //反馈意见输入区域
@property (weak, nonatomic) IBOutlet UIImageView *feedBackBackImage; //背景图片
@property (weak, nonatomic) IBOutlet MyTextField *contactMethodTextField; //联系方式TextField

@end

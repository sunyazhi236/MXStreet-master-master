//
//  SignatureViewController.h
//  mxj
//  P12-1-4个性签名
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface SignatureViewController : BaseViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *signatureTextView; //文本输入区域
@property (weak, nonatomic) IBOutlet UIImageView *backImageView; //背景imageView

@end

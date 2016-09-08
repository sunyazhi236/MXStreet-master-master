//
//  EditPhotoCell.h
//  mxj
//  P7-2-2编辑照片
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPhotoCell : UITableViewCell<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *linkImageView;  //链接图标
@property (strong, nonatomic) IBOutlet UILabel *linkName;           //标签名称
@property (weak, nonatomic) IBOutlet UITextView *linkTextView;      //链接地址
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;    //底部分割线
@property (strong, nonatomic) id<UITextViewDelegate> linkTextViewDelegate; //TextView代理
@property (weak, nonatomic) IBOutlet UIImageView *rowImageView;     //cell背景

@end

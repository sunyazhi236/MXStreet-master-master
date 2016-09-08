//
//  NoticeTableCell.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/12.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;         //发布时间
@property (strong, nonatomic) IBOutlet UIImageView *lineImageView;      //下划线
@property (weak, nonatomic) IBOutlet UITextView *noticeTitleAndContext; //通知标题及内容

@end

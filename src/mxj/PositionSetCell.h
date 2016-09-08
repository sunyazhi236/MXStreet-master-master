//
//  PositionSetCell.h
//  mxj
//  P7-3-1设置位置信息用Cell
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionSetCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelName;           //位置名称
@property (strong, nonatomic) IBOutlet UIImageView *labelImageView;  //位置选中imageView
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;          //地址

//调整名称标签的位置
- (void)setLabelPostion:(BOOL)adjustPostion;

@end

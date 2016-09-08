//
//  OverSeaTableCell.h
//  mxj
//
//  Created by 齐乐乐 on 15/11/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverSeaTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameEnglishLabel;  //英文名
@property (weak, nonatomic) IBOutlet UILabel *nameChineseLabel;  //中文名
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;         //代码

@end

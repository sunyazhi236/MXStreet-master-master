//
//  CustomLabelCell.m
//  mxj
//  P7-2-3自定义标签用Cell
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "CustomLabelCell.h"

@implementation CustomLabelCell

- (void)awakeFromNib {
    // Initialization code
    self.labelName.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

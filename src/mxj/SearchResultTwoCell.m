//
//  SearchResultTwoCell.m
//  mxj
//  P7-1-1搜索结果页（2）
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "SearchResultTwoCell.h"

@implementation SearchResultTwoCell

- (void)awakeFromNib {
    [CustomUtil setImageViewCorner:_personImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

//
//  MyBeansCashCell.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyBeansCashCell.h"

@interface MyBeansCashCell ()

@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation MyBeansCashCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子显示对象
    }
    
    return self;
}

-(void)initDataWithModel:(MyBeansCashModel *)itemData{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:itemData.icon]];
        _iconView.frame = CGRectMake(15, 10, 30, 30);
        [self.contentView addSubview:_iconView];
        
        CGSize titleSize = [itemData.title sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake(SCREENWIDTH - 55, CELL_HEIGH) lineBreakMode:UILineBreakModeWordWrap];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, titleSize.width, CELL_HEIGH)];
        title.text = itemData.title;
        title.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:title];
        
        CGSize subSize = [itemData.subTitle sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(SCREENWIDTH - 65 - titleSize.width, CELL_HEIGH) lineBreakMode:UILineBreakModeWordWrap];
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(65 + titleSize.width, 0, subSize.width, CELL_HEIGH)];
        subTitle.text = itemData.subTitle;
        subTitle.font = [UIFont systemFontOfSize:13.0f];
        subTitle.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:subTitle];
    }
}

@end

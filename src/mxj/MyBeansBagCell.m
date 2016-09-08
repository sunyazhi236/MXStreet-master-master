//
//  MyBeansBagCell.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/11.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyBeansBagCell.h"

@interface MyBeansBagCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView      *bagView;

@end
@implementation MyBeansBagCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子显示对象
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)initDataWithModel:(MyBeansBagModel *)itemData{
    if (!_bagView) {
        _bagView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREENWIDTH - 30, 55)];
        _bagView.layer.borderWidth = 1;
        _bagView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _bagView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bagView];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(21, 17.5, 20, 20)];
        _icon.userInteractionEnabled = YES;
        [_bagView addSubview:_icon];
        
        UILabel *bag = [[UILabel alloc] initWithFrame:CGRectMake(_icon.frame.origin.x + 30, 0, 35, 55)];
        bag.text = @"红包";
        bag.textAlignment = NSTextAlignmentCenter;
        [_bagView addSubview:bag];
        
        CGSize beansSize = [itemData.titleText sizeWithFont:[UIFont systemFontOfSize:18.0f] maxSize:CGSizeMake(150, 30)];
        UILabel *beans = [[UILabel alloc] initWithFrame:CGRectMake(bag.frame.origin.x + bag.frame.size.width + 5, 0, beansSize.width, 55)];
        beans.text = itemData.titleText;
        beans.textColor = [UIColor colorWithHexString:@"#a3ce1e"];
        [_bagView addSubview:beans];
        
        UIImageView *beanImg = [[UIImageView alloc] initWithFrame:CGRectMake(beans.frame.origin.x + beans.frame.size.width + 5, 17, 18, 21)];
        beanImg.userInteractionEnabled = YES;
        beanImg.image = [UIImage imageNamed:@"rechargebeans"];
        [_bagView addSubview:beanImg];
        
        NSString *subStr = [NSString stringWithFormat:@"人民币:%@元",itemData.subTitle];
        CGSize subSize = [subStr sizeWithFont:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(150, 30)];
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(_bagView.frame.size.width - subSize.width - 14, 0, subSize.width, 55)];
        subTitle.text = subStr;
        subTitle.textColor = [UIColor lightGrayColor];
        subTitle.font = [UIFont systemFontOfSize:13.0f];
        [_bagView addSubview:subTitle];
    }
    
    if (itemData.type == 0) {
        _icon.image = [UIImage imageNamed:@"redbagicon"];
    }
    else if (itemData.type == 1) {
        _icon.image = [UIImage imageNamed:@"redbagicon2"];
    }
}

@end

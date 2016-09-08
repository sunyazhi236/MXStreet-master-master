//
//  MyBeansCell.m
//  mxj
//
//  Created by MQ-MacBook on 16/6/10.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "MyBeansCell.h"

@interface MyBeansCell ()

@property (nonatomic, strong) UILabel *subTitle;

@property (nonatomic, strong) MyBeansModel *itemData;

@end

@implementation MyBeansCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子显示对象
    }
    
    return self;
}

-(void)initDataWithModel:(MyBeansModel *)itemData{
    _itemData = itemData;
    
    UILabel *dayLabel = (UILabel *)[self.contentView viewWithTag:1000];
    if (!dayLabel) {
        dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 40, 14)];
    }
    dayLabel.tag = 1000;
    dayLabel.text = itemData.day;
    dayLabel.font = [UIFont systemFontOfSize:13.0f];
    dayLabel.textColor = [UIColor lightGrayColor];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:dayLabel];
    
    UILabel *timeLabel = (UILabel *)[self.contentView viewWithTag:1001];
    if (!timeLabel) {
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 29, 35, 10)];
    }
    timeLabel.tag = 1001;
    timeLabel.text = itemData.time;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:9.0f];
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:timeLabel];
    
    //判断
    NSAttributedString *content;

    NSMutableString *beansStr = [NSMutableString string];
    NSString *tmpStr = @"+";
    switch ([itemData.type integerValue]) {
        case 1:
            /* 充值 */
            content = [self recharge];
            break;
        case 2:
            /* 打赏 */
            tmpStr = @"-";
            content = [self attributedTextWithaString:[self rewardTo]];
            break;
        case 3:
            /* 发红包 */
            tmpStr = @"-";
            content = [self attributedTextWithaString:[self redPackageTo]];
            break;
        case 4:
            /* 领取红包 */
            content = [self attributedTextWithaString:[self getRedPackage]];
            break;
        case 5:
            /* 红包退回余额 */
            content = [self backRedPackage];
            break;
        case 6:
            /* 提现 */
            tmpStr = @"-";
            content = [self withdraw];
            break;
        case 7:
            /* 提现退回 */
            content = [self backWithdraw];
            break;
        case 8:
            /* 被打赏 */
            content = [self attributedTextWithaString:[self getReward]];
            break;
        case 9:
            /* 签到 */
            content = [self attributedTextWithaString:[self getSign]];
            break;
        default:
            break;
    }
    [beansStr appendFormat:@"%@", tmpStr];
    [beansStr appendFormat:@"%@毛豆", itemData.sum];

    
    CGSize beanSize = [beansStr sizeWithFont:[UIFont systemFontOfSize:17.0f] maxSize:CGSizeMake(SCREENWIDTH - 74, CELL_HEIGH)];
    
    UILabel *beansLabel = (UILabel *)[self.contentView viewWithTag:1002];
    if (!beansLabel) {
        beansLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, beanSize.width, CELL_HEIGH)];
    }
    beansLabel.tag = 1002;
    beansLabel.textColor = [UIColor colorWithHexString:@"#fb4439"];
    beansLabel.text = beansStr;
    beansLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.contentView addSubview:beansLabel];
    
    
    if (!_subTitle) {
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(80 + beanSize.width, 0, SCREENWIDTH - (90 + beanSize.width), CELL_HEIGH)];
    }
    _subTitle.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_subTitle];
    _subTitle.attributedText = content;
}


// 充值
- (NSAttributedString *)recharge
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"充值%@元", _itemData.realMoney]];

    return str;
}

// 退回的红包
- (NSAttributedString *)backRedPackage
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"红包退回返%@元", _itemData.realMoney]];
    
    return str;
}

// 提现
- (NSAttributedString *)withdraw
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"提现%@元", _itemData.realMoney]];
    
    return str;
}

- (NSAttributedString *)backWithdraw
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"提现退回%@元", _itemData.realMoney]];
    
    return str;
}

//打赏给别人
- (NSMutableString *)rewardTo
{
    NSMutableString *subTitle = [NSMutableString string];
    [subTitle appendFormat:@"打赏给 %@", _itemData.userName];
    if (![CustomUtil CheckParam:_itemData.streetsnapName]) [subTitle appendFormat:@" 图片“%@”", _itemData.streetsnapName];

    return subTitle;
}

//发红包给别人
- (NSMutableString *)redPackageTo
{
    NSMutableString *subTitle = [NSMutableString string];
    [subTitle appendFormat:@"发红包给 %@", _itemData.userName];
    if (![CustomUtil CheckParam:_itemData.streetsnapName]) [subTitle appendFormat:@" 图片“%@”", _itemData.streetsnapName];
    
    return subTitle;
}

//收到红包
- (NSMutableString *)getRedPackage
{
    NSMutableString *subTitle = [NSMutableString string];
    [subTitle appendFormat:@"收获赏，来自 %@ 的红包", _itemData.userName];
    if (![CustomUtil CheckParam:_itemData.streetsnapName]) [subTitle appendFormat:@" 图片“%@”", _itemData.streetsnapName];

    return subTitle;
}

//收获打赏
- (NSMutableString *)getReward
{
    NSMutableString *subTitle = [NSMutableString string];
    [subTitle appendFormat:@"收获赏，来自 %@ 的打赏", _itemData.userName];
    if (![CustomUtil CheckParam:_itemData.streetsnapName]) [subTitle appendFormat:@" 图片“%@”", _itemData.streetsnapName];

    return subTitle;
}

//收获来自签到
- (NSMutableString *)getSign
{
    NSMutableString *subTitle = [NSMutableString string];
    [subTitle appendFormat:@"收获赏，来自 %@ 的打赏", _itemData.userName];
    if (![CustomUtil CheckParam:_itemData.streetsnapName]) [subTitle appendFormat:@" 图片“%@”", _itemData.streetsnapName];

    return subTitle;

}

- (NSAttributedString *)attributedTextWithaString:(NSString *)aString
{
    NSString *markString = _itemData.userName;
    
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:aString];
    [attrituteString setAttributes:@{NSFontAttributeName:FONT(13), NSForegroundColorAttributeName:[UIColor blackColor]} range:[aString rangeOfString:aString]];

    NSRange range = [aString rangeOfString:markString];
    if (range.location != NSNotFound) {
        [attrituteString setAttributes:@{NSFontAttributeName:FONT(13), NSForegroundColorAttributeName:[UIColor blueColor]} range:range];
    }
    if (![CustomUtil CheckParam:markString]) {
        NSRange range2 = [aString rangeOfString:markString];
        [attrituteString setAttributes:@{NSFontAttributeName:FONT(13), NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:range2];
    }
    
    return attrituteString;
}



@end

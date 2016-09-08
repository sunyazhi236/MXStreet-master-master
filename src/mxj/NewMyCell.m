//
//  NewMyCell.m
//  mxj
//
//  Created by MQ-MacBook on 16/5/22.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "NewMyCell.h"

#define TOPHEIGH 100
#define TOPLINE  10
@interface NewMyCell ()

@property (nonatomic, strong) UIView            *headView;
@property (nonatomic, strong) UIImageView       *personImageView;
@property (nonatomic, strong) UILabel           *userNameLabel;
@property (nonatomic, strong) UILabel           *loginDayLabel;
//@property (nonatomic, strong) UIView            *userDoorIdView;
@property (nonatomic, strong) UILabel           *userDoorIdLabel;

@property (nonatomic, strong) UIImageView       *titIcon;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UILabel           *subTitle;
@property (nonatomic, strong) UIImageView       *goIcon;

@end

@implementation NewMyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子显示对象
    }
    
    return self;
}

- (void)initDataWithModel:(GetUserInfo *)itemData type:(NSInteger)type dataArray:(NSMutableArray *)dataArray{
    if (type == 0) {
        [self topView:itemData];
    }else{
        NewMyModel *model = [dataArray objectAtIndex:type - 1];
        [self selectView:model];
    }
}

-(void)topView:(GetUserInfo *)itemData{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, TOPHEIGH)];
        _headView.backgroundColor = [UIColor whiteColor];
        
//        CGSize titleSize = [itemData.userName sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(SCREENWIDTH - 90, TOPHEIGH) lineBreakMode:UILineBreakModeWordWrap];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 90, 20, 100, 21)];
        _userNameLabel.text = itemData.userName;
        _userNameLabel.font = [UIFont systemFontOfSize:17.0f];
        [_headView addSubview:_userNameLabel];
        
        _loginDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.frame.origin.x + _userNameLabel.frame.size.width + 10, 15, 100, 30)];
//        [LoginModel shareInstance].loginDays = [NSString stringWithFormat:@"%d", [[LoginModel shareInstance].loginDays intValue]];
        _loginDayLabel.text = [NSString stringWithFormat:@"已连续签到%@天", [LoginModel shareInstance].loginDays];
        if ([[LoginModel shareInstance].loginDays intValue] == 0) {
            _loginDayLabel.text = @"";
        }
        if ([[LoginModel shareInstance].loginDays intValue] == 1) {
            _loginDayLabel.text = [NSString stringWithFormat:@"连续签到%@天", [LoginModel shareInstance].loginDays];
         
        }
        _loginDayLabel.textColor = [UIColor grayColor];
        _loginDayLabel.font = [UIFont systemFontOfSize:13.0f];
        [_headView addSubview:_loginDayLabel];
        
//        CGSize doorSize = [[NSString stringWithFormat:@"门牌号：%@", itemData.userDoorId] sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(_userNameLabel.frame.origin.x + 5, TOPHEIGH) lineBreakMode:UILineBreakModeWordWrap];
//        itemData.userDoorId = @"12345678901234567";
        CGSize doorSize = [[NSString stringWithFormat:@"门牌号：%@", itemData.userDoorId] sizeWithFont:[UIFont systemFontOfSize:13.0f] maxSize:CGSizeMake(SCREENWIDTH - _userNameLabel.frame.origin.x, 14)];
        UIImageView *numberView = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:@"door"];
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        img = [img resizableImageWithCapInsets:insets];

        numberView.image = img;
        
        numberView.frame = CGRectMake(_userNameLabel.frame.origin.x + 5, _userNameLabel.frame.origin.y + _userNameLabel.frame.size.height + 15, doorSize.width + 30, doorSize.height + 10);
        
//        _userDoorIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.frame.origin.x + 5, _userNameLabel.frame.origin.y + titleSize.height + 15, doorSize.width + 20, doorSize.height)];
        _userDoorIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, doorSize.width, doorSize.height + 10)];
        _userDoorIdLabel.text = [NSString stringWithFormat:@"门牌号：%@", itemData.userDoorId];
        _userDoorIdLabel.font = [UIFont systemFontOfSize:13.0f];
        _userDoorIdLabel.textColor = [UIColor whiteColor];
//        numberView.backgroundColor = [UIColor colorWithHexString:@"#ED635D"];
        _userDoorIdLabel.textAlignment = NSTextAlignmentCenter;
//        [_headView addSubview:_userDoorIdLabel];
        [numberView addSubview:_userDoorIdLabel];
        [_headView addSubview:numberView];

        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, TOPHEIGH - TOPLINE, SCREENHEIGHT, TOPLINE)];
        topLine.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        [_headView addSubview:topLine];
        
        NSURL *imageUrl = [CustomUtil getPhotoURL:itemData.image];
        _personImageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        _personImageView.image = image;
        _personImageView.frame = CGRectMake(10, 10, 70, 70);
        _personImageView.layer.masksToBounds =YES;
        _personImageView.layer.cornerRadius =35;
        _personImageView.backgroundColor = [UIColor redColor];
        [_headView addSubview:_personImageView];
        [self.contentView addSubview:_headView];
    }
}

-(void)selectView:(NewMyModel *)model{
    if (!_titIcon) {
        _titIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:model.titImg]];
        _titIcon.frame = CGRectMake(10, 6, 30, 30);
        [self.contentView addSubview:_titIcon];
        
        //    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],};
        //    NSString *str = model.titleText;
        //    CGSize textSize = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        CGSize textSize = [model.titleText sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(SCREENWIDTH - 50, 44) lineBreakMode:NSLineBreakByWordWrapping];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, textSize.width, 44)];
        _titleLabel.text = model.titleText;
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_titleLabel];
        
        _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + 10, 0, 150, 44)];
        _subTitle.text = model.subTitle;
        _subTitle.font = [UIFont systemFontOfSize:13.0f];
        _subTitle.textColor = [UIColor grayColor];
        [self.contentView addSubview:_subTitle];
    }
}
@end

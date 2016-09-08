//
//  WithdrawCashViewController.m
//  mxj
//
//  Created by shanpengtao on 16/7/25.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "WithdrawCashViewController.h"

@interface WithdrawCashViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accountTextField;

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIImageView *headTitleView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *bgBeansView;

@property (nonatomic, strong) UILabel *beansLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation WithdrawCashViewController

- (instancetype)initWithSum:(NSInteger)sum
{
    self = [super init];
    if (self) {
        _sum = sum;

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatView
{
    
    self.title = @"提现到支付宝账号";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    
    [self leftBtnWithTitle];
    
    UILabel *accountLabel = [[UILabel alloc] init];
    accountLabel.text = @"账号";
    accountLabel.frame = CGRectMake(0, 0, 80, 50);
    accountLabel.font = [UIFont systemFontOfSize:15.0f];
    accountLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    accountLabel.textAlignment = NSTextAlignmentCenter;

    _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    _accountTextField.delegate = self;
    _accountTextField.leftView = accountLabel;
    _accountTextField.leftViewMode = UITextFieldViewModeAlways;
    [_accountTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [_accountTextField setReturnKeyType:UIReturnKeyNext];
    _accountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _accountTextField.textAlignment = NSTextAlignmentLeft;
    _accountTextField.placeholder = @"请输入支付宝账号（邮箱或手机）";
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountTextField.font = [UIFont systemFontOfSize:15.0];
    _accountTextField.backgroundColor = [UIColor whiteColor];
    [_accountTextField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_accountTextField];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, GetBottom(_accountTextField), SCREENWIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.view addSubview:lineView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, 0, 80, 50);
    nameLabel.text = @"姓名";
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, GetBottom(lineView), SCREENWIDTH, 50)];
    _nameTextField.delegate = self;
    _nameTextField.leftView = nameLabel;
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    _nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameTextField.textAlignment = NSTextAlignmentLeft;
    _nameTextField.placeholder = @"请输入你的真实姓名";
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTextField.font = [UIFont systemFontOfSize:15.0];
    _nameTextField.backgroundColor = [UIColor whiteColor];
    [_nameTextField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_nameTextField];
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, GetBottom(_nameTextField), SCREENWIDTH, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self.view addSubview:lineView2];

    [self.view addSubview:self.headView];
    
    
    NSString *aStr = @"注意：\n1、提现金额将由毛线街打款到您的支付宝账户；\n2、提现将于次日到账；\n3、如提现失败，毛豆将会在48小时内退回到您的账户；";

    UIFont *font = FONT(14);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:aStr attributes:attributes];
    
    [attStr setAttributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor blackColor], NSParagraphStyleAttributeName : paragraphStyle.copy} range:[aStr rangeOfString:aStr]];

    CGSize size = [attStr.string boundingRectWithSize:CGSizeMake(SCREENWIDTH, SCREENHEIGHT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.frame = CGRectMake(15, GetBottom(self.headView) + 20, SCREENWIDTH - 30, size.height);
    [textLab setAttributedText:attStr];
    textLab.numberOfLines = 0;
    [textLab setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:textLab];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(25, MainViewHeight - 85, SCREENWIDTH - 50, 50);
    button.backgroundColor = [UIColor colorWithHexString:@"#e84335"];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(withdraw:) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setCornerRadius:25];
    [self.view addSubview:button];
}

//导航栏返回按钮标题
-(void)leftBtnWithTitle{
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    [leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = rightBarButton;
}

- (UIView *)headView{
    if (!_headView) {
        
        CGFloat paddingX = (SCREENWIDTH - 300)/2;
        
        _headView = [[UIView alloc] initWithFrame:CGRectMake(paddingX, GetBottom(_nameTextField) + 20, 300, 135)];
        _headView.layer.cornerRadius = 5;
        _headView.layer.masksToBounds = YES;
        _headView.backgroundColor = [UIColor whiteColor];
        
        _headTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GetWidth(_headView), 45)];
        _headTitleView.backgroundColor = [UIColor colorWithHexString:@"ee3e2f"];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GetWidth(_headView), 45)];
        _titleLabel.text = @"本次提现";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = [UIColor whiteColor];
        [_headTitleView addSubview:_titleLabel];
        [_headView addSubview:_headTitleView];
        
        _bgBeansView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59 , GetWidth(_headView), 62)];
//        _bgBeansView.image = [UIImage imageNamed:@"bgbeans"];
        
        
        NSString *beansStr = [NSString stringWithFormat:@"%ld",(long)_sum];
        CGSize beansSize = [beansStr sizeWithFont:[UIFont fontWithName:@"ArialMT" size:26.0f] maxSize:CGSizeMake(_bgBeansView.frame.size.width, 24)];
        NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f",_sum/100.0];
        CGSize moneySize = [moneyStr sizeWithFont:[UIFont fontWithName:@"ArialMT" size:26.0f] maxSize:CGSizeMake(_bgBeansView.frame.size.width, 24)];
        
        UIImageView *beans = [[UIImageView alloc] initWithFrame:CGRectMake(_bgBeansView.frame.size.width/2 - (beansSize.width + moneySize.width + 35)/2 - 7.5, 13.5, 30, 35)];
        beans.image = [UIImage imageNamed:@"beans"];
        [_bgBeansView addSubview:beans];
        
        _beansLabel = [[UILabel alloc] initWithFrame:CGRectMake(beans.frame.origin.x + beans.frame.size.width + 5, _bgBeansView.frame.size.height/2 - beansSize.height/2,beansSize.width, beansSize.height)];
        _beansLabel.text = beansStr;
        _beansLabel.font = [UIFont fontWithName:@"ArialMT" size:26.0f];
        _beansLabel.textColor = [UIColor colorWithHexString:@"#a3ce1e"];
        [_bgBeansView addSubview:_beansLabel];
        
        UILabel *plus = [[UILabel alloc] initWithFrame:CGRectMake(_beansLabel.frame.origin.x + _beansLabel.frame.size.width + 5, 20, 10, 24)];
        plus.text = @"=";
        [_bgBeansView addSubview:plus];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(plus.frame.origin.x + plus.frame.size.width + 5, _bgBeansView.frame.size.height/2 - moneySize.height/2, moneySize.width, moneySize.height)];
        _moneyLabel.text = moneyStr;
        _moneyLabel.font = [UIFont fontWithName:@"ArialMT" size:26.0f];
        _moneyLabel.textColor = [UIColor colorWithHexString:@"#e70b0b"];
        [_bgBeansView addSubview:_moneyLabel];
        
        [_headView addSubview:_bgBeansView];
    }
    
    return _headView;
}

#pragma mark - notification

- (void)keyboardWillHide:(NSNotification *)note{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (void)keyboardWillShow:(NSNotification *)note{
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, - 100.0f);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _accountTextField) {
        [_nameTextField becomeFirstResponder];
    }
    else if (textField == _nameTextField) {
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - ButtonAction

/**
 *  提现
 */
- (void)withdraw:(id)sender
{
    if (_sum < 10 * 100) {
        [CustomUtil showToast:@"满10元才可提现哦！" view:self.view];
        return;
    }
    
    if (_accountTextField.text.length == 0) {
        [CustomUtil showToast:@"账号不能为空！" view:self.view];
        return;
    }
    
    if (_nameTextField.text.length == 0) {
        [CustomUtil showToast:@"姓名不能为空！" view:self.view];
        return;
    }
    
    
    [CustomUtil showLoading:@""];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[LoginModel shareInstance].userId forKey:@"userId"];
    [dict setValue:_accountTextField.text forKey:@"txAccount"];
    [dict setValue:_nameTextField.text forKey:@"txName"];
    [dict setValue:@(_sum) forKey:@"sum"];

    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/withdrawApply" param:dict successBlock:^(NSDictionary *responseDict) {
        NSLog(@"withdrawApply：%@",responseDict);
        
        if ([[responseDict objectForKey:@"code"] integerValue] == 1) {
            [CustomUtil showToast:@"操作成功" view:kWindow];
            
            if (_aBlock) {
                _aBlock();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
//            [self initData];
        }
        else {
            [CustomUtil showToast:@"操作失败" view:self.view];
        }
    }failedBlock:^(NSError *err) {
        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
    }];
    
}


//返回按钮的点击事件处理
-(void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_nameTextField resignFirstResponder];
    
    [_accountTextField resignFirstResponder];
}

@end

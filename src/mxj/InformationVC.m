//
//  InformationVC.m
//  mxj
//
//  Created by MQ-MacBook on 16/5/15.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "InformationVC.h"
#import "Macro.h"
#import "LineTextField.h"
#import "GotoPhotoVC.h"
#import "OwnAreaViewController.h"

#import "UserProtocolViewController.h"
#import "SetAccountViewController.h"
#import "OwnAreaViewController.h"

#import "TabBarController.h"
#import "MainPageTabBarController.h"

#define kMinLength 4    //最小字符长度
#define kMaxLength 30   //最大字符长度

@interface InformationVC () <UITextFieldDelegate, GotoPhotoDelegate>
{
    BOOL isSex;
    UIDatePicker *datePicker; //时间选择器
    UIToolbar *pickerDateToolbar; //时间选择器工具栏
}

@property (nonatomic, strong) UILabel               *logoLabel;
//@property (nonatomic, strong) UIButton              *headButton;
@property (nonatomic, strong) UIImageView              *headButton;
@property (nonatomic, strong) LineTextField         *nameTextField;
@property (nonatomic, strong) LineTextField         *birthdayTextField;
@property (nonatomic, strong) LineTextField         *addressTextField;
@property (nonatomic, strong) UIButton              *nvButton;
@property (nonatomic, strong) UIButton              *nanButton;
@property (nonatomic, strong) UIButton              *registerButton;
@property (nonatomic, strong) UIButton              *birthdayButton;
@property (nonatomic, strong) UIButton              *addressButton;

@end

@implementation InformationVC

#pragma viewLife
-(void)viewWillAppear:(BOOL)animated
{
    //注册键盘通知
    [[CustomUtil shareInstance] registerKeyBoardNotification];
    [CustomUtil shareInstance].view = self.view;
    
    NSString *countryStr = [TKPostion shareInstance].countryName;
    NSString *provinceStr = [TKPostion shareInstance].provinceName;
    NSString *cityNameStr = [TKPostion shareInstance].cityName;
    NSString *arearNameStr = @"";
    if ([CustomUtil CheckParam:countryStr] && [CustomUtil CheckParam:provinceStr] && [CustomUtil CheckParam:cityNameStr]) {
        arearNameStr = nil;
    }
    
    if (![CustomUtil CheckParam:cityNameStr]) {
        arearNameStr = cityNameStr;
    }
    
    if (![CustomUtil CheckParam:countryStr]) {
        if (![countryStr isEqualToString:@"中国"]) {
            arearNameStr = countryStr;
        }
    }
    
    _addressTextField.text = arearNameStr;
    
    if (arearNameStr == nil || [arearNameStr isEqualToString:@""]) {
        [CustomUtil getLocationInfo:^(AMapLocationReGeocode *regoCode, CLLocation *position) {
            //获取当前城市
            if ([CustomUtil CheckParam:regoCode.city]) {
                [TKLoginPosition shareInstance].cityName = regoCode.province;
            } else {
                [TKLoginPosition shareInstance].cityName = regoCode.city;
            }
        }];
        _addressTextField.text = [TKLoginPosition shareInstance].cityName;
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self initView];
}

#pragma initView
-(void)initView{
    _logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, SCREENWIDTH, 40)];
    _logoLabel.numberOfLines = 2;
    _logoLabel.text = @"恭喜你注册成功！\n现在花费你一分钟完善资料";
    _logoLabel.textColor = [UIColor colorWithHexString:@"#E7443A"];
    _logoLabel.font = [UIFont systemFontOfSize:14.0f];
    _logoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_logoLabel];
    
    //    _headButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    _headButton.frame = CGRectMake(SCREENWIDTH/2 - 40, 80, 80, 80);
    //    [_headButton setBackgroundImage: [UIImage imageNamed: @"headImg"] forState: UIControlStateNormal];
    //    [_headButton addTarget:self action:@selector(headOnClick) forControlEvents:UIControlEventTouchUpInside];
    _headButton = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 40, 80, 80, 80)];
    [_headButton setImage:[UIImage imageNamed:@"headImg"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headOnClick)];
    [_headButton setUserInteractionEnabled:YES];
    [_headButton addGestureRecognizer:tapGesture];
    [self.view addSubview:_headButton];
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 30, 165, 60, 20)];
    headLabel.text = @"请上传照片";
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
    headLabel.font = [UIFont systemFontOfSize:11.0f];
    [self.view addSubview:headLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 200, 40, 30)];
    nameLabel.text = @"昵称";
    nameLabel.font = [UIFont systemFontOfSize:13.0f];
    nameLabel.textColor = [UIColor colorWithHexString:@"a3a3a3"];
    [self.view addSubview:nameLabel];
    _nameTextField = [[LineTextField alloc] initWithFrame:CGRectMake(55, 200, SCREENWIDTH - 110, 30)];
    [_nameTextField setBackgroundColor:[UIColor clearColor]];
    _nameTextField.layer.cornerRadius = 2;
    _nameTextField.placeholder = @"请输入昵称";
    _nameTextField.font = [UIFont systemFontOfSize:13.0f];
    [_nameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_nameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _nameTextField.layer.borderColor = [[UIColor clearColor] CGColor];
    _nameTextField.delegate = self;
    [self.view addSubview:_nameTextField];
    
//    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 220, 40, 30)];
//    birthdayLabel.text = @"生日";
//    birthdayLabel.font = [UIFont systemFontOfSize:13.0f];
//    birthdayLabel.textColor = [UIColor colorWithHexString:@"a3a3a3"];
//    [self.view addSubview:birthdayLabel];
//    _birthdayTextField = [[LineTextField alloc] initWithFrame:CGRectMake(55, 220, SCREENWIDTH - 110, 30)];
//    [_birthdayTextField setBackgroundColor:[UIColor clearColor]];
//    _birthdayTextField.layer.cornerRadius = 2;
//    _birthdayTextField.placeholder = @"请输入生日";
//    _birthdayTextField.font = [UIFont systemFontOfSize:13.0f];
//    [_birthdayTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
//    [_birthdayTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//    _birthdayTextField.layer.borderColor = [[UIColor clearColor] CGColor];
//    _birthdayTextField.userInteractionEnabled = NO;
//    _birthdayTextField.delegate = self;
//    [self.view addSubview:_birthdayTextField];
//    
//    _birthdayButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _birthdayButton.frame = CGRectMake(85, 220, SCREENWIDTH - 140, 30);
//    _birthdayButton.backgroundColor = [UIColor clearColor];
//    [_birthdayButton addTarget:self action:@selector(birthdayOnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_birthdayButton];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 245, 40, 30)];
    addressLabel.text = @"地区";
    addressLabel.font = [UIFont systemFontOfSize:13.0f];
    addressLabel.textColor = [UIColor colorWithHexString:@"a3a3a3"];
    [self.view addSubview:addressLabel];
    _addressTextField = [[LineTextField alloc] initWithFrame:CGRectMake(55, 245, SCREENWIDTH - 110, 30)];
    [_addressTextField setBackgroundColor:[UIColor clearColor]];
    _addressTextField.layer.cornerRadius = 2;
    _addressTextField.placeholder = @"请选择地区";
    _addressTextField.font = [UIFont systemFontOfSize:13.0f];
    [_addressTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_addressTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _addressTextField.layer.borderColor = [[UIColor clearColor] CGColor];
    _addressTextField.delegate = self;
    _addressTextField.userInteractionEnabled = NO;
    if ([TKLoginPosition shareInstance].cityName != nil && ![[TKLoginPosition shareInstance].cityName isEqualToString:@""]) {
        _addressTextField.placeholder = nil;
        _addressTextField.text = [TKLoginPosition shareInstance].cityName;
    }
    [self.view addSubview:_addressTextField];
    
    _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressButton.frame = CGRectMake(85, 255, SCREENWIDTH - 140, 30);
    _addressButton.backgroundColor = [UIColor clearColor];
    [_addressButton addTarget:self action:@selector(addressOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addressButton];
    
    UIView *lineleft = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 75, 310, 50, 0.5)];
    lineleft.backgroundColor = [UIColor colorWithHexString:@"#a3a3a3"];
    [self.view addSubview:lineleft];
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lineleft.frame.origin.y - 15, SCREENWIDTH, 30)];
    titLabel.text = @"性别";
    titLabel.textColor=[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
    titLabel.font = [UIFont systemFontOfSize:14.0f];
    titLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titLabel];
    UIView *lineright = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH - lineleft.frame.origin.x - 50, lineleft.frame.origin.y, 50, 0.5)];
    lineright.backgroundColor = [UIColor colorWithHexString:@"#a3a3a3"];
    [self.view addSubview:lineright];
    
    _nvButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nvButton.frame = CGRectMake(SCREENWIDTH/2 - 80, lineleft.frame.origin.y + 12, 55, 55);
    [_nvButton setBackgroundImage: [UIImage imageNamed:@"nv1"] forState: UIControlStateNormal];
    isSex = YES;
    [_nvButton addTarget:self action:@selector(sexOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nvButton];
    _nanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nanButton.frame = CGRectMake(SCREENWIDTH/2 + 25, lineleft.frame.origin.y + 12, 55, 55);
    [_nanButton setBackgroundImage: [UIImage imageNamed:@"nan2"] forState: UIControlStateNormal];
    [_nanButton addTarget:self action:@selector(sexOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nanButton];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _registerButton.frame = CGRectMake(55, lineleft.frame.origin.y + 90, SCREENWIDTH - 110, 40);
    _registerButton.backgroundColor = [UIColor colorWithRed:204.0/255 green:48.0/255 blue:49.0/255 alpha:1.0f];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setTintColor:[UIColor whiteColor]];
    _registerButton.layer.cornerRadius = 20;
    [_registerButton addTarget:self action:@selector(registerOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
}

#pragma Action
-(void)sexOnClick{
    if (isSex == YES) {
        [_nvButton setBackgroundImage: [UIImage imageNamed:@"nv2"] forState: UIControlStateNormal];
        [_nanButton setBackgroundImage: [UIImage imageNamed:@"nan1"] forState: UIControlStateNormal];
        isSex = NO;
    }else{
        [_nvButton setBackgroundImage: [UIImage imageNamed:@"nv1"] forState: UIControlStateNormal];
        [_nanButton setBackgroundImage: [UIImage imageNamed:@"nan2"] forState: UIControlStateNormal];
        isSex = YES;
    }
}

-(void)registerOnClick{
    //参数判断
    if ([CustomUtil CheckParam:_nameTextField.text]) {
        [CustomUtil showToastWithText:@"请输入昵称" view:kWindow];
        return;
    }
    //判断字符串长度是否符合要求
    BOOL isInputValid = [CustomUtil isInputStrValid:_nameTextField.text minLength:kMinLength maxLength:kMaxLength];
    if (!isInputValid) {
        return;
    }
    
    if ([CustomUtil CheckParam:_addressTextField.text] ||
        [_addressTextField.text isEqualToString:@"请选择地区"]) {
        [CustomUtil showToastWithText:@"请选择地区" view:kWindow];
        return;
    }
    
    //保存输入参数
    [RegisterInput shareInstance].userName = _nameTextField.text;
    if (isSex) {
        [RegisterInput shareInstance].sex = @"女";
    } else {
        [RegisterInput shareInstance].sex = @"男";
    }
    [RegisterInput shareInstance].source = @"2"; //默认为手机注册
    
    //调用注册接口进行注册
    [RegisterInput shareInstance].phoneType = @"0"; //1：安卓 0：iOS
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[RegisterInput shareInstance]];
    [[NetInterface shareInstance] registerUser:@"register" param:dict successBlock:^(NSDictionary *responseDict) {
        RegisterModel *returnData = [RegisterModel modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) { //注册成功
            //调用登录接口
            [LoginInput shareInstance].phoneNumber = [RegisterInput shareInstance].phoneNumber;
            [LoginInput shareInstance].userPassword = [RegisterInput shareInstance].userPassword;
            [LoginInput shareInstance].qqNumber = @"";
            [LoginInput shareInstance].webchatId = @"";
            [LoginInput shareInstance].sinaBlog = @"";
            [LoginInput shareInstance].registerId = [LoginModel shareInstance].registerId;
            [LoginInput shareInstance].phoneType = @"0";
            // app版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            [LoginInput shareInstance].verison=app_Version;
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[LoginInput shareInstance]];
            [CustomUtil showLoading:@"正在登录中..."];
            [[NetInterface shareInstance] login:@"login" param:dict successBlock:^(NSDictionary *responseDict) {
                LoginModel *returnData = [LoginModel modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    //跳转至主页
                    TabBarController *tabBarCtrl = [[TabBarController alloc] initWithNibName:@"TabBarController" bundle:nil];
                    MainPageTabBarController *viewCtrl = [[tabBarCtrl viewControllers] objectAtIndexCheck:0];
                    viewCtrl.loginFlag = YES;
                    [self.navigationController pushViewController:tabBarCtrl animated:YES];
                } else {
                    [CustomUtil showToastWithText:returnData.msg view:self.view];
                }
            } failedBlock:^(NSError *err) {
            }];
        } else { //注册失败
            [CustomUtil showCustomAlertView:@"提示" message:returnData.msg leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        }
    } failedBlock:^(NSError *err) {
    }];
    
}

-(void)headOnClick{
    [self ifDatePicker];
    
    GotoPhotoVC *vc = [[GotoPhotoVC alloc] init];
    vc.photoDelegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    self.definesPresentationContext = YES; //self is presenting view controller
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)birthdayOnClick{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (!datePicker) {
        if (!datePicker) {
            pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        }
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        CGRect datePickerFrame = datePicker.frame;
        datePickerFrame.size.width = SCREEN_WIDTH;
        datePickerFrame.origin.y = SCREEN_HEIGHT - datePickerFrame.size.height - pickerDateToolbar.frame.size.height;
        datePicker.frame = datePickerFrame;
        datePickerFrame = pickerDateToolbar.frame;
        datePickerFrame.origin.y = datePicker.frame.origin.y - pickerDateToolbar.frame.size.height;
        pickerDateToolbar.frame = datePickerFrame;
        pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerDateToolbar sizeToFit];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonSystemItemCancel target:self action:@selector(toolBarCancelClick)];
        [barItems addObject:cancelBtn];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(toolBarDoneClick)];
        [barItems addObject:doneBtn];
        [pickerDateToolbar setItems:barItems animated:YES];
        [pickerDateToolbar setBackgroundImage:[UIImage imageNamed:@"bg.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [pickerDateToolbar setTintColor:[UIColor lightGrayColor]];
        
        [self.view addSubview:pickerDateToolbar];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSString *miniDateStr = @"1900-01-01 00:00:00";
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *minDate = [formate dateFromString:miniDateStr];
        NSString *maxDateStr = [formate stringFromDate:[NSDate date]];
        NSDate *maxDate = [formate dateFromString:maxDateStr];
        datePicker.minimumDate = minDate;
        datePicker.maximumDate = maxDate;
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:datePicker];
    } else {
        [datePicker setHidden:(!datePicker.hidden)];
        [pickerDateToolbar setHidden:(!pickerDateToolbar.hidden)];
    }
}

-(void)addressOnClick{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self ifDatePicker];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //跳转至P12-1-3所在地区界面
    OwnAreaViewController *ownAreaViewCtrl = [[OwnAreaViewController alloc] initWithNibName:@"OwnAreaViewController" bundle:nil];
    ownAreaViewCtrl.intoFlag = 2; //注册进入
    [self.navigationController pushViewController:ownAreaViewCtrl animated:YES];
}

//picker取消按钮点击
-(void)toolBarCancelClick
{
    [datePicker setHidden:YES];
    [pickerDateToolbar setHidden:YES];
}

-(void)toolBarDoneClick{
    NSDate *selectDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:selectDate];
    //更新出生日期
    _birthdayTextField.text = dateStr;
    [datePicker setHidden:YES];
    [pickerDateToolbar setHidden:YES];
}

//通过触摸背景关闭键盘
- (IBAction) backgroundTap:(id)sender
{
//    [_nameTextField resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self ifDatePicker];
}

- (void)ifDatePicker{
    if (!datePicker.hidden && !pickerDateToolbar.hidden) {
        [self toolBarCancelClick];
    }
}

#pragma delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [textField resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self ifDatePicker];
}

- (void)setImage:(UIImage *)setImage{
    _headButton.layer.masksToBounds=YES;
    _headButton.layer.cornerRadius=40.0f;
    [_headButton setImage:setImage];
}
@end

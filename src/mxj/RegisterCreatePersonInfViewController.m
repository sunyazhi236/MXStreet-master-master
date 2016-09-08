//
//  RegisterCreatePersonInfViewController.m
//  mxj
//  P4-1注册-创建个人资料ViewController实现文件
//  Created by 齐乐乐 on 15/11/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
#define kMinLength 4    //最小字符长度
#define kMaxLength 30   //最大字符长度

#import "RegisterCreatePersonInfViewController.h"
#import "UserProtocolViewController.h"
#import "SetAccountViewController.h"
#import "OwnAreaViewController.h"

@interface RegisterCreatePersonInfViewController ()
{
    BOOL sexFlag; //性别标识  YES:男 NO:女
    UIImagePickerController *imagePickerCtrl; //照片及相册控件
    NSString *personImagePath;    //个人头像本地路径
}

@end

@implementation RegisterCreatePersonInfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameField.delegate = self;
    _storeName.delegate = self;
    
    sexFlag = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaLabelClick)];
    [_areaLabel setUserInteractionEnabled:YES];
    [_areaLabel addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personImageClick:)];
    [_personImageView setUserInteractionEnabled:YES];
    [_personImageView addGestureRecognizer:tapGesture];
    [_uploadPhotoView setHidden:YES];
    
    imagePickerCtrl = [[UIImagePickerController alloc] init];
    [CustomUtil setImageViewCorner:_personImageView];
    [RegisterInput shareInstance].country = @"";
    [RegisterInput shareInstance].province = @"";
    [RegisterInput shareInstance].city = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    //设置导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //设置导航栏标题
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationItem setTitle:@"创建个人资料1/3"];
    //设置导航栏右上角的下一步按钮
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnClick)];
    [nextBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = nextBtn;
    
    //注册键盘通知
    [[CustomUtil shareInstance] registerKeyBoardNotification];
    [CustomUtil shareInstance].view = self.view;
    
    NSString *countryStr = [TKPostion shareInstance].countryName;
    NSString *provinceStr = [TKPostion shareInstance].provinceName;
    NSString *cityNameStr = [TKPostion shareInstance].cityName;
    NSString *arearNameStr = @"";
    if ([CustomUtil CheckParam:countryStr] && [CustomUtil CheckParam:provinceStr] && [CustomUtil CheckParam:cityNameStr]) {
        arearNameStr = @"请选择地区";
    }
    
    if (![CustomUtil CheckParam:cityNameStr]) {
        arearNameStr = cityNameStr;
    }
    
    if (![CustomUtil CheckParam:countryStr]) {
        if (![countryStr isEqualToString:@"中国"]) {
            arearNameStr = countryStr;
        }
    }
    
    [_areaLabel setText:arearNameStr];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除键盘通知
    [[CustomUtil shareInstance] removeKeyBoardNotification];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_nameField];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:_nameField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        } else {
            
        }
    } else {
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}
*/
        
#pragma mark -按钮点击事件处理
//下一步按钮的点击事件
-(void)nextBtnClick
{
    //参数判断
    if ([CustomUtil CheckParam:_nameField.text]) {
        [CustomUtil showToastWithText:@"请输入昵称" view:kWindow];
        return;
    }
    //判断字符串长度是否符合要求
    BOOL isInputValid = [CustomUtil isInputStrValid:_nameField.text minLength:kMinLength maxLength:kMaxLength];
    if (!isInputValid) {
        return;
    }
    
    if ([CustomUtil CheckParam:_areaLabel.text] ||
        [_areaLabel.text isEqualToString:@"请选择地区"]) {
        [CustomUtil showToastWithText:@"请选择地区" view:kWindow];
        return;
    }
    
    //保存输入参数
    [RegisterInput shareInstance].userName = _nameField.text;
    if (sexFlag) {
        [RegisterInput shareInstance].sex = @"男";
    } else {
        [RegisterInput shareInstance].sex = @"女";
    }
    [RegisterInput shareInstance].store = _storeName.text;
    [RegisterInput shareInstance].source = @"2"; //默认为手机注册
    
    //跳转至下一步界面
    SetAccountViewController *setAccountViewCtrl = [[SetAccountViewController alloc] initWithNibName:@"SetAccountViewController" bundle:nil];
    [self.navigationController pushViewController:setAccountViewCtrl animated:YES];
}

//用户协议按钮点击事件
- (IBAction)userProtocolBtnClick:(id)sender {
    UserProtocolViewController *userProtocolViewCtrl = [[UserProtocolViewController alloc] initWithNibName:@"UserProtocolViewController" bundle:nil];
    [self.navigationController pushViewController:userProtocolViewCtrl animated:YES];
}

//男性按钮点击事件
- (IBAction)manBtnClick:(id)sender {
    [_manBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    [_womenBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    sexFlag = YES;
}

//女性按钮点击事件
- (IBAction)womenBtnClick:(id)sender {
    [_manBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [_womenBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    sexFlag = NO;
}

//地区Label点击事件
-(void)areaLabelClick
{
    [_nameField resignFirstResponder];
    //跳转至P12-1-3所在地区界面
    OwnAreaViewController *ownAreaViewCtrl = [[OwnAreaViewController alloc] initWithNibName:@"OwnAreaViewController" bundle:nil];
    ownAreaViewCtrl.intoFlag = 2; //注册进入
    [self.navigationController pushViewController:ownAreaViewCtrl animated:YES];
}

//打开相册按钮点击事件
- (IBAction)openPhotoLibBtnClick:(id)sender {
    [imagePickerCtrl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePickerCtrl.delegate = self;
    imagePickerCtrl.allowsEditing = YES;
    
    [self.navigationController presentViewController:imagePickerCtrl animated:YES completion:nil];
}

//打开相机按钮事件
- (IBAction)openCameraBtnClick:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [CustomUtil showCustomAlertView:nil message:@"设备不支持拍照" leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        return;
    }
    [imagePickerCtrl setSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePickerCtrl.delegate = self;
    imagePickerCtrl.allowsEditing = YES;
    [self.navigationController presentViewController:imagePickerCtrl animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [imagePickerCtrl dismissViewControllerAnimated:YES completion:nil];
    //保存图片到沙盒
    [CustomUtil saveImageToSandBox:info fileName:@"registerUser.jpg" block:^(UIImage *sandBoxImage, NSString *filePath) {
        //设置个人头像
        [_personImageView setImage:sandBoxImage];
        personImagePath = filePath;
        [RegisterInput shareInstance].image = personImagePath;
    }];
    [_uploadPhotoView setHidden:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_uploadPhotoView setHidden:YES];
    [imagePickerCtrl dismissViewControllerAnimated:YES completion:nil];
}

//取消按钮点击事件
- (IBAction)cancelBtnClick:(id)sender {
    [_uploadPhotoView setHidden:YES];
}

//头像点击事件
- (void)personImageClick:(id)sender
{
    //调整头像选择视图的布局
    CGRect rect = _uploadPhotoView.frame;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT;
    _uploadPhotoView.frame = rect;
    [self.view addSubview:_uploadPhotoView];
    [_uploadPhotoView setHidden:NO];
}

#pragma mark -TextField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameField) {
        [_nameField resignFirstResponder];
    }
    
    if (textField == _storeName) {
        [_storeName resignFirstResponder];
    }
    
    return YES;
}

/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _nameField) {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([toBeString length] > kMaxLength) {
            textField.text = [toBeString substringToIndex:16];
            [CustomUtil showToastWithText:@"最多输入16个字符" view:kWindow];
            return NO;
        }
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    
    return YES;
}
 */

@end

//
//  PersonDocViewController.m
//  mxj
//  P12-1个人资料
//  Created by 齐乐乐 on 15/11/17.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PersonDocViewController.h"
#import "NickNameViewController.h"
#import "SexSetViewController.h"
#import "OwnAreaViewController.h"
#import "StoreSetViewController.h"
#import "SignatureViewController.h"
#import "MyStreetPhotoViewController.h"

@interface PersonDocViewController ()
{
    UIDatePicker *datePicker; //时间选择器
    UIToolbar *pickerDateToolbar; //时间选择器工具栏
}

@end

@implementation PersonDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"编辑资料"];
    self.personDocTableView.delegate = self;
    self.personDocTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [datePicker setHidden:YES];
    [pickerDateToolbar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.row) {
        case 0:
            return 79.5;
            break;
        case 6:
        {
            if ([_queryUserId isEqualToString:[LoginModel shareInstance].userId]) { //查询当前登录用户
                if (![CustomUtil CheckParam:[GetUserInfo shareInstance].userSign]) {
                    CGRect rect = _personSign.frame;
                    //获取用户签名的文字高度
                    rect.size.height = [CustomUtil heightForString:[GetUserInfo shareInstance].userSign fontSize:15.0f andWidth:(SCREEN_WIDTH - 120)];
                    rect.size.width = SCREEN_WIDTH - 120;
                    rect.origin.y = 11;
                    _personSign.frame = rect;
                    if (rect.size.height > [CustomUtil heightForString:@"a" fontSize:15.0f andWidth:(SCREEN_WIDTH - 120)]) { //多行显示
                        [_personSign setTextAlignment:NSTextAlignmentLeft];
                    } else {
                        [_personSign setTextAlignment:NSTextAlignmentRight];
                    }
                    return rect.size.height + 11*2;
                }
            }
        }
            break;
        case 7:
        {
            if (![_queryUserId isEqualToString:[LoginModel shareInstance].userId]) { //查询非登录用户
                if (![CustomUtil CheckParam:[GetUserInfo shareInstance].userSign]) {
                    CGRect rect = _personSign.frame;
                    //获取用户签名的文字高度
                    rect.size.height = [CustomUtil heightForString:[GetUserInfo shareInstance].userSign fontSize:15.0f andWidth:(SCREEN_WIDTH - 120)];
                    rect.size.width = SCREEN_WIDTH - 120;
                    rect.origin.y = 11;
                    _personSign.frame = rect;
                    if (rect.size.height > [CustomUtil heightForString:@"a" fontSize:15.0f andWidth:(SCREEN_WIDTH - 120)]) { //多行显示
                        [_personSign setTextAlignment:NSTextAlignmentLeft];
                    } else {
                        [_personSign setTextAlignment:NSTextAlignmentRight];
                    }
                    return rect.size.height + 11*2;
                }
            }
        }
            break;
        default:
            break;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_queryUserId isEqualToString:[LoginModel shareInstance].userId]) { //查询当前登录用户
        return 8;
    } else { //查询非登录用户
        return 9;
    }
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_queryUserId isEqualToString:[LoginModel shareInstance].userId]) { //查询当前用户
        switch (indexPath.row) {
            case 0:
            {
                [CustomUtil setImageViewCorner:_personImageView];
                return self.touXiangCell;
            }
                break;
            case 1:
                return self.niChengCell;
                break;
            case 2:
                return self.xingBieCell;
                break;
            case 3:
                return self.chuShengNianYueCell;
                break;
            case 4:
                return self.suoZaiDiQuCell;
                break;
            case 5:
                return self.dianPuCell;
                break;
            case 6:
                return self.geXingQianMingCell;
                break;
            case 7:
                return self.zhuCeShiJianCell;
                break;
            default:
                break;
        }
    } else { //查询非登录用户
        switch (indexPath.row) {
            case 0:
            {
                [CustomUtil setImageViewCorner:_personImageView];
                return self.touXiangCell;
            }
                break;
            case 1:
            {
                return self.menpaiCell;
            }
                break;
            case 2:
                return self.niChengCell;
                break;
            case 3:
                return self.xingBieCell;
                break;
            case 4:
                return self.chuShengNianYueCell;
                break;
            case 5:
                return self.suoZaiDiQuCell;
                break;
            case 6:
                return self.dianPuCell;
                break;
            case 7:
                return self.geXingQianMingCell;
                break;
            case 8:
                return self.zhuCeShiJianCell;
                break;
            default:
                break;
        }
    }
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_queryUserId isEqualToString:[LoginModel shareInstance].userId]) {
        return;
    } else {
        switch (indexPath.row) {
            case 0:  //头像
            {
                [CustomUtil setImageViewCorner:_bigPersonImageView];
                CGRect rect = _openPhotoView.frame;
                rect.size.width = SCREEN_WIDTH;
                rect.size.height = SCREEN_HEIGHT;
                _openPhotoView.frame = rect;
                [kWindow addSubview:_openPhotoView];
            }
                break;
            case 1: //昵称
            {
                NickNameViewController *nickNameViewCtrl = [[NickNameViewController alloc] initWithNibName:@"NickNameViewController" bundle:nil];
                [self.navigationController pushViewController:nickNameViewCtrl animated:YES];
            }
                break;
            case 2: //性别
            {
                SexSetViewController *sexSetViewCtrl = [[SexSetViewController alloc] initWithNibName:@"SexSetViewController" bundle:nil];
                [self.navigationController pushViewController:sexSetViewCtrl animated:YES];
            }
                break;
            case 3: //出生年月
            {
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
                    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarCancelClick)];
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
                break;
            case 4: //所在地区
            {
                //跳转至P12-1-3所在地区界面
                OwnAreaViewController *ownAreaViewCtrl = [[OwnAreaViewController alloc] initWithNibName:@"OwnAreaViewController" bundle:nil];
                ownAreaViewCtrl.intoFlag = 1; //个人资料进入
                [self.navigationController pushViewController:ownAreaViewCtrl animated:YES];
            }
                break;
            case 5: //店铺
            {
                StoreSetViewController *storeSetViewCtrl = [[StoreSetViewController alloc] initWithNibName:@"StoreSetViewController" bundle:nil];
                [self.navigationController pushViewController:storeSetViewCtrl animated:YES];
            }
                break;
            case 6: //个性签名
            {
                SignatureViewController *signatureViewCtrl = [[SignatureViewController alloc] initWithNibName:@"SignatureViewController" bundle:nil];
                [self.navigationController pushViewController:signatureViewCtrl animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

//picker取消按钮点击
-(void)toolBarCancelClick
{
    [datePicker setHidden:YES];
    [pickerDateToolbar setHidden:YES];
}

//picker确定按钮点击
-(void)toolBarDoneClick
{
    NSDate *selectDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:selectDate];
    //更新出生日期
    [ModifyUserDataInput shareInstance].birthday = dateStr;
    [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
    [ModifyUserDataInput shareInstance].userSignFlag = @"0";
    [ModifyUserDataInput shareInstance].storeFlag = @"0";
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
    [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:dict successBlock:^(NSDictionary *responseDict) {
        ModifyUserData *modifyUserData = [ModifyUserData modelWithDict:responseDict];
        [CustomUtil showToastWithText:modifyUserData.msg view:self.view];
        [self reloadData];
    } failedBlock:^(NSError *err) {
    }];
    [datePicker setHidden:YES];
    [pickerDateToolbar setHidden:YES];
}

#pragma mark -按钮点击事件
//打开相册按钮
- (IBAction)openPhotoLibClick:(id)sender {
    [_openPhotoView removeFromSuperview];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"当前设备没有图片库" leftTitle:@"确定" rightTitle:nil leftHandle:^(UIAlertAction *action) {
            [_openPhotoView setHidden:NO];
        } rightHandle:nil target:self btnCount:1];
        return;
    }
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

//打开相机按钮
- (IBAction)openCameraClick:(id)sender {
    [_openPhotoView removeFromSuperview];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [CustomUtil showCustomAlertView:@"提示" message:@"当前设备没有摄像头" leftTitle:@"确定" rightTitle:nil leftHandle:^(UIAlertAction *action) {
            [_openPhotoView setHidden:NO];
        } rightHandle:nil target:self btnCount:1];
        return;
    }
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

//打开相册取消按钮
- (IBAction)openPhotoCancelBtnClick:(id)sender {
    [_openPhotoView removeFromSuperview];
}

//点击照相机Use按钮事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_openPhotoView setHidden:NO];
    [CustomUtil saveImageToSandBox:info fileName:@"personImage.jpg" block:^(UIImage *sandBoxImage, NSString *filePath) {
        //修改用户头像显示
        _bigPersonImageView.imageURL = [NSURL URLWithString:@""];
        [CustomUtil setImageViewCorner:_bigPersonImageView];
        [_bigPersonImageView setImage:sandBoxImage];
        //上传照片至服务器
        [ModifyUserDataInput shareInstance].image = filePath;
        [ModifyUserDataInput shareInstance].userId = [LoginModel shareInstance].userId;
        [ModifyUserDataInput shareInstance].birthday = @"";
        [ModifyUserDataInput shareInstance].userSignFlag = @"0";
        [ModifyUserDataInput shareInstance].storeFlag = @"0";
        
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[ModifyUserDataInput shareInstance]];
        [[NetInterface shareInstance] modifyUserData:@"modifyUserData" param:dict successBlock:^(NSDictionary *responseDict) {
            ModifyUserData *returnData = [ModifyUserData modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                //关闭视图
                [_openPhotoView removeFromSuperview];
                [self reloadData];
            } else {
                [CustomUtil showToastWithText:returnData.msg view:kWindow];
            }
            } failedBlock:^(NSError *err) {
        }];
    }];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击相机Cancel按钮事件
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_openPhotoView setHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)reloadData
{
#ifdef OPEN_NET_INTERFACE
    //调用接口获取数据
    [GetUserInfoInput shareInstance].currentUserId = [LoginModel shareInstance].userId;
    [GetUserInfoInput shareInstance].userId = _queryUserId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
    [[NetInterface shareInstance] getUserInfo:@"getUserInfo" param:dict successBlock:^(NSDictionary *responseDict) {
        GetUserInfo *getUserInfo = [GetUserInfo modelWithDict:responseDict];
        if (RETURN_SUCCESS(getUserInfo.status)) {
            //设置界面数据
            _personImageView.imageURL = [CustomUtil getPhotoURL:getUserInfo.image];
            _bigPersonImageView.imageURL = [CustomUtil getPhotoURL:getUserInfo.image];
            if ([_queryUserId isEqualToString:[LoginModel shareInstance].userId]) {
                [LoginModel shareInstance].image = getUserInfo.image;
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"touxianggaibian" object:nil userInfo:@{@"img":getUserInfo.image,@"name":getUserInfo.userName}];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            _nickNameLabel.text = getUserInfo.userName;
            _sexLabel.text = getUserInfo.sex;
            _birthDayLabel.text = getUserInfo.birthday;
            NSString *areaStr;
            if (![CustomUtil CheckParam:getUserInfo.city]) {
                areaStr = getUserInfo.city;
            } else if (![CustomUtil CheckParam:getUserInfo.country]) {
                areaStr = getUserInfo.country;
            } else {
                areaStr = @"";
            }
            _areaLabel.text = areaStr;
            _storeLabel.text = getUserInfo.store;
            _personSign.text = getUserInfo.userSign;
            _registerTime.text = getUserInfo.createTime;
            _menpaiLabel.text = getUserInfo.userDoorId;
#ifdef CACHE_SWITCH
            //缓存文字数据
            [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:responseDict flag:0 imageFlag:100];
            //缓存个人头像
            [CacheService saveDataToSandBox:VIEWCONTROLLER_NAME data:[CustomUtil getPhotoURL:getUserInfo.image] flag:0 imageFlag:0];
#endif
            [_personDocTableView reloadData];
        } else {
            [CustomUtil showToastWithText:getUserInfo.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
#ifdef CACHE_SWITCH
        if ((-1009) == err.code) {
            //读取缓存数据
            NSMutableDictionary *dict = (NSMutableDictionary *)[CacheService readCacheData:VIEWCONTROLLER_NAME flag:0];
            GetUserInfo *getUserInfo = [GetUserInfo modelWithDict:dict];
            //设置界面数据
            _personImageView.imageURL = [CustomUtil getPhotoURL:getUserInfo.image];
            _bigPersonImageView.imageURL = [CustomUtil getPhotoURL:getUserInfo.image];
            if ([_queryUserId isEqualToString:[LoginModel shareInstance].userId]) {
                [LoginModel shareInstance].image = getUserInfo.image;
            }
            _nickNameLabel.text = getUserInfo.userName;
            _sexLabel.text = getUserInfo.sex;
            _birthDayLabel.text = getUserInfo.birthday;
            NSString *areaStr;
            if (![CustomUtil CheckParam:getUserInfo.city]) {
                areaStr = getUserInfo.city;
            } else if (![CustomUtil CheckParam:getUserInfo.country]) {
                areaStr = getUserInfo.country;
            } else {
                areaStr = @"";
            }
            _areaLabel.text = areaStr;
            _storeLabel.text = getUserInfo.store;
            _personSign.text = getUserInfo.userSign;
            _registerTime.text = getUserInfo.createTime;
            [_personDocTableView reloadData];
        }
#endif
    }];
#endif
}

@end

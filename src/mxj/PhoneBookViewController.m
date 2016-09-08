//
//  PhoneBookViewController.m
//  mxj
//  P7-5-1-1手机通讯录
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PhoneBookViewController.h"
#import "PhoneBookTableOneCell.h"
#import "PhoneBookTableTwoCell.h"
#import <AddressBook/AddressBook.h>

@interface PhoneBookViewController ()
{
    //通讯录关联数组
    NSMutableArray *phoneBookArray;  //电话本
    NSMutableArray *invistUserArray; //已加入毛线街的用户数组(带平台信息）
    NSMutableArray *notInvistUserArray; //未加入毛线街的用户数组（不带平台信息）
    NSMutableArray *invistUserPhoneBookArray;      //已加入毛线街用户的电话信息
    NSMutableArray *notInvistUserPhoneBookArray;   //未加入毛线街用户的电话信息
    //微博好友关联数组
    NSMutableArray *weiboUserArray;         //微博好友数组
    NSMutableArray *weiboInvistUserArray;   //已加入毛线街的用户数组
    NSMutableArray *weiboInvistUserWithPlatformArray; //已加入毛线街用户的数组（带平台信息）
    NSMutableArray *weiboNoInvistUserArray; //未加入毛线街的用户数组
    NSMutableArray *weiboNoInvistUserWithPlatformArray; //未加入毛线街用户的数组（带平台信息）
}
@end

@implementation PhoneBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = @"";
    
    switch (_intoFlag) {
        case 1:
        {
            title = @"微博好友";
        }
            break;
        case 2:
        {
            title = @"微信好友";
        }
            break;
        case 3:
        {
            title = @"QQ好友";
        }
            break;
        case 4:
        {
            title = @"手机通讯录";
        }
            break;
        default:
            break;
    }
    [self.navigationItem setTitle:title];
    self.phoneBookTableView.delegate = self;
    self.phoneBookTableView.dataSource = self;
    
    phoneBookArray = [[NSMutableArray alloc] init];
    invistUserArray = [[NSMutableArray alloc] init];
    notInvistUserArray = [[NSMutableArray alloc] init];
    invistUserPhoneBookArray = [[NSMutableArray alloc] init];
    notInvistUserPhoneBookArray = [[NSMutableArray alloc] init];
    
    weiboUserArray = [[NSMutableArray alloc] init];
    weiboInvistUserArray = [[NSMutableArray alloc] init];
    weiboNoInvistUserArray = [[NSMutableArray alloc] init];
    weiboNoInvistUserWithPlatformArray = [[NSMutableArray alloc] init];
    weiboInvistUserWithPlatformArray = [[NSMutableArray alloc] init];
    [self reloadData:^{
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (1 == _intoFlag) {
                return weiboInvistUserArray.count;
            }
            return invistUserArray.count;
        }
            break;
        default:
            break;
    }
    if (1 == _intoFlag) {
        return weiboNoInvistUserArray.count;
    }
    return notInvistUserArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return self.headOneCell;
    } else {
        return self.headTwoCell;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        PhoneBookTableOneCell *phoneBookOneCell = [tableView dequeueReusableCellWithIdentifier:@"PhoneBookTableOneCell"];
        if (!phoneBookOneCell) {
            phoneBookOneCell = [[[NSBundle mainBundle] loadNibNamed:@"PhoneBookTableOneCell" owner:self options:nil] lastObject];
        }
        CheckMaoxjStatusInfo *p;
        if (1 == _intoFlag) {
            p = [weiboInvistUserArray objectAtIndexCheck:indexPath.row];
            [phoneBookOneCell.phoneNameLabel setHidden:YES];
            [phoneBookOneCell.phoneContactLabel setHidden:YES];
            CGPoint centerPoint = phoneBookOneCell.contentView.center;
            CGPoint personNameCenterPoint = phoneBookOneCell.personNameLabel.center;
            CGPoint changedCenterPoint;
            changedCenterPoint.x = personNameCenterPoint.x;
            changedCenterPoint.y = centerPoint.y;
            [phoneBookOneCell.personNameLabel setCenter:changedCenterPoint];
            if ([CustomUtil CheckParam:p.userName]) {
                NSString *userName = ((WeiboUser *)[weiboInvistUserWithPlatformArray objectAtIndexCheck:indexPath.row]).name;
                phoneBookOneCell.personNameLabel.text = userName;
            } else {
                phoneBookOneCell.personNameLabel.text = p.userName;
            }
        } else {
            p = [invistUserArray objectAtIndexCheck:indexPath.row];
            [phoneBookOneCell.phoneNameLabel setHidden:NO];
            [phoneBookOneCell.phoneContactLabel setHidden:NO];
            phoneBookOneCell.personNameLabel.text = p.userName;
            TKAddressBook *addressBookInfo = [invistUserPhoneBookArray objectAtIndexCheck:indexPath.row];
            phoneBookOneCell.phoneNameLabel.text = addressBookInfo.name;
        }
        phoneBookOneCell.personImageView.imageURL = [CustomUtil getPhotoURL:p.image];
        
        return phoneBookOneCell;
    } else {
        PhoneBookTableTwoCell *phoneBookTwoCell = [tableView dequeueReusableCellWithIdentifier:@"PhoneBookTableTwoCell"];
        if (!phoneBookTwoCell) {
            phoneBookTwoCell = [[[NSBundle mainBundle] loadNibNamed:@"PhoneBookTableTwoCell" owner:self options:nil] lastObject];
        }
        phoneBookTwoCell.personImageView.imageURL = [CustomUtil getPhotoURL:@""];
        if (1 == _intoFlag) {
            WeiboUser *p = [weiboNoInvistUserWithPlatformArray objectAtIndexCheck:indexPath.row];
            phoneBookTwoCell.personNameLabel.text = p.name;
        } else {
            TKAddressBook *p = [notInvistUserPhoneBookArray objectAtIndexCheck:indexPath.row];
            phoneBookTwoCell.personNameLabel.text = p.name;
        }
        
        //设置代理
        phoneBookTwoCell.invisteUserBtnDelegate = self;
        
        return phoneBookTwoCell;
    }
}

#pragma mark - 邀请按钮代理方法
//未加入毛线街用户的邀请按钮点击事件
-(void)invisteUserBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)(button.superview.superview);
    NSIndexPath *indexPath = [_phoneBookTableView indexPathForCell:cell];
    DLog(@"indexPath = %ld", (long)indexPath.row);
    if (1 == _intoFlag) { //微博好友
        WeiboUser *p = [weiboNoInvistUserWithPlatformArray objectAtIndexCheck:indexPath.row];
        [WBHttpRequest requestForInviteBilateralFriend:p.userID withAccessToken:[TKWeiboLogin shareInstance].token inviteText:@"这个好玩Test!" inviteUrl:@"http://www.weibo.com/u/2002619624" inviteLogoUrl:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            if (error) {
                [CustomUtil showToastWithText:[error localizedDescription] view:kWindow];
            }
        }];
    }
    if (4 == _intoFlag) { //通讯录


        NSString *string=[NSString stringWithFormat:@"place=%@&cityFlag=%@&current=%@&userId=%@&pagesize=%@&type=%@", [GetStreetsnapListInput shareInstance].place, [GetStreetsnapListInput shareInstance].cityFlag, [GetStreetsnapListInput shareInstance].current, [GetStreetsnapListInput shareInstance].userId, [GetStreetsnapListInput shareInstance].pagesize, [GetStreetsnapListInput shareInstance].type];
        
        NSString *string2=[NSString stringWithFormat:@"%@%@%@%@",@"http://",NET_BASE_URL,@"/maoxj/views/html5page/personal-center.html?",string];
        NSString *new_url=[string2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *contentUserArray = [[NSMutableArray alloc] init];
        TKAddressBook *p = [notInvistUserPhoneBookArray objectAtIndexCheck:indexPath.row];
        [contentUserArray addObject:p.tel];
        //获取邀请信息
        [CustomUtil getInviteUserMessage:^(NSString *shareMsg, NSString *shareUrl) {
            NSString *message=[NSString stringWithFormat:@"%@ %@",@"我已加入[毛线街]，你也赶快来一起逛街吧！",new_url];
            //调用短信分享
            [CustomUtil shareInstance].viewCtrl = self;
            [CustomUtil sendSMS:self bodyMesage:message recipientList:contentUserArray];
        }];
    }
}

#pragma mark - 共通方法
//获取手机通讯录
-(void)getPhoneBook:(void(^)())block
{
    ABAddressBookRef addressBookRef = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else {
        addressBookRef = ABAddressBookCreate();
    }
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBookRef);
    for (int i=0; i<nPeople; i++) {
        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [phoneBookArray addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    block();
}

//加载数据
-(void)reloadData:(void(^)())block
{
    if (1 == _intoFlag) { //微博好友
        weiboUserArray = [TKWeiboLogin shareInstance].userArray;
        //查询微博好友是否加入毛线街
        NSString *searchParam = @"";
        if (weiboUserArray.count > 0) {
            searchParam = ((WeiboUser *)[weiboUserArray objectAtIndexCheck:0]).userID;
        }
        if (weiboUserArray.count > 1) {
            for (int i=1; i<weiboUserArray.count; i++) {
                WeiboUser *user = [weiboUserArray objectAtIndexCheck:i];
                searchParam = [NSString stringWithFormat:@"%@,%@", searchParam, user.userID];
            }
        }
        [CheckMaoxjStatusInput shareInstance].type = @"3"; //查询微博用户
        [CheckMaoxjStatusInput shareInstance].searchParams = searchParam; //查询微博好友id
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[CheckMaoxjStatusInput shareInstance]];
        [[NetInterface shareInstance] checkMaoxjStatus:@"checkMaoxjStatus" param:dict successBlock:^(NSDictionary *responseDict) {
            CheckMaoxjStatus *returnData = [CheckMaoxjStatus modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                for (int i=0; i<returnData.info.count; i++) {
                    CheckMaoxjStatusInfo *p = [[CheckMaoxjStatusInfo alloc] initWithDict:(NSDictionary *)[returnData.info objectAtIndexCheck:i]];
                    if ([p.status isEqualToString:@"0"]) { //非用户
                        [weiboNoInvistUserArray addObject:p];
                        [weiboNoInvistUserWithPlatformArray addObject:[weiboUserArray objectAtIndexCheck:i]];
                    } else if ([p.status isEqualToString:@"1"]) { //用户
                        [weiboInvistUserArray addObject:p];
                        [weiboInvistUserWithPlatformArray addObject:[weiboUserArray objectAtIndexCheck:i]];
                    }
                }
                [_phoneBookTableView reloadData];
            } else {
                [CustomUtil showToastWithText:returnData.msg view:kWindow];
            }
            block();
        } failedBlock:^(NSError *err) {
        }];
    }
    if(4 == _intoFlag) { //通讯录
        //获取手机通讯录
        [self getPhoneBook:^{
            //查询通讯录中的用户是否加入了毛线街
            NSString *searchParam = @"";
            if (phoneBookArray.count > 0) {
                searchParam = ((TKAddressBook *)[phoneBookArray objectAtIndexCheck:0]).tel;
            }
            if (phoneBookArray.count > 1) {
                for (int i=1; i<phoneBookArray.count; i++) {
                    TKAddressBook *p = [phoneBookArray objectAtIndexCheck:i];
                    searchParam = [NSString stringWithFormat:@"%@,%@", searchParam, p.tel];
                }
            }
            [CheckMaoxjStatusInput shareInstance].type = @"2"; //手机
            [CheckMaoxjStatusInput shareInstance].searchParams = searchParam; //查询号码
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[CheckMaoxjStatusInput shareInstance]];
            [[NetInterface shareInstance] checkMaoxjStatus:@"checkMaoxjStatus" param:dict successBlock:^(NSDictionary *responseDict) {
                CheckMaoxjStatus *returnData = [CheckMaoxjStatus modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    for (int i=0; i<returnData.info.count; i++) {
                        CheckMaoxjStatusInfo *p = [[CheckMaoxjStatusInfo alloc] initWithDict:(NSDictionary *)[returnData.info objectAtIndexCheck:i]];
                        if ([p.status isEqualToString:@"0"]) { //非用户
                            [notInvistUserArray addObject:p];
                            [notInvistUserPhoneBookArray addObject:[phoneBookArray objectAtIndexCheck:i]];
                        } else if ([p.status isEqualToString:@"1"]) { //用户
                            [invistUserArray addObject:p];
                            [invistUserPhoneBookArray addObject:[phoneBookArray objectAtIndexCheck:i]];
                        }
                    }
                    [_phoneBookTableView reloadData];
                } else {
                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                }
                block();
            } failedBlock:^(NSError *err) {
            }];
        }];
    }
}

@end

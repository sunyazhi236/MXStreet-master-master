//
//  SendPrivateMessageViewController.m
//  mxj
//  P8-3-1发送私信实现文件
//  Created by 齐乐乐 on 15/11/13.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "SendPrivateMessageViewController.h"
#import "SendPrivateMessageCell.h"
#import "SendPrivateMessageTwoCell.h"
#import "PersonMainPageViewController.h"
#import "MyStreetPhotoViewController.h"

#define LINE_BREAK_WORD_COUNT 12 //12个汉字折行
#define DEFAULT_CELL_HEIGHT 69   //默认的Cell行高

static int currentPageNum;     //当前页码
@interface SendPrivateMessageViewController ()
{
    NSMutableArray *messageArray;  //消息数组
    NSMutableArray *timeArray;     //时间数组
    CGFloat oneLineHeight;  //单行文字的高度
    
    GetUserInfo *userInfo;  //用户信息
    
    NSMutableArray *infoArray;
    int infoArrayCount;     //数组总长度
    CGFloat keyboardHeight; //键盘高度
    NSString *baseTimeStr;  //基准时间，5分钟内显示时间标签
    CGFloat orginTableHeight; //原始表格高度
}
@end

@implementation SendPrivateMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:_userName];
    self.sendPrivateMessageTableView.delegate = self;
    self.sendPrivateMessageTableView.dataSource = self;

    messageArray = [[NSMutableArray alloc] init];
    timeArray = [[NSMutableArray alloc] init];
    infoArray = [[NSMutableArray alloc] init];
    baseTimeStr = @"2016-01-01 01:00:00";
    
    orginTableHeight = _sendPrivateMessageTableView.frame.size.height - 64;
    
    //为背景图添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageTap)];
    //[_sendPrivateMessageTableView addGestureRecognizer:tapGesture];
    [self.view addGestureRecognizer:tapGesture];
    
    infoArrayCount = 0;
#ifdef OPEN_NET_INTERFACE
    currentPageNum = 1;
    [self reloadData:currentPageNum block:^(BOOL successFlag){
        //获取用户信息
        if (infoArrayCount > 0) {
            NSDictionary *infoDict = (NSDictionary *)([infoArray[0] objectAtIndexCheck:0]);
            GetMessageInfo *messageInfo = [[GetMessageInfo alloc] initWithDict:infoDict];
            if (![messageInfo.userId isEqualToString:[LoginModel shareInstance].userId]) {
                [GetUserInfoInput shareInstance].userId = messageInfo.userId;
            } else {
                [GetUserInfoInput shareInstance].userId = messageInfo.receiveId;
            }
        }
        [GetUserInfoInput shareInstance].currentUserId = [LoginModel shareInstance].userId;
        NSMutableDictionary *getUserInfoDict = [CustomUtil modelToDictionary:[GetUserInfoInput shareInstance]];
        [[NetInterface shareInstance] getUserInfo:@"getUserInfo" param:getUserInfoDict successBlock:^(NSDictionary *responseDict) {
            GetUserInfo *getUserInfo = [GetUserInfo modelWithDict:responseDict];
            if (RETURN_SUCCESS(getUserInfo.status)) {
                userInfo = getUserInfo;
                [_sendPrivateMessageTableView reloadData];
                if (messageArray.count > 0) { //滑动到底部
                    [_sendPrivateMessageTableView scrollToRowAtIndexPath:([NSIndexPath indexPathForRow:(messageArray.count - 1) inSection:0]) atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
        } failedBlock:^(NSError *err) {
        }];
    }];
#else
    messageArray = [NSMutableArray arrayWithObjects:@"活动什么时候开始？",
                    @"10月16号晚八点钟。",
                    @"人数多的话有优惠的么？",
                    @"这个活动是只为加点人气，没什么盈利的亲，朋友一起来的话给您送几张优惠券好吗",
                    nil];
    timeArray = [NSMutableArray arrayWithObjects:@"2015-10-23 12:59",
                 @"昨天23:09",
                 @"今天12:59",
                 @"今天15:56",
                 nil];
#endif
    CGRect oneLineRect = [self heightForString:@"测试"];
    oneLineHeight = oneLineRect.size.height;
    CGRect rect = _footInputView.frame;
    rect.origin.y = self.view.frame.size.height - _footInputView.frame.size.height;
    _footInputView.frame = rect;
    [self.view addSubview:_footInputView];
    _inputTextFiled.delegate = self;
    
    //添加上拉加载更多
    __weak SendPrivateMessageViewController *blockSelf = self;
    //__block int currentPageNumSelf = currentPageNum;
    //下拉刷新
    [_sendPrivateMessageTableView addPullToRefreshWithActionHandler:^{
        //使用GCD开启一个线程，使圈圈转2秒
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            currentPageNum++;
            [blockSelf reloadData:currentPageNum block:^(BOOL successFlag){
                if (NO == successFlag) {
                    currentPageNum--;
                }
                [blockSelf.sendPrivateMessageTableView reloadData];
                [blockSelf.sendPrivateMessageTableView.pullToRefreshView stopAnimating];
            }];
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    //添加TextView监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoradWillDisplay:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView代理方法
-(void)textViewChange:(NSNotification *)notification
{
    UITextView *textView = (UITextView *)notification.object;
    //获取文本高度
    float height = [CustomUtil heightForString:textView.text fontSize:14.0f andWidth:_inputTextFiled.frame.size.width];
    //设置textView关联控件高度
    CGRect rect = textView.frame;
    rect.size.height = height;
    textView.frame = rect;
    
    rect = _footInputView.frame;
    rect.size.height = height + 19;
    rect.origin.y = self.view.frame.size.height - keyboardHeight - rect.size.height;
    _footInputView.frame = rect;
    
    //显示或隐藏占位文字
    if ([textView.text isEqualToString:@""]) {
        [_placeHolderLabel setHidden:NO];
    } else {
        [_placeHolderLabel setHidden:YES];
    }
}

#pragma mark-TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messageArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef OPEN_NET_INTERFACE
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<infoArray.count; i++) {
        NSMutableArray *messageInfoArray = [infoArray objectAtIndexCheck:i];
        for (int j=0; j<messageInfoArray.count; j++) {
            [array addObject:messageInfoArray[j]];
        }
    }
    
    NSDictionary *dict = (NSDictionary *)[array objectAtIndexCheck:(infoArrayCount - 1 - indexPath.row)];
    //NSDictionary *dict = (NSDictionary *)[array objectAtIndexCheck:indexPath.row];
    GetMessageInfo *messageInfo = [[GetMessageInfo alloc] initWithDict:dict];
    if (![messageInfo.userId isEqualToString:[LoginModel shareInstance].userId]) { //发送给我的
#else
    if (0 == indexPath.row % 2) {
#endif
        //SendPrivateMessageCell *sendPrivateMessageCell = [tableView dequeueReusableCellWithIdentifier:@"SendPrivateMessageCell"];
        //if (!sendPrivateMessageCell) {
          SendPrivateMessageCell *sendPrivateMessageCell = [[[NSBundle mainBundle] loadNibNamed:@"SendPrivateMessageCell" owner:self options:nil] lastObject];
        //}
        //根据文字高度调整Label高度
        NSString *messageStr = [messageArray objectAtIndexCheck:indexPath.row];
        CGRect cgRect = [self heightForString:messageStr];
        CGRect rect = sendPrivateMessageCell.messageLabel.frame;
        rect.size.width = cgRect.size.width;
        rect.size.height = cgRect.size.height;
        
        //根据文字高度调整ImageView的高度
        UIImage *image = [UIImage imageNamed:@"kuang_8_3_1"];
        image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        CGRect imageViewRect = sendPrivateMessageCell.kuangImageView.frame;
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            imageViewRect.origin.y = 38;
        } else {
            imageViewRect.origin.y = 9;
        }
        imageViewRect.size.width = rect.size.width + 15 + 10;
        imageViewRect.size.height = rect.size.height + 10 + 6;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
        [imageView setImage:image];
        [sendPrivateMessageCell.contentView addSubview:imageView];
        
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            rect.origin.y = 46;
        } else {
            rect.origin.y = 17;
        }
        CustomLabel *label = [[CustomLabel alloc] initWithFrame:rect];
        [label setFont:[UIFont systemFontOfSize:15.0f]];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByCharWrapping];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setText:messageStr];
        [sendPrivateMessageCell.contentView addSubview:label];
        [sendPrivateMessageCell.messageLabel setHidden:YES];
        [sendPrivateMessageCell.kuangImageView setHidden:YES];
        /*
        NSArray *viewArray = [sendPrivateMessageCell.contentView subviews];
        for (UIView *view in viewArray) {
            if (YES == [view isKindOfClass:[UILabel class]]) {
                UILabel *timeLabel = (UILabel *)view;
                [timeLabel setText:[timeArray objectAtIndexCheck:indexPath.row]];
                break;
            }
        }
         */
        sendPrivateMessageCell.timeLabel.text = ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).time;
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            [sendPrivateMessageCell.timeLabel setHidden:NO];
            [sendPrivateMessageCell.timeImageView setHidden:NO];
        } else {
            [sendPrivateMessageCell.timeLabel setHidden:YES];
            [sendPrivateMessageCell.timeImageView setHidden:YES];
        }
        /*
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //获取基准时间
        NSDate *baseDate = [dateFormatter dateFromString:changeTimeStr];
        NSDate *orginDate = [dateFormatter dateFromString:baseTimeStr];
        //获取待比较时间
        NSDate *date = [dateFormatter dateFromString:[timeArray objectAtIndex:indexPath.row]];
        NSTimeInterval time = [date timeIntervalSinceDate:baseDate];
        NSTimeInterval orginTime = [date timeIntervalSinceDate:orginDate];
        if ((0 == time) || (time > (5*60)) || (time < (-5*60)) || (0 == orginTime)) {
            [sendPrivateMessageCell.timeLabel setHidden:NO];
            [sendPrivateMessageCell.timeImageView setHidden:NO];
            changeTimeStr = [dateFormatter stringFromDate:date];
        } else {
            [sendPrivateMessageCell.timeLabel setHidden:YES];
            [sendPrivateMessageCell.timeImageView setHidden:YES];
        }
         */
        rect = sendPrivateMessageCell.personImageView.frame;
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            rect.origin.y = 38;
        } else {
            rect.origin.y = 9;
        }
        sendPrivateMessageCell.personImageView.frame = rect;
        rect = sendPrivateMessageCell.personBtn.frame;
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            rect.origin.y = 38;
        } else {
            rect.origin.y = 9;
        }
        sendPrivateMessageCell.personBtn.frame = rect;
        if(![sendPrivateMessageCell.personImageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:userInfo.image].absoluteString])
        {
            sendPrivateMessageCell.personImageView.imageURL = [CustomUtil getPhotoURL:userInfo.image];
        }
        sendPrivateMessageCell.personBtn.tag = indexPath.row;
        [sendPrivateMessageCell.personBtn addTarget:self action:@selector(personBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return sendPrivateMessageCell;
    } else { //我发送的
       // SendPrivateMessageTwoCell *sendPrivateMessageTwoCell = [tableView dequeueReusableCellWithIdentifier:@"SendPrivateMessageTwoCell"];
       // if (!sendPrivateMessageTwoCell) {
          SendPrivateMessageTwoCell *sendPrivateMessageTwoCell = [[[NSBundle mainBundle] loadNibNamed:@"SendPrivateMessageTwoCell" owner:self options:nil] lastObject];
        //}
        //根据文字高度调整Label高度
        NSString *messageStr = [messageArray objectAtIndexCheck:indexPath.row];
        CGRect cgRect = [self heightForString:messageStr];
        CGRect rect = sendPrivateMessageTwoCell.messageLabel.frame;
        rect.size.width = cgRect.size.width;
        rect.size.height = cgRect.size.height;
        
        //根据文字高度调整ImageView的高度
        UIImage *image = [UIImage imageNamed:@"kuang02_8_3_1"];
        image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        CGRect imageViewRect = sendPrivateMessageTwoCell.kuangImageView.frame;
        imageViewRect.origin.x = imageViewRect.origin.x + imageViewRect.size.width - 15 - rect.size.width - 10 + (SCREEN_WIDTH - 320);
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            imageViewRect.origin.y = 38;
        } else {
            imageViewRect.origin.y = 9;
        }
        imageViewRect.size.width = rect.size.width + 15 + 10;
        imageViewRect.size.height = rect.size.height + 10 + 6;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
        [imageView setImage:image];
        [sendPrivateMessageTwoCell.contentView addSubview:imageView];
        
        rect.origin.x = imageView.frame.origin.x + 10;
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            rect.origin.y = 46;
        } else {
            rect.origin.y = 17;
        }
        CustomLabel *label = [[CustomLabel alloc] initWithFrame:rect];
        [label setFont:[UIFont systemFontOfSize:15.0f]];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByCharWrapping];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setText:messageStr];
        [sendPrivateMessageTwoCell.contentView addSubview:label];
        
        [sendPrivateMessageTwoCell.messageLabel setHidden:YES];
        [sendPrivateMessageTwoCell.kuangImageView setHidden:YES];
        sendPrivateMessageTwoCell.timeLabel.text = ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).time;
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            [sendPrivateMessageTwoCell.timeLabel setHidden:NO];
            [sendPrivateMessageTwoCell.timeImageView setHidden:NO];
        } else {
            [sendPrivateMessageTwoCell.timeLabel setHidden:YES];
            [sendPrivateMessageTwoCell.timeImageView setHidden:YES];
        }
        /*
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //获取基准时间
        NSDate *baseDate = [dateFormatter dateFromString:changeTimeStr];
        NSDate *orginDate = [dateFormatter dateFromString:baseTimeStr];
        //获取待比较时间
        NSDate *date = [dateFormatter dateFromString:[timeArray objectAtIndex:indexPath.row]];
        NSTimeInterval time = [date timeIntervalSinceDate:baseDate];
        NSTimeInterval orginTime = [date timeIntervalSinceDate:orginDate];
        if ((0 == time) || (time > (5*60)) || (time < (-5*60)) || (0 == orginTime)) {
            [sendPrivateMessageTwoCell.timeLabel setHidden:NO];
            [sendPrivateMessageTwoCell.timeImageView setHidden:NO];
            changeTimeStr = [dateFormatter stringFromDate:date];
        } else {
            [sendPrivateMessageTwoCell.timeLabel setHidden:YES];
            [sendPrivateMessageTwoCell.timeImageView setHidden:YES];
        }
         */
        rect = sendPrivateMessageTwoCell.personImageView.frame;
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            rect.origin.y = 38;
        } else {
            rect.origin.y = 9;
        }
        sendPrivateMessageTwoCell.personImageView.frame = rect;
        rect = sendPrivateMessageTwoCell.personBtn.frame;
        if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
            rect.origin.y = 38;
        } else {
            rect.origin.y = 9;
        }
        sendPrivateMessageTwoCell.personBtn.frame = rect;
        if (![sendPrivateMessageTwoCell.personImageView.imageURL.absoluteString isEqualToString:[CustomUtil getPhotoURL:[LoginModel shareInstance].image].absoluteString]) {
            sendPrivateMessageTwoCell.personImageView.imageURL = [CustomUtil getPhotoURL:[LoginModel shareInstance].image];
        }
        [sendPrivateMessageTwoCell.personBtn addTarget:self action:@selector(myImageClick:) forControlEvents:UIControlEventTouchUpInside];
        return sendPrivateMessageTwoCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageStr = [messageArray objectAtIndexCheck:indexPath.row];
    CGRect rect= [self heightForString:messageStr];
    CGFloat addValue = DEFAULT_CELL_HEIGHT + rect.size.height;
    
    //根据是否显示时间标签调整高度
    if (YES == ((TKTime *)[timeArray objectAtIndexCheck:indexPath.row]).displayFlag) {
        addValue = 61 + rect.size.height;
    } else {
        addValue = 34 + rect.size.height;
    }
    
    DLog(@"rect.size.height = %f", rect.size.height);
    
    return addValue;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_inputTextFiled resignFirstResponder];
}

/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (CGRect) heightForString:(NSString *)orignStr
{
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *fnt = [UIFont systemFontOfSize:15.0f];
    NSDictionary *fontDict = [[NSDictionary alloc] initWithObjectsAndKeys:fnt, NSFontAttributeName, nil];
    CGSize size = CGSizeMake(180, CGFLOAT_MAX);
    CGRect rect = [orignStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
    
    return rect;
}

#pragma mark -键盘关联
-(void)keyBoradWillDisplay:(NSNotification *)aNotification
{
    CGRect rect = _footInputView.frame;
    keyboardHeight = [self getKeyBoardHeight:aNotification];
    rect.origin.y = self.view.frame.size.height - keyboardHeight - _footInputView.frame.size.height;
    _footInputView.frame = rect;
    //调整Table的高度
    CGRect tableViewRect = _sendPrivateMessageTableView.frame;
    tableViewRect.origin.x = 0;
    tableViewRect.origin.y = 0;
//    if (orginTableHeight == tableViewRect.size.height) {
    tableViewRect.size.height = _sendPrivateMessageTableView.frame.size.height - keyboardHeight - 30;
    _sendPrivateMessageTableView.frame = tableViewRect;
  //  }
    //将最后一条信息滚动至键盘上方
    if (messageArray.count > 0) { //滑动到底部
        [_sendPrivateMessageTableView scrollToRowAtIndexPath:([NSIndexPath indexPathForRow:(messageArray.count - 1) inSection:0]) atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

-(void)keyBoardWillHide:(NSNotification *)aNotification
{
    CGRect rect = _footInputView.frame;
    rect.origin.y = self.view.frame.size.height - _footInputView.frame.size.height;
    _footInputView.frame = rect;
    //调整Table的高度
    CGRect tableViewRect = _sendPrivateMessageTableView.frame;
    tableViewRect.origin.x = 0;
    tableViewRect.origin.y = 0;
    tableViewRect.size.height += keyboardHeight + 30;
    _sendPrivateMessageTableView.frame = tableViewRect;
}

-(CGFloat)getKeyBoardHeight:(NSNotification *)aNotification
{
    NSDictionary *ainfo = [aNotification userInfo];
    NSValue *value = [ainfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [value CGRectValue];
    return rect.size.height;
}

#pragma mark -按钮点击事件
//TableView空白区域点击事件
-(void)backImageTap
{
    if ([_inputTextFiled isFirstResponder]) {
        [_inputTextFiled resignFirstResponder];
    }
}
    
//发送按钮点击
- (IBAction)sendBtnClick:(id)sender {
    //[_inputTextFiled resignFirstResponder];
    //调整footView高度
    CGRect rect = _footInputView.frame;
    rect.size.height = 30 + 19;
    if (YES == [_inputTextFiled isFirstResponder]) {
        rect.origin.y = self.view.frame.size.height - keyboardHeight - rect.size.height;
    } else {
        rect.origin.y = self.view.frame.size.height - rect.size.height;
    }
    _footInputView.frame = rect;
#ifdef OPEN_NET_INTERFACE
    //参数判空
    if ([CustomUtil CheckParam:_inputTextFiled.text]) {
        //[CustomUtil showToastWithText:@"没有输入消息" view:kWindow];
        return;
    }
    [SendMessageInput shareInstance].userId = [LoginModel shareInstance].userId;
    [SendMessageInput shareInstance].receiveId = _receiveId;
    [SendMessageInput shareInstance].content = _inputTextFiled.text;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[SendMessageInput shareInstance]];
    [[NetInterface shareInstance] sendMessage:@"sendMessage" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        if (!RETURN_SUCCESS(returnData.status)) {
            [CustomUtil showCustomAlertView:@"提示" message:returnData.msg leftTitle:@"确定" rightTitle:nil leftHandle:nil rightHandle:nil target:self btnCount:1];
        } else {
            //刷新数据
            currentPageNum = 1;
            [messageArray removeAllObjects];
            [timeArray removeAllObjects];
            [infoArray removeAllObjects];
            infoArrayCount = 0;
            [self reloadData:currentPageNum block:^(BOOL successFlag){
                if (messageArray.count > 0) { //滑动到底部
                    [_sendPrivateMessageTableView reloadData];
                    [_sendPrivateMessageTableView scrollToRowAtIndexPath:([NSIndexPath indexPathForRow:(messageArray.count - 1) inSection:0]) atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }];
            //清空输入数据
            _inputTextFiled.text = @"";
        }
    } failedBlock:^(NSError *err) {
    }];
#endif
}

//刷新数据
-(void)reloadData:(int)current block:(void(^)(BOOL successFlag))block
{
#ifdef OPEN_NET_INTERFACE
    BOOL flag = YES;
    [GetMessageInput shareInstance].current = [NSString stringWithFormat:@"%d", current];
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetMessageInput shareInstance]];
    //获取聊天内容
    
    __block BOOL flagSelf = flag;
    [[NetInterface shareInstance] getMessage:@"getMessage" param:dict successBlock:^(NSDictionary *responseDict) {
        GetMessage *returnData = [GetMessage modelWithDict:responseDict];
        if (!RETURN_SUCCESS(returnData.status)) {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
            flagSelf = NO;
        } else{
            if (returnData.info.count > 0) {
                [infoArray addObject:returnData.info];
                infoArrayCount += returnData.info.count;
                flagSelf = YES;
            } else {
                flagSelf = NO;
            }
            for (int i=0; i<returnData.info.count; i++) {
                NSDictionary *infoDict = (NSDictionary *)(returnData.info[i]);
                GetMessageInfo *infoData = [[GetMessageInfo alloc] initWithDict:infoDict];
                [messageArray insertObject:infoData.content atIndex:0];
                //[timeArray insertObject:infoData.createTime atIndex:0];
                TKTime *tkTime = [[TKTime alloc] init];
                tkTime.time = infoData.createTime;
                [timeArray insertObject:tkTime atIndex:0];
            }
            if (timeArray.count > 0) {
                baseTimeStr = ((TKTime *)[timeArray objectAtIndexCheck:0]).time;
                //判断哪些时间标签需要显示
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                for (TKTime *object in timeArray) {
                    //获取基准时间
                    NSDate *baseDate = [dateFormatter dateFromString:baseTimeStr];
                    //获取待比较时间
                    NSDate *date = [dateFormatter dateFromString:object.time];
                    NSTimeInterval time = [date timeIntervalSinceDate:baseDate];
                    if ((0 == time) || (time > (5*60))) {
                        object.displayFlag = YES;
                        baseTimeStr = [dateFormatter stringFromDate:date];
                    } else {
                        object.displayFlag = NO;
                    }
                }
            }
        }
        block(flagSelf);
    } failedBlock:^(NSError *err) {
    }];
#endif
}

//个人头像点击
-(void)personBtnClick:(id)sender
{
    //跳转至个人主页
    MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
    viewCtrl.type = 1;
    viewCtrl.userId = userInfo.userId;
    [self.navigationController pushViewController:viewCtrl animated:YES];
}
    
//我的头像点击
-(void)myImageClick:(id)sender
{
    //跳转至我的主页
    MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
    [self.navigationController pushViewController:viewCtrl animated:YES];
}

@end

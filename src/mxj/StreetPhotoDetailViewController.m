//
//  StreetPhotoDetailViewController.m
//  mxj
//  P7-4街拍详情
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "StreetPhotoDetailViewController.h"
#import "StreetPhotoDetailCell.h"
#import "PhotoDetailViewController.h"
#import "LabelDetailViewController.h"
#import "TabBarController.h"
#import "MyStreetPhotoViewController.h"
#import "PersonMainPageViewController.h"
#import "MyStreetPhotoViewController.h"
#import "PublishStreetPhotoViewController.h"
#import "StreetPraiseListViewController.h"
#import "StreetRewardListViewController.h"
#import "SendPrivateMessageViewController.h"

#define SHARE_TITLE @"刚刚在［毛线街］分享了自己的街拍，快来看看吧！"

#define PHOTO_COUNT 3 //图片数量
#define kMaxCommentLength 140 //评论字数限制
#define MORE_BTN_WIDTH 30 //点赞用户省略号宽度
#define USER_IMAGE_OFFSET (SCREEN_WIDTH - 10 * 26)/11 //点赞用户头像间的间距
#define ZANUSR_HEIGHT 26 //点赞用户头像高度
#define ZANUSR_Y_OFFSET 10 //点赞用户头像上下空白间距
#define Y_OFFSET 10 //控件之间的垂直间距
static TencentOAuth *_tencentOAuth= nil;
static  NSString *new_url;
StreetsnapInfo *publishInfo = nil;
@interface StreetPhotoDetailViewController () <UITextFieldDelegate,TencentSessionDelegate>
{
    UIView *keyBoardView; //键盘遮罩
    
    NSDictionary *_streetsnapInfo;          //街拍信息
    NSMutableArray *_tagInfoArray;          //标签信息
    NSMutableArray *_praiseInfoArray;       //点赞信息数组
    NSMutableArray *_rewardInfoArray;       //打赏信息数组
    NSMutableArray *_commentInfoArray;      //评论信息数组
    
    NSMutableArray *_zanUserArray;          //点赞用户数组（只含头像）
    NSMutableArray *_zanUserBtnArray;       //点赞用户数组（只含按钮）

    NSMutableArray *_rewardUserArray;       //打赏用户数组（只含头像）
    NSMutableArray *_rewardUserBtnArray;    //打赏用户数组（只含按钮）

    GetStreetsnapDetail *_streetsnapDetailModel;
    
    int photoCount; //街拍图片数量
    BOOL commentFlag;  //评论标记 YES：评论图片 NO：回复评论
    CommentInfo *selectInfo;  //当前选中的行对应的数据
    CGRect footViewFrame;     //原始footView位置
    CGRect footViewOrginFrame; //原始footView位置2
    UIButton *moreBtn;         //更多按钮
//    float cellHeight;          //cell高度
//    BOOL moreBtnClickFlag;     //更多按钮点击标记
}

@property (nonatomic,strong) UIButton               *guanzhuBtn;

@property (nonatomic,strong) UIButton               *siliaoBtn;
// qq
@property (nonatomic, assign) BOOL              isQQShare;
// 微信
@property (nonatomic, assign) BOOL              isWeiXinShare;
@end

@implementation StreetPhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.automaticallyAdjustsScrollViewInsets = NO; // Avoid the top UITextView space, iOS7 (~bug?)
    }
    
    [self.navigationItem setTitle:@"街拍详情"];
    
    _zanUserArray = [[NSMutableArray alloc] init];
    _zanUserBtnArray = [[NSMutableArray alloc] init];
    
    _rewardUserArray = [[NSMutableArray alloc] init];
    _rewardUserBtnArray = [[NSMutableArray alloc] init];
    
    photoCount = 0;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    
    _inputTextView.delegate = self;
    _inputTextView.returnKeyType = UIReturnKeyDefault;
    
    //ScrollView设置
    [_photoScrollView setDelegate:self];
    CGRect rect = _photoScrollView.frame;
    rect.origin.x = 0;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_WIDTH;
    _photoScrollView.frame = rect;
    [_photoScrollView setContentOffset:CGPointMake(0, 0)];
    [_photoScrollView setCanCancelContentTouches:NO];
    [_photoScrollView setBounces:NO];
    
    //调整底部的FootView位置
    footViewFrame = _footView.frame;
    footViewFrame.origin.y = self.view.frame.size.height - footViewFrame.size.height;
    footViewFrame.size.width = SCREEN_WIDTH;
    _footView.frame = footViewFrame;
    
    footViewOrginFrame = footViewFrame;
    
    commentFlag = YES; //默认评论图片
    
    float height = 40;

    _zanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    _zanView.backgroundColor = [UIColor whiteColor];
//    NSArray *array = @[@"赞", @"打赏", @"分享", @"收藏"];
    NSArray *images = @[@"zan7-4.png", @"dashang7-4.png", @"share7-4.png", @"like7-4.png"];
    
    float width = SCREEN_WIDTH / 4;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGB(229, 229, 229, 1);
    [_zanView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, height - 0.5, SCREEN_WIDTH, 0.5)];
    lineView2.backgroundColor = RGB(229, 229, 229, 1);
    [_zanView addSubview:lineView2];

    for (int i = 0; i < images.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * i, 0, width, height);
        button.titleLabel.font = FONT(11);
        [button setTitleColor:[UIColor colorWithHexString:@"#a3a3a3"] forState:UIControlStateNormal];
//        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        button.tag = i ;
        button.selected = NO;
        [button addTarget:self action:@selector(customButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_zanView addSubview:button];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(width * i, 8, 0.5, height-16)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [_zanView addSubview:lineView];
        if (i == 0) {
            _zanBtn = button;
        }
        else if (i == 1) {
            
        }
        else if (i == 2) {
            _shareBtn = button;
        }
        else if (i == 3) {
            _collectionBtn = button;
        }
    }
    
    /*
    if (![TKLoginType shareInstance].loginType) {
        [_zanBtn setEnabled:NO];
        [_collectionBtn setEnabled:NO];
        [_shareBtn setEnabled:NO];
        
        [_inputTextView setUserInteractionEnabled:NO];
        [_sendBtn setEnabled:NO];
    }
     */
    
//    [self showZanAnimation];
}

- (UIView *)zanAnimationView
{
    UIImage *image = [UIImage imageNamed:@"点赞动画"];
    UIImage *image2 = [UIImage imageNamed:@"点赞加1"];
    
    if (!_zanAnimationView) {
        _zanAnimationView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH)];
//        _zanAnimationView.backgroundColor = [UIColor clearColor];
        _zanAnimationView.userInteractionEnabled = NO;

        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake((SCREEN_WIDTH - image.size.width) / 2, (SCREEN_WIDTH - image.size.height) / 2, image.size.width, image.size.height);
        [_zanAnimationView addSubview:imageView];
        

        _zanAnimationImageView = [[UIImageView alloc] initWithImage:image2];
        [_zanAnimationView addSubview:_zanAnimationImageView];
    }
    
    _zanAnimationImageView.frame = CGRectMake((SCREEN_WIDTH - image.size.width) / 2 + image.size.width, (SCREEN_WIDTH - image.size.height) / 2 + 10, image2.size.width, image2.size.height);

    return _zanAnimationView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //文本高度变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [_shareView setHidden:YES];
    [self reloadData:YES block:^{
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (keyBoardView) {
        [keyBoardView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textChanged:(NSNotification *)notification
{
    UITextView *textView = notification.object;
    CGFloat height = textView.contentSize.height;
    DLog(@"height = %f", height);
    //调整textView的位置
    CGRect rect = textView.frame;
    rect.size.height = height;
    CGRect footViewRect = _footView.frame;
    if (textView.frame.size.height != height) {
        footViewRect.origin.y -= height - textView.frame.size.height;
        footViewRect.size.height += height - textView.frame.size.height;
        _footView.frame = footViewRect;
        footViewFrame = _footView.frame;
    }
    
    if ([textView.text isEqualToString:@""]) {
        commentFlag = YES; //回复评论
        selectInfo = nil;
        [_placeholderLabel setHidden:NO];
    } else {
        [_placeholderLabel setHidden:YES];
    }
}

//获取数据
- (void)reloadData:(BOOL)refreshView block:(void(^)())block
{
    [GetStreetsnapDetailInput shareInstance].streetsnapId = _streetsnapId;
    [GetStreetsnapDetailInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetStreetsnapDetailInput shareInstance]];
    [[NetInterface shareInstance] getStreetsnapDetail:@"getStreetsnapDetail" param:dict successBlock:^(NSDictionary *responseDict) {
        GetStreetsnapDetail *returnData = [GetStreetsnapDetail modelWithDict:responseDict];
        _streetsnapDetailModel = returnData;
        if (RETURN_SUCCESS(returnData.status)) {
            _streetsnapInfo = returnData.streetsnapInfo;
            _tagInfoArray = returnData.tagInfo;
            _praiseInfoArray = returnData.praiseInfo;
            _rewardInfoArray = returnData.rewardInfo;
            _commentInfoArray = returnData.commentInfo;
            if ([_streetsnapInfo isEqual:@""]) {
                return;
            }
            StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
            if ([info.status isEqualToString:@"1"]) { //当前用户发布
                if (!(self.navigationItem.rightBarButtonItem)) {
                    //设置右侧删除图标
                    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
                    [rightButton setTitle:@"删除" forState:UIControlStateNormal];
                    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
                    [rightButton addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
                    self.navigationItem.rightBarButtonItem = rightItem;
                }
            } else {
                self.navigationItem.rightBarButtonItem = nil;
            }
            if (YES == refreshView) {
                [_detailTableView reloadData];
            }
            block();
        } else {
            [CustomUtil showToastWithText:returnData.msg view:self.view];
        }
    } failedBlock:^(NSError *err) {
    }];
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + _commentInfoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 50;
        case 1:
        {
            StreetsnapInfo *publishInfo = nil;
            if ((nil != _streetsnapInfo) &&
                (![[NSString stringWithFormat:@"%@", _streetsnapInfo] isEqualToString:@""])) {
                publishInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
//                float strRect = [CustomUtil heightForString:publishInfo.streetsnapContent fontSize:14.0f andWidth:(SCREEN_WIDTH - 20)];
              
                float height = SCREEN_WIDTH + _locationLabel.frame.size.height + Y_OFFSET + 1;
                
                if ([CustomUtil CheckParam:publishInfo.publishPlace]) {
                    height = height - _locationLabel.frame.size.height - Y_OFFSET;
                }
                if ([CustomUtil CheckParam:publishInfo.streetsnapContent]) {
//                    height = height - _publishContextLabel.frame.size.height - Y_OFFSET;
                }
                else {
                    height = height + _publishContextLabel.frame.size.height;
                }
                //判断当前是否有用户点赞
                if (_praiseInfoArray.count > 0 || _rewardInfoArray.count > 0) {
                    height += ZANUSR_HEIGHT + ZANUSR_Y_OFFSET * 2;
                }
                else {
                    height = height + ZANUSR_Y_OFFSET;
                }
                
                height = height + GetHeight(_zanView);
                
                return height;
            }
            return _secondCell.frame.size.height;
        }
            break;
        default:
        {
            if (_commentInfoArray.count > 0) {
                NSDictionary *dict = [_commentInfoArray objectAtIndexCheck:(indexPath.row - 2)];
                CommentInfo *info = [[CommentInfo alloc] initWithDict:dict];
                if (indexPath.row == 2) {
                    return [CustomUtil heightForString:info.commentContent fontSize:11.0f andWidth:223] + 24 + 2 + 32;
                }
                return [CustomUtil heightForString:info.commentContent fontSize:11.0f andWidth:223] + 24 + 2;
            }
            return 50;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if ((nil != _streetsnapInfo) && (![[NSString stringWithFormat:@"%@", _streetsnapInfo] isEqualToString:@""])) {
                StreetsnapInfo *personInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
                if (nil == _personImageView.imageURL) {
                    _personImageView.imageURL = [CustomUtil getPhotoURL:personInfo.image];
                }
                [CustomUtil setImageViewCorner:_personImageView];
                [_personImageView setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personImageClick:)];
                [_personImageView addGestureRecognizer:tapGesture];
                _personNameLabel.text = personInfo.userName;
                _publishTimeLabel.text = [CustomUtil timeSpaceWithTimeStr: personInfo.publishTime isBigPhoto:YES];
                
                _publichLocationLabel.text = personInfo.city;
                if ([CustomUtil CheckParam:personInfo.city]) {
                    [_publishLocationImageView setHidden:YES];
                } else {
                    [_publishLocationImageView setHidden:NO];
                }
                
                
                if ([personInfo.status isEqualToString:@"0"]) {
                    if (_guanzhuBtn) {
                        [_guanzhuBtn removeFromSuperview];
                    }
                    
                    // 别人的详情页
                    _guanzhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    _guanzhuBtn.frame = CGRectMake(SCREENWIDTH - 57, (self.firstCell.frame.size.height - 27) / 2 , 57, 27);
                    [_guanzhuBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
                    [_guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
                    _guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
                    _guanzhuBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
                    [self.firstCell addSubview:_guanzhuBtn];
                    [_guanzhuBtn addTarget:self action:@selector(guanzhuPerson:) forControlEvents:UIControlEventTouchUpInside];
                    _guanzhuBtn.hidden = NO;

                    if (_siliaoBtn) {
                        [_siliaoBtn removeFromSuperview];
                    }
                    _siliaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    _siliaoBtn.frame = self.guanzhuBtn.frame;
                    [_siliaoBtn setBackgroundImage:[UIImage imageNamed:@"siliao"] forState:UIControlStateNormal];
                    [_siliaoBtn setTitle:@"私聊" forState:UIControlStateNormal];
                    _siliaoBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
                    _siliaoBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
                    [self.firstCell addSubview:_siliaoBtn];
                    [_siliaoBtn addTarget:self action:@selector(messageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    _siliaoBtn.hidden = YES;

                    if ([_streetsnapDetailModel.followFlag intValue] == 0) { //未关注
                        _guanzhuBtn.hidden = NO;
                        _siliaoBtn.hidden = YES;
                    }
                    if ([_streetsnapDetailModel.followFlag intValue] == 1 || [_streetsnapDetailModel.followFlag intValue] == 2){ //已关注
                        _guanzhuBtn.hidden = YES;
                        _siliaoBtn.hidden = NO;
                    }
                }
            }
        }
            return self.firstCell;
        case 1:
        {
      
            if ((nil != _streetsnapInfo) &&
                (![[NSString stringWithFormat:@"%@", _streetsnapInfo] isEqualToString:@""])) {
                for (UIView *view in _photoScrollView.subviews) {
                    if (view) {
                        [view removeFromSuperview];
                    }
                }
                
                publishInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
                photoCount = 0;
                if (![CustomUtil CheckParam:publishInfo.photo1]) {
                    photoCount++;
                }
                if (![CustomUtil CheckParam:publishInfo.photo2]) {
                    photoCount++;
                }
                if (![CustomUtil CheckParam:publishInfo.photo3]) {
                    photoCount++;
                }
                if (![CustomUtil CheckParam:publishInfo.photo4]) {
                    photoCount++;
                }
                _photoControl.numberOfPages = photoCount;
                if (photoCount > 1) {
                    [_photoControl setHidden:NO];
                } else {
                    [_photoControl setHidden:YES];
                }
                //调整图片指示器的坐标
                CGRect photoCtrlRect = _photoControl.frame;
                photoCtrlRect.origin.y = SCREEN_WIDTH - _photoControl.frame.size.height;
                _photoControl.frame = photoCtrlRect;
                //设置ScrollView
                [_photoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*photoCount, SCREEN_WIDTH)];
                [_photoScrollView setContentOffset:CGPointZero];
                CGRect rect = _photoScrollView.frame;
                rect.origin.x = 0;
                rect.size.width = SCREEN_WIDTH;
                rect.size.height = SCREEN_WIDTH;
                _photoScrollView.frame = rect;
                for (int i=0; i<photoCount; i++) {
                    //原图的尺寸
                    int orginWidth = [[_streetsnapInfo objectForKey:[NSString stringWithFormat:@"width%i", i+1]] intValue];
                    int orginHeight = [[_streetsnapInfo objectForKey:[NSString stringWithFormat:@"height%i", i+1]] intValue];
                    int changeWidth = SCREEN_WIDTH;
                    int changeHeight = SCREEN_WIDTH * orginHeight / orginWidth;
                    
                    if (changeHeight < SCREEN_WIDTH) {
                        changeHeight = SCREEN_WIDTH;
                        changeWidth = changeWidth * SCREEN_WIDTH / (SCREEN_WIDTH * orginHeight / orginWidth);
                    }
                    
                    EGOImageView *destImageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, changeWidth, changeHeight)];
                    destImageView.imageURL = [CustomUtil getPhotoURL:[_streetsnapInfo objectForKey:[NSString stringWithFormat:@"photo%i", i+1]]];
                    [destImageView setUserInteractionEnabled:YES];
                    //创建图片区域
                    EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
                    [imageView setClipsToBounds:YES];
                    [destImageView setCenter:CGPointMake(SCREEN_WIDTH/2, imageView.center.y)];
                    [imageView addSubview:destImageView];
                    
                    /*
                    //计算原图偏移量
                    int tempH = 0;
                    if (orginHeight > SCREEN_WIDTH) {
                        tempH = orginHeight * SCREEN_WIDTH/orginWidth;
                    } else {
                        tempH = orginHeight;
                    }
                    

                    int imageViewOffsetX = 0;
                    int imageViewOffsetY = 0;
                    /\*
                    if (orginWidth >= imageView.frame.size.width) {
                        imageViewOffsetX = (orginWidth - imageView.frame.size.width)/2;
                    } else {
                        imageViewOffsetX = (imageView.frame.size.width - orginWidth)/2;
                    }
                     */
                    //是否图片可以整体显示标记
                    /*
                    BOOL isPhotoCanAllDisplay = NO;
                    if (tempH > imageView.frame.size.height) {
                        imageViewOffsetY = (tempH - imageView.frame.size.height)/2;
                    } else {
                        imageViewOffsetY = (imageView.frame.size.height - tempH)/2;
                        isPhotoCanAllDisplay = YES;
                    }
                     */
                    //add by qi_lele end
                    
                    //确定标签显示的有效区域坐标
                    /*
                    int validateAreaX = 0;
                    int validateAreaY = 0;
                    if (orginWidth > imageView.frame.size.width) {
                        validateAreaX = (orginWidth - imageView.frame.size.width)/2;
                    }
                    if (orginHeight > imageView.frame.size.height) {
                        validateAreaY = (orginHeight - imageView.frame.size.height)/2;
                    }
                     */
                    //创建标签
                    for (int j=0; j<_tagInfoArray.count; j++) {
                        NSDictionary *infoDict = [_tagInfoArray objectAtIndexCheck:j];
                        TagInfo *info = [[TagInfo alloc] initWithDict:infoDict];
                        if ([info.photoNo isEqualToString:[NSString stringWithFormat:@"%d", i+1]]) {
                            
                            int xPosition = [info.horizontal intValue] * changeWidth / orginWidth;
                            int yPostion = [info.vertical intValue] * changeHeight / orginHeight;
                            //过滤标签
                            //获取标签文本尺寸
                            CGSize labelTextSize = [info.tagName sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                            //添加小红点
                            UIImage *backImage = [UIImage imageNamed:@"黑点"];
                            
                            UIImageView *backView = [[UIImageView alloc] init];
                            backView.tag = 100 * i + j;
                            backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
                            backView.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
                            backView.layer.cornerRadius = backImage.size.width / 2;
                            backView.layer.masksToBounds = YES;
                            [destImageView addSubview:backView];
                            
                            UIImage *redImage = [UIImage imageNamed:@"红点-单独"];
                            
                            UIImageView *labelPointImageView = [[UIImageView alloc] initWithImage:redImage];
//                            UIImageView *labelPointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yuan_8"]];
                            int imageOffsetX = (int)(destImageView.frame.size.width - imageView.frame.size.width)/2.0f;
                            int imageOffsetY = (int)(destImageView.frame.size.height - imageView.frame.size.height)/2.0f;
                            //调整大图标签
                            if (xPosition > (destImageView.frame.size.width - 4.5)) {
                                xPosition = destImageView.frame.size.width - 4.5;
                            }
                            if (yPostion > (destImageView.frame.size.height - 25 / 2)) {
                                yPostion = destImageView.frame.size.height - 25 / 2;
                            }
                            if (yPostion < 25 / 2) {
                                yPostion = 25 / 2;
                            }
                            CGRect rect = labelPointImageView.frame;
                            rect.size.width = 9;
                            rect.size.height = 9;
                            labelPointImageView.frame = rect;
                            [labelPointImageView setCenter:CGPointMake(xPosition, yPostion)];
                            [destImageView addSubview:labelPointImageView];
                            backView.center = labelPointImageView.center;

                            //调整label的位置
                            float labelXPostion = xPosition + 8;
                            float labelYPostion = yPostion - 25/2.0f;
                                
                            if (((xPosition - imageOffsetX) < imageView.frame.size.width) && ((xPosition - imageOffsetX) > (imageView.frame.size.width - labelPointImageView.frame.size.width - 8 - labelTextSize.width - 30))) { //右侧超出，将标签显示在左侧
                                labelXPostion = xPosition - 8 - labelTextSize.width - 30;
                            }
                            if (((yPostion - imageOffsetY) < imageView.frame.size.height) && ((yPostion - imageOffsetY) < 25/2.0f)) { //上部超出，移动标签
                                labelYPostion = 0;
                            }
//                            if (((yPostion - imageOffsetY) < imageView.frame.size.height) && (yPostion - imageOffsetY) > (imageView.frame.size.height - 25/2.0f)) { //下部超出，移动标签
//                                labelYPostion = imageView.frame.size.height - 25;
//                            }
                            
                            UIButton *labelButton = [[UIButton alloc] initWithFrame:CGRectMake(labelXPostion, labelYPostion, labelTextSize.width + 35, 25)];
                            [labelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                      
                            labelButton.tag = j;
                            UIImage *buttonBackImage = [UIImage imageNamed:@"标签-通用"];
                            /*
                             if ([CustomUtil CheckParam:info.link]) {
                                buttonBackImage = [UIImage imageNamed:@"标签-通用"];
                                [labelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                            }
                            else {
                                buttonBackImage = [UIImage imageNamed:@"链接-通用"];
                                [labelButton setTitleColor:RGB(21, 161, 173, 1) forState:UIControlStateNormal];
                                [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
                            }
                             */
                            if ([CustomUtil CheckParam:info.link]) {
//                                [backView.layer removeAllAnimations];
                            }
                            else {
                                [self shakeToShow:backView];
                            }

                            [labelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                            [labelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
                            [labelButton setTitle:info.tagName forState:UIControlStateNormal];
//                            [labelButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
                            [labelButton addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [destImageView addSubview:labelButton];
                            
                            UIEdgeInsets insets = UIEdgeInsetsMake(0, 30, 0, 5);

                            if (((xPosition - imageOffsetX) < imageView.frame.size.width) && ((xPosition - imageOffsetX) > (imageView.frame.size.width - labelPointImageView.frame.size.width - 8 - labelTextSize.width - 30))) { //右侧超出，将标签显示在左侧
                                
                                buttonBackImage = [CustomUtil image:buttonBackImage rotation:UIImageOrientationDown];
                                
                                [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];

                                insets = UIEdgeInsetsMake(0, 5, 0, 30);
                            }
                            
                            buttonBackImage = [buttonBackImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
                            [labelButton setBackgroundImage:buttonBackImage forState:UIControlStateNormal];
                        }
                        /*
                        if ((xPosition >= validateAreaX) &&
                            (xPosition <= (validateAreaX + imageView.frame.size.width)) &&
                            (yPostion >= validateAreaY) &&
                            (yPostion <= (validateAreaY + imageView.frame.size.height))) {
                        }
                         */
                    }
                    
                    //为ImageView添加点击事件
                    [imageView setUserInteractionEnabled:YES];
                    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageView)];
                    tapGestureRecognizer.numberOfTapsRequired = 1;
                    tapGestureRecognizer.numberOfTouchesRequired  = 1;
                    [destImageView addGestureRecognizer:tapGestureRecognizer];
                    
                    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
                    doubleTapGesture.numberOfTapsRequired = 2;
                    doubleTapGesture.numberOfTouchesRequired = 1;
                    [destImageView addGestureRecognizer:doubleTapGesture];
                    
                    [tapGestureRecognizer requireGestureRecognizerToFail:doubleTapGesture];

                    [_photoScrollView addSubview:imageView];
                }
                //设置详细位置
                _locationLabel.text = publishInfo.publishPlace;
                if ([CustomUtil CheckParam:publishInfo.publishPlace]) {
                    [_locationImageView setHidden:YES];
                    
                    CGRect publishPlaceRect = _locationLabel.frame;
                    publishPlaceRect.origin.y = SCREEN_WIDTH;
                    publishPlaceRect.size.height = 0;
                    _locationLabel.frame = publishPlaceRect;
                    
                    CGRect locationImageViewRect = _locationImageView.frame;
                    locationImageViewRect.origin.y = SCREEN_WIDTH;
                    locationImageViewRect.size.height = 0;
                    _locationImageView.frame = locationImageViewRect;
                    [_locationImageView setHidden:NO];
                } else {
                    CGRect locationImageViewRect = _locationImageView.frame;
                    locationImageViewRect.origin.x = USER_IMAGE_OFFSET;

                    locationImageViewRect.origin.y = SCREEN_WIDTH + Y_OFFSET;
                    _locationImageView.frame = locationImageViewRect;
                    [_locationImageView setHidden:NO];
                    
                    CGRect publishPlaceRect = _locationLabel.frame;
                    publishPlaceRect.origin.x = locationImageViewRect.origin.x + locationImageViewRect.size.width + 2;
                
                    publishPlaceRect.origin.y = SCREEN_WIDTH + Y_OFFSET;
                    _locationLabel.frame = publishPlaceRect;
                }
                
                [_locationImageView setCenter:CGPointMake(_locationImageView.center.x, _locationLabel.center.y)];
                
                if ([CustomUtil CheckParam:publishInfo.streetsnapContent]) {
                    CGRect publishContextRect = _publishContextLabel.frame;
                    publishContextRect.origin.x = _locationImageView.frame.origin.x;
                    publishContextRect.origin.y = _locationImageView.frame.origin.y + _locationImageView.frame.size.height;
                    publishContextRect.size.height = 0;
                    _publishContextLabel.frame = publishContextRect;
                } else {
                    CGRect publishContextRect = _publishContextLabel.frame;
                    publishContextRect.origin.x = 10;
                    publishContextRect.origin.y = _locationImageView.frame.origin.y + _locationImageView.frame.size.height ;
                    publishContextRect.size.width = (SCREEN_WIDTH - 20);
                    publishContextRect.size.height = [CustomUtil heightForString:publishInfo.streetsnapContent fontSize:14.0f andWidth:(SCREEN_WIDTH - 20)];//[publishInfo.streetsnapContent sizeWithFont:FONT(14) maxSize:CGSizeMake(SCREEN_WIDTH - 20, 200)].height + 1;
                    _publishContextLabel.frame = publishContextRect;                    
                }
                _publishContextLabel.textColor = [UIColor colorWithHexString:@"#585858"];
                
                //设置街拍内容位置
                _publishContextLabel.text = publishInfo.streetsnapContent;
                if ([publishInfo.praiseFlag isEqualToString:@"0"]) { //未赞
                    [_zanBtn setImage:[UIImage imageNamed:@"zan7-4"] forState:UIControlStateNormal];
                } else if ([publishInfo.praiseFlag isEqualToString:@"1"]) { //已赞
                    [_zanBtn setImage:[UIImage imageNamed:@"zan02-7-4"] forState:UIControlStateNormal];
                }
                
                if ([publishInfo.collectionFlag isEqualToString:@"0"]) { //未收藏
                    [_collectionBtn setImage:[UIImage imageNamed:@"like7-4"] forState:UIControlStateNormal];
                } else if ([publishInfo.collectionFlag isEqualToString:@"1"]) { //已收藏
                    [_collectionBtn setImage:[UIImage imageNamed:@"like02-7-4"] forState:UIControlStateNormal];
                }
            }
            
            //获取Cell高度
            StreetsnapInfo *publishInfo1 = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
//            float strRect = [CustomUtil heightForString:publishInfo1.streetsnapContent fontSize:14.0f andWidth:(SCREEN_WIDTH - 20)];
            
            float height = SCREEN_WIDTH + _locationLabel.frame.size.height + Y_OFFSET + 1;
            
            if ([CustomUtil CheckParam:publishInfo1.publishPlace]) {
                height = height - _locationLabel.frame.size.height - Y_OFFSET;
            }
            if ([CustomUtil CheckParam:publishInfo1.streetsnapContent]) {
//                height = height - _publishContextLabel.frame.size.height - Y_OFFSET;
            } else {
                height = height + _publishContextLabel.frame.size.height;
            }
            
            //调整发布位置标签的位置
            CGRect locationImageViewRect = _locationImageView.frame;
            locationImageViewRect.origin.x = 10;
            _locationImageView.frame = locationImageViewRect;
            
            CGRect locationLabelRect = _locationLabel.frame;
            locationLabelRect.origin.x = 10 + _locationImageView.frame.size.width + 2;
            _locationLabel.frame = locationLabelRect;

            
            //创建点赞用户头像及按钮
            
            for (UIView *view in _secondCell.contentView.subviews) {
                if (view && view.tag >4000 && view.tag < 4007) {
                    [view removeFromSuperview];
                }
            }
            
            int i = 0;
            for (EGOImageView *image in _zanUserArray) {
                [image removeFromSuperview];
            }
            for (UIButton *button in _zanUserBtnArray) {
                [button removeFromSuperview];
            }
            [_zanUserArray removeAllObjects];
            [_zanUserBtnArray removeAllObjects];
            for (NSDictionary *dict in _praiseInfoArray) {
                PraiseInfo *info = [[PraiseInfo alloc] initWithDict:dict];
                EGOImageView *zanUserImageView = [[EGOImageView alloc] init];
                zanUserImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
                zanUserImageView.imageURL = [CustomUtil getPhotoURL:info.image];
                UIButton *zanUserBtn = [[UIButton alloc] init];
                zanUserBtn.tag = i;
                [zanUserBtn addTarget:self action:@selector(zanUserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_zanUserArray addObject:zanUserImageView];
                [_zanUserBtnArray addObject:zanUserBtn];
                i++;
            }

            //放置首行用户头像
            
            CGFloat tmpY = height;
            
            if (_zanUserArray.count > 0) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dianzancount"]];
                imageView.tag = 4001;
                imageView.frame = CGRectMake(USER_IMAGE_OFFSET - 1, tmpY  + ZANUSR_HEIGHT + 2 * ZANUSR_Y_OFFSET, ZANUSR_HEIGHT + 2, ZANUSR_HEIGHT + 2);
                imageView.userInteractionEnabled = YES;
                imageView.layer.cornerRadius = imageView.frame.size.width / 2;
                imageView.layer.masksToBounds = YES;
                
                [_secondCell.contentView addSubview:imageView];
                
                NSInteger minX = MIN(3, _zanUserArray.count) + 1;

                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((minX + 1) * USER_IMAGE_OFFSET + minX * ZANUSR_HEIGHT, tmpY  + ZANUSR_HEIGHT + 2 * ZANUSR_Y_OFFSET, ZANUSR_HEIGHT, ZANUSR_HEIGHT)];
                label.layer.cornerRadius = label.frame.size.width / 2;
                label.tag = 4002;
                label.layer.masksToBounds = YES;
                label.userInteractionEnabled = YES;
                label.backgroundColor = [UIColor blackColor];
                label.text = [NSString stringWithFormat:@"%ld", (long)[_streetsnapDetailModel.praiseCount integerValue]];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                labelBtn.tag = 4003;
                labelBtn.frame = CGRectMake(0, 0, ZANUSR_HEIGHT, ZANUSR_HEIGHT);
                [labelBtn addTarget:self action:@selector(zanCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [label addSubview:labelBtn];
                
                [_secondCell.contentView addSubview:label];
                
                for (int j=0; j<3; j++) {
                    if (j < _zanUserArray.count) {
                        int tmp = j + 1;
                        
                        EGOImageView *imageView = [_zanUserArray objectAtIndexCheck:j];
                        imageView.layer.masksToBounds = YES;
                        CGRect rect = imageView.frame;
                        rect.origin.x = (tmp+1) * USER_IMAGE_OFFSET + tmp * ZANUSR_HEIGHT;
                        rect.origin.y = tmpY  + ZANUSR_HEIGHT + 2 * ZANUSR_Y_OFFSET;
                        rect.size.width = ZANUSR_HEIGHT;
                        rect.size.height = ZANUSR_HEIGHT;
                        imageView.frame = rect;
                        [CustomUtil setImageViewCorner:imageView];
                        [_secondCell.contentView addSubview:imageView];
                        UIButton *imageBtn = [_zanUserBtnArray objectAtIndexCheck:j];
                        imageBtn.frame = rect;
                        [_secondCell.contentView addSubview:imageBtn];
                    }
                }
            }

            //创建点赞用户头像及按钮
            int j = 0;
            for (EGOImageView *image in _rewardUserArray) {
                [image removeFromSuperview];
            }
            for (UIButton *button in _rewardUserBtnArray) {
                [button removeFromSuperview];
            }
            [_rewardUserArray removeAllObjects];
            [_rewardUserBtnArray removeAllObjects];
            for (NSDictionary *dict in _rewardInfoArray) {
                RewardInfo *info = [[RewardInfo alloc] initWithDict:dict];
                EGOImageView *zanUserImageView = [[EGOImageView alloc] init];
                zanUserImageView.placeholderImage = [UIImage imageNamed:@"photo-bg7-4"];
                zanUserImageView.imageURL = [CustomUtil getPhotoURL:info.image];
                UIButton *zanUserBtn = [[UIButton alloc] init];
                zanUserBtn.tag = j;
                [zanUserBtn addTarget:self action:@selector(rewardUserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_rewardUserArray addObject:zanUserImageView];
                [_rewardUserBtnArray addObject:zanUserBtn];
                j++;
            }
            
            CGFloat tmp_x = SCREEN_WIDTH / 2;
            if (_praiseInfoArray.count == 0) {
                tmp_x = 0;
            }
            if (_rewardUserArray.count > 0) {
                UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rewardcount"]];
                imageView2.frame = CGRectMake(tmp_x + USER_IMAGE_OFFSET - 1, tmpY +  + ZANUSR_HEIGHT + 2 * ZANUSR_Y_OFFSET, ZANUSR_HEIGHT + 2, ZANUSR_HEIGHT + 2);
                imageView2.tag = 4004;
                imageView2.userInteractionEnabled = YES;
                imageView2.layer.cornerRadius = imageView2.frame.size.width / 2;
                imageView2.layer.masksToBounds = YES;
                
                [_secondCell.contentView addSubview:imageView2];

                NSInteger minX = MIN(3, _rewardUserArray.count) + 1;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tmp_x + (minX + 1) * USER_IMAGE_OFFSET + minX * ZANUSR_HEIGHT, tmpY  + ZANUSR_HEIGHT + 2 * ZANUSR_Y_OFFSET, ZANUSR_HEIGHT, ZANUSR_HEIGHT)];
                label.userInteractionEnabled = YES;
                label.tag = 4005;
                label.layer.cornerRadius = label.frame.size.width / 2;
                label.layer.masksToBounds = YES;
                label.backgroundColor = [UIColor blackColor];
                label.text = [NSString stringWithFormat:@"%lu",  (long)[_streetsnapDetailModel.rewardCount integerValue]];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                labelBtn.tag = 4006;
                labelBtn.frame = CGRectMake(0, 0, ZANUSR_HEIGHT, ZANUSR_HEIGHT);
                [labelBtn addTarget:self action:@selector(rewardCountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [label addSubview:labelBtn];
                
                [_secondCell.contentView addSubview:label];
                
                for (int j=0; j<3; j++) {
                    if (j < _rewardUserArray.count) {
                        int tmp = j + 1;
                        
                        EGOImageView *imageView = [_rewardUserArray objectAtIndexCheck:j];
                        CGRect rect = imageView.frame;
                        rect.origin.x = tmp_x + (tmp+1) * USER_IMAGE_OFFSET + tmp * ZANUSR_HEIGHT;
                        rect.origin.y = tmpY  + ZANUSR_HEIGHT + 2 * ZANUSR_Y_OFFSET;
                        rect.size.width = ZANUSR_HEIGHT;
                        rect.size.height = ZANUSR_HEIGHT;
                        imageView.frame = rect;
                        [CustomUtil setImageViewCorner:imageView];
                        [_secondCell.contentView addSubview:imageView];
                        UIButton *imageBtn = [_rewardUserBtnArray objectAtIndexCheck:j];
                        imageBtn.frame = rect;
                        [_secondCell.contentView addSubview:imageBtn];
                    }
                }
            }

            
            //用户头像首行y坐标
            float zanViewY = tmpY;
//            if (_praiseInfoArray.count > 0 || _rewardInfoArray.count > 0) {
//                zanViewY = zanViewY + ZANUSR_HEIGHT + 2 * ZANUSR_Y_OFFSET;
//            }
//            else {
//                zanViewY = zanViewY + ZANUSR_Y_OFFSET;
//            }
            
            CGRect zanViewRect = _zanView.frame;
            if (_zanUserArray.count > 0) {
                zanViewRect.origin.y = zanViewY;
            } else {
                zanViewRect.origin.y = zanViewY;
            }
            
            _zanView.frame = zanViewRect;
            [_secondCell.contentView addSubview:_zanView];
            
//            _publishContextLabel.backgroundColor = [UIColor greenColor];
//            _zanView.backgroundColor = [UIColor redColor];
        }
            return self.secondCell;
        default:
        {
            StreetPhotoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StreetPhotoDetailCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"StreetPhotoDetailCell" owner:self options:nil] lastObject];
            }
            CommentInfo *commentInfo = [[CommentInfo alloc] initWithDict:[_commentInfoArray objectAtIndexCheck:(indexPath.row - 2)]];
            StreetsnapInfo *streetSnapInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
            if ([streetSnapInfo.userId isEqualToString:[LoginModel shareInstance].userId]) {
                [cell.deleteCommentBtn setHidden:NO];
            } else if ([commentInfo.userId isEqualToString:[LoginModel shareInstance].userId]) {
                [cell.deleteCommentBtn setHidden:NO];
            } else {
                [cell.deleteCommentBtn setHidden:YES];
            }
            cell.deleteCommentBtn.tag = indexPath.row - 2;
            cell.personBtn.tag = indexPath.row - 2;
            if ([[cell.personImageView.imageURL absoluteString] isEqualToString:[CustomUtil getPhotoURL:commentInfo.image].absoluteString]) {
            } else {
                cell.personImageView.imageURL = [CustomUtil getPhotoURL:commentInfo.image];
            }
            
            [CustomUtil setImageViewCorner:cell.personImageView];

            //设置评论用户名称
            if ([commentInfo.replyName isEqualToString:@""]) {
                cell.personNameLabel.text = commentInfo.userName;
            } else {
                cell.personNameLabel.text = [NSString stringWithFormat:@"%@ 回复 %@", commentInfo.userName, commentInfo.replyName];
            }
            
            cell.commentContextLabel.text = commentInfo.commentContent;
            
            cell.commentTimeLabel.text = [NSString stringWithFormat:@"%@", [CustomUtil timeSpaceWithTimeStr:commentInfo.commentTime isBigPhoto:NO]];
            
            cell.imageClickDelegate = self;
            cell.deleteCommentDelegate = self;
            
            CGSize size = [cell.commentTimeLabel.text sizeWithFont:cell.commentTimeLabel.font maxSize:CGSizeMake(SCREENWIDTH, 40)];
            CGRect timeRect = cell.commentTimeLabel.frame;
            timeRect.origin.x = SCREENWIDTH - size.width - 9;
            timeRect.size.width = size.width + 1;
            cell.commentTimeLabel.frame = timeRect;
//            cell.commentTimeLabel.autoresizesSubviews = NO;
            cell.commentTimeLabel.autoresizingMask = UIViewAutoresizingNone;

            //根据评论内容调整行高度
            CGRect rect = cell.commentContextLabel.frame;
            float contentHeight = [CustomUtil heightForString:commentInfo.commentContent fontSize:11.0f andWidth:cell.commentContextLabel.frame.size.width];
            rect.size.height = contentHeight;
            cell.commentContextLabel.frame = rect;
            [cell.commentContextLabel setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            [cell.commentContextLabel setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

            CGRect rect2 = cell.personNameLabel.frame;
            rect2.origin.x = 45 + 4;
            rect2.size.width = GetX(cell.commentTimeLabel) - (45 + 4) - 4;
            cell.personNameLabel.frame = rect2;
            
            cell.commentTimeLabel.textColor = cell.personNameLabel.textColor = [UIColor colorWithHexString:@"#8d8d8d"];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentLabelClick:)];
            [cell.commentContextLabel addGestureRecognizer:tapGesture];
            
            
            CGFloat tmpHeight = 50 - 0.5;
            if (_commentInfoArray.count > 0) {
                NSDictionary *dict = [_commentInfoArray objectAtIndexCheck:(indexPath.row - 2)];
                CommentInfo *info = [[CommentInfo alloc] initWithDict:dict];
                tmpHeight = [CustomUtil heightForString:info.commentContent fontSize:11.0f andWidth:223] + 24 + 2 - 0.5;
            }
            
            cell.lineView.frame = CGRectMake(0, tmpHeight, SCREENWIDTH, 0.5);
            [cell.contentView addSubview:cell.lineView];
            
            CGFloat tmp_Y = 0;
            
            if (indexPath.row == 2) {
                
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:10001];
                if (!imageView) {
                    imageView = [[UIImageView alloc] init];
                }
                imageView.hidden = NO;
                UIImage *image = [UIImage imageNamed:@"评论列表"];
                imageView.frame = CGRectMake(8, (45 - image.size.height) / 2, image.size.width, image.size.height);
                imageView.image = image;
                imageView.tag = 10001;
                [cell.contentView addSubview:imageView];
                
                UILabel *label = (UILabel *)[cell.contentView viewWithTag:10002];
                if (!label) {
                    label = [[UILabel alloc] init];
                }
                label.frame = CGRectMake(GetWidth(imageView) + 8 + 6, (45 - image.size.height) / 2 - 1, SCREENWIDTH - (GetWidth(imageView) - 14), image.size.height);
                label.tag = 10002;
                label.hidden = NO;
                label.font = FONT(12);
                label.textColor = [UIColor colorWithHexString:@"#8d8d8d"];
                label.text = [NSString stringWithFormat:@"%d条评论", (int)_commentInfoArray.count];
                [cell.contentView addSubview:label];

                UIButton *button = (UIButton *)[cell.contentView viewWithTag:10003];
                if (!button) {
                    button = [UIButton buttonWithType:UIButtonTypeCustom];
                }
                button.hidden = NO;
                [button addTarget:self action:@selector(blankCLick) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(0, 0, SCREENWIDTH, 45);
                button.tag = 10003;
                [cell.contentView addSubview:button];
                
                tmp_Y = 32;
            }
            else {
                UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:10001];
                imageView.hidden = YES;
                
                UILabel *label = (UILabel *)[cell.contentView viewWithTag:10002];
                label.hidden = YES;
                
                UIButton *button = (UIButton *)[cell.contentView viewWithTag:10003];
                button.hidden = YES;
            }
            
            CGRect timeRect2 = cell.commentTimeLabel.frame;
            timeRect2.origin.y = 11 + tmp_Y;
            cell.commentTimeLabel.frame = timeRect2;
            
            CGRect backImageRect = cell.personBackImageView.frame;
            backImageRect.origin.y = 13 + tmp_Y;
            cell.personBackImageView.frame = backImageRect;
            
            CGRect imageRect = cell.personImageView.frame;
            imageRect.origin.y = 13 + tmp_Y;
            cell.personImageView.frame = imageRect;
            
            CGRect imageBtnRect = cell.personBtn.frame;
            imageBtnRect.origin.y = 13 + tmp_Y;
            cell.personBtn.frame = imageBtnRect;
            
            CGRect _rect = cell.commentContextLabel.frame;
            _rect.origin.y = 27 + tmp_Y;
            cell.commentContextLabel.frame = _rect;
            
            CGRect _rect2 = cell.personNameLabel.frame;
            _rect2.origin.y = 9 + tmp_Y;
            cell.personNameLabel.frame = _rect2;
            
            CGRect _rect3 = cell.deleteCommentBtn.frame;
            _rect3.origin.y = 22 + tmp_Y;
            cell.deleteCommentBtn.frame = _rect3;
            
            cell.lineView.frame = CGRectMake(0, tmpHeight + tmp_Y, SCREENWIDTH, 0.5);
            
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  if ([TKLoginType shareInstance].loginType) {
        if (indexPath.row > 1) { //评论列表
            CommentInfo *info = [[CommentInfo alloc] initWithDict:[_commentInfoArray objectAtIndexCheck:(indexPath.row -2)]];
            [_inputTextView setText:[NSString stringWithFormat:@"回复%@:", info.userName]];
            [_placeholderLabel setHidden:YES];
            [_inputTextView becomeFirstResponder];
            commentFlag = NO; //回复评论
            selectInfo = info;
        }
  //  }
    
    return;
}

//评论内容点击事件
-(void)commentLabelClick:(UIGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    StreetPhotoDetailCell *cell = (StreetPhotoDetailCell *)(view.superview.superview);
    NSIndexPath *index = [_detailTableView indexPathForCell:cell];
    [self tableView:_detailTableView didSelectRowAtIndexPath:index];
}

//更多按钮点击事件
-(void)moreBtnClick:(id)sender
{

    [_detailTableView reloadData];
}

#pragma mark -TextField代理方法
-(void)keyboardWillShow:(NSNotification *)aNotifaction
{
    if (!_isRewardEdit) {
        CGFloat offsetHeight = [self getKeyBoardHeight:aNotifaction];
        
        if ([_inputTextView.text isEqualToString:@""]) {
            CGRect footViewRect = _footView.frame;
            footViewRect.size.height = footViewOrginFrame.size.height;
            footViewRect.origin.y = self.view.frame.size.height - offsetHeight - footViewRect.size.height;
            _footView.frame = footViewRect;
        } else {
            _footView.frame = footViewFrame;
            CGRect rect = _footView.frame;
            rect.origin.y = self.view.frame.size.height - offsetHeight - rect.size.height;
            _footView.frame = rect;
        }
        
        //增加遮罩，点击后键盘消失
        if (!keyBoardView) {
            keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - offsetHeight - _footView.frame.size.height)];
        }
        [keyBoardView setBackgroundColor:[UIColor clearColor]];
        [keyBoardView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageClick)];
        [keyBoardView addGestureRecognizer:guesture];
        UIWindow *keyv = [[UIApplication sharedApplication] keyWindow];
        [keyv addSubview:keyBoardView];
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotifaction
{
    if ([_inputTextView.text isEqualToString:@""]) {
        CGRect footViewRect = _footView.frame;
        footViewRect.size.height = footViewOrginFrame.size.height;
        _footView.frame = footViewRect;
    }
    CGRect rect = _footView.frame;
    rect.origin.y = self.view.frame.size.height - rect.size.height;
    _footView.frame = rect;
    
    [keyBoardView removeFromSuperview];
}

-(CGFloat)getKeyBoardHeight:(NSNotification *)aNotifaction
{
    NSDictionary *info = [aNotifaction userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    return keyboardRect.size.height;
}

-(void)backImageClick
{
    [_inputTextView resignFirstResponder];
    
    [_rewardTextFeild resignFirstResponder];
}

//关注按钮点击事件
- (void)guanzhuPerson:(id)sender {
    //if (![TKLoginType shareInstance].loginType) {
    //   return;
    //}
    StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    
    [UpdateFollwInput shareInstance].userId = info.userId;
    [UpdateFollwInput shareInstance].fansId = [LoginModel shareInstance].userId;
    if ([_streetsnapDetailModel.followFlag intValue] == 0) {
        // 未关注
        //加关注
        [UpdateFollwInput shareInstance].flag = @"0";
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
        [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
           
            UpdateBlacklist *returnData = [UpdateBlacklist modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                if ([_streetsnapDetailModel.followFlag intValue] == 0) {
                    _streetsnapDetailModel.followFlag = @1;
                } else if ([_streetsnapDetailModel.followFlag intValue] == 1) {
                    _streetsnapDetailModel.followFlag = @0;
                }
                if ([_streetsnapDetailModel.followFlag intValue] == 0) { //未关注
                    _guanzhuBtn.hidden = NO;
                    _siliaoBtn.hidden = YES;
                } else if([_streetsnapDetailModel.followFlag intValue] == 1) { //已关注
                    _guanzhuBtn.hidden = YES;
                    _siliaoBtn.hidden = NO;
                }
            }
            [CustomUtil showToastWithText:returnData.msg view:self.view];
                    
        } failedBlock:^(NSError *err) {
            
        }];
    } else if ([_streetsnapDetailModel.followFlag intValue] == 1 || [_streetsnapDetailModel.followFlag intValue] == 2) { //已关注
        //取消关注
        [CustomUtil showCustomAlertView:nil message:@"确定不再关注此人？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
            [UpdateFollwInput shareInstance].flag = @"1";
            NSMutableDictionary *dict = [CustomUtil modelToDictionary:[UpdateFollwInput shareInstance]];
            [[NetInterface shareInstance] updateFollow:@"updateFollow" param:dict successBlock:^(NSDictionary *responseDict) {
                UpdateBlacklist *returnData = [UpdateBlacklist modelWithDict:responseDict];
                if (RETURN_SUCCESS(returnData.status)) {
                    if ([_streetsnapDetailModel.followFlag intValue] == 0) {
                        _streetsnapDetailModel.followFlag = @1;
                    } else if ([_streetsnapDetailModel.followFlag intValue] == 1) {
                        _streetsnapDetailModel.followFlag = @0;
                    }
                    if ([_streetsnapDetailModel.followFlag intValue] == 0) { //未关注
                        _guanzhuBtn.hidden = NO;
                        _siliaoBtn.hidden = YES;
                    } else if([_streetsnapDetailModel.followFlag intValue] == 1) { //已关注
                        _guanzhuBtn.hidden = YES;
                        _siliaoBtn.hidden = NO;
                    }
                }
                [CustomUtil showToastWithText:returnData.msg view:self.view];
            } failedBlock:^(NSError *err) {
            }];
        } target:self btnCount:2];
    }
}

- (void)messageBtnClick:(id)sender {
    //    if ([TKLoginType shareInstance].loginType) {
    
    StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];

    //取得私信内容
    [GetMessageInput shareInstance].pagesize = @"10";
    [GetMessageInput shareInstance].current = @"1";
    [GetMessageInput shareInstance].userId = [LoginModel shareInstance].userId;
    [GetMessageInput shareInstance].targetId = info.userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[GetMessageInput shareInstance]];
    SendPrivateMessageViewController *sendPrivateMessageViewCtrl = [[SendPrivateMessageViewController alloc] initWithNibName:@"SendPrivateMessageViewController" bundle:nil];
    sendPrivateMessageViewCtrl.dict = dict;
    sendPrivateMessageViewCtrl.userName = info.userName;
    sendPrivateMessageViewCtrl.receiveId = info.userId;
    [self.navigationController pushViewController:sendPrivateMessageViewCtrl animated:YES];
    //   }
}


#pragma mark -ScrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_photoControl setCurrentPage:(int)fabs(scrollView.contentOffset.x/SCREEN_WIDTH)];
}

#pragma mark - UITextField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _rewardTextFeild) {
        _isRewardEdit = YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _rewardTextFeild) {
        _isRewardEdit = NO;
    }
}

#pragma mark -街拍详情评论删除代理
//删除评论
-(void)deleteCommentBtnClick:(id)sender
{
    [CustomUtil showCustomAlertView:@"" message:@"确定要删除这条评论吗？" leftTitle:@"取消" rightTitle:@"确认" leftHandle:nil rightHandle:^(UIAlertAction *action) {
        UIButton *button = (UIButton *)sender;
        NSDictionary *dict = [_commentInfoArray objectAtIndexCheck:button.tag];
        CommentInfo *info = [[CommentInfo alloc] initWithDict:dict];
        StreetsnapInfo *snapInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
        
        [DeleteCommentInput shareInstance].commentId = info.commentId;
        [DeleteCommentInput shareInstance].streetsnapUserId = snapInfo.userId;
        NSMutableDictionary *inputDict = [CustomUtil modelToDictionary:[DeleteCommentInput shareInstance]];
        [[NetInterface shareInstance] deleteComment:@"deleteComment" param:inputDict successBlock:^(NSDictionary *responseDict) {
            BaseModel *returnData = [BaseModel modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                [self reloadData:YES block:^{
                }];
            }
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        } failedBlock:^(NSError *err) {
        }];
    } target:self btnCount:2];
}

#pragma mark - custommethod
/* 显示打赏选择界面 */
- (void)showRewardView1
{
    NSLog(@"打赏点击:%@", _rewardDictionary);
    
    [_rewardTextFeild resignFirstResponder];
    
    NSArray *array = [_rewardDictionary objectForKey:@"rewardTemplate"];
    _rewardCount = array.count;
    
    StreetsnapInfo *personInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    
    if (!_rewardBackView) {
        _rewardBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _rewardBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:_rewardBackView];
    }
    
    UIImageView *imageView1 = (UIImageView *)[_rewardBackView viewWithTag:2000];
    UIImage *image1 = [UIImage imageNamed:@"打赏背景"];
    if (!imageView1) {
        imageView1 = [[UIImageView alloc] initWithImage:image1];
    }
    imageView1.frame = CGRectMake(23, (SCREEN_HEIGHT - image1.size.height)/2, SCREEN_WIDTH - 46, image1.size.height);
    imageView1.userInteractionEnabled = YES;
    imageView1.layer.cornerRadius = 3;
    imageView1.layer.masksToBounds = YES;
    [_rewardBackView addSubview:imageView1];
    
    UIImageView *imageView2 = (UIImageView *)[_rewardBackView viewWithTag:2001];
    UIImage *image2 = [UIImage imageNamed:@"打赏关闭"];
    if (!imageView2) {
        imageView2 = [[UIImageView alloc] initWithImage:image2];
    }
    imageView2.frame = CGRectMake(GetWidth(imageView1) - image2.size.width, GetY(imageView1) - image2.size.height, image2.size.width, image2.size.height);
    imageView2.userInteractionEnabled = YES;
    [_rewardBackView addSubview:imageView2];

    UIImageView *imageView3 = (UIImageView *)[_rewardBackView viewWithTag:2002];
    UIImage *image3 = [UIImage imageNamed:@"打赏打赏"];
    if (!imageView3) {
        imageView3 = [[UIImageView alloc] initWithImage:image3];
    }
    imageView3.userInteractionEnabled = YES;
    [imageView1 addSubview:imageView3];

    
    NSString *str = [NSString stringWithFormat:@" %@", personInfo.userName];
    UILabel *label = (UILabel *)[_rewardBackView viewWithTag:2003];
    if (!label) {
        label = [[UILabel alloc] init];
    }
    label.text = str;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    [imageView1 addSubview:label];

    CGSize size = [str sizeWithFont:label.font maxSize:CGSizeMake(GetWidth(imageView1) - image3.size.width, 55)];

    imageView3.frame = CGRectMake((GetWidth(imageView1) - size.width - image3.size.width)/2, (55 - image3.size.height)/2, image3.size.width, image3.size.height);

    label.frame = CGRectMake(GetWidth(imageView3) + GetX(imageView3), 0, size.width, 55);

    CGFloat btn_width = 80;
    CGFloat btn_height = 30;

    CGFloat btn_offsetX = 5;
    CGFloat btn_offsetY = 8;

    CGFloat btn_X = (GetWidth(imageView1) - 3 * btn_width - 2 * btn_offsetX) / 2;
    CGFloat btn_Y = 91;

    for (int i = 0; i < array.count; i++) {
        UIButton *button = (UIButton *)[_rewardBackView viewWithTag:3000 + i];
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        button.frame = CGRectMake(btn_X + (btn_width + btn_offsetX) * (i % 3), btn_Y + (btn_height + btn_offsetY) * (i / 3), btn_width, btn_height);
        button.tag = 3000 + i;
        button.layer.borderColor = [UIColor colorWithHexString:@"#a3a3a3"].CGColor;
        button.layer.borderWidth = 0.5;
        [button setImage:[UIImage imageNamed:@"打赏毛豆"] forState:UIControlStateNormal];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#ee3e2f"]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(chooseReward:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [imageView1 addSubview:button];
    }
    
    UILabel *label2 = (UILabel *)[_rewardBackView viewWithTag:2004];
    if (!label2) {
        label2 = [[UILabel alloc] init];
    }
    label2.frame = CGRectMake(0, GetHeight(imageView1) - 42 - 18 - 40, GetWidth(imageView1), 40);
    label2.text = [NSString stringWithFormat:@"目前账户余额毛豆为：%@毛豆", [_rewardDictionary objectForKey:@"mxCoinSum"]];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
    [imageView1 addSubview:label2];

    UIButton *button = (UIButton *)[_rewardBackView viewWithTag:2005];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    button.frame = CGRectMake((GetWidth(imageView1) - 240) / 2, GetHeight(imageView1) - 42 - 18, 240, 42);
    button.layer.cornerRadius = 21;
    button.layer.masksToBounds = YES;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#ee3e2f"]] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toDoReward:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [imageView1 addSubview:button];

    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRewardBackView)];
    }
    [imageView2 addGestureRecognizer:_tap];
    
    [_rewardBackView setHidden:NO];
    [_rewardBackView2 setHidden:YES];
}

- (void)showRewardView2
{
    NSLog(@"打赏点击:%@", _rewardDictionary);
    
    if (!_rewardBackView2) {
        _rewardBackView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        _rewardBackView2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:_rewardBackView2];
    }
    
    UIImageView *imageView1 = (UIImageView *)[_rewardBackView2 viewWithTag:1000];
    UIImage *image1 = [UIImage imageNamed:@"打赏背景"];
    if (!imageView1) {
        imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    }
    imageView1.frame = CGRectMake(23, (SCREEN_HEIGHT - image1.size.height)/2, SCREEN_WIDTH - 46, image1.size.height);
    imageView1.userInteractionEnabled = YES;
    imageView1.layer.cornerRadius = 3;
    imageView1.layer.masksToBounds = YES;
    imageView1.backgroundColor = [UIColor whiteColor];
    [_rewardBackView2 addSubview:imageView1];
    
    UIImageView *imageView2 = (UIImageView *)[_rewardBackView2 viewWithTag:1001];
    UIImage *image2 = [UIImage imageNamed:@"打赏关闭"];
    if (!imageView2) {
        imageView2 = [[UIImageView alloc] initWithImage:image2];
    }
    imageView2.frame = CGRectMake(GetWidth(imageView1) - image2.size.width, GetY(imageView1) - image2.size.height, image2.size.width, image2.size.height);
    imageView2.userInteractionEnabled = YES;
    [_rewardBackView2 addSubview:imageView2];
    
    UIImageView *imageView3 = (UIImageView *)[_rewardBackView2 viewWithTag:1002];
    UIImage *image3 = [UIImage imageNamed:@"打赏标题"];
    if (!imageView3) {
        imageView3 = [[UIImageView alloc] initWithImage:image3];
    }
    imageView3.frame = CGRectMake((GetWidth(imageView1) - image3.size.width)/2, 25, image3.size.width, image3.size.height);
    imageView3.userInteractionEnabled = YES;
    [imageView1 addSubview:imageView3];

    UIButton *button2 = (UIButton *)[_rewardBackView2 viewWithTag:1003];
    if (!button2) {
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    button2.frame = CGRectMake(0, 0, 100, 49);
    button2.layer.cornerRadius = 21;
    button2.layer.masksToBounds = YES;
    [button2 setImage:[UIImage imageNamed:@"返回箭头-通用2"] forState:UIControlStateNormal];
    [button2 setTitle:@" 返回选择" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithHexString:@"#a3a3a3"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showRewardView1) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font = [UIFont systemFontOfSize:16];
    [imageView1 addSubview:button2];

    _rewardTextFeild = (UITextField *)[_rewardBackView2 viewWithTag:1004];
    if (!_rewardTextFeild) {
        _rewardTextFeild = [[UITextField alloc] init];
    }
    _rewardTextFeild.frame = CGRectMake((GetWidth(imageView1) - 240) / 2, GetHeight(imageView3) + GetY(imageView3) + 10, 240, 40);
    _rewardTextFeild.placeholder = @"请输入毛豆金额";
    _rewardTextFeild.delegate = self;
    _rewardTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    _rewardTextFeild.layer.borderColor = [UIColor colorWithHexString:@"#a3a3a3"].CGColor;
    _rewardTextFeild.layer.borderWidth = 0.5;
    _rewardTextFeild.font = [UIFont systemFontOfSize:12];
    _rewardTextFeild.textColor = [UIColor blackColor];
    _rewardTextFeild.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _rewardTextFeild.leftViewMode = UITextFieldViewModeAlways;
    [imageView1 addSubview:_rewardTextFeild];
    
    UILabel *label2 = (UILabel *)[_rewardBackView2 viewWithTag:1005];
    if (!label2) {
        label2 = [[UILabel alloc] init];
    }
    label2.frame = CGRectMake(0, GetHeight(imageView1) - 42 - 18 - 40, GetWidth(imageView1), 40);
    label2.text = [NSString stringWithFormat:@"目前账户余额毛豆为：%@毛豆", [_rewardDictionary objectForKey:@"mxCoinSum"]];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
    [imageView1 addSubview:label2];
    
    UIButton *button = (UIButton *)[_rewardBackView2 viewWithTag:1006];
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    button.frame = CGRectMake((GetWidth(imageView1) - 240) / 2, GetHeight(imageView1) - 42 - 18, 240, 42);
    button.layer.cornerRadius = 21;
    button.layer.masksToBounds = YES;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#ee3e2f"]] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toDoReward2:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [imageView1 addSubview:button];
    
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRewardBackView)];
    }
    [imageView2 addGestureRecognizer:_tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [_rewardBackView2 addGestureRecognizer:tap2];
    
    [_rewardBackView setHidden:YES];
    [_rewardBackView2 setHidden:NO];
}

- (void)chooseReward:(UIButton *)sender
{
    for (int i = 0; i < _rewardCount; i++) {
        UIButton *button = (UIButton *)[_rewardBackView viewWithTag:3000 + i];
        button.selected = NO;
    }
    
    if (sender.tag == 3000 + _rewardCount - 1) {
        [self showRewardView2];
    }
    else {
        sender.selected = !sender.selected;
    }
}

- (void)toReward:(NSInteger)coin
{
    [_rewardTextFeild resignFirstResponder];

//    localhost:8080/maoxj/mxCoin/toReward?streetsnapId=2833&streetsnapUserId=2833&rewardSum=5&userId=2833
    if ([_streetsnapInfo isEqual:@""] ||
        (nil == _streetsnapInfo)) {
        return;
    }
    StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    [PublishPraiseInput shareInstance].streetsnapId = _streetsnapId;
    [PublishPraiseInput shareInstance].streetsnapUserId = info.userId;
    [PublishPraiseInput shareInstance].userId = [LoginModel shareInstance].userId;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[PublishPraiseInput shareInstance]];
    [dict setValue:@(coin) forKey:@"rewardSum"];
    [CustomUtil showLoadingInView:[UIApplication sharedApplication].keyWindow hintText:@""];
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/toReward" param:dict successBlock:^(NSDictionary *responseDict) {
        if ([[responseDict objectForKey:@"code"] integerValue] == 1) {
            NSLog(@"打赏成功：%@", responseDict);
            [self hideRewardBackView];
            [self reloadData:YES block:^{
                
            }];

            [CustomUtil showToast:[responseDict objectForKey:@"msg"] ? [responseDict objectForKey:@"msg"] : @"打赏成功" view:self.view];
        }
        else {
            [CustomUtil showToast:[responseDict objectForKey:@"msg"] ? [responseDict objectForKey:@"msg"]: @"打赏失败" view:[UIApplication sharedApplication].keyWindow];
        }
    } failedBlock:^(NSError *err) {
        //        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
    }];
}

- (void)hideRewardBackView
{
    [_rewardBackView setHidden:YES];
    [_rewardBackView2 setHidden:YES];
}

- (void)hideKeyBoard
{
    [_rewardTextFeild resignFirstResponder];
}

- (void)shakeToShow:(UIView *)aView
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.7;
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:0];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

#pragma mark -按钮点击事件
- (void)customButtonClick:(UIButton *)btn
{
//    @"赞", @"打赏", @"分享", @"收藏"
    if (btn.tag == 0) {
        // 赞
        [self zanBtnClick:btn];
    }
    else if (btn.tag == 1) {
        // 打赏
        [self dashangBtnClick:btn];
    }
    else if (btn.tag == 2) {
        // 分享
        [self shareBtnClick:btn];
    }
    else if (btn.tag == 3) {
        // 收藏
        [self collectionBtnClick:btn];
    }
}

//大图点击事件
-(void)touchImageView
{
    NSLog(@"单击");
    PhotoDetailViewController *photoDetailViewCtrl = [[PhotoDetailViewController alloc] initWithNibName:@"PhotoDetailViewController" bundle:nil];
    photoDetailViewCtrl.streetsnapInfo = _streetsnapInfo;
    photoDetailViewCtrl.tagInfoArray = _tagInfoArray;
    DLog(@"currentPage = %ld", (long)_photoControl.currentPage);
    photoDetailViewCtrl.currentPageIndex = (int)_photoControl.currentPage;
    [self.navigationController pushViewController:photoDetailViewCtrl animated:YES];
}

// 大图双击事件
- (void)handleDoubleTap
{
    NSLog(@"双击");
    [self zanBtnClick:nil];
}

//标签按钮点击事件
-(void)imageBtnClick:(UIButton *)sender
{
    DLog(@"button.tag = %ld", sender.tag);
    NSDictionary *dict = [_tagInfoArray objectAtIndexCheck:sender.tag];
    TagInfo *info = [[TagInfo alloc] initWithDict:dict];
    if ([CustomUtil CheckParam:info.link]) {
        LabelDetailViewController *viewCtrl = [[LabelDetailViewController alloc] init];
        viewCtrl.tagId = info.tagId;
        viewCtrl.tagName = info.tagName;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    } else {
        NSString *urlAddress = @"";
        if ((info.link.length > 7) && [[info.link substringToIndex:7] isEqualToString:@"http://"]) {
            urlAddress = info.link;
        } else if ((info.link.length > 8) && [[info.link substringToIndex:8] isEqualToString:@"https://"]) {
            urlAddress = info.link;
        } else {
            urlAddress = [NSString stringWithFormat:@"http://%@", info.link];
        }
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress]]) {
            [CustomUtil showToastWithText:@"无效的网址" view:kWindow];
        }
    }
}

//返回按钮的点击事件处理
-(void)backButtonClick
{
    if (YES == _intoFlag) {
        if (YES == [TKPublishType shareInstance].publishType) {
            //跳转至个人主页
            for (UIViewController *ctrl in self.navigationController.viewControllers) {
                if ([ctrl isKindOfClass:[MyStreetPhotoViewController class]]) {
                    [self.navigationController popToViewController:ctrl animated:YES];
                }
            }
        } else {
            //跳转至首页
            for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
                if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                    TabBarController *controller = (TabBarController *)viewCtrl;
                    [controller setSelectedIndex:0];
                    PublishStreetPhotoViewController *publishViewCtr = (PublishStreetPhotoViewController *)(controller.viewControllers[2]);
                    //清空相机胶卷的选择图片
                    [publishViewCtr.selectPhotoArray removeAllObjects];
                    [self.navigationController popToViewController:viewCtrl animated:YES];
                }
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//删除街拍按钮点击事件
-(void)deleteBtnClick:(id)sender
{
    [CustomUtil showCustomAlertView:@"" message:@"确定要删除这条街拍吗？" leftTitle:@"取消" rightTitle:@"确认" leftHandle:nil rightHandle:^(UIAlertAction *action) {
        StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
        [DeleteStreetsnapInput shareInstance].streetsnapId = info.streetsnapId;
        [DeleteStreetsnapInput shareInstance].userId = [LoginModel shareInstance].userId;
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[DeleteStreetsnapInput shareInstance]];
        [[NetInterface shareInstance] deleteStreetsnap:@"deleteStreetsnap" param:dict successBlock:^(NSDictionary *responseDict) {
            BaseModel *returnData = [BaseModel modelWithDict:responseDict];
            if (RETURN_SUCCESS(returnData.status)) {
                [CustomUtil showToastWithText:returnData.msg view:self.view];
                if (YES == _intoFlag) { //发布进入
                    if (NO == [TKPublishType shareInstance].publishType) { //街拍发布
                        //跳转至发布街拍前的画面
                        for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
                            if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                                TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                                [tabBarCtrl setSelectedIndex:tabBarCtrl.intoStreetFlag];
                                [self.navigationController popToViewController:tabBarCtrl animated:YES];
                            }
                        }
                    } else { //个人主页发布
                        for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
                            if ([viewCtrl isKindOfClass:[MyStreetPhotoViewController class]]) {
                                MyStreetPhotoViewController *myStreetViewCtrl = (MyStreetPhotoViewController *)viewCtrl;
                                [self.navigationController popToViewController:myStreetViewCtrl animated:YES];
                                [TKPublishType shareInstance].publishType = NO;
                            }
                        }
                    }
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [CustomUtil showToastWithText:returnData.msg view:self.view];
            }
        } failedBlock:^(NSError *err) {
        }];
    } target:self btnCount:2];
}

//评论个人头像点击事件
-(void)imageViewClick:(id)sender
{
    //跳转至个人主页
    UIButton *button = (UIButton *)sender;
    if ([[_commentInfoArray objectAtIndexCheck:button.tag] isEqual:@""]) {
        return;
    }
    CommentInfo *commentInfo = [[CommentInfo alloc] initWithDict:[_commentInfoArray objectAtIndexCheck:button.tag]];
    if ([commentInfo.userId isEqualToString:[LoginModel shareInstance].userId]) { //我的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        [self.navigationController pushViewController:viewCtrl animated:YES];
    } else {  //他人的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        viewCtrl.type = 1;
        viewCtrl.userId = commentInfo.userId;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
}


//点赞用户头像点击事件
-(void)zanUserBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([_praiseInfoArray[button.tag] isEqual:@""]) {
        return;
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:_praiseInfoArray[button.tag]];
    PraiseInfo *info = [[PraiseInfo alloc] initWithDict:dict];
    if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) { //我的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        [self.navigationController pushViewController:viewCtrl animated:YES];
    } else {  //他人的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        viewCtrl.type = 1;
        viewCtrl.userId = info.userId;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
}

-(void)rewardUserBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([_rewardInfoArray[button.tag] isEqual:@""]) {
        return;
    }
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:_rewardInfoArray[button.tag]];
    PraiseInfo *info = [[PraiseInfo alloc] initWithDict:dict];
    if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) { //我的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        [self.navigationController pushViewController:viewCtrl animated:YES];
    } else {  //他人的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        viewCtrl.type = 1;
        viewCtrl.userId = info.userId;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
}

- (void)zanCountBtnClick:(UIButton *)btn
{
    NSLog(@"更多点赞列表：%lu\n", (unsigned long)_praiseInfoArray.count);
    for (id obj in _praiseInfoArray) {
        NSLog(@"obj:%@",obj);
    }
    if (_praiseInfoArray.count == 0) {
        return;
    }
    StreetPraiseListViewController *vc = [[StreetPraiseListViewController alloc] initWithStreetsnapId:_streetsnapId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rewardCountBtnClick:(UIButton *)btn
{
    NSLog(@"更多打赏列表：%lu\n", (unsigned long)_rewardInfoArray.count);
    for (id obj in _rewardInfoArray) {
        NSLog(@"obj:%@",obj);
    }
    if (_rewardInfoArray.count == 0) {
        return;
    }
    StreetRewardListViewController *vc = [[StreetRewardListViewController alloc] initWithStreetsnapId:_streetsnapId];
    [self.navigationController pushViewController:vc animated:YES];

}

//点赞按钮点击事件
- (void)zanBtnClick:(id)sender {
    if ([_streetsnapInfo isEqual:@""] ||
        (nil == _streetsnapInfo)) {
        return;
    }
    StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    [PublishPraiseInput shareInstance].streetsnapId = _streetsnapId;
    [PublishPraiseInput shareInstance].streetsnapUserId = info.userId;
    [PublishPraiseInput shareInstance].userId = [LoginModel shareInstance].userId;
    [PublishPraiseInput shareInstance].flag = info.praiseFlag;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[PublishPraiseInput shareInstance]];
    [[NetInterface shareInstance] publishPraise:@"publishPraise" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [self reloadData:YES block:^{
                //更新点赞按钮状态
                StreetsnapInfo *publishInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
                if ([publishInfo.praiseFlag isEqualToString:@"0"]) { //未赞
//                    [CustomUtil showToastWithText:returnData.msg view:kWindow];
                    // 取消点赞
                    [_zanBtn setImage:[UIImage imageNamed:@"zan7-4"] forState:UIControlStateNormal];
                } else if ([publishInfo.praiseFlag isEqualToString:@"1"]) { //已赞
                    [self showZanAnimation];
                    // 点赞成功
                    [_zanBtn setImage:[UIImage imageNamed:@"zan02-7-4"] forState:UIControlStateNormal];
                }
                
                //设置点赞用户头像
                /*
                for (EGOImageView *zanUserImageView in _zanUserArray) {
                    [zanUserImageView setHidden:YES];
                }
                for (UIButton *btn in _zanUserBtnArray) {
                    [btn setHidden:YES];
                }
                 */
                /*
                if (_praiseInfoArray && _zanUserArray && _zanUserBtnArray) {
                    for (int i=0; i<(_praiseInfoArray.count); i++) {
                        if (i < (_zanUserArray.count - 1)) {
                            EGOImageView *view = [_zanUserArray objectAtIndex:i];
                            [view setHidden:NO];
                            UIButton *button = [_zanUserBtnArray objectAtIndex:i];
                            button.tag = i;
                            [button addTarget:self action:@selector(zanUserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [button setHidden:NO];
                            NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:_praiseInfoArray[i]];
                            PraiseInfo *info = [[PraiseInfo alloc] initWithDict:dict];
                            view.imageURL = [CustomUtil getPhotoURL:info.image];
                        }
                    }
                    if (_praiseInfoArray.count > 7) {
                        //[_moreImageView setHidden:NO];
                    }
                }
                 */
            }];
        }
        else {
            [CustomUtil showToastWithText:returnData.msg view:kWindow];
        }
    } failedBlock:^(NSError *err) {
    }];
}

//收藏按钮点击事件
- (void)collectionBtnClick:(id)sender {
    if ([_streetsnapInfo isEqual:@""] ||
        (nil == _streetsnapInfo)) {
        return;
    }
    StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    [CollectionInput shareInstance].streetsnapId = _streetsnapId;
    [CollectionInput shareInstance].streetsnapUserId = info.userId;
    [CollectionInput shareInstance].userId = [LoginModel shareInstance].userId;
    [CollectionInput shareInstance].flag = info.collectionFlag;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[CollectionInput shareInstance]];
    [[NetInterface shareInstance] collection:@"collection" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            [self reloadData:NO block:^{
                //更新收藏按钮状态
                StreetsnapInfo *publishInfo = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
                if ([publishInfo.collectionFlag isEqualToString:@"0"]) { //未收藏
                    [_collectionBtn setImage:[UIImage imageNamed:@"like7-4"] forState:UIControlStateNormal];
                } else if ([publishInfo.collectionFlag isEqualToString:@"1"]) { //已收藏
                    [_collectionBtn setImage:[UIImage imageNamed:@"like02-7-4"] forState:UIControlStateNormal];
                }
            }];
        }
        [CustomUtil showToastWithText:returnData.msg view:kWindow];
    } failedBlock:^(NSError *err) {
    }];
}

//发送评论
- (IBAction)sendCommentBtnClick:(id)sender {
    //检查评论内容是否为空
    if ([CustomUtil CheckParam:_inputTextView.text]) {
        [CustomUtil showToastWithText:@"请输入评论内容" view:kWindow];
        return;
    }
    //判断输入的评论字数
    NSInteger chineseCount = [CustomUtil chineseCountOfString:_inputTextView.text];
    NSInteger charCount = [CustomUtil characterCountOfString:_inputTextView.text];
    NSInteger allCharCount = chineseCount + charCount;
    if (allCharCount > kMaxCommentLength) {
        [CustomUtil showToastWithText:@"评论字数不能超过140字" view:kWindow];
        return;
    }
    //[_inputTextView resignFirstResponder];
    
    if (YES == commentFlag) {
        [self sendComment:nil];
    } else {
        [self sendComment:selectInfo];
    }
    
    //commentFlag = YES;
}

//调用评论接口
- (void)sendComment:(CommentInfo *)info
{
    [PublishCommentInput shareInstance].streetsnapId = _streetsnapId;
    [PublishCommentInput shareInstance].userId = [LoginModel shareInstance].userId;
    if (!info) {
        [PublishCommentInput shareInstance].replyId = @"";
        [PublishCommentInput shareInstance].commentContent = _inputTextView.text;
    } else {
        [PublishCommentInput shareInstance].replyId = info.userId;
        NSString *message = _inputTextView.text;
        message = [message stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"回复%@:", info.userName] withString:@""];
        if ([CustomUtil CheckParam:message]) {
            [CustomUtil showToastWithText:@"请输入评论内容" view:kWindow];
            return;
        }
        [PublishCommentInput shareInstance].commentContent = message;
    }
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[PublishCommentInput shareInstance]];
    [[NetInterface shareInstance] publishComment:@"publishComment" param:dict successBlock:^(NSDictionary *responseDict) {
        BaseModel *returnData = [BaseModel modelWithDict:responseDict];
        if (RETURN_SUCCESS(returnData.status)) {
            commentFlag = YES; //回复评论
            selectInfo = nil;
            //刷新界面
            [self reloadData:YES block:^{
            }];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_commentInfoArray.count + 1) inSection:0];
            int row = 2;
            if (_commentInfoArray.count == 0) {
                row = 1;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [_detailTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            _inputTextView.text = @"";
        }
        [_inputTextView resignFirstResponder];
        [CustomUtil showToastWithText:returnData.msg view:kWindow];
    } failedBlock:^(NSError *err) {
    }];
}

//街拍个人头像点击
-(void)personImageClick:(id)sender
{
    if ([_streetsnapInfo isEqual:@""]) {
        return;
    }
    StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    if ([info.userId isEqualToString:[LoginModel shareInstance].userId]) { //我的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        [self.navigationController pushViewController:viewCtrl animated:YES];
    } else {  //他人的街拍
        MyStreetPhotoViewController *viewCtrl = [[MyStreetPhotoViewController alloc] initWithNibName:@"MyStreetPhotoViewController" bundle:nil];
        viewCtrl.type = 1;
        viewCtrl.userId = info.userId;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
}

//打赏按钮点击
- (void)dashangBtnClick:(id)sender
{
//    15e2091z08.imwork.net:14780/maoxj/mxCoin/getrewardTemplate?userId=2833
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[LoginModel shareInstance].userId}];
    
    [[NetInterface shareInstance] requestNetWork:@"maoxj/mxCoin/getrewardTemplate" param:dic successBlock:^(NSDictionary *responseDict) {
        if ([[responseDict objectForKey:@"code"] integerValue] == 1 && [responseDict objectForKey:@"rewardTemplate"]&& [[responseDict objectForKey:@"rewardTemplate"] isKindOfClass:[NSArray class]]) {
            _rewardDictionary = [NSDictionary dictionaryWithDictionary:responseDict];
            [self showRewardView1];
        }
        else {
            [CustomUtil showToast:@"获取打赏列表失败" view:self.view];
        }
    } failedBlock:^(NSError *err) {
        //        [CustomUtil showToast:@"网络不给力，请稍后重试" view:self.view];
    }];
}

/**
 *  打赏
 */
- (void)toDoReward:(UIButton *)sender
{
    NSInteger tmpSelectIndex  = -1;
    for (int i = 0; i < _rewardCount; i++) {
        UIButton *button = (UIButton *)[_rewardBackView viewWithTag:3000 + i];
        if (button.selected) {
            tmpSelectIndex = button.tag - 3000;
        }
    }
    
    if (tmpSelectIndex >= 0) {
        [self toReward:[[[_rewardDictionary objectForKey:@"rewardTemplate"] objectAtIndex:tmpSelectIndex] integerValue]];
    }
    else {
        [CustomUtil showToast:@"请选择要打赏的毛豆数" view:[[UIApplication sharedApplication] keyWindow]];
    }
}

- (void)toDoReward2:(UIButton *)sender
{
    if (_rewardTextFeild.text.length > 0) {
        [self toReward:[_rewardTextFeild.text integerValue]];
    }
    else {
        [CustomUtil showToast:@"请输入正确的毛豆数" view:[[UIApplication sharedApplication] keyWindow]];
    }
}

// 显示点赞成功按钮
- (void)showZanAnimation
{
    [self.view addSubview:self.zanAnimationView];
    self.zanAnimationView.alpha = 0;
    _zanAnimationImageView.alpha = 1;
    
    CGRect rect = _zanAnimationImageView.frame;
    rect.origin.x += 5;
    rect.origin.y -= 10;
    
    [UIView animateWithDuration:0.2 animations:^{
        _zanAnimationView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            _zanAnimationImageView.frame = rect;
            _zanAnimationImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _zanAnimationView.alpha = 0;
            }];
        }];

    }];
}

//分享按钮点击事件
- (void)shareBtnClick:(id)sender {
    _shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //设置分享按钮的布局
    NSArray *firstLineBtnArray = [NSArray arrayWithObjects:__weixinBtn, _pengyouquanBtn, _qqBtn, _qqKongjianBtn, nil];
    NSArray *fristLineLabelArray = [NSArray arrayWithObjects:_weixinLabel, _pengyouquanLabel, _qqLabel, _qqKongjianLabel, nil];
    CGFloat btnMarginX = [self getBtnMarginX];
    for (int i=0; i<4; i++) {
        UIButton *fenxiangBtn = [firstLineBtnArray objectAtIndexCheck:i];
        CGRect fenxiangBtnFrame = fenxiangBtn.frame;
        fenxiangBtnFrame.origin.x = btnMarginX*(i+1) + i*fenxiangBtnFrame.size.width;
        fenxiangBtn.frame = fenxiangBtnFrame;
        UILabel *fenxiangLabel = [fristLineLabelArray objectAtIndexCheck:i];
        CGPoint fenxiangLabelCenter = fenxiangLabel.center;
        fenxiangLabelCenter.x = fenxiangBtn.center.x;
        fenxiangLabel.center = fenxiangLabelCenter;
    }
    
    NSArray *secondeLineBtnArray = [NSArray arrayWithObjects:_weiboBtn, nil];
    NSArray *secondeLineLabelArray = [NSArray arrayWithObjects:_weiboLabel, nil];
    UIButton *fenxiangBtn = [secondeLineBtnArray objectAtIndexCheck:0];
    CGRect fenxiangBtnFrame = fenxiangBtn.frame;
    fenxiangBtnFrame.origin.x = btnMarginX;
    fenxiangBtn.frame = fenxiangBtnFrame;
    UILabel *fenxiangLabel = [secondeLineLabelArray objectAtIndexCheck:0];
    CGPoint fenxiangLabelCenter = fenxiangLabel.center;
    fenxiangLabelCenter.x = fenxiangBtn.center.x;
    fenxiangLabel.center = fenxiangLabelCenter;
    
    [kWindow addSubview:_shareView];
    //显示分享视图
    [_shareView setHidden:NO];
}

//微信按钮点击事件
- (IBAction)weiXinBtnClick:(id)sender {
    [_shareView setHidden:YES];
    if ([_streetsnapInfo isEqual:@""]) {
        return;
    }
    _isWeiXinShare = YES;
    [CustomUtil shareInstance].personOrZone=YES;
    [self outhWeixin];
}

//朋友圈按钮点击事件
- (IBAction)pengyouquanBtnClick:(id)sender {
    [_shareView setHidden:YES];
    if ([_streetsnapInfo isEqual:@""]) {
        return;
    }
    _isWeiXinShare = NO;
     [CustomUtil shareInstance].personOrZone=NO;
    [self outhWeixin];
}

//qq按钮点击事件
- (IBAction)qqBtnClick:(id)sender {
    [_shareView setHidden:YES];
    if ([_streetsnapInfo isEqual:@""]) {
        return;
    }
    _isQQShare = YES;
    
    [self authQQ];
}

//qq空间按钮点击事件
- (IBAction)qqkongjianBtnClick:(id)sender {
    [_shareView setHidden:YES];
    if ([_streetsnapInfo isEqual:@""]) {
        return;
    }
    _isQQShare = NO;
    
    [self authQQ];
}

//微博按钮点击事件
- (IBAction)weiboBtnClick:(id)sender {
    [_shareView setHidden:YES];
    if ([_streetsnapInfo isEqual:@""]) {
        return;
    }
    NSString *string=[NSString stringWithFormat:@"streetsnapId=%@&place=%@&cityFlag=%@&current=%@&userId=%@&pagesize=%@&type=%@",_streetsnapId, [GetStreetsnapListInput shareInstance].place, [GetStreetsnapListInput shareInstance].cityFlag, [GetStreetsnapListInput shareInstance].current, [GetStreetsnapListInput shareInstance].userId, [GetStreetsnapListInput shareInstance].pagesize, [GetStreetsnapListInput shareInstance].type];
    
    NSString *string2=[NSString stringWithFormat:@"%@%@%@%@",@"http://",NET_BASE_URL,@"/maoxj/views/html5page/details.html?",string];
    new_url=[string2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *message=[NSString stringWithFormat:@"%@%@",@"毛线街－记录我的毛线·生活",new_url];

    StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
    [CustomUtil sinaLogin:YES viewCtrl:@"StreetPhotoDetailViewController" personOrZone:NO inviteUser:NO imagePath:info.photo1 shareContent:message];
}
//代理-登录成功
-(void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0!=[_tencentOAuth.accessToken length]) {
        //记录登录用户的OpenID、Token以及过期时间
        [TKQQLogin shareInstance].openId = _tencentOAuth.openId;
        [TKQQLogin shareInstance].token = _tencentOAuth.accessToken;
        [TKQQLogin shareInstance].expirationDate = _tencentOAuth.expirationDate;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndexCheck:0];
        NSString *filePath = [path stringByAppendingPathComponent:@"TKQQLogin.plist"];
        NSMutableDictionary *dict = [CustomUtil modelToDictionary:[TKQQLogin shareInstance]];
        [dict writeToFile:filePath atomically:YES];
        [_tencentOAuth getUserInfo];
    } else {
        //[CustomUtil showToastWithText:@"登录失败" view:kWindow];
    }
}
//获取用户信息代理
-(void)getUserInfoResponse:(APIResponse *)response{
    if (response.retCode == URLREQUEST_SUCCEED) {
        StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
        NSString *str=[NSString stringWithFormat:@"%@%@%@",@"http://",NET_BASE_URL,info.photo1];
        NSURL *url=[NSURL URLWithString:str];
        //分享QQ
        NSString *string=[NSString stringWithFormat:@"streetsnapId=%@&place=%@&cityFlag=%@&current=%@&userId=%@&pagesize=%@&type=%@",_streetsnapId, [GetStreetsnapListInput shareInstance].place, [GetStreetsnapListInput shareInstance].cityFlag, [GetStreetsnapListInput shareInstance].current, [GetStreetsnapListInput shareInstance].userId, [GetStreetsnapListInput shareInstance].pagesize, [GetStreetsnapListInput shareInstance].type];
         
        NSString *string2=[NSString stringWithFormat:@"%@%@%@%@",@"http://",NET_BASE_URL,@"/maoxj/views/html5page/details.html?",string];
        new_url=[string2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (_isQQShare) {
            QQApiNewsObject *object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:new_url] title:[NSString stringWithFormat:@"%@%@", publishInfo.userName,SHARE_TITLE] description:publishInfo.streetsnapContent previewImageURL:url targetContentType:QQApiURLTargetTypeNews];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
            QQApiSendResultCode send = [QQApiInterface sendReq:req];
            if (EQQAPISENDSUCESS == send) {
                //                [CustomUtil showToastWithText:@"分享成功" view:kWindow];
            }
            else {
                //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
            }
        }
        else {
             //QZone分享
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:new_url]
                                        title:[NSString stringWithFormat:@"%@%@", publishInfo.userName,SHARE_TITLE]
                                        description:publishInfo.streetsnapContent
                                        previewImageURL:url];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            //将内容分享到qzone
            QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            if (EQQAPISENDSUCESS == sent) {
                //                [CustomUtil showToastWithText:@"分享成功" view:kWindow];
            }
            else {
                //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
            }
        }
    }
}

- (void)outhWeixin
{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    [userdefault setObject:@"Detail" forKey:@"StreetPhoto"];
    [userdefault synchronize];
    
    [CustomUtil shareInstance].shareFlag=YES;
    NSString *string=[NSString stringWithFormat:@"streetsnapId=%@&place=%@&cityFlag=%@&current=%@&userId=%@&pagesize=%@&type=%@",_streetsnapId, [GetStreetsnapListInput shareInstance].place, [GetStreetsnapListInput shareInstance].cityFlag, [GetStreetsnapListInput shareInstance].current, [GetStreetsnapListInput shareInstance].userId, [GetStreetsnapListInput shareInstance].pagesize, [GetStreetsnapListInput shareInstance].type];
    
    NSString *string2=[NSString stringWithFormat:@"%@%@%@%@",@"http://",NET_BASE_URL,@"/maoxj/views/html5page/details.html?",string];
   new_url=[string2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //读取微信授权plist文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"TKWeixinLogin.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [TKWeixinLogin shareInstance].openId = [dict objectForKey:@"openId"];
    [TKWeixinLogin shareInstance].token = [dict objectForKey:@"token"];
    
    if ((![CustomUtil CheckParam:[TKWeixinLogin shareInstance].openId]) &&
        (![CustomUtil CheckParam:[TKWeixinLogin shareInstance].token])) {
        [[CustomUtil shareInstance] getWeixinToken:^{
            //发送分享内容
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.openID = [TKWeixinLogin shareInstance].openId;
            req.bText = NO;
            WXMediaMessage *message = [[WXMediaMessage alloc] init];
            
            message.description = publishInfo.streetsnapContent;
            message.title = [NSString stringWithFormat:@"%@%@",publishInfo.userName,SHARE_TITLE];
            
            StreetsnapInfo *info = [[StreetsnapInfo alloc] initWithDict:_streetsnapInfo];
            NSString *str=[NSString stringWithFormat:@"%@%@%@",@"http://",NET_BASE_URL,info.photo1];
            NSURL *url=[NSURL URLWithString:str];
            NSData *data=[NSData dataWithContentsOfURL:url];
            UIImage *orginalImage = [UIImage imageWithData:data];
            UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
            NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
            UIImage *finishImage = [UIImage imageWithData:targetImageData];
            [message setThumbImage:finishImage];
            WXWebpageObject *webPageExt = [WXWebpageObject object];
            webPageExt.webpageUrl = new_url;
            message.mediaObject = webPageExt;
            req.message = message;
            
            if (_isWeiXinShare) {
                req.scene = 0;          //发送至个人
            } else {
                req.scene = 1;          //发送至朋友圈
            }
            [WXApi sendReq:req];
        }];
        
    } else {
        //请求授权
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
        req.state = @"123";
        //req.openID = WEIXIN_APPKEY;
        [WXApi sendAuthReq:req viewController:self delegate:self];
    }
}

//微信响应代理
- (void)onResp:(BaseResp *)resp{

     if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
        if (sendResp.errCode == WXSuccess) { //分享成功
            //增加积分
            [CustomUtil share];
        } else {
            //[CustomUtil showToastWithText:@"分享失败" view:kWindow];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.errCode == WXSuccess) {
            [TKWeixinLogin shareInstance].code = authResp.code;
            if (YES == [CustomUtil shareInstance].shareFlag) {
                //获取微信token、openId及用户信息
                [[CustomUtil shareInstance] getWeixinToken:^{
                    //发送分享内容
                    __block BOOL weiXinFlagSelf = [CustomUtil shareInstance].personOrZone;
                    [CustomUtil getInviteUserMessage:^(NSString *returnStr, NSString *shareUrl) {
                        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                        if ([CustomUtil shareInstance].shareFlag) {
                            req.bText = NO;
                            WXMediaMessage *message = [[WXMediaMessage alloc] init];
                            NSString *shareText;
                            if (YES == [CustomUtil shareInstance].weixinInviteUser) {
                                shareText = returnStr;
                            } else {
                                if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                                    shareText = @"";
                                } else {
                                    shareText = [CustomUtil shareInstance].shareContent;
                                }
                            }
                            message.description = publishInfo.streetsnapContent;;
                            message.title = [NSString stringWithFormat:@"%@%@", publishInfo.userName,SHARE_TITLE];
                            NSString *str=[NSString stringWithFormat:@"%@%@%@",@"http://",NET_BASE_URL,publishInfo.photo1];
                            NSURL *url=[NSURL URLWithString:str];
                            NSData *data=[NSData dataWithContentsOfURL:url];
                            UIImage *orginalImage = [UIImage imageWithData:data];
                            UIImage *targetImage = [CustomUtil compressImageForWidth:orginalImage targetWidth:128];
                            NSData *targetImageData = UIImageJPEGRepresentation(targetImage, 1);
                            UIImage *finishImage = [UIImage imageWithData:targetImageData];
                            [message setThumbImage:finishImage];
                            WXWebpageObject *webPageExt = [WXWebpageObject object];
                            webPageExt.webpageUrl = new_url;
                            message.mediaObject = webPageExt;
                            req.message = message;
                        } else {
                            req.bText = YES;        //仅发送文本
                            if ([CustomUtil shareInstance].weixinInviteUser) {
                                req.text = returnStr;
                            } else {
                                if ([CustomUtil CheckParam:[CustomUtil shareInstance].shareContent]) {
                                    req.text = @"";
                                } else {
                                    req.text = [CustomUtil shareInstance].shareContent;
                                }
                            }
                        }
                        if (YES == weiXinFlagSelf) {
                            req.scene = 0;          //发送至个人
                        } else {
                            req.scene = 1;          //发送至朋友圈
                        }
                        [WXApi sendReq:req];
                    }];
                }];
            }
        } else {
            //[CustomUtil showToastWithText:@"授权失败" view:kWindow];
        }
    }
}

- (void)authQQ
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndexCheck:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"TKQQLogin.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [TKQQLogin shareInstance].openId = [dict objectForKey:@"openId"];
    [TKQQLogin shareInstance].token = [dict objectForKey:@"token"];
    [TKQQLogin shareInstance].expirationDate = [dict objectForKey:@"expirationDate"];
    if (![CustomUtil CheckParam:[TKQQLogin shareInstance].openId] &&
        ![CustomUtil CheckParam:[TKQQLogin shareInstance].token]) {
        if (!_tencentOAuth) {
            _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:self];
            [CustomUtil shareInstance].oAuth = _tencentOAuth;
        }
        _tencentOAuth.redirectURI = @"www.qq.com";
        _tencentOAuth.openId = [TKQQLogin shareInstance].openId;
        _tencentOAuth.expirationDate = [TKQQLogin shareInstance].expirationDate;
        _tencentOAuth.accessToken = [TKQQLogin shareInstance].token;
        [_tencentOAuth getUserInfo];
    } else {
        if (!_tencentOAuth) {
            _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:self];
            [CustomUtil shareInstance].oAuth = _tencentOAuth;
        }
        _tencentOAuth.redirectURI = @"www.qq.com";
        //授权
        NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,
                                 kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                 kOPEN_PERMISSION_ADD_SHARE,
                                 nil];
        [_tencentOAuth authorize:_permissions inSafari:NO];
    }
}

//取消按钮点击事件
- (IBAction)cancelBtnClick:(id)sender {
    [_shareView setHidden:YES];
}
//获取分享按钮的X坐标偏移量
-(CGFloat)getBtnMarginX
{
    return (SCREEN_WIDTH - _weiboBtn.frame.size.width * 4)/5;
}

- (void)blankCLick
{
    
}

@end

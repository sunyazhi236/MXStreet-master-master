//
//  EditPhotoViewController.m
//  mxj
//  P7-2-2编辑照片
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "EditPhotoCell.h"
#import "CustomLabelViewController.h"
#import "PublishViewController.h"
#import "LabelDetailViewController.h"
#import "AppDelegate.h"
#import "EditImageViewController.h"
#import "PublishStreetPhotoViewController.h"
#import "TabBarController.h"

#define ARC4RANDOM_MAX      0x100000000

#define LABLE_NAME_LENGTH 10 //标签名称的长度（汉字个数）

#define PLACE_HOLDER_TEXT @"给标签添加站外链（可选）" //placeholder字符

@interface EditPhotoViewController () <EditImageDelegate>
{
    UITextView *editPhotoTextView; //当前编辑的TextView
    UIView *maskView; //遮罩View
    CGFloat keyBoardHeight;  //键盘高度
    CGRect picImageViewRect; //原始数据
    UILabel *alertLabel;     //提示添加标签的Label
    BOOL keyboardIsHidden;   //键盘是否已隐藏标志
    
    UIView *firstMaskImageView;   //第一幅照片的遮罩
    UIView *secondeMaskImageView; //第二幅照片的遮罩
    UIView *thirdMaskImageView;   //第三幅照片的遮罩
    UIView *forthMaskImageView;   //第四幅照片的遮罩
}
@end

@implementation EditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _mainTableView.backgroundColor = [UIColor clearColor];
    
    _backButton.layer.cornerRadius = 3;
    
    [_mainTableView registerClass :[EditPhotoCell class] forCellReuseIdentifier:@"EditPhotoCell"];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    //_mainTableView.estimatedRowHeight = 44;
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    
    _addLabelFlag = 0;
    picImageViewRect = _picImageView.frame;
    keyboardIsHidden = YES;
    
    [self initUI];
    
    //为大图添加点击事件
    //UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageView:)];
    //[_picImageView addGestureRecognizer:gestureRecognizer];
    [_picImageView setBackgroundColor:[UIColor clearColor]]; //TODO
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bankAreaClick)];
    [self.view addGestureRecognizer:gesture];
    
    [self initFootView];
    
    [self initBiaoqianView];
}

- (void)initBiaoqianView
{
    _biaoqianBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _biaoqianBackView.hidden = YES;
    _biaoqianBackView.userInteractionEnabled = YES;
    _biaoqianBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_biaoqianBackView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = _biaoqianBackView.bounds;
    [button addTarget:self action:@selector(hideBiaoqianView) forControlEvents:UIControlEventTouchUpInside];
    [_biaoqianBackView addSubview:button];

    _biaoqianChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
    _biaoqianChooseView.backgroundColor = [UIColor clearColor];
    _biaoqianChooseView.hidden = YES;
    _biaoqianChooseView.center = _biaoqianBackView.center;
    [_biaoqianBackView addSubview:_biaoqianChooseView];
    
    NSArray *images = @[@"发布_选择标签", @"发布_选择链接"];
    
    NSArray *names = @[@"标 签", @"链 接"];
    
    CGFloat width = (SCREEN_WIDTH  - 60) / 2;
    for(int i = 0; i < images.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30 + width * i, 0, width, 150);
        button.tag = i + 200;
        button.selected = NO;
        [button addTarget:self action:@selector(biaoqianChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_biaoqianChooseView addSubview:button];
        
        UIImage *image = [UIImage imageNamed:images[i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake((width - image.size.width)/2, (50 - image.size.height)/2, image.size.width, image.size.height);
        [button addSubview:imageView];
//        [button setImage:image forState:UIControlStateNormal];
//        [button setImageEdgeInsets:UIEdgeInsetsMake(-22, 0, 0, 0)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, width, 100)];
        label.textColor = [UIColor colorWithHexString:@"#a7a7a7"];
        label.tag = 100 + i + 1;
        label.font = [UIFont systemFontOfSize:14];
        label.text = names[i];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    
    _biaoqianInputView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    _biaoqianInputView.userInteractionEnabled = YES;
    _biaoqianInputView.hidden = YES;
    [_biaoqianBackView addSubview:_biaoqianInputView];
    
    CGFloat tmpY = (SCREENHEIGHT - 280) / 2;
    CGFloat tmpX = 26;
    CGFloat tmpW = SCREENWIDTH - 26 * 2;
    
    _biaoqianInputLabel.frame = CGRectMake(0, tmpY, SCREENWIDTH, 21);
    
    tmpY = tmpY + 21 + 18;
    
    _biaoqianInputTitleTextField.frame = CGRectMake(tmpX, tmpY, tmpW, 36);
    
    tmpY = tmpY + 36 + 10;
    
    _biaoqianInputLinkTextField.frame = CGRectMake(tmpX, tmpY, tmpW, 36);

    tmpY = tmpY + 36 + 31;
    
    _biaoqianInputSureButton.frame = CGRectMake(tmpX, tmpY, tmpW, 44);

    tmpY = tmpY + 44 + 10;
    
    _biaoqianInputCancelButton.frame = CGRectMake(tmpX, tmpY, tmpW, GetHeight(_biaoqianInputSureButton));

    _biaoqianInputSureButton.layer.cornerRadius = _biaoqianInputCancelButton.layer.cornerRadius  = GetHeight(_biaoqianInputCancelButton) / 2;
    
    _biaoqianInputTitleTextField.returnKeyType = _biaoqianInputLinkTextField.returnKeyType = UIReturnKeyDone;
    
    _biaoqianInputTitleTextField.delegate = _biaoqianInputLinkTextField.delegate = self;
    
    _biaoqianInputTitleTextField.textColor = _biaoqianInputLinkTextField.textColor = [UIColor whiteColor];
    
    _biaoqianInputTitleTextField.layer.borderColor = _biaoqianInputLinkTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    _biaoqianInputTitleTextField.layer.borderWidth = _biaoqianInputLinkTextField.layer.borderWidth = 0.5;
    [_biaoqianInputTitleTextField setValue:[UIColor colorWithWhite:1 alpha:0.4] forKeyPath:@"_placeholderLabel.textColor"];
    [_biaoqianInputLinkTextField setValue:[UIColor colorWithWhite:1 alpha:0.4] forKeyPath:@"_placeholderLabel.textColor"];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, GetHeight(_biaoqianInputLinkTextField))];
    label.text = @" 标题：";
    label.textColor = [UIColor whiteColor];
    label.font = FONT(14);
    _biaoqianInputTitleTextField.leftView = label;
    _biaoqianInputTitleTextField.leftViewMode = UITextFieldViewModeAlways;

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, GetHeight(_biaoqianInputLinkTextField))];
    label2.text = @" 链接：";
    label2.textColor = [UIColor whiteColor];
    label2.font = FONT(14);
    _biaoqianInputLinkTextField.leftView = label2;
    _biaoqianInputLinkTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [_biaoqianInputSureButton addTarget:self action:@selector(addLinkBiaoqianClick:) forControlEvents:UIControlEventTouchUpInside];

    [_biaoqianInputCancelButton addTarget:self action:@selector(cancelAddLinkBiaoqianClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)initFootView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 54, SCREENWIDTH, 54)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f2f3f3"];
    [self.view addSubview:view];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e1e2e3"];
    [view addSubview:lineView];
    
    NSArray *images = @[@"发布_标签", @"发布_滤镜"];
    
    NSArray *names = @[@"标签", @"滤镜"];
    
    CGFloat width = (SCREEN_WIDTH  - 60) / 2;
    for(int i = 0; i < images.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30 + width * i, 0, width, 54);
        button.tag = i + 100;
        button.selected = NO;
        [button addTarget:self action:@selector(footBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIImage *image = [UIImage imageNamed:images[i]];
        [button setImage:image forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(-22, 0, 0, 0)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, width, 15)];
        label.textColor = [UIColor colorWithHexString:@"#a7a7a7"];
        label.tag = 100 + i + 1;
        label.font = [UIFont systemFontOfSize:12];
        label.text = names[i];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self refreshPointView];
    
    if (_editImageArray.count < 4 && _intoFlag == YES) {
        _addButton.hidden = NO;
        
        _addButton.frame = CGRectMake(33 + (7 + 37)*_editImageArray.count, 21, 37, 37);
    }
    else {
        _addButton.hidden = YES;
    }
}

- (void)refreshPointView
{
    if ([CustomUtil CheckParam:_addLabelName] && (1 == _addLabelFlag)) { //没有添加标签时
        switch (_selectImageFlag) {
            case 0:
            {
                [_photo1LabelCoordinateArray removeLastObject];
            }
                break;
            case 1:
            {
                [_photo2LabelCoordinateArray removeLastObject];
            }
                break;
            case 2:
            {
                [_photo3LabelCoordinateArray removeLastObject];
            }
                break;
            case 3:
            {
                [_photo4LabelCoordinateArray removeLastObject];
            }
                break;
            default:
                break;
        }
        _addLabelFlag = 0;
    } else if((![CustomUtil CheckParam:_addLabelName]) && (1 == _addLabelFlag)) { //标签添加成功或选择了标签时
        _addLabelFlag = 0;
        //判断当前是否有重复标签存在
        switch (_selectImageFlag) {
            case 0:
            {
                for (TouchPositionModel *model in _photo1LabelCoordinateArray) {
                    if ([model.labelName isEqualToString:_addLabelName]) {
                        [CustomUtil showToast:[NSString stringWithFormat:@"【%@】标签已经存在，不能重复添加", _addLabelName] view:kWindow];
                        [_photo1LabelCoordinateArray removeLastObject];
                        return;
                    }
                }
            }
                break;
            case 1:
            {
                for (TouchPositionModel *model in _photo2LabelCoordinateArray) {
                    if ([model.labelName isEqualToString:_addLabelName]) {
                        [CustomUtil showToast:[NSString stringWithFormat:@"【%@】标签已经存在，不能重复添加", _addLabelName] view:kWindow];
                        [_photo2LabelCoordinateArray removeLastObject];
                        return;
                    }
                }
            }
                break;
            case 2:
            {
                for (TouchPositionModel *model in _photo3LabelCoordinateArray) {
                    if ([model.labelName isEqualToString:_addLabelName]) {
                        [CustomUtil showToast:[NSString stringWithFormat:@"【%@】标签已经存在，不能重复添加", _addLabelName] view:kWindow];
                        [_photo3LabelCoordinateArray removeLastObject];
                        return;
                    }
                }
            }
                break;
            case 3:
            {
                for (TouchPositionModel *model in _photo4LabelCoordinateArray) {
                    if ([model.labelName isEqualToString:_addLabelName]) {
                        [CustomUtil showToast:[NSString stringWithFormat:@"【%@】标签已经存在，不能重复添加", _addLabelName] view:kWindow];
                        [_photo4LabelCoordinateArray removeLastObject];
                        return;
                    }
                }
            }
                break;
            default:
                break;
        }
        //获取坐标
        TouchPositionModel *positionModel = nil;
        switch (_selectImageFlag) {
            case 0:
            {
                positionModel = (TouchPositionModel *)[_photo1LabelCoordinateArray lastObject];
            }
                break;
            case 1:
            {
                positionModel = (TouchPositionModel *)[_photo2LabelCoordinateArray lastObject];
            }
                break;
            case 2:
            {
                positionModel = (TouchPositionModel *)[_photo3LabelCoordinateArray lastObject];
            }
                break;
            case 3:
            {
                positionModel = (TouchPositionModel *)[_photo4LabelCoordinateArray lastObject];
            }
                break;
            default:
                break;
        }
        positionModel.labelName = _addLabelName;
        positionModel.tagId = _addLabelId;
        //绘制标签
        [self drawLabelBtn:positionModel];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//空白区域点击事件
-(void)bankAreaClick
{
    if ([editPhotoTextView isFirstResponder]) {
        [editPhotoTextView resignFirstResponder];
    }
}

//初始化界面
- (void)initUI
{
    if(!_photo1LabelCoordinateArray) {
        _photo1LabelCoordinateArray = [[NSMutableArray alloc] init];
    }
    if (!_photo2LabelCoordinateArray) {
        _photo2LabelCoordinateArray = [[NSMutableArray alloc] init];
    }
    if (!_photo3LabelCoordinateArray) {
        _photo3LabelCoordinateArray = [[NSMutableArray alloc] init];
    }
    if (!_photo4LabelCoordinateArray) {
        _photo4LabelCoordinateArray = [[NSMutableArray alloc] init];
    }
    [_secondSmallBackImageView setHidden:YES];
    [_secondeSmallBtn setHidden:YES];
    [_thirdSmallBackImageView setHidden:YES];
    [_thirdSmallBtn setHidden:YES];
    [_fourthSmallBackImageView setHidden:YES];
    [_fourthSmallBtn setHidden:YES];
    
    switch (_editImageArray.count) {
        case 2:
        {
            [_secondSmallBackImageView setHidden:NO];
            [_secondeSmallBtn setHidden:NO];
        }
            break;
        case 3:
        {
            [_secondSmallBackImageView setHidden:NO];
            [_secondeSmallBtn setHidden:NO];
            [_thirdSmallBackImageView setHidden:NO];
            [_thirdSmallBtn setHidden:NO];
        }
            break;
        case 4:
        {
            [_secondSmallBackImageView setHidden:NO];
            [_secondeSmallBtn setHidden:NO];
            [_thirdSmallBackImageView setHidden:NO];
            [_thirdSmallBtn setHidden:NO];
            [_fourthSmallBackImageView setHidden:NO];
            [_fourthSmallBtn setHidden:NO];
        }
            break;
        default:
            break;
    }
    
    for (int i=0; i<_editImageArray.count; i++) {
        ALAsset *asset = [_editImageArray objectAtIndexCheck:i];
        switch (i) {
            case 0:
            {
                [_firstSmallBtn setBackgroundImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [_secondeSmallBtn setBackgroundImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [_thirdSmallBtn setBackgroundImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [_fourthSmallBtn setBackgroundImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
    switch (_selectImageFlag) {
        case 0:
            [self firstImageBtnClick:_firstSmallBtn];
            break;
        case 1:
            [self secondeImageBtnClick:_secondeSmallBtn];
            break;
        case 2:
            [self thirdImageBtnClick:_thirdSmallBtn];
            break;
        case 3:
            [self fourthImageBtnClick:_fourthSmallBtn];
            break;
        default:
            break;
    }
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setImage:[UIImage imageNamed:@"添加照片"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_addButton];
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNumber = 0;
//    switch (_selectImageFlag) {
//        case 0:
//            rowNumber = _photo1LabelCoordinateArray.count;
//            break;
//        case 1:
//            rowNumber = _photo2LabelCoordinateArray.count;
//            break;
//        case 2:
//            rowNumber = _photo3LabelCoordinateArray.count;
//            break;
//        case 3:
//            rowNumber = _photo4LabelCoordinateArray.count;
//            break;
//        default:
//            break;
//    }
    return rowNumber + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return _cellOne.frame.size.height;
        default:
        {
            TouchPositionModel *model = nil;
            switch (_selectImageFlag) {
                case 0:
                    if (_photo1LabelCoordinateArray.count >= indexPath.row) {
                        model = [_photo1LabelCoordinateArray objectAtIndexCheck:indexPath.row-1];
                    }
                    break;
                case 1:
                    if (_photo2LabelCoordinateArray.count >= indexPath.row) {
                        model = [_photo2LabelCoordinateArray objectAtIndexCheck:indexPath.row-1];
                    }
                    break;
                case 2:
                    if (_photo3LabelCoordinateArray.count >= indexPath.row) {
                        model = [_photo3LabelCoordinateArray objectAtIndexCheck:indexPath.row-1];
                    }
                    break;
                case 3:
                    if (_photo4LabelCoordinateArray.count >= indexPath.row) {
                        model = [_photo4LabelCoordinateArray objectAtIndexCheck:indexPath.row-1];
                    }
                    break;
                default:
                    break;
            }
            
            EditPhotoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EditPhotoCell" owner:self options:nil] lastObject];
            float height = 0;
            //调整TextView的高度
            if ([CustomUtil CheckParam:model.link]) {
                height = 44;
            } else {
                height = [CustomUtil heightForString:model.link fontSize:13.0f andWidth:cell.linkTextView.bounds.size.width] + 4;
                if (height < 44) {
                    height = 44;
                }
            }
            return height;
        }
            break;
    }

    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            _cellOne.backgroundColor = [UIColor clearColor];
            return _cellOne;
        }
        default:
        {
            
            //EditPhotoCell *editPhotoCell = [tableView dequeueReusableCellWithIdentifier:@"EditPhotoCell" forIndexPath:indexPath];
            //if (!editPhotoCell) {
              EditPhotoCell *editPhotoCell = [[[NSBundle mainBundle] loadNibNamed:@"EditPhotoCell" owner:self options:nil] lastObject];
            //}
            
            TouchPositionModel *model = nil;
            switch (_selectImageFlag) {
                case 0:
                    model = [_photo1LabelCoordinateArray objectAtIndexCheck:indexPath.row - 1];
                    break;
                case 1:
                    model = [_photo2LabelCoordinateArray objectAtIndexCheck:indexPath.row - 1];
                    break;
                case 2:
                    model = [_photo3LabelCoordinateArray objectAtIndexCheck:indexPath.row - 1];
                    break;
                case 3:
                    model = [_photo4LabelCoordinateArray objectAtIndexCheck:indexPath.row - 1];
                    break;
                default:
                    break;
            }
            [editPhotoCell.linkName setText:model.labelName];
            if ([CustomUtil CheckParam:model.link]) {
                [editPhotoCell.linkImageView setImage:[UIImage imageNamed:@"link7-2-2"]];
                [editPhotoCell.linkTextView setText:model.link];
                [editPhotoCell.linkTextView setText:PLACE_HOLDER_TEXT];
            } else {
                [editPhotoCell.linkImageView setImage:[UIImage imageNamed:@"link7-2-2"]];
                [editPhotoCell.linkTextView setText:model.link];
            }
//            editPhotoCell.linkTextViewDelegate = self;
            /*
            //调整TextView的高度
            float height = [CustomUtil heightForString:editPhotoCell.linkTextView.text fontSize:13.0f andWidth:editPhotoCell.linkTextView.frame.size.width];
            CGRect rect = editPhotoCell.linkTextView.frame;
            rect.size.height = height;
            editPhotoCell.linkTextView.frame = rect;
            DLog(@"linkTextView = %@", editPhotoCell.linkTextView.textContainer);
            
            rect = editPhotoCell.frame;
            rect.size.height = height + 4;
            editPhotoCell.frame = rect;
            
            //调整分割线
            rect = editPhotoCell.lineImageView.frame;
            rect.origin.y = editPhotoCell.frame.size.height - 1;
            editPhotoCell.lineImageView.frame = rect;
             */
            
            return editPhotoCell;
            /*
            //调整cell的y坐标
            //获取前一个cell的位置信息
            NSInteger rowNumber = 0;
            switch (_selectImageFlag) {
                case 0:
                    rowNumber = _photo1LabelCoordinateArray.count;
                    break;
                case 1:
                    rowNumber = _photo2LabelCoordinateArray.count;
                    break;
                case 2:
                    rowNumber = _photo3LabelCoordinateArray.count;
                    break;
                case 3:
                    rowNumber = _photo4LabelCoordinateArray.count;
                    break;
                default:
                    break;
            }
            if (indexPath.row == 1) {
                float yPostion = _cellOne.frame.size.height;
                CGRect currentCellFrame = editPhotoCell.frame;
                currentCellFrame.origin.y = yPostion;
                editPhotoCell.frame = currentCellFrame;
            } else {
                EditPhotoCell *preCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row-1) inSection:0]];
                float height = [CustomUtil heightForString:preCell.linkTextView.text fontSize:13.0f andWidth:preCell.linkTextView.frame.size.width];
                float yPostion = preCell.frame.origin.y + height + 4;
                CGRect currentCellFrame = editPhotoCell.frame;
                currentCellFrame.origin.y = yPostion;
                editPhotoCell.frame = currentCellFrame;
            }
            return editPhotoCell;
             */

        }
            break;
    }
    return nil;
}

#pragma mark -TextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_biaoqianInputTitleTextField resignFirstResponder];
    [_biaoqianInputLinkTextField resignFirstResponder];
    
    return YES;
}

#pragma mark - EditImageDelegate
- (void)editImageSuccese:(ALAsset *)aALAsset
{

//    [_editImageArray objectAtIndexCheck:_selectImageFlag];

    [_editImageArray replaceObjectAtIndex:_selectImageFlag withObject:aALAsset];

    switch (_selectImageFlag) {
        case 0:
        {
            [_firstSmallBtn setBackgroundImage:[UIImage imageWithCGImage:aALAsset.thumbnail] forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [_secondeSmallBtn setBackgroundImage:[UIImage imageWithCGImage:aALAsset.thumbnail] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [_thirdSmallBtn setBackgroundImage:[UIImage imageWithCGImage:aALAsset.thumbnail] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [_fourthSmallBtn setBackgroundImage:[UIImage imageWithCGImage:aALAsset.thumbnail] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    switch (_selectImageFlag) {
        case 0:
            [self firstImageBtnClick:_firstSmallBtn];
            break;
        case 1:
            [self secondeImageBtnClick:_secondeSmallBtn];
            break;
        case 2:
            [self thirdImageBtnClick:_thirdSmallBtn];
            break;
        case 3:
            [self fourthImageBtnClick:_fourthSmallBtn];
            break;
        default:
            break;
    }
}

#pragma mark -按钮点击事件处理
- (void)hideBiaoqianView
{
    _biaoqianBackView.hidden = YES;
}

// 添加图片
- (void)addPhoto
{
    NSLog(@"添加图片");
    //进入手机相册页面
//    PublishStreetPhotoViewController *publishStreetPhotoViewCtrl  = [[PublishStreetPhotoViewController alloc] initWithNibName:@"PublishStreetPhotoViewController" bundle:nil];
//    publishStreetPhotoViewCtrl.intoFlag = 2;
//    publishStreetPhotoViewCtrl.selectPhotoArray = [NSMutableArray arrayWithArray:_editImageArray];
//    publishStreetPhotoViewCtrl.photo1LabelArray = [NSMutableArray arrayWithArray:_photo1LabelCoordinateArray];
//    publishStreetPhotoViewCtrl.photo2LabelArray = [NSMutableArray arrayWithArray:_photo2LabelCoordinateArray];
//    publishStreetPhotoViewCtrl.photo3LabelArray = [NSMutableArray arrayWithArray:_photo3LabelCoordinateArray];
//    publishStreetPhotoViewCtrl.photo4LabelArray = [NSMutableArray arrayWithArray:_photo4LabelCoordinateArray];
//    publishStreetPhotoViewCtrl.photoIndex = [publishStreetPhotoViewCtrl.selectPhotoArray count];
//    for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
//        if ([viewCtrl isKindOfClass:[TabBarController class]]) {
//            TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
//            PublishStreetPhotoViewController *streetPhotoViewCtrl = [[tabBarCtrl viewControllers] objectAtIndexCheck:2];
//            publishStreetPhotoViewCtrl.labelArray = streetPhotoViewCtrl.labelArray;
//        }
//    }
//    [self.navigationController pushViewController:publishStreetPhotoViewCtrl animated:YES];
    
    for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
        if ([viewCtrl isKindOfClass:[TabBarController class]]) {
            TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
            PublishStreetPhotoViewController *publishStreetPhotoViewCtrl = [[tabBarCtrl viewControllers] objectAtIndexCheck:2];
//            publishStreetPhotoViewCtrl.intoFlag = YES;
            publishStreetPhotoViewCtrl.selectPhotoArray = [NSMutableArray arrayWithArray:_editImageArray];
            publishStreetPhotoViewCtrl.photo1LabelArray = [NSMutableArray arrayWithArray:_photo1LabelCoordinateArray];
            publishStreetPhotoViewCtrl.photo2LabelArray = [NSMutableArray arrayWithArray:_photo2LabelCoordinateArray];
            publishStreetPhotoViewCtrl.photo3LabelArray = [NSMutableArray arrayWithArray:_photo3LabelCoordinateArray];
            publishStreetPhotoViewCtrl.photo4LabelArray = [NSMutableArray arrayWithArray:_photo4LabelCoordinateArray];
            publishStreetPhotoViewCtrl.photoIndex = [publishStreetPhotoViewCtrl.selectPhotoArray count];
            [self.navigationController popToViewController:viewCtrl animated:YES];
            return;
        }
    }
}
// 添加标签
- (void)addLinkBiaoqianClick:(id)sender
{
    if ([CustomUtil CheckParam:_biaoqianInputTitleTextField.text]) {
        [CustomUtil showToastWithText:@"请输入标题" view:kWindow];
        return;
    }
    if ([CustomUtil CheckParam:_biaoqianInputLinkTextField.text]) {
        [CustomUtil showToastWithText:@"请输入链接" view:kWindow];
        return;
    }

    
    //检查添加的标签名称是否小于10个汉字（20个字符）
    NSInteger chineseCharCount = [CustomUtil chineseCountOfString:_biaoqianInputTitleTextField.text];
    NSInteger charCount = [CustomUtil characterCountOfString:_biaoqianInputTitleTextField.text];
    NSInteger totalCount = chineseCharCount * 2 + charCount;
    if (totalCount > LABLE_NAME_LENGTH * 2) {
        [CustomUtil showToastWithText:@"标签名20个字符以内" view:kWindow];
        return;
    }
    
    [_biaoqianInputTitleTextField resignFirstResponder];
    
    [_biaoqianInputLinkTextField resignFirstResponder];
    
    //添加标签
    [AddTagInput shareInstance].userId = [LoginModel shareInstance].userId;
    [AddTagInput shareInstance].tagName = _biaoqianInputTitleTextField.text;
    NSMutableDictionary *dict = [CustomUtil modelToDictionary:[AddTagInput shareInstance]];
    [[NetInterface shareInstance] addTag:@"addTag" param:dict successBlock:^(NSDictionary *responseDict) {
        AddTag *resultData = [AddTag modelWithDict:responseDict];
        if (RETURN_SUCCESS(resultData.status)) {
            _biaoqianBackView.hidden = YES;

            _addLabelFlag = 0;
            
            NSString *returnTagId = resultData.tagId;
            //添加标签
            [CustomUtil showToastWithText:resultData.msg view:[UIApplication sharedApplication].keyWindow];
            self.addLabelName = _biaoqianInputTitleTextField.text;
            self.addLabelId = returnTagId;

            UIView *tmpMaskImageView;
            
            switch (_selectImageFlag) {
                case 0:
                    tmpMaskImageView = firstMaskImageView;
                    break;
                case 1:
                    tmpMaskImageView = secondeMaskImageView;
                    break;
                case 2:
                    tmpMaskImageView = thirdMaskImageView;
                    break;
                case 3:
                    tmpMaskImageView = forthMaskImageView;
                    break;
                default:
                    break;
            }

            CGPoint tapPoint;
            double angle = floorf(((double)arc4random() / ARC4RANDOM_MAX) * (2 * M_PI));
            
            double radius = floorf(((double)arc4random() / ARC4RANDOM_MAX) * (tmpMaskImageView.frame.size.width/2)) - 5;
            
            CGFloat x3 = tmpMaskImageView.frame.size.width/2 + cos(angle) * radius;
            
            CGFloat y3 = tmpMaskImageView.frame.size.height/2 + sin(angle) * radius;
            
            tapPoint = CGPointMake(x3, y3);
            TouchPositionModel *positionModel = [[TouchPositionModel alloc] init];
            positionModel.tagId = returnTagId;
            positionModel.labelName = _biaoqianInputTitleTextField.text;
            positionModel.link = [CustomUtil deleteBlankAndNewlineChar:_biaoqianInputLinkTextField.text];

            positionModel.horizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x)];
            //获取原图尺寸
            ALAsset *asset = [_editImageArray objectAtIndexCheck:_selectImageFlag];
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            UIImage *photoImage = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)representation.orientation];
            switch (_selectImageFlag) {
                case 0:
                    positionModel.changeHorizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x / (firstMaskImageView.frame.size.width/photoImage.size.width))];
                    break;
                case 1:
                    positionModel.changeHorizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x / (secondeMaskImageView.frame.size.width/photoImage.size.width))];
                    break;
                case 2:
                    positionModel.changeHorizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x / (thirdMaskImageView.frame.size.width/photoImage.size.width))];
                    break;
                case 3:
                    positionModel.changeHorizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x / (forthMaskImageView.frame.size.width/photoImage.size.width))];
                    break;
                default:
                    break;
            }
            positionModel.vertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y)];
            switch (_selectImageFlag) {
                case 0:
                {
                    positionModel.changeVertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y / (firstMaskImageView.frame.size.height/photoImage.size.height))];
                }
                    break;
                case 1:
                {
                    positionModel.changeVertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y / (secondeMaskImageView.frame.size.height/photoImage.size.height))];
                }
                    break;
                case 2:
                {
                    positionModel.changeVertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y / (thirdMaskImageView.frame.size.height/photoImage.size.height))];
                }
                    break;
                case 3:
                {
                    positionModel.changeVertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y / (forthMaskImageView.frame.size.height/photoImage.size.height))];
                }
                    break;
                default:
                    break;
            }
            
            switch (_selectImageFlag) {
                case 0:
                {
                    for (TouchPositionModel *model in _photo1LabelCoordinateArray) {
                        if ([model.labelName isEqualToString:_addLabelName]) {
                            [CustomUtil showToast:[NSString stringWithFormat:@"【%@】标签已经存在，不能重复添加", _addLabelName] view:kWindow];
                            [_photo1LabelCoordinateArray removeLastObject];
                            return;
                        }
                    }
                    [_photo1LabelCoordinateArray addObject:positionModel];
                }
                    break;
                case 1:
                {
                    for (TouchPositionModel *model in _photo2LabelCoordinateArray) {
                        if ([model.labelName isEqualToString:_addLabelName]) {
                            [CustomUtil showToast:[NSString stringWithFormat:@"【%@】标签已经存在，不能重复添加", _addLabelName] view:kWindow];
                            [_photo2LabelCoordinateArray removeLastObject];
                            return;
                        }
                    }
                    [_photo2LabelCoordinateArray addObject:positionModel];
                }
                    break;
                case 2:
                {
                    for (TouchPositionModel *model in _photo3LabelCoordinateArray) {
                        if ([model.labelName isEqualToString:_addLabelName]) {
                            [CustomUtil showToast:[NSString stringWithFormat:@"【%@】标签已经存在，不能重复添加", _addLabelName] view:kWindow];
                            [_photo3LabelCoordinateArray removeLastObject];
                            return;
                        }
                    }
                    [_photo3LabelCoordinateArray addObject:positionModel];
                }
                    break;
                case 3:
                {
                    for (TouchPositionModel *model in _photo4LabelCoordinateArray) {
                        if ([model.labelName isEqualToString:_addLabelName]) {
                            [CustomUtil showToast:[NSString stringWithFormat:@"【%@】标签已经存在，不能重复添加", _addLabelName] view:kWindow];
                            [_photo4LabelCoordinateArray removeLastObject];
                            return;
                        }
                    }
                    [_photo4LabelCoordinateArray addObject:positionModel];
                }
                    break;
                default:
                    break;
            }
            
            [self drawLabelBtn:positionModel];

        } else {
            [CustomUtil showToastWithText:resultData.msg view:[UIApplication sharedApplication].keyWindow];
        }
    } failedBlock:^(NSError *err) {
        [CustomUtil showToastWithText:@"网络不给力，请稍后重试" view:self.view];
    }];
}

// 取消添加外链标签
- (void)cancelAddLinkBiaoqianClick:(id)sender
{
    [_biaoqianInputTitleTextField resignFirstResponder];
    
    [_biaoqianInputLinkTextField resignFirstResponder];

    self.addLabelName = @"";
    self.addLabelId = @"";

    _biaoqianBackView.hidden = YES;
}

//标签选择点击
- (void)biaoqianChooseBtnClick:(UIButton *)btn
{
    if (btn.tag == 200) {
        // 普通标签
        _biaoqianBackView.hidden = YES;
        [self addBiaoqianWithToush:_tmpGesture];
    }
    else {
        _biaoqianInputTitleTextField.text = @"";
        
        _biaoqianInputLinkTextField.text = @"";

        // 链接标签
        _biaoqianChooseView.hidden = YES;
        _biaoqianInputView.hidden = NO;
    }
}

// 标签 or 滤镜
- (void)footBtnClick:(UIButton *)btn
{
    //去除标签提示
    if (alertLabel) {
        [alertLabel removeFromSuperview];
    }
    
    if (btn.tag == 100) {
        // 标签
        _biaoqianBackView.hidden = NO;
        _biaoqianChooseView.hidden = NO;
        _biaoqianInputView.hidden = YES;
    }
    else {
        ALAsset *asset = [_editImageArray objectAtIndexCheck:_selectImageFlag];
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        UIImage *photoImage = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)representation.orientation];
        DLog(@"width = %f, height = %f", photoImage.size.width, photoImage.size.height);
        self.editImage = [CustomUtil normalizedImage:photoImage];

//        self.editImage = [UIImage imageWithCGImage:asset.thumbnail];

        // 滤镜
        [self goEditImageController];
    }
    
}

-(void)goEditImageController {
    
    EditImageViewController *editVC = [[EditImageViewController alloc] initWithImage:self.editImage];
    editVC.delegate = self;
    [self.navigationController pushViewController:editVC animated:YES];
}

//返回按钮点击事件
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击大图空白区域的事件处理
-(void)touchImageView:(id)sender
{
    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    [self footBtnClick:button];
    return;
    
}

- (void)addBiaoqianWithToush:(id)sender
{
    //去除标签提示
    if (alertLabel) {
        [alertLabel removeFromSuperview];
    }
    _addLabelFlag = 1;
    //取得点击坐标
    UITapGestureRecognizer *loaclGesture = (UITapGestureRecognizer *)sender;
    CGPoint tapPoint;
    UIView *tmpMaskImageView;
    
    switch (_selectImageFlag) {
        case 0:
            tmpMaskImageView = firstMaskImageView;
            tapPoint = [loaclGesture locationInView:firstMaskImageView];
            break;
        case 1:
            tmpMaskImageView = secondeMaskImageView;
            
            tapPoint = [loaclGesture locationInView:secondeMaskImageView];
            break;
        case 2:
            tmpMaskImageView = thirdMaskImageView;
            
            tapPoint = [loaclGesture locationInView:thirdMaskImageView];
            break;
        case 3:
            tmpMaskImageView = forthMaskImageView;
            
            tapPoint = [loaclGesture locationInView:forthMaskImageView];
            break;
        default:
            break;
    }
    if (tapPoint.x <= 0 || tapPoint.y <= 0) {
        double angle = floorf(((double)arc4random() / ARC4RANDOM_MAX) * (2*M_PI));
        
        double radius = floorf(((double)arc4random() / ARC4RANDOM_MAX) * (tmpMaskImageView.frame.size.width/2)) - 5;
        
        CGFloat x3 = tmpMaskImageView.frame.size.width/2 + cos(angle) * radius;
        
        CGFloat y3 = tmpMaskImageView.frame.size.height/2 + sin(angle) * radius;
        
        tapPoint = CGPointMake(x3, y3);
    }
    
    
    TouchPositionModel *positionModel = [[TouchPositionModel alloc] init];
    positionModel.horizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x)];
    //获取原图尺寸
    ALAsset *asset = [_editImageArray objectAtIndexCheck:_selectImageFlag];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImage *photoImage = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)representation.orientation];
    switch (_selectImageFlag) {
        case 0:
            positionModel.changeHorizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x / (firstMaskImageView.frame.size.width/photoImage.size.width))];
            break;
        case 1:
            positionModel.changeHorizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x / (secondeMaskImageView.frame.size.width/photoImage.size.width))];
            break;
        case 2:
            positionModel.changeHorizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x / (thirdMaskImageView.frame.size.width/photoImage.size.width))];
            break;
        case 3:
            positionModel.changeHorizontal = [NSString stringWithFormat:@"%d", (int)(tapPoint.x / (forthMaskImageView.frame.size.width/photoImage.size.width))];
            break;
        default:
            break;
    }
    positionModel.vertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y)];
    switch (_selectImageFlag) {
        case 0:
        {
            positionModel.changeVertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y / (firstMaskImageView.frame.size.height/photoImage.size.height))];
            [_photo1LabelCoordinateArray addObject:positionModel];
        }
            break;
        case 1:
        {
            positionModel.changeVertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y / (secondeMaskImageView.frame.size.height/photoImage.size.height))];
            [_photo2LabelCoordinateArray addObject:positionModel];
        }
            break;
        case 2:
        {
            positionModel.changeVertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y / (thirdMaskImageView.frame.size.height/photoImage.size.height))];
            [_photo3LabelCoordinateArray addObject:positionModel];
        }
            break;
        case 3:
        {
            positionModel.changeVertical = [NSString stringWithFormat:@"%d", (int)(tapPoint.y / (forthMaskImageView.frame.size.height/photoImage.size.height))];
            [_photo4LabelCoordinateArray addObject:positionModel];
        }
            break;
        default:
            break;
    }
    CustomLabelViewController *customLabelViewCtrl = [[CustomLabelViewController alloc] initWithNibName:@"CustomLabelViewController" bundle:nil];
    customLabelViewCtrl.preViewCtrl = self;
    [self.navigationController pushViewController:customLabelViewCtrl animated:YES];

}

//下一步按钮点击
- (IBAction)nextBtnClick:(id)sender {
    if ((0 == _photo1LabelCoordinateArray.count) &&
        (0 == _photo2LabelCoordinateArray.count) &&
        (0 == _photo3LabelCoordinateArray.count) &&
        (0 == _photo4LabelCoordinateArray.count)) {
        if (!alertLabel) {
            alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 90 * 2, 30)];
        }
        [alertLabel setCenter:kWindow.center];
        [alertLabel setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.6f]];
        [alertLabel setTextAlignment:NSTextAlignmentCenter];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"至少添加一个标签"];
        NSRange whiteRange = NSMakeRange([[noteStr string] rangeOfString:@"至少添加一个"].location, [[noteStr string] rangeOfString:@"至少添加一个"].length);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:whiteRange];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:whiteRange];
        NSRange yellowRange = NSMakeRange([[noteStr string] rangeOfString:@"标签"].location, [[noteStr string] rangeOfString:@"标签"].length);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:yellowRange];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:yellowRange];
        [alertLabel setAttributedText:noteStr];
        [self.view addSubview:alertLabel];
        
        return;
    }
    
    for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
        if ([viewCtrl isKindOfClass:[PublishViewController class]]) {
            PublishViewController *publishViewCtrl = (PublishViewController *)viewCtrl;
            publishViewCtrl.photo1PositionArray = _photo1LabelCoordinateArray;
            publishViewCtrl.photo2PositionArray = _photo2LabelCoordinateArray;
            publishViewCtrl.photo3PositionArray = _photo3LabelCoordinateArray;
            publishViewCtrl.photo4PositionArray = _photo4LabelCoordinateArray;
            publishViewCtrl.photoArray = [_editImageArray mutableCopy];
            [self.navigationController popToViewController:viewCtrl animated:YES];
            return;
        }
    }

    PublishViewController *publishViewCtrl = [[PublishViewController alloc] initWithNibName:@"PublishViewController" bundle:nil];
    publishViewCtrl.photo1PositionArray = _photo1LabelCoordinateArray;
    publishViewCtrl.photo2PositionArray = _photo2LabelCoordinateArray;
    publishViewCtrl.photo3PositionArray = _photo3LabelCoordinateArray;
    publishViewCtrl.photo4PositionArray = _photo4LabelCoordinateArray;
    publishViewCtrl.photoArray = [_editImageArray mutableCopy];
    [self.navigationController pushViewController:publishViewCtrl animated:YES];
}

//小图一按钮点击事件
- (IBAction)firstImageBtnClick:(id)sender {
    [self removeSmallPhotoBackImage];
    _selectImageFlag = 0;
    [_firstSmallBackImageView setImage:[UIImage imageNamed:@"pic02-bg7-2-2"]];
    ALAsset *asset = [_editImageArray objectAtIndexCheck:0];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:1 orientation:representation.orientation];
    image = [CustomUtil normalizedImage:image];
    CGSize size = [self getImageViewSizeFromImage:image];
    CGRect rect = _picImageView.frame;
    [_picImageView setImage:image];
    rect.size.width = size.width;
    rect.size.height = size.height;
    float xPostion = (SCREEN_WIDTH - size.width)/2.0f;
    rect.origin.x = xPostion;
    _picImageView.frame = rect;
    [_picImageView setCenter:CGPointMake(_picImageView.superview.center.x, _picImageView.center.y)];
    [self removeAllSubviewsFromBigPhotoView];
    if (size.width > size.height) {
        //float rate = ceilf(size.width/size.height*100)/100;
        DLog(@"size.width/size.height = %f", size.width/size.height);
        if (size.width/size.height == 1.3333333333333333) {
            firstMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(int)(size.width/size.height))];
        } else {
            firstMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(size.width/size.height))];
        }
    } else {
        firstMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(xPostion, 0, size.width, size.height)];
    }
    [_picImageView addSubview:firstMaskImageView];
    if (size.width > size.height) {
        [firstMaskImageView setCenter:CGPointMake(SCREEN_WIDTH/2, _picImageView.center.y)];
    }
    [firstMaskImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageView:)];
    [firstMaskImageView addGestureRecognizer:gestureRecognizer];
    [firstMaskImageView setBackgroundColor:[UIColor clearColor]];
    
    _tmpGesture = gestureRecognizer;
    
    for (int i=0; i<_photo1LabelCoordinateArray.count; i++) {
        TouchPositionModel *model = _photo1LabelCoordinateArray[i];
        [self drawLabelBtn:model];
    }
    [_mainTableView reloadData];
}

//小图二按钮点击事件
- (IBAction)secondeImageBtnClick:(id)sender {
    [self removeSmallPhotoBackImage];
    _selectImageFlag = 1;
    [_secondSmallBackImageView setImage:[UIImage imageNamed:@"pic02-bg7-2-2"]];
    ALAsset *asset = [_editImageArray objectAtIndexCheck:1];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:1 orientation:representation.orientation];
    image = [CustomUtil normalizedImage:image];
    CGSize size = [self getImageViewSizeFromImage:image];
    [_picImageView setImage:image];
    CGRect rect = _picImageView.frame;
    rect.size.width = size.width;
    rect.size.height = size.height;
    float xPostion = (SCREEN_WIDTH - rect.size.width)/2.0f;
    rect.origin.x = xPostion;
    _picImageView.frame = rect;
    [_picImageView setCenter:CGPointMake(_picImageView.superview.center.x, _picImageView.center.y)];
    [self removeAllSubviewsFromBigPhotoView];
    if (size.width > size.height) {
        if (size.width/size.height == 1.3333333333333333) {
            secondeMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(int)(size.width/size.height))];
        } else {
            secondeMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(size.width/size.height))];
        }
    } else {
        secondeMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(xPostion, 0, size.width, size.height)];
    }
    [_picImageView addSubview:secondeMaskImageView];
    if (size.width > size.height) {
        [secondeMaskImageView setCenter:CGPointMake(SCREEN_WIDTH/2, _picImageView.center.y)];
    }
    [secondeMaskImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageView:)];
    [secondeMaskImageView addGestureRecognizer:gestureRecognizer];
    [secondeMaskImageView setBackgroundColor:[UIColor clearColor]];
    
    _tmpGesture = gestureRecognizer;

    for (int i=0; i<_photo2LabelCoordinateArray.count; i++) {
        TouchPositionModel *model = _photo2LabelCoordinateArray[i];
        [self drawLabelBtn:model];
    }
    [_mainTableView reloadData];
}

//小图三按钮点击事件
- (IBAction)thirdImageBtnClick:(id)sender {
    [self removeSmallPhotoBackImage];
    _selectImageFlag = 2;
    [_thirdSmallBackImageView setImage:[UIImage imageNamed:@"pic02-bg7-2-2"]];
    ALAsset *asset = [_editImageArray objectAtIndexCheck:2];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:1 orientation:representation.orientation];
    image = [CustomUtil normalizedImage:image];
    CGSize size = [self getImageViewSizeFromImage:image];
    [_picImageView setImage:image];
    CGRect rect = _picImageView.frame;
    rect.size.width = size.width;
    rect.size.height = size.height;
    float xPostion = (SCREEN_WIDTH - rect.size.width)/2.0f;
    rect.origin.x = xPostion;
    _picImageView.frame = rect;
    [_picImageView setCenter:CGPointMake(_picImageView.superview.center.x, _picImageView.center.y)];
    [self removeAllSubviewsFromBigPhotoView];
    if (size.width > size.height) {
        if (size.width/size.height == 1.3333333333333333) {
            thirdMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(int)(size.width/size.height))];
        } else {
            thirdMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(size.width/size.height))];
        }
    } else {
        thirdMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(xPostion, 0, size.width, size.height)];
    }
    [_picImageView addSubview:thirdMaskImageView];
    if (size.width > size.height) {
        [thirdMaskImageView setCenter:CGPointMake(SCREEN_WIDTH/2, _picImageView.center.y)];
    }
    [thirdMaskImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageView:)];
    [thirdMaskImageView addGestureRecognizer:gestureRecognizer];
    [thirdMaskImageView setBackgroundColor:[UIColor clearColor]];
    
    _tmpGesture = gestureRecognizer;

    for (int i=0; i<_photo3LabelCoordinateArray.count; i++) {
        TouchPositionModel *model = _photo3LabelCoordinateArray[i];
        [self drawLabelBtn:model];
    }
    [_mainTableView reloadData];
}

//小图四按钮点击事件
- (IBAction)fourthImageBtnClick:(id)sender {
    [self removeSmallPhotoBackImage];
    _selectImageFlag = 3;
    [_fourthSmallBackImageView setImage:[UIImage imageNamed:@"pic02-bg7-2-2"]];
    ALAsset *asset = [_editImageArray objectAtIndexCheck:3];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:1 orientation:representation.orientation];
    image = [CustomUtil normalizedImage:image];
    CGSize size = [self getImageViewSizeFromImage:image];
    [_picImageView setImage:image];
    CGRect rect = _picImageView.frame;
    rect.size.width = size.width;
    rect.size.height = size.height;
    float xPostion = (SCREEN_WIDTH - rect.size.width)/2.0f;
    rect.origin.x = xPostion;
    _picImageView.frame = rect;
    [_picImageView setCenter:CGPointMake(_picImageView.superview.center.x, _picImageView.center.y)];
    [self removeAllSubviewsFromBigPhotoView];
    if (size.width > size.height) {
        if (size.width/size.height == 1.3333333333333333) {
            forthMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(int)(size.width/size.height))];
        } else {
            forthMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/(size.width/size.height))];
        }
    } else {
        forthMaskImageView = [[UIView alloc] initWithFrame:CGRectMake(xPostion, 0, size.width, size.height)];
    }
    [_picImageView addSubview:forthMaskImageView];
    if (size.width > size.height) {
        [forthMaskImageView setCenter:CGPointMake(SCREEN_WIDTH/2, _picImageView.center.y)];
    }
    [forthMaskImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageView:)];
    [forthMaskImageView addGestureRecognizer:gestureRecognizer];
    [forthMaskImageView setBackgroundColor:[UIColor clearColor]];
    
    _tmpGesture = gestureRecognizer;

    for (int i=0; i<_photo4LabelCoordinateArray.count; i++) {
        TouchPositionModel *model = _photo4LabelCoordinateArray[i];
        [self drawLabelBtn:model];
    }
    [_mainTableView reloadData];
}

- (void)removeSmallPhotoBackImage
{
    [_firstSmallBackImageView setImage:nil];
    [_secondSmallBackImageView setImage:nil];
    [_thirdSmallBackImageView setImage:nil];
    [_fourthSmallBackImageView setImage:nil];
}

//标签按钮点击事件
-(void)linkBtnClick:(id)sender
{
    LabelButton *button = (LabelButton *)sender;
    if (([CustomUtil CheckParam:button.model.link]) || ([button.model.link isEqualToString:PLACE_HOLDER_TEXT])) {
        //跳转至7-1-2标签列表页
        LabelDetailViewController *viewCtrl = [[LabelDetailViewController alloc] init];
        viewCtrl.tagName = button.model.labelName;
        viewCtrl.tagId = button.model.tagId;
        [self.navigationController pushViewController:viewCtrl animated:YES];
    } else {  //浏览器打开链接
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", button.model.link]]];
    }
}

#pragma mark -共通方法
//绘制标签按钮
-(void)drawLabelBtn:(TouchPositionModel *)model
{
    //获取标签文本尺寸
    CGSize labelTextSize = [model.labelName sizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    //调整label的位置
    float labelPointXPostion = [model.horizontal floatValue];
    float labelPointYPostion = [model.vertical floatValue];
    /*
    if (labelXPostion > (_picImageView.frame.size.width - labelTextSize.width - 30)) {
        labelXPostion = _picImageView.frame.size.width - labelTextSize.width - 30;
    }
    if (labelYPostion > (_picImageView.frame.size.height - 25)) {
        labelYPostion = _picImageView.frame.size.height - 25;
    }
     */
    UIView *currentImageView = nil;
    switch (_selectImageFlag) {
        case 0:
            currentImageView = firstMaskImageView;
            break;
        case 1:
            currentImageView = secondeMaskImageView;
            break;
        case 2:
            currentImageView = thirdMaskImageView;
            break;
        case 3:
            currentImageView = forthMaskImageView;
            break;
        default:
            break;
    }
    //添加小红点
    UIImage *backImage = [UIImage imageNamed:@"黑点"];
    
    UIImageView *backView = [[UIImageView alloc] init];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    backView.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    backView.layer.cornerRadius = backImage.size.width / 2;
    backView.layer.masksToBounds = YES;
    [currentImageView addSubview:backView];
    
    UIImage *redImage = [UIImage imageNamed:@"红点-单独"];
    
    UIImageView *labelPointImageView = [[UIImageView alloc] initWithImage:redImage];
    
//    UIImageView *labelPointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yuan_8"]];
    if (labelPointXPostion > (currentImageView.frame.size.width - 4.5)) {
        labelPointXPostion = currentImageView.frame.size.width - 4.5;
    }
    if (labelPointYPostion > (currentImageView.frame.size.height - 25 / 2)) {
        labelPointYPostion = currentImageView.frame.size.height - 25 / 2;
    }
    if (labelPointYPostion < 25/2.0f) { //上部超出，移动标签
        labelPointYPostion = 25/2.0f;
    }
    CGRect rect = labelPointImageView.frame;
    rect.size.width = 9;
    rect.size.height = 9;
    labelPointImageView.frame = rect;
    [labelPointImageView setCenter:CGPointMake(labelPointXPostion, labelPointYPostion)];
    [currentImageView addSubview:labelPointImageView];
    backView.center = labelPointImageView.center;
    
    //调整label的位置
    float labelXPostion = labelPointXPostion + 8;
    float labelYPostion = labelPointYPostion - 25/2.0f;
    
    if (labelPointXPostion > (currentImageView.frame.size.width - labelPointImageView.frame.size.width - 8 - labelTextSize.width - 30)) { //右侧超出，将标签显示在左侧
        labelXPostion = labelPointXPostion - 8 - labelTextSize.width - 30;
    }
    if (labelPointYPostion < 25/2.0f) { //上部超出，移动标签
        labelYPostion = 0;
    }
    if (labelPointYPostion > (currentImageView.frame.size.height - 25/2.0f)) { //下部超出，移动标签
        labelYPostion = currentImageView.frame.size.height - 25;
    }
    
    LabelButton *labelButton = [[LabelButton alloc] initWithFrame:CGRectMake(labelXPostion, labelYPostion, labelTextSize.width + 30, 25)];
    [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];

    backView.center = labelPointImageView.center = CGPointMake(GetX(labelButton) - 4, labelButton.center.y);;

//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 30, 0, 5);

    UIImage *buttonBackImage = [UIImage imageNamed:@"标签-通用"];
    
//    if (labelPointXPostion > (currentImageView.frame.size.width - labelPointImageView.frame.size.width - 8 - labelTextSize.width - 30)) { //右侧超出，将标签显示在左侧
//        
//        buttonBackImage = [CustomUtil image:buttonBackImage rotation:UIImageOrientationDown];
//        
//        [labelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//        
//        insets = UIEdgeInsetsMake(0, 5, 0, 30);
//    }
    
//    buttonBackImage = [buttonBackImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [labelButton setBackgroundImage:buttonBackImage forState:UIControlStateNormal];
    if ([CustomUtil CheckParam:model.link]) {
//      [backView.layer removeAllAnimations];
    }
    else {
        [self shakeToShow:backView];
    }

    [labelButton setTintColor:[UIColor whiteColor]];
    [labelButton setTitle:model.labelName forState:UIControlStateNormal];
    labelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    [labelButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPressGR.minimumPressDuration = 0.5;
    [labelButton addGestureRecognizer:longPressGR];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(labelPan:)];
    [labelButton addGestureRecognizer:pan];
    
    labelButton.model = model;
    labelButton.pointImageView = labelPointImageView;
    labelButton.backImageView = backView;

    [labelButton addTarget:self action:@selector(linkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [currentImageView addSubview:labelButton];
    
    [_mainTableView reloadData];
}

- (void)labelPan:(UIPanGestureRecognizer *)gesture {
    
    LabelButton *labelButton = (LabelButton *)(((UIPanGestureRecognizer *)gesture).view);

    TouchPositionModel *tmpModel;
    
    switch (_selectImageFlag) {
        case 0:
        {
            for (TouchPositionModel *model in _photo1LabelCoordinateArray) {
                if (([labelButton.model.horizontal intValue] == [model.horizontal intValue]) &&
                    ([labelButton.model.vertical intValue] == [model.vertical intValue]) && labelButton.model) {
                    tmpModel = model;
                    break;
                }
            }
        }
            break;
        case 1:
        {
            for (TouchPositionModel *model in _photo2LabelCoordinateArray) {
                if (([labelButton.model.horizontal intValue] == [model.horizontal intValue]) &&
                    ([labelButton.model.vertical intValue] == [model.vertical intValue]) && labelButton.model) {
                    tmpModel = model;
                    break;
                }
            }
        }
            break;
        case 2:
        {
            for (TouchPositionModel *model in _photo3LabelCoordinateArray) {
                if (([labelButton.model.horizontal intValue] == [model.horizontal intValue]) &&
                    ([labelButton.model.vertical intValue] == [model.vertical intValue]) && labelButton.model) {
                    tmpModel = model;
                    break;
                }
            }
        }
            break;
        case 3:
        {
            for (TouchPositionModel *model in _photo4LabelCoordinateArray) {
                if (([labelButton.model.horizontal intValue] == [model.horizontal intValue]) &&
                    ([labelButton.model.vertical intValue] == [model.vertical intValue]) && labelButton.model) {
                    tmpModel = model;
                    break;
                }
            }
        }
            break;
        default:
            break;
    }
    
    
    static CGPoint oldCenter;
    
    CGPoint tranlation = [gesture translationInView:labelButton];
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        oldCenter = gesture.view.center;
    }
    
    CGPoint newCenter = CGPointMake(oldCenter.x + tranlation.x, oldCenter.y + tranlation.y);
    
    labelButton.center = [self constraintCircleCenter:newCenter withView:labelButton];
    
    tmpModel.horizontal = [NSString stringWithFormat:@"%f", GetX(labelButton) - 4];
    tmpModel.vertical = [NSString stringWithFormat:@"%f", labelButton.center.y];
    
    ALAsset *asset = [_editImageArray objectAtIndexCheck:_selectImageFlag];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImage *photoImage = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)representation.orientation];
    tmpModel.changeHorizontal = [NSString stringWithFormat:@"%d", (int)([tmpModel.horizontal floatValue] / (labelButton.superview.frame.size.width/photoImage.size.width))];
    tmpModel.changeVertical = [NSString stringWithFormat:@"%d", (int)([tmpModel.vertical floatValue] / (labelButton.superview.frame.size.height/photoImage.size.height))];

//    float labelXPostion = labelPointXPostion + 8;
//    float labelYPostion = labelPointYPostion - 25/2.0f;

    labelButton.backImageView.center = labelButton.pointImageView.center = CGPointMake(GetX(labelButton) - 4, labelButton.center.y);
}

/**
 *  移动时计算最大半径是否超出图片大小
 *
 *  @param circleCeinter   园心坐标
 *
 */
- (CGPoint)constraintCircleCenter:(CGPoint)circleCenter withView:(UIView *)targetView
{    
    CGFloat cx = circleCenter.x;
    
    CGFloat cy = circleCenter.y;
    NSLog(@"++++++++++%f________%f",cx,cy);
    /* 横向越界 */
    // 右边越界
    if (circleCenter.x + targetView.frame.size.width / 2 > targetView.superview.frame.size.width) {
        
        cx = targetView.superview.frame.size.width - targetView.frame.size.width / 2;
            NSLog(@"++++++++++%f",cx);
    }
    // 左边越界
    else if (circleCenter.x - targetView.frame.size.width / 2 < 4) {
        
        cx = targetView.frame.size.width / 2 + 4;
            NSLog(@"++++++++++%f",cx);
    }
    
    /* 纵向越界 */
    // 下边越界
    if (circleCenter.y + targetView.frame.size.height / 2 > targetView.superview.frame.size.height) {
        
        cy = targetView.superview.frame.size.height - targetView.frame.size.height / 2;
            NSLog(@"++++++++++%f",cy);
    }
    // 上边越界
    else if (circleCenter.y - targetView.frame.size.height / 2 < 0) {
        
        cy = targetView.frame.size.height / 2;
            NSLog(@"++++++++++%f",cy);
    }
    
    return CGPointMake(cx, cy);
}



//移除大图上的标签
-(void)removeAllSubviewsFromBigPhotoView
{
    for (UIView *view in _picImageView.subviews) {
        [view removeFromSuperview];
    }
}

//标签按钮长按事件
-(void)longPress:(id)sender
{
    [CustomUtil showCustomAlertView:nil message:@"确认删除该标签？" leftTitle:@"取消" rightTitle:@"确定" leftHandle:nil rightHandle:^(UIAlertAction *action) {
        //删除标签
        LabelButton *removeBtn = (LabelButton *)(((UILongPressGestureRecognizer *)sender).view);
        [removeBtn.backImageView removeFromSuperview];
        [removeBtn.pointImageView removeFromSuperview];
        [removeBtn removeFromSuperview];
        switch (_selectImageFlag) {
            case 0:
            {
                for (TouchPositionModel *model in _photo1LabelCoordinateArray) {
                    if (([removeBtn.model.horizontal intValue] == [model.horizontal intValue]) &&
                        ([removeBtn.model.vertical intValue] == [model.vertical intValue]) && removeBtn.model) {
                        [_photo1LabelCoordinateArray removeObject:model];
                        [_mainTableView reloadData];
                        return;
                    }
                }
            }
                break;
            case 1:
            {
                for (TouchPositionModel *model in _photo2LabelCoordinateArray) {
                    if (([removeBtn.model.horizontal intValue] == [model.horizontal intValue]) &&
                        ([removeBtn.model.vertical intValue] == [model.vertical intValue]) && removeBtn.model) {
                        [_photo2LabelCoordinateArray removeObject:model];
                        [_mainTableView reloadData];
                        return;
                    }
                }
            }
                break;
            case 2:
            {
                for (TouchPositionModel *model in _photo3LabelCoordinateArray) {
                    if (([removeBtn.model.horizontal intValue] == [model.horizontal intValue]) &&
                        ([removeBtn.model.vertical intValue] == [model.vertical intValue]) && removeBtn.model) {
                        [_photo3LabelCoordinateArray removeObject:model];
                        [_mainTableView reloadData];
                        return;
                    }
                }
            }
                break;
            case 3:
            {
                for (TouchPositionModel *model in _photo4LabelCoordinateArray) {
                    if (([removeBtn.model.horizontal intValue] == [model.horizontal intValue]) &&
                        ([removeBtn.model.vertical intValue] == [model.vertical intValue]) && removeBtn.model) {
                        [_photo4LabelCoordinateArray removeObject:model];
                        [_mainTableView reloadData];
                        return;
                    }
                }
            }
                break;
            default:
                break;
        }
        
    } target:self btnCount:2];
}

//根据图片大小获取imageView的尺寸
-(CGSize)getImageViewSizeFromImage:(UIImage *)image
{
    CGFloat imageViewWidth = picImageViewRect.size.width;
    CGFloat imageViewHeight = picImageViewRect.size.height;
    //fix bug start
    //_picImageView.frame = picImageViewRect;
    //fix bug end
    
    CGFloat viewWidth = imageViewWidth;    //imageView宽度
    CGFloat viewHeight = imageViewHeight;  //imageView高度
    if (image.size.width > viewWidth) {
        viewHeight = image.size.height/image.size.width * viewWidth;
        viewWidth = imageViewWidth;
    } else {
        viewWidth = image.size.width;
        viewHeight = image.size.height/image.size.width * viewWidth;
    }
    
    if (viewHeight > imageViewHeight) {
        viewWidth = imageViewHeight/(viewHeight/viewWidth);
        viewHeight = imageViewHeight;
    }
    
    return CGSizeMake(viewWidth, viewHeight);
}


#pragma mark - custommethod
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

@end

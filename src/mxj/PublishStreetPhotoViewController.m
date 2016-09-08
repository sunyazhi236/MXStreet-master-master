//
//  PublishStreetPhotoViewController.m
//  mxj
//  P7-2发布街拍-手机相册
//  Created by 齐乐乐 on 15/11/18.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "PublishStreetPhotoViewController.h"
#import "PublishStreetPhotoCell.h"
#import "TakePhotosViewController.h"
#import "EditPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TabBarController.h"
#import "AppDelegate.h"

#define PHOTO_WIDTH 70 //设定照片的默认尺寸（正方形）
#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.24299

@interface PublishStreetPhotoViewController ()
{
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *groupArray;       //相册分组
    NSMutableArray *photoArray;       //相册所有图片
    
    UIImagePickerController *imagePicker; //照片拾取器
    TakePhotosViewController *takePhotoViewCtrl; //照相机视图
    UIImageView *maskView;    //照片遮罩层
    UIImage *captureImage;    //拍摄的图片
    
    ALAssetsLibrary *library;
    
    NSMutableArray *orginLabelArray;        //进入画面前的标签数组
    NSMutableArray *orginSelectPhotoArray;  //进入画面前的选中图片数组
}
@end

@implementation PublishStreetPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.publishStreetPhotoTableView.delegate = self;
    self.publishStreetPhotoTableView.dataSource = self;
    //根据入口标记设置TableView的高度
    CGRect rect = _publishStreetPhotoTableView.frame;
    if (YES == _intoFlag) { //主页进入
        if ((int)SCREEN_HEIGHT == 480) {
            rect.size.height = SCREEN_HEIGHT;
            rect.origin.y = 64;
        } else {
            rect.size.height = SCREEN_HEIGHT - self.navigationController.navigationBar.frame.size.height - 20 - 44;
        }
    } else { //发布进入
        if ((int)SCREEN_HEIGHT == 480) {
            rect.size.height = SCREEN_HEIGHT + 25;
            rect.origin.y = 64;
        } else {
            rect.size.height = SCREEN_HEIGHT - self.navigationController.navigationBar.frame.size.height - 20;
        }
    }
    _publishStreetPhotoTableView.frame = rect;
    assetsLibrary = [CustomUtil defaultAssetsLibrary];
    groupArray = [[NSMutableArray alloc] init];
    photoArray = [[NSMutableArray alloc] init];
    if (!_selectPhotoArray) {
        _selectPhotoArray = [[NSMutableArray alloc] init];
    }
    if (!_photo1LabelArray) {
        _photo1LabelArray = [[NSMutableArray alloc] init];
    }
    if (!_photo2LabelArray) {
        _photo2LabelArray = [[NSMutableArray alloc] init];
    }
    if (!_photo3LabelArray) {
        _photo3LabelArray = [[NSMutableArray alloc] init];
    }
    if (!_photo4LabelArray) {
        _photo4LabelArray = [[NSMutableArray alloc] init];
    }
    if (YES == _intoFlag) { //主页进入
        _photoIndex = 0;
    }
    if(!_labelArray) {
        _labelArray = [[NSMutableArray alloc] init];
    }
    if (!_imageViewArray) {
        _imageViewArray = [[NSMutableArray alloc] init];
    }
    orginLabelArray = [_labelArray mutableCopy];
    orginSelectPhotoArray = [_selectPhotoArray mutableCopy];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_nextButton setTitle:_selectPhotoArray.count==0 ? @"确认" : [NSString stringWithFormat:@"确认(%d)", (int)_selectPhotoArray.count] forState:UIControlStateNormal];
    [self.navigationController setNavigationBarHidden:YES];
    [self reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int buttonCountPerLine = [self getButtonCountPerLine];
    switch (indexPath.row) {
        case 0: //首行
        {
            //设置照相机按钮布局
            CGSize size = [self getItemMarginWithScreen];
            //设置Cell高度
            CGRect camerBtnFrame = _firstCell.frame;
            camerBtnFrame.size.height = size.height;
            _firstCell.frame = camerBtnFrame;
            
            int firstLineCount = 0;
            if (photoArray.count >= buttonCountPerLine) {
                firstLineCount = buttonCountPerLine;
            } else {
                firstLineCount = photoArray.count;
            }
            //创建图片Button
            for (int i=0; i<firstLineCount; i++) {
                MyButton *photoButton = [[MyButton alloc] initWithFrame:CGRectMake((PHOTO_WIDTH*i + size.width*(i+1)), size.height - PHOTO_WIDTH, PHOTO_WIDTH, PHOTO_WIDTH)];
                [photoButton setBackgroundImage:[UIImage imageNamed:@"pic-bg7_2"] forState:UIControlStateNormal];
                if (0 == i) { //照相机按钮
                    [photoButton setBackgroundImage:[UIImage imageNamed:@"pic-ng7_2"] forState:UIControlStateNormal];
                    [photoButton setImage:[UIImage imageNamed:@"cameca7_2"] forState:UIControlStateNormal];
                    [photoButton addTarget:self action:@selector(takePhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [_firstCell addSubview:photoButton];
                } else {
                    if (0 != i) {
                        if (photoArray.count > 0) {
                            ALAsset *result = ((MyALAsset *)[photoArray objectAtIndexCheck:(i-1)]).asset;
                            UIImage *btnImage = [UIImage imageWithCGImage:result.thumbnail];
                            [photoButton setBackgroundImage:btnImage forState:UIControlStateNormal];
                            photoButton.tag = i-1;
                            //设置label
                            [self setImageLabel:photoButton];
                            [photoButton addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [_firstCell addSubview:photoButton];
                        }
                    }
                }
            }
            return _firstCell;
        }
            break;
        default:
        {
            if (photoArray.count > (buttonCountPerLine - 1)) {
                PublishStreetPhotoCell *publishStreetPhotoCell = [tableView dequeueReusableCellWithIdentifier:@"PublishStreetPhotoCell"];
                if (!publishStreetPhotoCell) {
                    publishStreetPhotoCell = [[[NSBundle mainBundle] loadNibNamed:@"PublishStreetPhotoCell" owner:self options:nil] lastObject];
                }
                //添加照片按钮
                CGSize size = [self getItemMarginWithScreen];
                //设置Cell高度
                CGRect cellFrame = publishStreetPhotoCell.frame;
                cellFrame.size.height = size.height;
                publishStreetPhotoCell.frame = cellFrame;
                //创建图片Button
                int buttonCountPerLine = [self getButtonCountPerLine];
                if (indexPath.row < (photoArray.count - (buttonCountPerLine - 1))/buttonCountPerLine + 1) {
                    for (int i=0; i<buttonCountPerLine; i++) {
                        MyButton *photoButton = [[MyButton alloc] initWithFrame:CGRectMake((PHOTO_WIDTH*i + size.width*(i+1)), size.height - PHOTO_WIDTH, PHOTO_WIDTH, PHOTO_WIDTH)];
                        [photoButton setBackgroundImage:[UIImage imageNamed:@"pic-bg7_2"] forState:UIControlStateNormal];
                        ALAsset *photoAsset = ((MyALAsset *)[photoArray objectAtIndexCheck:((buttonCountPerLine * indexPath.row - 1) + i)]).asset;
                        photoButton.tag = (buttonCountPerLine * indexPath.row - 1) + i;
                        //设置label
                        [self setImageLabel:photoButton];
                        [photoButton setBackgroundImage:[UIImage imageWithCGImage:photoAsset.thumbnail] forState:UIControlStateNormal];
                        [photoButton addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [publishStreetPhotoCell addSubview:photoButton];
                    }
                } else {
                    for (int i=0; i<(photoArray.count + 1 - indexPath.row*buttonCountPerLine); i++) {
                        MyButton *photoButton = [[MyButton alloc] initWithFrame:CGRectMake((PHOTO_WIDTH*i + size.width*(i+1)), size.height - PHOTO_WIDTH, PHOTO_WIDTH, PHOTO_WIDTH)];
                        [photoButton setBackgroundImage:[UIImage imageNamed:@"pic-bg7_2"] forState:UIControlStateNormal];
                        ALAsset *photoAsset = ((MyALAsset *)[photoArray objectAtIndexCheck:((buttonCountPerLine * indexPath.row - 1) + i)]).asset;
                        photoButton.tag = (buttonCountPerLine * indexPath.row - 1) + i;
                        //设置label
                        [self setImageLabel:photoButton];
                        [photoButton setBackgroundImage:[UIImage imageWithCGImage:photoAsset.thumbnail] forState:UIControlStateNormal];
                        [photoButton addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [publishStreetPhotoCell addSubview:photoButton];
                    }
                }
                return publishStreetPhotoCell;
            }
        }
            break;
    }
    return [[UITableViewCell alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [self getItemMarginWithScreen];
    return size.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int cout = [self getButtonCountPerLine];
    return ([photoArray count]/cout + 1);
}

-(void)reloadData
{
    [groupArray removeAllObjects];
    [photoArray removeAllObjects];

    //获取相册信息
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"相机胶卷"]) {
                [groupArray addObject:group];
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                            MyALAsset *myalAsset = [[MyALAsset alloc] init];
                            myalAsset.asset = result;
                            myalAsset.date = [result valueForProperty:ALAssetPropertyDate];
                            [photoArray addObject:myalAsset];
                        }
                    } else {
                        *stop = YES;
                        //对所有的图片按照创建时间排序
                        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
                        NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
                        NSArray *resultArray = [photoArray sortedArrayUsingDescriptors:sortDescriptors];
                        [photoArray removeAllObjects];
                        [photoArray addObjectsFromArray:resultArray];
                        
                        [_publishStreetPhotoTableView reloadData];
                    }
                }];
            }
        } else {
            *stop = YES;
            if (0 == groupArray.count) {
                [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    if (group) {
                        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"所有照片"]) {
                            [groupArray addObject:group];
                            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                if (result) {
                                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                                        MyALAsset *myalAsset = [[MyALAsset alloc] init];
                                        myalAsset.asset = result;
                                        myalAsset.date = [result valueForProperty:ALAssetPropertyDate];
                                        [photoArray addObject:myalAsset];
                                    }
                                } else {
                                    *stop = YES;
                                    //对所有的图片按照创建时间排序
                                    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
                                    NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
                                    NSArray *resultArray = [photoArray sortedArrayUsingDescriptors:sortDescriptors];
                                    [photoArray removeAllObjects];
                                    [photoArray addObjectsFromArray:resultArray];
                                    
                                    [_publishStreetPhotoTableView reloadData];
                                }
                            }];
                        }
                    } else {
                        *stop = YES;
                        if (0 == groupArray.count) {
                            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                if (group) {
                                    [groupArray addObject:group];
                                    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                        if (result) {
                                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                                                MyALAsset *myalAsset = [[MyALAsset alloc] init];
                                                myalAsset.asset = result;
                                                myalAsset.date = [result valueForProperty:ALAssetPropertyDate];
                                                [photoArray addObject:myalAsset];
                                            }
                                        } else {
                                            *stop = YES;
                                            //对所有的图片按照创建时间排序
                                            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
                                            NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
                                            NSArray *resultArray = [photoArray sortedArrayUsingDescriptors:sortDescriptors];
                                            [photoArray removeAllObjects];
                                            [photoArray addObjectsFromArray:resultArray];
                                            
                                            [_publishStreetPhotoTableView reloadData];
                                        }
                                    }];
                                } else {
                                    *stop = YES;
                                }
                            } failureBlock:^(NSError *error) {
                                DLog(@"没有找到图片分组.\n");
                            }];
                        }
                    }
                } failureBlock:^(NSError *error) {
                    DLog(@"没有找到图片分组.\n");
                }];
            }
        }
    } failureBlock:^(NSError *error) {
        DLog(@"没有找到图片分组.\n");
    }];
}

#pragma mark -按钮点击事件
//返回按钮点击事件
- (IBAction)backBtnClick:(id)sender {
    if (YES == _intoFlag) {
        UIViewController *rootVC = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
        
        TabBarController *mainTabVC;
        
        for (id viewController in rootVC.childViewControllers) {
            
            if ([viewController isKindOfClass:[TabBarController class]]) {
                
                mainTabVC = (TabBarController *)viewController;
                
            }
        }
        
        [mainTabVC setSelectedIndex:mainTabVC.intoStreetFlag];
        
//        [self.tabBarController setSelectedIndex:0];
        _photoIndex = 0;
        //清空图片数组
        [_selectPhotoArray removeAllObjects];
        [_labelArray removeAllObjects];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        //还原标签
        _labelArray = [orginLabelArray mutableCopy];
        for (UIViewController *viewCtrl in [self.navigationController viewControllers]) {
            if ([viewCtrl isKindOfClass:[TabBarController class]]) {
                TabBarController *tabBarCtrl = (TabBarController *)viewCtrl;
                PublishStreetPhotoViewController *streetPhotoViewCtrl = [[tabBarCtrl viewControllers] objectAtIndexCheck:2];
                streetPhotoViewCtrl.labelArray = [orginLabelArray mutableCopy];
            }
        }
        _selectPhotoArray = [orginSelectPhotoArray mutableCopy];
    }
}

//拍照按钮点击事件
- (void)takePhotoBtnClick:(id)sender {
    //判断照相机是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [CustomUtil showToastWithText:@"相机不可用" view:[UIApplication sharedApplication].keyWindow];
        return;
    }
    //自定义相机界面
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.showsCameraControls = NO;
    imagePicker.navigationBarHidden = YES;
    imagePicker.allowsEditing = YES;
//    imagePicker.cameraViewTransform = CGAffineTransformScale(imagePicker.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
    takePhotoViewCtrl = [[TakePhotosViewController alloc] initWithNibName:@"TakePhotosViewController" bundle:nil];
    imagePicker.cameraOverlayView = takePhotoViewCtrl.view;
//    CGRect rect = imagePicker.view.frame;
//    rect.origin.y = 0;
//    rect.size.width = SCREEN_WIDTH;
//    rect.size.height = SCREEN_HEIGHT;
//    imagePicker.view.frame = rect;
    takePhotoViewCtrl.imagePickerCtrl = imagePicker;
    //注册返回按钮事件
    [takePhotoViewCtrl.backBtn addTarget:self action:@selector(phontoBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //注册拍照按钮事件
    [takePhotoViewCtrl.capturePhotoBtn addTarget:self action:@selector(photoTakePhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //注册重拍按钮事件
    [takePhotoViewCtrl.reCaptureBtn addTarget:self action:@selector(reTakePhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //注册使用照片按钮事件
    [takePhotoViewCtrl.userPhotoBtn addTarget:self action:@selector(userPhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [takePhotoViewCtrl.reCaptureBtn setHidden:YES];
    [takePhotoViewCtrl.userPhotoBtn setHidden:YES];
    [self presentViewController:imagePicker animated:NO completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [takePhotoViewCtrl.reCaptureBtn setHidden:NO];
    [takePhotoViewCtrl.userPhotoBtn setHidden:NO];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    image = [CustomUtil normalizedImage:image];
    maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - imagePicker.toolbar.frame.size.height)];
    maskView.image = image;
    [imagePicker.view addSubview:maskView];
    [takePhotoViewCtrl.capturePhotoBtn setHidden:YES];
    captureImage = image;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [maskView removeFromSuperview];
    [takePhotoViewCtrl.capturePhotoBtn setHidden:NO];
}

//下一步按钮点击事件
- (IBAction)nextBtnClick:(id)sender {
    if (0 == _selectPhotoArray.count) {
        [CustomUtil showToastWithText:@"请选择照片" view:[UIApplication sharedApplication].keyWindow];
        return;
    }
    EditPhotoViewController *editPhotoViewCtrl = [[EditPhotoViewController alloc] initWithNibName:@"EditPhotoViewController" bundle:nil];
    editPhotoViewCtrl.intoFlag = YES;
    editPhotoViewCtrl.editImageArray = [NSMutableArray arrayWithArray:_selectPhotoArray];
    editPhotoViewCtrl.photo1LabelCoordinateArray = [NSMutableArray arrayWithArray:_photo1LabelArray];
    editPhotoViewCtrl.photo2LabelCoordinateArray = [NSMutableArray arrayWithArray:_photo2LabelArray];
    editPhotoViewCtrl.photo3LabelCoordinateArray = [NSMutableArray arrayWithArray:_photo3LabelArray];
    editPhotoViewCtrl.photo4LabelCoordinateArray = [NSMutableArray arrayWithArray:_photo4LabelArray];
    [self.navigationController pushViewController:editPhotoViewCtrl animated:YES];
}

//照片按钮点击事件
-(void)photoBtnClick:(id)sender
{
    MyButton *button = (MyButton *)sender;
    //取消右上角的imageView
    for (UIView *view in button.subviews) {
        if ([view isKindOfClass:[UIImageView class]] &&
            (((UIImageView*)view).frame.origin.x == 46)) {
            [view removeFromSuperview];
            UIImageView *imageView = (UIImageView *)view;
            NSInteger labelTextIntValue = 0;
            for (UIView *subView in imageView.subviews) {
                if ([subView isKindOfClass:[MyLabel class]]) {
                    MyLabel *subLabel = (MyLabel *)subView;
                    labelTextIntValue = subLabel.labelNum;
                    //移除选中的图片
                    [_selectPhotoArray removeObjectAtIndex:(subLabel.labelNum - 1)];
                    [_labelArray removeObject:subLabel];
                    _photoIndex--;
                }
            }
            //调整图片下标显示数字
            for (MyLabel *label in _labelArray) {
                if ((label.labelNum > 1) &&
                    (label.labelNum > labelTextIntValue)) {
                    [label setText:[NSString stringWithFormat:@"%ld", label.labelNum - 1]];
                    label.labelNum--;
                }
            }
            [_nextButton setTitle:_selectPhotoArray.count==0 ? @"确认" : [NSString stringWithFormat:@"确认(%d)", (int)_selectPhotoArray.count] forState:UIControlStateNormal];

            return;
        }
    }
    
    //判断是否已选择了四张图片
    if (4 == _selectPhotoArray.count) {
        [CustomUtil showToastWithText:@"最多可选择四张照片" view:[UIApplication sharedApplication].keyWindow];
        return;
    }
    //右上角添加imageView
    UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 6, 18, 18)];
    [checkImageView setImage:[UIImage imageNamed:@"selectOk7_2"]];
    MyLabel *checkNumLabel = [[MyLabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [checkNumLabel setTextColor:[UIColor whiteColor]];
    [checkNumLabel setFont:[UIFont systemFontOfSize:11.0f]];
    checkNumLabel.text = [NSString stringWithFormat:@"%ld", _photoIndex + 1];
    checkNumLabel.tag = button.tag;
    DLog(@"button.tag = %ld", button.tag);
    DLog(@"checkNumLabel.tag = %ld", checkNumLabel.tag);
    checkNumLabel.labelNum = _photoIndex + 1;
    _photoIndex++;
    [_labelArray addObject:checkNumLabel];
    [checkNumLabel setTextAlignment:NSTextAlignmentCenter];
    [checkImageView addSubview:checkNumLabel];
    [checkNumLabel setCenter:CGPointMake(18/2, 18/2)];
    [_imageViewArray addObject:checkImageView];
    [button addSubview:checkImageView];
    
    //将选中的图片添加进数组
    [_selectPhotoArray addObject:((MyALAsset *)[photoArray objectAtIndexCheck:button.tag]).asset];
    
    [_nextButton setTitle:_selectPhotoArray.count==0 ? @"确认" : [NSString stringWithFormat:@"确认(%d)", (int)_selectPhotoArray.count] forState:UIControlStateNormal];
}

//拍照画面按钮的点击事件
#pragma mark -按钮点击事件处理
//返回按钮点击事件
- (void)phontoBackBtnClick:(id)sender {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

//重拍按钮点击事件处理
- (void)reTakePhotoBtnClick:(id)sender {
    [imagePicker.delegate imagePickerControllerDidCancel:imagePicker];
}

//使用照片按钮点击事件处理
- (void)userPhotoBtnClick:(id)sender {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    //保存至相册
    if (!library) {
        library = [CustomUtil defaultAssetsLibrary];
    }
    __block ALAsset *captureAsset = [[ALAsset alloc] init];
    [library writeImageToSavedPhotosAlbum:[captureImage CGImage] orientation:(ALAssetOrientation)captureImage.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            [CustomUtil showToastWithText:error.description view:self.view];
        } else {
            //获取相册中的照片
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                captureAsset = asset;
                //跳转至编辑页面
                EditPhotoViewController *editPhotoViewCtrl = [[EditPhotoViewController alloc] initWithNibName:@"EditPhotoViewController" bundle:nil];
                editPhotoViewCtrl.intoFlag = YES;
                NSMutableArray *copySelectPhotoArray = [_selectPhotoArray mutableCopy];
                [copySelectPhotoArray addObject:captureAsset];
                editPhotoViewCtrl.editImageArray = [NSMutableArray arrayWithArray:copySelectPhotoArray];
                editPhotoViewCtrl.photo1LabelCoordinateArray = [NSMutableArray arrayWithArray:_photo1LabelArray];
                editPhotoViewCtrl.photo2LabelCoordinateArray = [NSMutableArray arrayWithArray:_photo2LabelArray];
                editPhotoViewCtrl.photo3LabelCoordinateArray = [NSMutableArray arrayWithArray:_photo3LabelArray];
                editPhotoViewCtrl.photo4LabelCoordinateArray = [NSMutableArray arrayWithArray:_photo4LabelArray];
                [self.navigationController pushViewController:editPhotoViewCtrl animated:YES];
            } failureBlock:^(NSError *error) {
                [CustomUtil showToastWithText:error.description view:self.view];
            }];
        }
    }];
}

//拍照按钮点击事件
- (void)photoTakePhotoBtnClick:(id)sender {
    [imagePicker takePicture];
}

#pragma mark -共通方法
//获取照片的X偏移量及Cell调整后的高度
-(CGSize)getItemMarginWithScreen
{
    CGSize size = CGSizeZero;
    
    int displayPhotoCount = 0; //每行显示的图片数量
    switch ((int)SCREEN_WIDTH) {
        case 320:
            displayPhotoCount = 4;
            break;
        default:
            displayPhotoCount = 5;
            break;
    }
    
    size.width = (SCREEN_WIDTH - PHOTO_WIDTH * displayPhotoCount)/(displayPhotoCount + 1);
    size.height = size.width + PHOTO_WIDTH;
    
    return size;
}

//获取所要显示的照片按钮数量(一行）
-(int)getButtonCountPerLine
{
    int buttonCount = 0;
    switch ((int)SCREEN_WIDTH) {
        case 320:
            buttonCount = 4;
            break;
        default:
            buttonCount = 5;
            break;
    }
    
    return buttonCount;
}

//设置图片右上角的标签
-(void)setImageLabel:(MyButton *)button
{
    for (int i=0; i<_labelArray.count; i++) {
        MyLabel *label = (MyLabel *)[_labelArray objectAtIndexCheck:i];
        if (label.tag == button.tag) {
            //右上角添加imageView
            UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 6, 18, 18)];
            [checkImageView setImage:[UIImage imageNamed:@"selectOk7_2"]];
            label.text = [NSString stringWithFormat:@"%ld", label.labelNum];
            [checkImageView addSubview:label];
            [button addSubview:checkImageView];
        }
    }
}

@end

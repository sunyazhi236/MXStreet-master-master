//
//  GotoPhotoVC.m
//  mxj
//
//  Created by MQ-MacBook on 16/5/15.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import "GotoPhotoVC.h"
#import "Macro.h"
#import <AVFoundation/AVFoundation.h>

const NSInteger kToosViewHeight = 70;
#define CIRCLE CGRectMake(50, 130, SCREENWIDTH - 100, SCREENWIDTH - 100)
#define PHOTOSVIEWTOPMARGIN     45
#define PHOTOSVIEWUNDERMARGIN   50

@interface GotoPhotoVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>
{
    UIImagePickerController *imagePickerCtrl; //照片及相册控件
    NSString                *personImagePath; //个人头像本地路径
}

@property (nonatomic, strong)   UIButton                *goCamera;
@property (nonatomic, strong)   UIButton                *goPhoto;
@property (nonatomic, strong)   UIButton                *cancel;
@property (nonatomic, strong)   UIView                  *toolsView;
@property (nonatomic, strong)   UIScrollView            *paintView;
@property (nonatomic, strong)   UIImageView             *editPhotoView;
@property (nonatomic, strong)   UIImage                 *image;

@end

@implementation GotoPhotoVC

#pragma viewLife
-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self initView];
}

#pragma initView
-(void)initView{
    
    _goCamera = [[UIButton alloc] initWithFrame:CGRectMake(0, MainViewHeight - 122, SCREENWIDTH, 40.5)];
    [_goCamera setTitle:@"拍照" forState:UIControlStateNormal];
    _goCamera.backgroundColor = [UIColor colorWithRed:204.0/255 green:48.0/255 blue:49.0/255 alpha:1.0f];
    _goCamera.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_goCamera addTarget:self action:@selector(cameraOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_goCamera];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MainViewHeight - 82, SCREENWIDTH, 1)];
//    lineView.backgroundColor = [UIColor whiteColor];
//    [_goCamera addSubview:lineView];
    
    _goPhoto = [[UIButton alloc] initWithFrame:CGRectMake(0, MainViewHeight - 81, SCREENWIDTH, 40.5)];
    [_goPhoto setTitle:@"从手机相册选择" forState:UIControlStateNormal];
    _goPhoto.backgroundColor = [UIColor colorWithRed:204.0/255 green:48.0/255 blue:49.0/255 alpha:1.0f];
    _goPhoto.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_goPhoto addTarget:self action:@selector(photoOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_goPhoto];
    
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, MainViewHeight - 41, SCREENWIDTH, 1)];
//    lineView1.backgroundColor = [UIColor whiteColor];
//    [_goPhoto addSubview:lineView1];
    
    _cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, MainViewHeight - 40, SCREENWIDTH, 40)];
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    _cancel.backgroundColor = [UIColor blackColor];
    _cancel.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_cancel addTarget:self action:@selector(cancelOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel];
}

- (void)initMainView:editImage{
    _paintView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kToosViewHeight)];
    [_paintView setAlwaysBounceVertical:YES];
    [_paintView setAlwaysBounceHorizontal:YES];
    _paintView.delegate = self;
    [self.view addSubview:_paintView];
    
    _editPhotoView = [[UIImageView alloc] initWithFrame:_paintView.frame];
    _editPhotoView.image = editImage;
    [_paintView addSubview:_editPhotoView];
    [self adjustFrame];
    
}

- (void)adjustFrame
{
    if (_editPhotoView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = _paintView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height - PHOTOSVIEWTOPMARGIN - PHOTOSVIEWUNDERMARGIN - 20;
    
    CGSize imageSize = _editPhotoView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat widthRatio = boundsWidth/imageWidth;
    CGFloat heightRatio = boundsHeight/imageHeight;
    CGFloat minScale = MAX(widthRatio, heightRatio);
    
    CGFloat maxScale = 3.0;
    
    _paintView.maximumZoomScale = maxScale;
    _paintView.minimumZoomScale = minScale;
    _paintView.zoomScale = minScale;
    
    //    [self centerScrollViewContents];
    
    CGRect imageFrame = CGRectMake(0, PHOTOSVIEWTOPMARGIN + 20, imageWidth * minScale, imageHeight * minScale);
    // 内容尺寸
    //    self.contentSize = imageFrame.size;
    _paintView.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // x,y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
    }
    if (imageFrame.size.width < boundsWidth){
        imageFrame.origin.x = floorf((boundsWidth - imageFrame.size.width) / 2.0);
    }
    
    _editPhotoView.frame = imageFrame;
    
}


- (void)initShadowView {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageV.image = [self getImage];
    imageV.alpha = 0.6;
    [self.view addSubview:imageV];
}

-(UIImage *)getImage{
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 1.0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(con, [UIColor blackColor].CGColor);
    CGContextFillRect(con, [UIScreen mainScreen].bounds);
//    CGContextAddEllipseInRect(con, CGRectMake(50, 100, SCREENWIDTH - 100, SCREENWIDTH - 100));
    CGContextAddEllipseInRect(con, CIRCLE);
    CGContextSetBlendMode(con, kCGBlendModeClear);
    CGContextFillPath(con);
    UIImage *ima = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return ima;
}

- (void)initToolsView {
    
    _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, MainViewHeight - kToosViewHeight, SCREENWIDTH, kToosViewHeight)];
    _toolsView.backgroundColor = [UIColor blackColor];
    [_toolsView setAlpha:0.5];
    [self.view addSubview:_toolsView];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"使用图片" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor colorWithHexString:@"#676767"] forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(SCREENWIDTH - 100 - 15, 10, 100, 50);
    editBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [editBtn addTarget:self action:@selector(editBtnClickOn:) forControlEvents:UIControlEventTouchUpInside];
    [_toolsView addSubview:editBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(15, 10, 100, 50);
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBtn addTarget:self action:@selector(cancelBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolsView addSubview:cancelBtn];
}

- (UIImage *)Capture {
    UIGraphicsBeginImageContext(_paintView.frame.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    
    [_paintView.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    CGRect rect = CGRectMake(50, (GetHeight(_editPhotoView) - (SCREENWIDTH - 100) + 100) / 2, SCREENWIDTH - 100, SCREENWIDTH - 100); //创建矩形框

    UIImage *cropped = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];

    return cropped;
}

#pragma Action
//去相机
-(void)cameraOnClick{
    [self hiddenButton];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        }
//    sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;//设置可编辑   
//    picker.showsCameraControls = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
}

//去相册
-(void)photoOnClick{
    [self hiddenButton];
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

//相机相册取消
-(void)cancelOnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//隐藏相机等按钮
-(void)hiddenButton{
    _goCamera.hidden = YES;
    _goPhoto.hidden = YES;
    _cancel.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
}

//显示相机等按钮
-(void)displayButton{
    _goCamera.hidden = NO;
    _goPhoto.hidden = NO;
    _cancel.hidden = NO;
    self.view.backgroundColor = [UIColor clearColor];
}

//截图取消
- (void)cancelBtnDidClick:(id)sender {
    
//    [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
}

//截图确定
- (void)editBtnClickOn:(id)sender
{
//    if (_image && [_delegate respondsToSelector:@selector(shotImageSuccese:)]) {
//        [_delegate shotImageSuccese:_image];
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    //保存图片到沙盒
    [CustomUtil saveHeadImageToSandBox:[self Capture] fileName:@"registerUser.jpg" block:^(UIImage *sandBoxImage, NSString *filePath) {
        personImagePath = filePath;
        [RegisterInput shareInstance].image = personImagePath;
        //设置个人头像
        if([_photoDelegate respondsToSelector:@selector(setImage:)])
        {
            //send the delegate function with the amount entered by the user
            [self dismissViewControllerAnimated:YES completion:nil];
            [_photoDelegate setImage:sandBoxImage];
        }
    }];
    
    
}

#pragma mark - 图片回调代理
//相机相册代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.view.backgroundColor = [UIColor blackColor];
    _image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //初始化编辑
    [self initMainView:_image];
    [self initShadowView];
    [self initToolsView];
}

//相机相册取消代理
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _editPhotoView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents
{
    CGSize boundsSize = _paintView.bounds.size;
    CGRect contentsFrame = _editPhotoView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    _editPhotoView.frame = contentsFrame;
}

@end

//
//  EditImageViewController.m
//  ImageFilter
//
//  Created by shanpengtao on 16/5/16.
//  Copyright (c) 2016年 shanpengtao. All rights reserved.
//

#import "EditImageViewController.h"
#import "ImageFilterItem.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import <Photos/Photos.h>
#import "ALAssetsLibrary+GetTheLastImage.h"

@interface EditImageViewController ()

@property(strong, nonatomic) ImageFilterItem *item;

@end

@implementation EditImageViewController

- (instancetype)initWithImage:(UIImage *)aImage
{
    self = [super init];
    if (self) {
        _image = aImage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"选择滤镜";
    
//    [self.navigationController setNavigationBarHidden:YES];

    //设置导航栏左侧返回按钮-设置文字
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头-通用2"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    [backButtonItem setTintColor:[UIColor lightGrayColor]];
    //设置返回按钮的图片
    self.navigationItem.leftBarButtonItem = backButtonItem;

    self.navigationItem.backBarButtonItem = nil;
    
    //设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    //设置标题栏文字颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    [self initView];
}

- (void)initView {
    
    if (!_image) {
        return;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"edittpsave"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(savePicture) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    [self.view addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - FILTERIMAGE_HEIGHT - 2 * FILTERIMAGE_Y_OFFSET, self.view.bounds.size.width, FILTERIMAGE_HEIGHT + 2 * FILTERIMAGE_Y_OFFSET)];
    _scrollView.contentSize = CGSizeMake((FILTERIMAGE_WIDTH + 10) * self.effectImages.count + 10, _scrollView.frame.size.height);
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view addSubview:_scrollView];
    
    _iconImageView = [[UIImageView alloc] initWithImage:_image];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.userInteractionEnabled = YES;
    [self.view addSubview:_iconImageView];
    
    // 基本尺寸参数
    CGSize boundsSize = self.view.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height - 64 - FILTERIMAGE_HEIGHT - 2 * FILTERIMAGE_Y_OFFSET;
    
    CGSize imageSize = _iconImageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat widthRatio = boundsWidth/imageWidth;
    CGFloat heightRatio = boundsHeight/imageHeight;
    CGFloat minScale = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    
    CGRect imageFrame = CGRectMake(0, 64, imageWidth * minScale, imageHeight * minScale);
    // 内容尺寸
    
    // x,y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y += floorf((boundsHeight - imageFrame.size.height) / 2.0);
    }
    if (imageFrame.size.width < boundsWidth){
        imageFrame.origin.x = floorf((boundsWidth - imageFrame.size.width) / 2.0);
    }
    
    _iconImageView.frame = imageFrame;
    
    
    NSArray *imageNames = [NSArray arrayWithObjects:@"原始",@"lomo",@"黑白",@"怀旧",@"哥特",@"淡雅",@"酒红",@"清宁",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色", nil];
    for (int i = 0; i < self.effectImages.count; i++) {
        _item = [[ImageFilterItem alloc] init];
        _item.select = NO;
        if (i == 0) {
            _item.select = YES;
        }
        _item.frame = CGRectMake(i * (FILTERIMAGE_WIDTH + 10) + 10, FILTERIMAGE_Y_OFFSET, _item.frame.size.width, _item.frame.size.height);
        _item.icon.image = self.effectImages[i];
        _item.tag = i + 100;
        _item.titleLabel.text = imageNames[i];
        __weak typeof(self) weakSelf = self;
        _item.iconClick = ^(ImageFilterItem *item){
            for (int i = 0; i < imageNames.count; i++) {
                ImageFilterItem *itemView = (ImageFilterItem *)[weakSelf.scrollView viewWithTag:i + 100];
                itemView.select = NO;
            }
            item.select = YES;
            
            weakSelf.iconImageView.image = weakSelf.effectImages[i];
        };
        [_scrollView addSubview:_item];
    }
}

// 原始,lomo,黑白,怀旧,哥特,淡雅,酒红,清宁,浪漫,光晕,蓝调,梦幻,夜色
- (NSArray *)effectImages {
    if(!_effectImages) {
        _effectImages = @[self.image,
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_lomo],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_heibai],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_huaijiu],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_gete],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_danya],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_jiuhong],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_qingning],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_langman],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_guangyun],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_landiao],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_menghuan],
                          [ImageUtil imageWithImage:self.image withColorMatrix:colormatrix_yese]];
    }
    return _effectImages;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)savePicture {
    
    UIImageWriteToSavedPhotosAlbum(_iconImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"存储结束！");
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }
    else {
//        PHFetchOptions *options = [[PHFetchOptions alloc] init];
//        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
//        ALAsset *asset = [assetsFetchResults firstObject];
        
        [[CustomUtil defaultAssetsLibrary] latestAsset:^(ALAsset * _Nullable asset, NSError * _Nullable error) {
            if ([_delegate respondsToSelector:@selector(editImageSuccese:)] && asset) {
                [_delegate editImageSuccese:asset];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }

}
@end

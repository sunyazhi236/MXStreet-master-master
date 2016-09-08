//
//  PPEditDynamicMainView.m
//  peipei
//
//  Created by thinker on 3/24/16.
//  Copyright © 2016 com.58. All rights reserved.
//

#import "PPEditDynamicMainView.h"

#define PHOTOSVIEWTOPMARGIN     45
#define PHOTOSVIEWUNDERMARGIN   50

@interface PPEditDynamicMainView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *editPhotoView;

@end

@implementation PPEditDynamicMainView

- (instancetype)initWithFrame:(CGRect)frame editImage:(UIImage *)editImage {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setAlwaysBounceVertical:YES];
        [self setAlwaysBounceHorizontal:YES];
//        [self setMaximumZoomScale:3.0];
//        [self setMinimumZoomScale:1.0];
        self.delegate = self;
        
        [self p_initEditImageViewWithEditImage:editImage];
    }
    
    return self;
}

- (void)p_initEditImageViewWithEditImage:(UIImage *)editImage {
    
//    _editPhotoView = [[UIImageView alloc] initWithFrame:self.frame];
//    _editPhotoView = [[UIImageView alloc] initWithImage:editImage];
    _editPhotoView = [[UIImageView alloc] init];
    _editPhotoView.image = editImage;
//    [_editPhotoView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_editPhotoView];
    [self p_adjustFrame];
}



#pragma mark 调整frame
- (void)p_adjustFrame
{
    if (_editPhotoView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height - PHOTOSVIEWTOPMARGIN - PHOTOSVIEWUNDERMARGIN - 20;
    
    CGSize imageSize = _editPhotoView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    CGFloat widthRatio = boundsWidth/imageWidth;
    CGFloat heightRatio = boundsHeight/imageHeight;
    CGFloat minScale = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    
    CGFloat maxScale = 3.0;
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    //    [self centerScrollViewContents];
    
    CGRect imageFrame = CGRectMake(0, PHOTOSVIEWTOPMARGIN + 20, imageWidth * minScale, imageHeight * minScale);
    // 内容尺寸
    //    self.contentSize = imageFrame.size;
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // x,y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y += floorf((boundsHeight - imageFrame.size.height) / 2.0);
    }
    if (imageFrame.size.width < boundsWidth){
        imageFrame.origin.x = floorf((boundsWidth - imageFrame.size.width) / 2.0);
    }
    
    _editPhotoView.frame = imageFrame;
    
}
#pragma mark - UIScrollViewDelegate
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
    CGSize boundsSize = self.bounds.size;
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

//
//  EditImageViewController.h
//  ImageFilter
//
//  Created by shanpengtao on 16/5/16.
//  Copyright (c) 2016年 shanpengtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditImageDelegate <NSObject>

@optional

- (void)editImageSuccese:(ALAsset *)aALAsset;

@end

@interface EditImageViewController : UIViewController

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *effectImages;

@property (nonatomic, weak) id <EditImageDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)aImage;

@end

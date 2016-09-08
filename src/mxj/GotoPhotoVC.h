//
//  GotoPhotoVC.h
//  mxj
//
//  Created by MQ-MacBook on 16/5/15.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GotoPhotoDelegate <NSObject>

- (void)setImage:(UIImage *)setImage;

@end

@interface GotoPhotoVC : UIViewController

@property (assign, nonatomic) id<GotoPhotoDelegate> photoDelegate;

@end

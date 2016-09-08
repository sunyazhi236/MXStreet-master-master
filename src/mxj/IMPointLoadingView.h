//
//  IMPointLoadingView.h
//  imbangbang
//
//  Created by 赵露 on 15/6/1.
//  Copyright (c) 2015年 com.58. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMPointLoadingView : UIView

+ (IMPointLoadingView *)viewWithPointLoading;

- (void)startAnimating;
- (void)stopAnimating;

@end

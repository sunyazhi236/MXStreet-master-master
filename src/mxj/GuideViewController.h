//
//  GuideViewController.h
//  mxj
//  P2引导页
//  Created by 齐乐乐 on 15/11/20.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface GuideViewController : BaseViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *guideScrollView; //引导ScrollView
@property (strong, nonatomic) IBOutlet UIPageControl *guidePageCtrl;  //页面指示器

@end

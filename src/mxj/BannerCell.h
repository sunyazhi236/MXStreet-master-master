//
//  BannerCell.h
//  mxj
//  广告轮播用Cell
//  Created by 齐乐乐 on 15/11/26.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *bannerScrollView; //广告ScrollView
@property (weak, nonatomic) IBOutlet UIPageControl *bannerPageCtrl; //广告PageController

@end

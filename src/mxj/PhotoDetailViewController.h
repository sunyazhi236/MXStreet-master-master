//
//  PhotoDetailViewController.h
//  mxj
//  P7-4-1照片详情
//  Created by 齐乐乐 on 15/11/19.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseViewController.h"

@interface PhotoDetailViewController : BaseViewController<UIScrollViewDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *phontoDetailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *currentPageNum;  //当前页码
@property (weak, nonatomic) IBOutlet UILabel *totalPageNum;    //图片总数
@property (weak, nonatomic) IBOutlet UILabel *spliteText;      //分割文字
@property (weak, nonatomic) IBOutlet UIImageView *pageBackImage; //页码背景
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;           //赞按钮
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;      //下载按钮
@property (weak, nonatomic) IBOutlet UIImageView *footImage;     //底部灰色区域

@property (nonatomic, copy) NSDictionary *streetsnapInfo;        //街拍信息
@property (nonatomic, copy) NSMutableArray *tagInfoArray;        //标签信息
@property (weak, nonatomic) IBOutlet UIImageView *backImageView; //背景图片
@property (nonatomic, assign) int currentPageIndex; //从街拍详情点击进入照片详情时的页面号

- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center;

@end

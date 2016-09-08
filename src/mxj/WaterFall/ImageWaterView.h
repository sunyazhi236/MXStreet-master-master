//
//  ImageWaterView.h
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//
/*
思路：在scrollview上面放三个UIView代表每一个列，
     然后在每个UIview上添加图片，每次都是挑最短的UIView把图片添加上去；
 */
#import <UIKit/UIKit.h>
#import "SelfImageVIew.h"
#define CELL_COUNT 2 //列数

@protocol imageViewClickDelegate <NSObject>
//图片点击事件处理
- (void)imageViewClick:(ImageInfo *)imageInfo;

@optional
// 图片双击处理
- (void)imageViewDoubleClick:(ImageInfo *)imageInfo;

@end

@interface ImageWaterView : UIScrollView<ImageDelegate>
{
    //第一列,第二列
    UIView *firstView,*secondView;
    //最高列，最低列,行数
    int higher,lower,row;
    //最高列高度
    float highValue;
    //记录多少图片
    int countImage;
}
//图像对象数组
@property (nonatomic,strong)NSArray *arrayImage;
@property (nonatomic,strong)id<imageViewClickDelegate> imageViewClickDelegate;
@property (nonatomic,strong)UIView *firstView;
@property (nonatomic,strong)UIView *secondView;

//初始化瀑布流，array图片对象数组
-(id)initWithDataArray:(NSArray*)array withFrame:(CGRect)rect intoFlag:(int)intoFlag;
//刷新瀑布流
-(void)refreshView:(NSArray*)array intoFlag:(int)intoFlag;
//加载下一页瀑布流
-(void)loadNextPage:(NSArray*)array intoFlag:(int)intoFlag;

@end

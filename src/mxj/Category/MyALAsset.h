//
//  MyALAsset.h
//  mxj
//
//  Created by 齐乐乐 on 16/1/24.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface MyALAsset : NSObject

@property (nonatomic, strong) ALAsset *asset; //图片实例
@property (nonatomic, strong) NSString *date; //照片的日期

@end

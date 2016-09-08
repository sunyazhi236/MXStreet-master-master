//
//  ALAssetsLibrary+GetTheLastImage.h
//  mxj
//
//  Created by shanpengtao on 16/5/28.
//  Copyright © 2016年 bluemobi. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (GetTheLastImage)

- (void)latestAsset:(void(^_Nullable)(ALAsset * _Nullable asset,NSError *_Nullable error)) block;

@end

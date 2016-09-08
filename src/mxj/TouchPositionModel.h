//
//  TouchPositionModel.h
//  mxj
//  图片点击坐标模型
//  Created by 齐乐乐 on 15/12/9.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchPositionModel : NSObject

@property (nonatomic, copy) NSString *tagId;      //标签Id
@property (nonatomic, copy) NSString *horizontal; //横坐标
@property (nonatomic, copy) NSString *vertical;   //纵坐标
@property (nonatomic, copy) NSString *labelName;  //标签名称
@property (nonatomic, copy) NSString *link;       //链接地址
@property (nonatomic, copy) NSString *changeHorizontal; //变换横坐标
@property (nonatomic, copy) NSString *changeVertical;   //变换纵坐标

@end

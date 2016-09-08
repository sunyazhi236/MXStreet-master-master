//
//  PublishPraiseInput.h
//  mxj
//  点赞
//  Created by 齐乐乐 on 15/12/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface PublishPraiseInput : BaseInput

@property(nonatomic, copy) NSString *streetsnapId;	    //街拍Id
@property(nonatomic, copy) NSString *streetsnapUserId;	//街拍用户Id
@property(nonatomic, copy) NSString *userId;            //用户Id
@property(nonatomic, copy) NSString *flag;	            //标识(0:点赞,1:取消赞)

+(instancetype)shareInstance;

@end

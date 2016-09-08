//
//  PublishCommentInput.h
//  mxj
//  发表评论
//  Created by 齐乐乐 on 15/12/3.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface PublishCommentInput : BaseInput

@property(nonatomic, copy) NSString *streetsnapId;    //街拍Id
@property(nonatomic, copy) NSString *commentContent;  //评论内容
@property(nonatomic, copy) NSString *userId;          //用户Id
@property(nonatomic, copy) NSString *replyId;         //回复Id

+(instancetype)shareInstance;

@end

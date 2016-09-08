//
//  DeleteCommentInput.h
//  mxj
//  删除评论
//  Created by 齐乐乐 on 15/12/11.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import "BaseInput.h"

@interface DeleteCommentInput : BaseInput

@property(nonatomic, copy) NSString *commentId;         //评论Id
@property(nonatomic, copy) NSString *streetsnapUserId;  //街拍用户Id

+(instancetype)shareInstance;

@end

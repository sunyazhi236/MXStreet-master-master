//
//  TKAddressBook.h
//  mxj
//  通讯录模型
//  Created by 齐乐乐 on 15/12/14.
//  Copyright © 2015年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKAddressBook : NSObject

@property NSInteger sectionNumber;
@property NSInteger recordID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *tel;

@end

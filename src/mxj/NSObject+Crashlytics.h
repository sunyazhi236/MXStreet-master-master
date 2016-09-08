//
//  NSObject+Crashlytics.h
//  xmj
//
//  Created by shanpengtao on 16-5-11.
//

#import <Foundation/Foundation.h>

@interface NSObject(Crashlytics)

//crashlytics添加附加信息，帮助解决线上crash，目前增加uid(id)和clsn(class name),opt(oprate time)
- (void)addCrashUserInfo;

@end

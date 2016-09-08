//
//  NSObject+Crashlytics.m
//  xmj
//
//  Created by shanpengtao on 16-5-11.
//

#import "NSObject+Crashlytics.h"
#import <Bugly/Bugly.h>

#define IM_CRASHLYTICS_CUSTOMKEY_CLASSNAME  @"vc"
#define IM_CRASHLYTICS_CUSTOMKEY_OPRATETIME @"opttime"
#define IM_CRASHLYTICS_CUSTOMKEY_USERID     @"uid"

@implementation NSObject(Crashlytics)

- (void)addCrashUserInfo
{
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [LoginModel shareInstance].userId ? [LoginModel shareInstance].userId : @""]];
    
    const char * clsn = object_getClassName(self);
    if (clsn) {
        NSString *clsName = [NSString stringWithUTF8String:clsn];
        if (clsName) {
            
            [Bugly setUserValue:clsName forKey:IM_CRASHLYTICS_CUSTOMKEY_CLASSNAME];
        }
    }
}

@end

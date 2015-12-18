//
//  NSObject+LSSwizzle.m
//  LSLog-XCode
//
//  Created by lslin on 15/12/11.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import "NSObject+LSSwizzle.h"

#import <objc/runtime.h>

@implementation NSObject (LSSwizzle)

+ (BOOL)ls_swizzleOriginalMethod:(SEL)origSel withAltMethod:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    if (!origMethod) {
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel), class_getInstanceMethod(self, altSel));
    return YES;
}

+ (IMP)ls_replaceOriginalClass:(Class)origClass withAltClass:(Class)altClass method:(SEL)sel {
    Method oldMethod = class_getInstanceMethod(origClass, sel);
    IMP oldIMP = method_getImplementation(oldMethod);
    IMP newIMP = class_getMethodImplementation(altClass, sel);
    method_setImplementation(oldMethod, newIMP);
    return oldIMP;
}

@end

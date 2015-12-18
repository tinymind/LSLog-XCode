//
//  NSObject+LSSwizzle.h
//  LSLog-XCode
//
//  Created by lslin on 15/12/11.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

IMP ls_replaceOriginalClassMethod(Class origClass, Class altClass, SEL sel);

@interface NSObject (LSSwizzle)

+ (BOOL)ls_swizzleOriginalMethod:(SEL)origSel withAltMethod:(SEL)altSel;
+ (IMP)ls_replaceOriginalClass:(Class)origClass withAltClass:(Class)altClass method:(SEL)sel;

@end

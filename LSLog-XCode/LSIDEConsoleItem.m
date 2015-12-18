//
//  LSIDEConsoleItem.m
//  LSLog-XCode
//
//  Created by lslin on 15/12/11.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import "LSIDEConsoleItem.h"
#import "LSLog.h"
#import "LSLogSettings.h"
#import "NSObject+LSLog.h"

@implementation LSIDEConsoleItem

- (id)initWithAdaptorType:(id)arg1 content:(id)arg2 kind:(int)arg3 {
    id item = LSLog.originalConsoleItemInitIMP(self, _cmd, arg1, arg2, arg3);
    if (![LSLog hasXcodeColorsInstalled]) {
        [self ls_updateItemAttribute:item];
    }
    return item;
}

@end

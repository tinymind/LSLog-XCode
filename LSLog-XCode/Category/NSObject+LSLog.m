//
//  NSObject+LSLog.m
//  LSLog-XCode
//
//  Created by lslin on 15/12/10.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//


#import "NSObject+LSLog.h"
#import "LSLog.h"
#import "LSLogSettings.h"
#import "LSIDEConsoleArea.h"

#import <objc/runtime.h>

static const void *kLSIDEConsoleTextViewKey;
static const void *kLSIDEConsoleAreaKey;
static const void *kLSLogLevelKey;

@implementation NSObject (LSLog)


+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        [LSLog sharedPlugin];
    }
}

- (void)setConsoleTextView:(NSTextView *)consoleTextView
{
    objc_setAssociatedObject(self, &kLSIDEConsoleTextViewKey, consoleTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTextView *)consoleTextView
{
    return objc_getAssociatedObject(self, &kLSIDEConsoleTextViewKey);
}

- (void)setConsoleArea:(LSIDEConsoleArea *)consoleArea
{
    objc_setAssociatedObject(self, &kLSIDEConsoleAreaKey, consoleArea, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LSIDEConsoleArea *)consoleArea
{
    return objc_getAssociatedObject(self, &kLSIDEConsoleAreaKey);
}

- (void)setLogLevel:(NSUInteger)loglevel
{
    objc_setAssociatedObject(self, &kLSLogLevelKey, @(loglevel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)logLevel
{
    return [objc_getAssociatedObject(self, &kLSLogLevelKey) unsignedIntegerValue];
}

- (NSSearchField *)ls_getFilterField {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (![self respondsToSelector:@selector(scopeBarView)]) {
        return nil;
    }
    
    NSView *scopeBarView = [self performSelector:@selector(scopeBarView) withObject:nil];
    return [scopeBarView viewWithTag:LSLogViewTagFilterField];
#pragma clang diagnositc pop
}

- (void)ls_updateItemAttribute:(id)item {
    if (![LSLogSettings defaultSettings].enableColoring) {
        return;
    }
    
    NSString *logText = [item valueForKey:@"content"];
    if (!logText.length) {
        return;
    }
    
    if ([[item valueForKey:@"error"] boolValue] || [logText hasPrefix:@"error"]) {
        logText = [self formatStringWithString:logText fgColor:[LSLogSettings defaultSettings].fgColorError];
        [item setValue:logText forKey:@"content"];
        return;
    }
    
    if (![[item valueForKey:@"output"] boolValue] || [[item valueForKey:@"outputRequestedByUser"] boolValue]) {
        return;
    }
    
    NSString *content = logText;
    if ([logText rangeOfString:[LSLogSettings defaultSettings].logLevelPrefixError].location != NSNotFound) {
        [item setLogLevel:LSLogLevelError];
        content = [self formatStringWithString:logText fgColor:[LSLogSettings defaultSettings].fgColorError];
    } else if ([logText rangeOfString:[LSLogSettings defaultSettings].logLevelPrefixWarn].location != NSNotFound) {
        [item setLogLevel:LSLogLevelWarn];
        content = [self formatStringWithString:logText fgColor:[LSLogSettings defaultSettings].fgColorWarn];
    } else if ([logText rangeOfString:[LSLogSettings defaultSettings].logLevelPrefixInfo].location != NSNotFound) {
        [item setLogLevel:LSLogLevelInfo];
        content = [self formatStringWithString:logText fgColor:[LSLogSettings defaultSettings].fgColorInfo];
    } else if ([logText rangeOfString:[LSLogSettings defaultSettings].logLevelPrefixVerbose].location != NSNotFound) {
        [item setLogLevel:LSLogLevelVerbose];
        content = [self formatStringWithString:logText fgColor:[LSLogSettings defaultSettings].fgColorVerbose];
    } else {
        static NSArray *normalErrors = nil;
        if (normalErrors == nil) {
            normalErrors = @[@"Terminating app due to uncaught exception",
                             @"unrecognized selector sent to",
                             @"Assertion failure in"
                            ];
        }
        for (NSString *err in normalErrors) {
            if ([logText rangeOfString:err].location != NSNotFound) {
                content = [self formatStringWithString:logText fgColor:[LSLogSettings defaultSettings].fgColorError];
                break;
            }
        }
    }
    
    [item setValue:content forKey:@"content"];
}

- (NSString *)ls_hash {
    return [NSString stringWithFormat:@"%lx", (long)self];
}

#pragma mark - Private

- (NSString *)stringFromColor:(NSColor *)color {
    return [NSString stringWithFormat:@"%d,%d,%d", (int)(color.redComponent * 255), (int)(color.greenComponent * 255), (int)(color.blueComponent * 255)];
}

- (NSString *)formatStringWithString:(NSString *)str fgColor:(NSColor *)fgColor {
    return [NSString stringWithFormat:(XCODE_COLORS_ESCAPE @"fg%@;%@" XCODE_COLORS_RESET_FG), [self stringFromColor:fgColor], str];
}

//- (NSString *)formatStringWithString:(NSString *)str fgColor:(NSColor *)fgColor bgColor:(NSColor *)bgColor {
//    return [NSString stringWithFormat:@"%@fg%@;bg%@;%@%@", XCODE_COLORS_ESCAPE, [self stringFromColor:fgColor], [self stringFromColor:bgColor], str, XCODE_COLORS_RESET];
//}

@end

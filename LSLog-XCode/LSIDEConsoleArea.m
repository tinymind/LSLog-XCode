//
//  LSIDEConsoleArea.m
//  LSLog-XCode
//
//  Created by lslin on 15/12/11.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import "LSIDEConsoleArea.h"
#import "LSLog.h"
#import "NSObject+LSLog.h"

@implementation LSIDEConsoleArea

- (BOOL)_shouldAppendItem:(id)obj {
    NSSearchField *fiterField = [self ls_getFilterField];
    if (!fiterField) {
        return YES;
    }
    if (!fiterField.consoleArea) {
        fiterField.consoleArea = self;
    }
    
    NSMutableDictionary *cachedItems = [[LSLog originalConsoleAreaItemsDict] objectForKey:[self ls_hash]];
    if (!cachedItems) {
        cachedItems = [NSMutableDictionary dictionary];
        [[LSLog originalConsoleAreaItemsDict] setObject:cachedItems forKey:[self ls_hash]];
    }
    if (![cachedItems objectForKey:@([obj timestamp])]) {
        [cachedItems setObject:obj forKey:@([obj timestamp])];
    }
    
    NSInteger filterMode = [[self valueForKey:@"filterMode"] intValue];
    BOOL shouldShowLogLevel = YES;
    BOOL isForcedShow = [[obj valueForKey:@"input"] boolValue]
                    || [[obj valueForKey:@"prompt"] boolValue]
                    || [[obj valueForKey:@"outputRequestedByUser"] boolValue]
                    || [[obj valueForKey:@"adaptorType"] hasSuffix:@".Debugger"];
    if (filterMode >= LSLogLevelVerbose) {
        shouldShowLogLevel = [obj logLevel] >= filterMode || isForcedShow;
    } else {
        shouldShowLogLevel = [LSLog.originalShouldAppendItemIMP(self, _cmd, obj) boolValue];
    }
    
    if (!shouldShowLogLevel) {
        return NO;
    }
    
    NSString *filterString = fiterField.stringValue;
    if (!filterString.length) {
        return YES;
    }
    
    // Match with regex
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:filterString
                                                          options:(NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators)
                                                            error:&error];
    NSString *content = [obj content];
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    if ([matches count] > 0  || isForcedShow) {
        return YES;
    }
    
    return NO;
}

- (void)_clearText {
    LSLog.originalClearTextIMP(self, _cmd);
    [[LSLog originalConsoleAreaItemsDict] removeObjectForKey:[self ls_hash]];
}

@end

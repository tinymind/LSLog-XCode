//
//  NSObject+LSLog.h
//  LSLog-XCode
//
//  Created by lslin on 15/12/10.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import <AppKit/AppKit.h>

@class LSIDEConsoleArea;

@interface NSObject (LSLog)

@property (nonatomic, strong) NSTextView *consoleTextView;
@property (nonatomic, strong) LSIDEConsoleArea *consoleArea;
@property (nonatomic, assign) NSUInteger logLevel;

+ (void)pluginDidLoad:(NSBundle *)plugin;

- (NSSearchField *)ls_getFilterField;
- (void)ls_updateItemAttribute:(id)item;
- (NSString *)ls_hash;
    
@end

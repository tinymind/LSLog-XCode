//
//  LSLog-XCode.h
//  LSLog-XCode
//
//  Created by lslin on 15/12/10.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import <AppKit/AppKit.h>

@class LSLog;

#define XCODE_COLORS "XcodeColors"
#define XCODE_COLORS_ESCAPE @"\033["

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color


#define LS_COLOR_RGB(r, g, b)     [NSColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define LS_COLOR_RGBA(r, g, b, a) [NSColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define LS_RECT_ADJUST(r, x1, y1, w1, h1)         NSMakeRect(r.origin.x + x1, r.origin.y + y1,  r.size.width + w1, r.size.height + h1)
#define LS_VIEW_FRAME_ADJUST(view, x1, y1, w1, h1)   view.frame = LS_RECT_ADJUST(view.frame, x1, y1, w1, h1)


typedef NS_ENUM(NSUInteger, LSLogLevel) {
    LSLogLevelVerbose = 1111000,
    LSLogLevelInfo    = 1111001,
    LSLogLevelWarn    = 1111002,
    LSLogLevelError   = 1111003,
};


typedef NS_ENUM(NSUInteger, LSLogViewTag) {
    LSLogViewTagSettingsButton = 2111000,
    LSLogViewTagFilterField    = 2111001,
};


extern NSMutableArray *originalConsoleItems;


@interface LSLog : NSObject

+ (instancetype)sharedPlugin;

/**
 *  NSMutableDictionary<Obj : NSMutableDictionary<@timestamp, item>>
 *
 *  @return Cached console items
 */
+ (NSMutableDictionary *)originalConsoleAreaItemsDict;
+ (IMP)originalShouldAppendItemIMP;
+ (IMP)originalClearTextIMP;
+ (IMP)originalConsoleItemInitIMP;
+ (BOOL)hasXcodeColorsInstalled;

@end
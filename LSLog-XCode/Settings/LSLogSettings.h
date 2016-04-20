//
//  LSLogSettings.h
//  LSLog-XCode
//
//  Created by lslin on 15/12/11.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface LSLogSettings : NSObject

@property (strong, nonatomic) NSString *logLevelPrefixError; /**< default is '<ERROR>' */
@property (strong, nonatomic) NSString *logLevelPrefixWarn; /**< default is '<WARNING>' */
@property (strong, nonatomic) NSString *logLevelPrefixInfo; /**< default is '<INFO>' */
@property (strong, nonatomic) NSString *logLevelPrefixVerbose; /**< default is '<VERBOSE>' */

@property (assign, nonatomic) BOOL enableColoring; /**< default is 'YES' */
@property (strong, nonatomic) NSColor *fgColorError; /**< default is '214, 57, 30' */
@property (strong, nonatomic) NSColor *fgColorWarn; /**< default is '204, 121, 32' */
@property (strong, nonatomic) NSColor *fgColorInfo; /**< default is '32, 32, 32' */
@property (strong, nonatomic) NSColor *fgColorVerbose; /**< default is '0, 0, 255' */

//@property (strong, nonatomic) NSColor *bgColorError; /**< default is '255, 255, 255' */
//@property (strong, nonatomic) NSColor *bgColorWarn; /**< default is '255, 255, 255' */
//@property (strong, nonatomic) NSColor *bgColorInfo; /**< default is '255, 255, 255' */
//@property (strong, nonatomic) NSColor *bgColorVerbose; /**< default is '255, 255, 255' */

+ (instancetype)defaultSettings;

@end

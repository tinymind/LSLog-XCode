//
//  LSIDEConsoleArea.h
//  LSLog-XCode
//
//  Created by lslin on 15/12/11.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface LSIDEConsoleArea : NSViewController

- (BOOL)_shouldAppendItem:(id)obj;
- (void)_clearText;

@end

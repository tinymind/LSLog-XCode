//
//  NSTextStorage+LSLog.h
//  LSLog-XCode
//
//  Created by lslin on 15/12/10.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSTextStorage (LSLog)

- (void)ls_fixAttributesInRange:(NSRange)range;

@end

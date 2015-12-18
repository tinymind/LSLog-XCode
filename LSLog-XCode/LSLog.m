//
//  LSLog.m
//  LSLog-XCode
//
//  Created by lslin on 15/12/10.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import "LSLog.h"

#import "LSIDEConsoleArea.h"
#import "LSIDEConsoleItem.h"
#import "LSLogSettingsWindowController.h"

#import "NSObject+LSLog.h"
#import "NSObject+LSSwizzle.h"
#import "NSTextStorage+LSLog.h"

#define LSLOG_FLAG "LSLOG_FLAG"

static NSMutableDictionary *_originalConsoleAreaItemsDict = nil;
static IMP _originalShouldAppendItemIMP = nil;
static IMP _originalClearTextIMP = nil;
static IMP _originalConsoleItemInitIMP = nil;
static BOOL _hasXcodeColorsInstalled = NO;


@interface LSLog() <NSSearchFieldDelegate>

@property (nonatomic, strong, readwrite) LSLogSettingsWindowController *settingsPanel;

@end


@implementation LSLog

+ (void)load {
    if (getenv(LSLOG_FLAG) && !strcmp(getenv(LSLOG_FLAG), "YES")) {
        return;
    }
    
    _originalConsoleAreaItemsDict = [NSMutableDictionary dictionary];
    
    _hasXcodeColorsInstalled = getenv(XCODE_COLORS) && (strcmp(getenv(XCODE_COLORS), "YES") != 0);
    if (!_hasXcodeColorsInstalled) {
        if (![NSTextStorage ls_swizzleOriginalMethod:@selector(fixAttributesInRange:) withAltMethod:@selector(ls_fixAttributesInRange:)]) {
            NSLog(@"LSLog: Error swizzling methods fixAttributesInRange");
            return;
        }
    }
    
    _originalShouldAppendItemIMP = [self ls_replaceOriginalClass:NSClassFromString(@"IDEConsoleArea") withAltClass:NSClassFromString(@"LSIDEConsoleArea") method:@selector(_shouldAppendItem:)];
    _originalClearTextIMP = [self ls_replaceOriginalClass:NSClassFromString(@"IDEConsoleArea") withAltClass:NSClassFromString(@"LSIDEConsoleArea") method:@selector(_clearText)];
    
    _originalConsoleItemInitIMP = [self ls_replaceOriginalClass:NSClassFromString(@"IDEConsoleItem") withAltClass:NSClassFromString(@"LSIDEConsoleItem") method:@selector(initWithAdaptorType:content:kind:)];
    
    setenv(LSLOG_FLAG, "YES", 0);
}

+ (instancetype)sharedPlugin {
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
    
    return sharedPlugin;
}

+ (NSMutableDictionary *)originalConsoleAreaItemsDict {
    return _originalConsoleAreaItemsDict;
}

+ (IMP)originalShouldAppendItemIMP {
    return _originalShouldAppendItemIMP;
}

+ (IMP)originalClearTextIMP {
    return _originalClearTextIMP;
}

+ (IMP)originalConsoleItemInitIMP {
    return _originalConsoleItemInitIMP;
}

+ (BOOL)hasXcodeColorsInstalled {
    return _hasXcodeColorsInstalled;
}

#pragma mark - Lifecircle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onIDEControlGroupDidChange:)
                                                     name:@"IDEControlGroupDidChangeNotificationName"
                                                   object:nil];
    }
    return self;
}

#pragma mark - Notification

- (void)onIDEControlGroupDidChange:(NSNotification*)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addFilterViews];
    });
}

- (void)onFilterFieldDidChange:(NSNotification*)notification {
    if (![[notification object] isMemberOfClass:[NSSearchField class]]) {
        return;
    }
    
    NSSearchField *searchField = [notification object];
    if (![searchField respondsToSelector:@selector(consoleTextView)]) {
        return;
    }
    
    if (![searchField respondsToSelector:@selector(consoleArea)]) {
        return;
    }
    
    NSTextView *consoleTextView = searchField.consoleTextView;
    LSIDEConsoleArea *consoleArea = searchField.consoleArea;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([consoleTextView respondsToSelector:@selector(clearConsoleItems)]) {
        [consoleTextView performSelector:@selector(clearConsoleItems) withObject:nil];
    }
    
    if ([consoleArea respondsToSelector:@selector(_appendItems:)]) {
        
        NSMutableDictionary *cacheItems = [[LSLog originalConsoleAreaItemsDict] objectForKey:[consoleArea ls_hash]];
        NSArray *sortedKeys = [[cacheItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableArray *sortedItems = [NSMutableArray array];
        for (NSNumber *key in sortedKeys) {
            [sortedItems addObject:cacheItems[key]];
        }
        
        [consoleArea performSelector:@selector(_appendItems:) withObject:sortedItems];
    }
#pragma clang diagnostic pop
}

#pragma mark - Action

- (void)onSettingsButtonClicked:(NSButton *)sender {
    self.settingsPanel = [[LSLogSettingsWindowController alloc] initWithWindowNibName:@"LSLogSettingsWindowController"];
    [self.settingsPanel showWindow:self.settingsPanel];
}

#pragma mark - Private

- (void)addFilterViews {
    NSView *consoleTextView = [self getViewByClassName:@"IDEConsoleTextView" inContainerView:[[NSApp mainWindow] contentView]];
    if (!consoleTextView) {
        NSLog(@"[LSLog:addFilterViews] IDEConsoleTextView not found");
        return;
    }
    
    NSView *consoleParentView = [self getParantViewByClassName:@"DVTControllerContentView" ofView:consoleTextView];
    NSView *scopeBarView = [self getViewByClassName:@"DVTScopeBarView" inContainerView:consoleParentView];
    if (!scopeBarView) {
        NSLog(@"[LSLog:addFilterViews] DVTScopeBarView not found");
        return;
    }
    
    if ([scopeBarView viewWithTag:LSLogViewTagSettingsButton]) {
        return;
    }
    
    NSButton *trashButton = nil;
    NSPopUpButton *filterButton = nil;
    for (NSView *subView in scopeBarView.subviews) {
        if (trashButton && filterButton) {
            break;
        }
        if (trashButton == nil && [[subView className] isEqualToString:@"NSButton"]) {
            trashButton = (NSButton *)subView;
        } else if (filterButton == nil && [[subView className] isEqualToString:@"NSPopUpButton"]) {
            filterButton = (NSPopUpButton *)subView;
        }
    }
    
    if (!trashButton) {
        NSLog(@"[LSLog:addFilterViews] TrashButton not found");
        return;
    }
    
    if (filterButton) {
        // Remove empty item
        for (NSInteger index = filterButton.numberOfItems - 1; index >= 0; -- index) {
            NSMenuItem *item = [filterButton itemAtIndex:index];
            if (!item.title.length) {
                [filterButton removeItemAtIndex:index];
            }
        }
        
        NSArray *items = @[@"Verbose", @"Info", @"Warn", @"Error"];
        NSUInteger tag = LSLogLevelVerbose;
        for (NSUInteger i = 0; i < items.count; ++ i) {
            [filterButton addItemWithTitle:items[i]];
            [filterButton itemAtIndex:filterButton.numberOfItems - 1].tag = tag;
            tag ++;
        }
    }
    
    NSInteger selectedItem = [filterButton indexOfItemWithTag:[[consoleTextView valueForKey:@"logMode"] intValue]];
    if (selectedItem < 0 || selectedItem >= [filterButton numberOfItems]) {
        selectedItem = 0;
    }
    [filterButton selectItemAtIndex:selectedItem];
    
    NSRect frame = LS_RECT_ADJUST(trashButton.frame, -70, -4, 50, 4);

    NSButton *settingsButton = [[NSButton alloc] initWithFrame:frame];
    settingsButton.tag = LSLogViewTagSettingsButton;
    settingsButton.font = [NSFont systemFontOfSize:10.0];
    settingsButton.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
    [settingsButton setButtonType:NSToggleButton];
    [settingsButton setBezelStyle:NSRoundedBezelStyle];
    [settingsButton setTitle:@"Settings"];
    [settingsButton setTarget:self];
    [settingsButton setAction:@selector(onSettingsButtonClicked:)];
    [scopeBarView addSubview:settingsButton];
    
    frame = LS_RECT_ADJUST(frame, -220, 4, 150, -4);
    
    NSSearchField *filterField = [[NSSearchField alloc] initWithFrame:frame];
    filterField.tag = LSLogViewTagFilterField;
    filterField.autoresizingMask = NSViewMinXMargin | NSViewMinYMargin;
    filterField.font = [NSFont systemFontOfSize:11.0];
    filterField.delegate = self;
    filterField.consoleTextView = (NSTextView *)consoleTextView;
    [filterField.cell setPlaceholderString:@"Regular Expression"];
    [scopeBarView addSubview:filterField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFilterFieldDidChange:) name:NSControlTextDidChangeNotification object:nil];
}

- (NSView *)getViewByClassName:(NSString *)className inContainerView:(NSView *)container {
    Class class = NSClassFromString(className);
    for (NSView *subView in container.subviews) {
        if ([subView isKindOfClass:class]) {
            return subView;
        } else {
            NSView *view = [self getViewByClassName:className inContainerView:subView];
            if ([view isKindOfClass:class]) {
                return view;
            }
        }
    }
    return nil;
}

- (NSView *)getParantViewByClassName:(NSString *)className ofView:(NSView *)view {
    NSView *superView = view.superview;
    while (superView) {
        if ([[superView className] isEqualToString:className]) {
            return superView;
        }
        superView = superView.superview;
    }
    
    return nil;
}
@end

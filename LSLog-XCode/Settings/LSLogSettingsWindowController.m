//
//  LSLogSettingsWindowController.m
//  LSLog-XCode
//
//  Created by lslin on 15/12/13.
//  Copyright © 2015年 lessfun.com. All rights reserved.
//

#import "LSLogSettingsWindowController.h"
#import "LSLogSettings.h"

@interface LSLogSettingsWindowController ()

@property (weak) IBOutlet NSTextField *errorTextField;
@property (weak) IBOutlet NSTextField *warnTextField;
@property (weak) IBOutlet NSTextField *infoTextField;
@property (weak) IBOutlet NSTextField *verboseTextField;

@property (weak) IBOutlet NSButton *enableColoringButton;

@property (weak) IBOutlet NSColorWell *fgErrorColorWell;
@property (weak) IBOutlet NSColorWell *fgWarnColorWell;
@property (weak) IBOutlet NSColorWell *fgInfoColorWell;
@property (weak) IBOutlet NSColorWell *fgVerboseColorWell;

@property (weak) IBOutlet NSColorWell *bgErrorColorWell;
@property (weak) IBOutlet NSColorWell *bgWarnColorWell;
@property (weak) IBOutlet NSColorWell *bgInfoColorWell;
@property (weak) IBOutlet NSColorWell *bgVerboseColorWell;

@end

@implementation LSLogSettingsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self defaultInit];
}

#pragma mark - Action

- (IBAction)onColorWellClicked:(NSColorWell *)sender {
    if (sender == self.fgErrorColorWell) {
        [[LSLogSettings defaultSettings] setFgColorError:sender.color];
    } else if (sender == self.fgWarnColorWell) {
        [[LSLogSettings defaultSettings] setFgColorWarn:sender.color];
    } else if (sender == self.fgInfoColorWell) {
        [[LSLogSettings defaultSettings] setFgColorInfo:sender.color];
    } else if (sender == self.fgVerboseColorWell) {
        [[LSLogSettings defaultSettings] setFgColorVerbose:sender.color];
    }
//    else if (sender == self.bgErrorColorWell) {
//        [[LSLogSettings defaultSettings] setBgColorError:sender.color];
//    } else if (sender == self.bgWarnColorWell) {
//        [[LSLogSettings defaultSettings] setBgColorWarn:sender.color];
//    } else if (sender == self.bgInfoColorWell) {
//        [[LSLogSettings defaultSettings] setBgColorInfo:sender.color];
//    } else if (sender == self.bgVerboseColorWell) {
//        [[LSLogSettings defaultSettings] setBgColorVerbose:sender.color];
//    }
}

- (IBAction)onTextFieldDidChange:(NSTextField *)textField {
    if(textField == self.errorTextField) {
        [[LSLogSettings defaultSettings] setLogLevelPrefixError:textField.stringValue];
    } else if(textField == self.warnTextField) {
        [[LSLogSettings defaultSettings] setLogLevelPrefixWarn:textField.stringValue];
    } else if(textField == self.infoTextField) {
        [[LSLogSettings defaultSettings] setLogLevelPrefixInfo:textField.stringValue];
    } else if(textField == self.verboseTextField) {
        [[LSLogSettings defaultSettings] setLogLevelPrefixVerbose:textField.stringValue];
    }
}

- (IBAction)onEnableColoringButtonClicked:(NSButton *)sender {
    [[LSLogSettings defaultSettings] setEnableColoring:sender.state == NSOnState];
    [self updateColorWellState:[LSLogSettings defaultSettings].enableColoring];
}

#pragma mark - Private

- (void)defaultInit {
    self.errorTextField.stringValue = [LSLogSettings defaultSettings].logLevelPrefixError;
    self.warnTextField.stringValue = [LSLogSettings defaultSettings].logLevelPrefixWarn;
    self.infoTextField.stringValue = [LSLogSettings defaultSettings].logLevelPrefixInfo;
    self.verboseTextField.stringValue = [LSLogSettings defaultSettings].logLevelPrefixVerbose;
    
    self.enableColoringButton.state = [LSLogSettings defaultSettings].enableColoring ? NSOnState : NSOffState;
    [self updateColorWellState:[LSLogSettings defaultSettings].enableColoring];
    
    self.fgErrorColorWell.color = [LSLogSettings defaultSettings].fgColorError;
    self.fgWarnColorWell.color = [LSLogSettings defaultSettings].fgColorWarn;
    self.fgInfoColorWell.color = [LSLogSettings defaultSettings].fgColorInfo;
    self.fgVerboseColorWell.color = [LSLogSettings defaultSettings].fgColorVerbose;
    
//    self.bgErrorColorWell.color = [LSLogSettings defaultSettings].bgColorError;
//    self.bgWarnColorWell.color = [LSLogSettings defaultSettings].bgColorWarn;
//    self.bgInfoColorWell.color = [LSLogSettings defaultSettings].bgColorInfo;
//    self.bgVerboseColorWell.color = [LSLogSettings defaultSettings].bgColorVerbose;
}

- (void)updateColorWellState:(BOOL)enable {
    self.fgErrorColorWell.enabled = enable;
    self.fgWarnColorWell.enabled = enable;
    self.fgInfoColorWell.enabled = enable;
    self.fgVerboseColorWell.enabled = enable;

//    self.bgErrorColorWell.enabled = enable;
//    self.bgWarnColorWell.enabled = enable;
//    self.bgInfoColorWell.enabled = enable;
//    self.bgVerboseColorWell.enabled = enable;
}

@end

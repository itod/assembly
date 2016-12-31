//
//  ASDocument.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AssemblyKit/ASContext.h>

@class TDDraggableBar;
@class TDStatusBarPopUpView;
@class TDUberView;

@class ASRegisterViewController;
@class ASEFlagsViewController;
@class ASMemoryViewController;
@class ASLogViewController;
@class ASSourceViewController;

@class ASContext;
@class ASProgram;
@class ASProgramRunner;

@interface ASDocument : NSDocument <ASContextDelegate>

- (IBAction)compile:(id)sender;
- (IBAction)run:(id)sender;
- (IBAction)step:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)clear:(id)sender;

- (IBAction)changeEndianness:(id)sender;

@property (nonatomic, retain) IBOutlet NSToolbar *toolbar;
@property (nonatomic, retain) IBOutlet NSView *uberContainerView;
@property (nonatomic, retain) IBOutlet TDDraggableBar *statusBar;
@property (nonatomic, retain) IBOutlet TDStatusBarPopUpView *endianPopUpView;

@property (nonatomic, retain) IBOutlet NSView *cpuView;
@property (nonatomic, retain) IBOutlet NSView *registerContainerView;
@property (nonatomic, retain) IBOutlet NSView *eFlagsContainerView;

@property (nonatomic, retain) TDUberView *innerUberView;
@property (nonatomic, retain) TDUberView *outerUberView;

@property (nonatomic, retain) ASRegisterViewController *registerViewController;
@property (nonatomic, retain) ASEFlagsViewController *eFlagsViewController;
@property (nonatomic, retain) ASMemoryViewController *memoryViewController;
@property (nonatomic, retain) ASLogViewController *logViewController;
@property (nonatomic, retain) ASSourceViewController *sourceViewController;

@property (nonatomic, retain) ASContext *context;
@property (nonatomic, retain) ASProgram *program;
@property (nonatomic, retain) ASProgramRunner *programRunner;

@property (nonatomic, assign) BOOL isCompiling;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) BOOL isStepping;
@property (nonatomic, assign) BOOL canRun;
@property (nonatomic, assign) BOOL canStep;
@property (nonatomic, assign) BOOL canStop;
@end

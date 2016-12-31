//
//  ASDocument.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASDocument.h"
#import "ASRegisterViewController.h"
#import "ASEFlagsViewController.h"
#import "ASMemoryViewController.h"
#import "ASLogViewController.h"
#import "ASSourceViewController.h"

#import <AssemblyKit/AssemblyKit.h>

#import <TDAppKit/TDUberView.h>
#import <TDAppKit/TDSourceCodeTextView.h>
#import <TDAppKit/TDDraggableBar.h>
#import <TDAppKit/TDUtils.h>

#define TAG_RUN 100
#define TAG_COMPILE 200
#define TAG_STOP 300
#define TAG_STEP 400

@interface ASDocument ()
- (void)setUpBindings;
- (void)tearDownBindings;
- (void)updateBindings;
- (void)validateItem:(id)item;

- (void)renderHighlightedLineNumber;
- (void)setUpFullScreenInWindow:(NSWindow *)win;
- (void)setUpUberViewsInWindow:(NSWindow *)win;
- (void)renderRegisters;
- (void)renderMemory;
- (void)log:(NSString *)str;
- (void)clearLog;
@property (nonatomic, copy) NSString *tmpString;
@end

@implementation ASDocument

+ (BOOL)autosavesInPlace {
    return YES;
}


+ (BOOL)autosavesDrafts {
    return YES;
}


- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)dealloc {    
    self.uberContainerView = nil;
    self.statusBar = nil;
    self.endianPopUpView = nil;
    
    self.innerUberView = nil;
    self.outerUberView = nil;
    
    self.cpuView = nil;
    self.registerContainerView = nil;
    self.eFlagsContainerView = nil;
    
    self.registerViewController = nil;
    self.eFlagsViewController = nil;
    self.memoryViewController = nil;
    self.logViewController = nil;
    self.sourceViewController = nil;
    
    self.context = nil;
    self.program = nil;
    self.programRunner = nil;
    
    self.tmpString = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark NSDocument

- (NSString *)windowNibName {
    return @"ASDocument";
}


- (void)windowControllerDidLoadNib:(NSWindowController *)wc {
    [super windowControllerDidLoadNib:wc];
    
    [self setUpBindings];
    
    self.context = [[[ASContext alloc] initWithDelegate:self] autorelease];
    self.programRunner = [[[ASProgramRunner alloc] initWithContext:_context] autorelease];

    [self setUpFullScreenInWindow:[wc window]];
    [self setUpUberViewsInWindow:[wc window]];

    if (_tmpString) {
        [_sourceViewController.sourceCodeTextView setString:_tmpString];
        self.tmpString = nil;
    }
        
    TDPerformOnMainThreadAfterDelay(0.0, ^{
        [self updateBindings];

        NSTextView *tv = _sourceViewController.sourceCodeTextView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:tv];
        [[wc window] makeFirstResponder:tv];
    });
}


- (void)close {
    [self tearDownBindings];
    [super close];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outErr {
    NSString *str = [_sourceViewController.sourceCodeTextView string];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outErr {
    NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if (str) {
        self.tmpString = str;
        return YES;
    } else {
        return NO;
    }
}


#pragma mark -
#pragma mark Actions

- (IBAction)compile:(id)sender {    
    [self clear:sender];
    
    [self log:NSLocalizedString(@"Compiling…", @"")];
    NSString *input = [_sourceViewController.sourceCodeTextView string];
    
    if (![input length]) {
        NSBeep();
        return;
    }
    
    self.isStepping = NO;
    self.isRunning = NO;
    self.isCompiling = YES;
    
    NSError *err = nil;
    ASProgram *prog = [_programRunner compiledProgramFromInput:input error:&err];
    if (prog) {
        [self log:NSLocalizedString(@"Compilation Succeeded.", @"")];
    } else {
        [self log:NSLocalizedString(@"Compilation Failed.", @"")];
        [self log:[err localizedDescription]];
        [self log:[err localizedFailureReason]];
        NSBeep();
        return;
    }

    self.program = prog;
    self.isCompiling = NO;
}


- (IBAction)run:(id)sender {
    [self compile:sender];
    if (!_program) return;
    
    self.isRunning = YES;
    
    [self log:NSLocalizedString(@"Running…", @"")];
    
    NSError *err = nil;
    if ([_programRunner runProgram:_program error:&err]) {
        [self log:NSLocalizedString(@"Run Succeeded.", @"")];
    } else {
        [self log:NSLocalizedString(@"Run Failed.", @"")];
        [self log:[err localizedDescription]];
        [self log:[err localizedFailureReason]];
        NSBeep();
        return;
    }

    self.isRunning = NO;

    [self renderRegisters];
    [self renderMemory];
}


- (IBAction)step:(id)sender {
    if (_program && [_program isSteppingBlocked]) {
        NSBeep();
        return;
    }
    
    if (!_program || ![_program isRunning]) {
        [self renderHighlightedLineNumber];

        [self clear:sender];
        [self compile:sender];
    }

    if (!_program) return;
    
    self.isStepping = YES;

    [self renderHighlightedLineNumber];

    NSError *err = nil;
    if (![_programRunner stepProgram:_program error:&err]) {
        [self log:NSLocalizedString(@"Step Failed.", @"")];
        [self log:[err localizedDescription]];
        [self log:[err localizedFailureReason]];
        NSBeep();
        return;
    }
    
    [self renderRegisters];
    [self renderMemory];
}


- (IBAction)stop:(id)sender {
    NSAssert(self.canStop, @"");

//    [self clear:sender];
    
    self.isCompiling = NO;
    self.isRunning = NO;
    self.isStepping = NO;
    
    [_context reset];
    self.program = nil;
    [self renderHighlightedLineNumber];
}


- (IBAction)clear:(id)sender {
    
    self.isCompiling = NO;
    self.isRunning = NO;
    self.isStepping = NO;
    
    [_context reset];
    self.program = nil;
    [self renderRegisters];
    [self renderMemory];
    [self renderHighlightedLineNumber];
    [self clearLog];
}


- (IBAction)changeEndianness:(id)sender {
    BOOL bigEndian = [_endianPopUpView.popUpButton selectedTag];
    _context.isBigEndian = bigEndian;
    
    [self clear:nil];
}


#pragma mark -
#pragma mark ASContextDelegate

- (void)context:(ASContext *)ctx didLog:(NSString *)str {
    [self log:str];
}


#pragma mark -
#pragma mark Notifications

- (void)textDidChange:(NSNotification *)n {
    if (_program && [_program isRunning]) {
        [self clear:nil];
    }
}


#pragma mark -
#pragma mark Bindings

- (void)setUpBindings {
    [self addObserver:self forKeyPath:@"isCompiling" options:0 context:NULL];
    [self addObserver:self forKeyPath:@"isRunning" options:0 context:NULL];
    [self addObserver:self forKeyPath:@"isStepping" options:0 context:NULL];
}


- (void)tearDownBindings {
    [self removeObserver:self forKeyPath:@"isCompiling"];
    [self removeObserver:self forKeyPath:@"isRunning"];
    [self removeObserver:self forKeyPath:@"isStepping"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)obj change:(NSDictionary *)change context:(void *)ctx {
#if !NDEBUG
    BOOL isValidPath = [@[@"isCompiling", @"isRunning", @"isStepping"] containsObject:keyPath];
    NSAssert(isValidPath, @"");
#endif

    [self updateBindings];
}


- (void)updateBindings {
    TDAssertMainThread();
    
    self.canRun = !self.isStepping;
    self.canStep = !self.isCompiling && !self.isRunning;
    self.canStop = self.isCompiling || self.isRunning || self.isStepping;

    //NSLog(@"canRun: %d, canStep: %d, canStop: %d", self.canRun, self.canStep, self.canStop);
    
    [_toolbar validateVisibleItems];
}


- (void)validateItem:(id)item {
    //NSLog(@"%@", [item label]);

    switch ([item tag]) {
        case TAG_RUN:
            [item setEnabled:self.canRun];
            break;
        case TAG_COMPILE:
            [item setEnabled:self.canRun];
            break;
        case TAG_STOP:
            [item setEnabled:self.canStop];
            break;
        case TAG_STEP:
            [item setEnabled:self.canStep];
            break;
        default:
            break;
    }

}


- (void)validateToolbarItem:(NSToolbarItem *)item {
    [self validateItem:item];
}


- (void)validateMenuItem:(NSMenuItem *)item {
    [self validateItem:item];
}


#pragma mark -
#pragma mark Private

- (void)setUpFullScreenInWindow:(NSWindow *)win {
    NSWindowCollectionBehavior cb = [win collectionBehavior];
    cb |= NSWindowCollectionBehaviorFullScreenPrimary;
    [win setCollectionBehavior:cb];
}


- (void)setUpUberViewsInWindow:(NSWindow *)win {
    self.registerViewController = [[[ASRegisterViewController alloc] init] autorelease];
    self.eFlagsViewController = [[[ASEFlagsViewController alloc] init] autorelease];
    self.memoryViewController = [[[ASMemoryViewController alloc] init] autorelease];
    self.logViewController = [[[ASLogViewController alloc] init] autorelease];
    self.sourceViewController = [[[ASSourceViewController alloc] init] autorelease];
    
    [_registerViewController.view setFrame:[_registerContainerView bounds]];
    [_registerContainerView addSubview:_registerViewController.view];
    
    [_eFlagsViewController.view setFrame:[_eFlagsContainerView bounds]];
    [_eFlagsContainerView addSubview:_eFlagsViewController.view];
    
    [self renderRegisters];
    [self renderMemory];
    
    // setup uberviews
    CGRect uberFrame = [_uberContainerView bounds];
    self.innerUberView = [[[TDUberView alloc] initWithFrame:uberFrame dividerStyle:NSSplitViewDividerStyleThin] autorelease];
    [_innerUberView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    _innerUberView.autosaveName = @"ASInnerUberView";
    
    self.outerUberView = [[[TDUberView alloc] initWithFrame:uberFrame dividerStyle:NSSplitViewDividerStyleThin] autorelease];
    [_outerUberView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    _outerUberView.autosaveName = @"ASOuterUberView";
    
    [_uberContainerView addSubview:_outerUberView];
    
    _innerUberView.preferredLeftSplitWidth = 240.0;
    _innerUberView.preferredTopSplitHeight = 380.0 + NSHeight([_eFlagsContainerView frame]);
    [_innerUberView openLeftView:nil];
    [_innerUberView openTopView:nil];
    _innerUberView.leftView = _memoryViewController.view;
    _innerUberView.topView = _cpuView;
    _innerUberView.midView = _sourceViewController.view;
    
    _outerUberView.preferredLeftSplitWidth = 960.0;
    [_outerUberView openLeftView:nil];
    _outerUberView.leftView = _innerUberView;
    _outerUberView.midView = _logViewController.view;
}


- (void)renderHighlightedLineNumber {
    NSUInteger lineNum = _program.currentLineNumber;
    _sourceViewController.highlightedLineNumber = lineNum;
}


- (void)renderRegisters {
    NSAssert(_context, @"");
    NSAssert(_registerViewController, @"");
    NSAssert(_eFlagsViewController, @"");
    [_registerViewController renderWithContext:_context];
    [_eFlagsViewController renderWithContext:_context];
}


- (void)renderMemory {
    NSAssert(_context, @"");
    NSAssert(_memoryViewController, @"");
    [_memoryViewController renderWithContext:_context];
}


- (void)log:(NSString *)str {
    NSAssert(_logViewController, @"");
    [_logViewController log:str];
}


- (void)clearLog {
    NSAssert(_logViewController, @"");
    [_logViewController clearLog];
}


#pragma mark -
#pragma mark Properties

@end

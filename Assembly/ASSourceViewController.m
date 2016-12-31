//
//  ASSourceViewController.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASSourceViewController.h"

#import <TDAppKit/TDGutterView.h>
#import <TDAppKit/TDSourceCodeTextView.h>

@interface ASSourceViewController ()

@end

@implementation ASSourceViewController

- (id)init {
    self = [super initWithNibName:@"ASSourceViewController" bundle:nil];
    return self;
}


- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)b {
    self = [super initWithNibName:name bundle:b];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    self.gutterView = nil;
    self.sourceCodeTextView = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    
    self.viewControllerView.color = [NSColor whiteColor];
    self.gutterView.color = [NSColor windowBackgroundColor];
    
    NSFont *font = [NSFont userFixedPitchFontOfSize:11.0]; // [NSFont fontWithName:@"Monaco" size:10.0];
    [_sourceCodeTextView setFont:font];
    [_sourceCodeTextView setEnabledTextCheckingTypes:0];
    [_sourceCodeTextView setContinuousSpellCheckingEnabled:NO];
    [_sourceCodeTextView setGrammarCheckingEnabled:NO];
    [_sourceCodeTextView setAutomaticSpellingCorrectionEnabled:NO];
    [_sourceCodeTextView setAutomaticTextReplacementEnabled:NO];
    [_sourceCodeTextView renderGutter];
    
    // necessary to prevent horiz scroll. dunno why.
    NSRect frame = [_sourceCodeTextView frame];
    frame.size.width = NSWidth([[_sourceCodeTextView enclosingScrollView] frame]);
    [_sourceCodeTextView setFrame:frame];
    
//    [_sourceCodeTextView setDelegate:self];
}


#pragma mark -
#pragma mark NSTextDelegate

//- (void)textDidChange:(NSNotification *)n {
//    
//}


- (void)setHighlightedLineNumber:(NSUInteger)n {
    if (n != _highlightedLineNumber) {
        _highlightedLineNumber = n;
        _gutterView.highlightedLineNumber = n;
        [_sourceCodeTextView renderGutter];
    }
}

@end

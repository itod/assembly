//
//  ASLogViewController.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASLogViewController.h"

@interface ASLogViewController ()

@end

@implementation ASLogViewController

- (id)init {
    self = [super initWithNibName:@"ASLogViewController" bundle:nil];
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
    
    self.viewControllerView.color = [NSColor windowBackgroundColor];
    
    NSFont *font = [NSFont userFixedPitchFontOfSize:11.0];
    [_sourceCodeTextView setFont:font];
    
    // necessary to prevent horiz scroll. dunno why.
    NSRect frame = [_sourceCodeTextView frame];
    frame.size.width = NSWidth([[_sourceCodeTextView enclosingScrollView] frame]);
    [_sourceCodeTextView setFrame:frame];

}


- (void)log:(NSString *)str {
    NSAssert(str, @"");
    NSString *oldStr = [_sourceCodeTextView string];
    str = [NSString stringWithFormat:@"%@\n%@", oldStr, str];
    [_sourceCodeTextView setString:str];
    [_sourceCodeTextView scrollToEndOfDocument:nil];
}


- (void)clearLog {
    [_sourceCodeTextView setString:@""];
}

@end

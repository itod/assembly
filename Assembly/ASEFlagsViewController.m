//
//  ASEFlagsViewController.m
//  Assembly
//
//  Created by Todd Ditchendorf on 3/3/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASEFlagsViewController.h"
#import "ASEFlagsView.h"

#import <AssemblyKit/ASContext.h>

@interface ASEFlagsViewController ()

@end

@implementation ASEFlagsViewController

- (id)init {
    self = [super initWithNibName:@"ASEFlagsViewController" bundle:nil];
    return self;
}


- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)b {
    self = [super initWithNibName:name bundle:b];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    self.eFlagsView = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllerView.color = [NSColor windowBackgroundColor];
    
}


- (void)renderWithContext:(ASContext *)ctx {
    _eFlagsView.context = ctx;
    [_eFlagsView setNeedsDisplay:YES];
}

@end

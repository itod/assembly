//
//  ASRegisterViewController.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASRegisterViewController.h"
#import "ASRegisterView.h"

#import <AssemblyKit/ASContext.h>

@interface ASRegisterViewController ()

@end

@implementation ASRegisterViewController

- (id)init {
    self = [super initWithNibName:@"ASRegisterViewController" bundle:nil];
    return self;
}


- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)b {
    self = [super initWithNibName:name bundle:b];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    self.registerView = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllerView.color = [NSColor windowBackgroundColor];
    
}


- (void)renderWithContext:(ASContext *)ctx {
    _registerView.context = ctx;
    [_registerView setNeedsDisplay:YES];
}

@end

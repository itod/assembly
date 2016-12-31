//
//  ASRegisterViewController.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <TDAppKit/TDViewController.h>

@class ASContext;
@class ASRegisterView;

@interface ASRegisterViewController : TDViewController

- (void)renderWithContext:(ASContext *)ctx;

@property (nonatomic, retain) IBOutlet ASRegisterView *registerView;
@end

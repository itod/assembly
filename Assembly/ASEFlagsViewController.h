//
//  ASEFlagsViewController.h
//  Assembly
//
//  Created by Todd Ditchendorf on 3/3/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <TDAppKit/TDAppKit.h>

@class ASContext;
@class ASEFlagsView;

@interface ASEFlagsViewController : TDViewController

- (void)renderWithContext:(ASContext *)ctx;

@property (nonatomic, retain) IBOutlet ASEFlagsView *eFlagsView;
@end

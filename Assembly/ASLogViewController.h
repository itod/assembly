//
//  ASLogViewController.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <TDAppKit/TDViewController.h>

@class TDGutterView;
@class TDSourceCodeTextView;

@interface ASLogViewController : TDViewController

- (void)log:(NSString *)msg;
- (void)clearLog;

@property (nonatomic, retain) IBOutlet TDGutterView *gutterView;
@property (nonatomic, retain) IBOutlet TDSourceCodeTextView *sourceCodeTextView;
@end

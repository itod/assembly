//
//  ASSourceViewController.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <TDAppKit/TDViewController.h>

@class TDGutterView;
@class TDSourceCodeTextView;

@interface ASSourceViewController : TDViewController <NSTextViewDelegate>

@property (nonatomic, retain) IBOutlet TDGutterView *gutterView;
@property (nonatomic, retain) IBOutlet TDSourceCodeTextView *sourceCodeTextView;

@property (nonatomic, assign) NSUInteger highlightedLineNumber;
@end

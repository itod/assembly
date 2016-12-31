//
//  ASEFlagsView.h
//  Assembly
//
//  Created by Todd Ditchendorf on 3/3/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <TDAppKit/TDFlippedColorView.h>

@class ASContext;

@interface ASEFlagsView : TDFlippedColorView

- (CGRect)lowOrderWordRectForBounds:(CGRect)bounds;
- (CGRect)bitRectForLowOrderWordRect:(CGRect)wrect atIndex:(NSUInteger)idx;
- (CGRect)bitValueBorderRectForBitRect:(CGRect)bitRect;
- (CGRect)bitValueRectForBitRect:(CGRect)bitRect;
- (CGRect)bitLabelRectForBitRect:(CGRect)bitRect;

@property (nonatomic, retain) ASContext *context;
@end

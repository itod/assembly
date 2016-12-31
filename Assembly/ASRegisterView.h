//
//  ASRegisterView.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <TDAppKit/TDFlippedColorView.h>

@class ASContext;

@interface ASRegisterView : TDFlippedColorView

- (CGRect)leftRectForBounds:(CGRect)bounds;
- (CGRect)rightRectForBounds:(CGRect)bounds;

- (CGRect)labelRectForBorderRect:(CGRect)brect;

- (CGRect)dwordBorderRectForLeftRightRect:(CGRect)lrect atIndex:(NSInteger)idx;
- (CGRect)dwordRegisterRectForBorderRect:(CGRect)brect;

- (CGRect)wordBorderRectForDwordBorderRect:(CGRect)brect;
- (CGRect)wordRegisterRectForDwordBorderRect:(CGRect)brect;

- (CGRect)hBorderRectForDwordBorderRect:(CGRect)brect;
- (CGRect)lBorderRectForDwordBorderRect:(CGRect)brect;
- (CGRect)hRegisterRectForDwordBorderRect:(CGRect)brect;
- (CGRect)lRegisterRectForDwordBorderRect:(CGRect)brect;

- (CGRect)hexValueRectForRegisterRect:(CGRect)rrect;
- (CGRect)binValueRectForRegisterRect:(CGRect)rrect;

@property (nonatomic, retain) ASContext *context;
@end

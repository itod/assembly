//
//  ASMemoryView.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/22/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <TDAppKit/TDFlippedView.h>

@class ASContext;

@interface ASMemoryView : TDFlippedView

- (CGRect)stackRectForBounds:(CGRect)bounds;

- (CGRect)stackAddrRectForStackRect:(CGRect)stackRect atIndex:(NSUInteger)idx;
- (CGRect)valueBorderRectForStackAddrRect:(CGRect)addrRect;
- (CGRect)hexValueRectForValueBorderRect:(CGRect)brect;
- (CGRect)binaryValueRectForValueBorderRect:(CGRect)brect;
- (CGRect)binaryBorderRectForValueBorderRect:(CGRect)brect;
- (CGRect)labelTextRectForStackAddrRect:(CGRect)addrRect;

@property (nonatomic, retain) ASContext *context;
@end

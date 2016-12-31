//
//  ASMemoryLocationListItem.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/26/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <TDAppKit/TDListItem.h>
#import <AssemblyKit/ASTypes.h>

@class ASContext;

@interface ASMemoryLocationListItem : TDListItem

+ (NSString *)identifier;
+ (CGFloat)defaultHeight;

- (CGRect)stackAddrRectForBounds:(CGRect)bounds;
- (CGRect)valueBorderRectForStackAddrRect:(CGRect)addrRect;
- (CGRect)hexValueRectForValueBorderRect:(CGRect)brect;
- (CGRect)binaryValueRectForValueBorderRect:(CGRect)brect;
- (CGRect)binaryBorderRectForValueBorderRect:(CGRect)brect;
- (CGRect)labelTextRectForStackAddrRect:(CGRect)addrRect;

@property (nonatomic, retain) ASContext *context;
@property (nonatomic, assign) ASDword address;
@property (nonatomic, assign) BOOL isStackPointer;
@property (nonatomic, assign) BOOL isBelowStackPointer;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) BOOL isDwordBoundary;
@end

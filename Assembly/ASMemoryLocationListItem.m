//
//  ASMemoryLocationListItem.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/26/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASMemoryLocationListItem.h"

#import <AssemblyKit/ASUtils.h>
#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASRegister.h>

#define DEFAULT_HEIGHT 20.0

#define FUDGE 0.5
#define TDAlignFloor(x) (floor((x)) + FUDGE)
#define TDRound(x) round((x))

#define ADDR_MARGIN_X 2.0
#define ADDR_MARGIN_Y 0.0

#define LABEL_FONT_SIZE 12.0
#define VALUE_FONT_SIZE 13.0

#define STACK_BORDER_MARGIN_X 6.0
#define STACK_BORDER_MARGIN_Y 10.0
#define STACK_BORDER_HEIGHT 20.0

#define STACK_VALUE_MARGIN_X 4.0
#define STACK_VALUE_MARGIN_Y 2.0
#define STACK_LABEL_MARGIN_X 5.0

static NSColor *sBorderStrokeColor = nil;
static NSColor *sSPBorderStrokeColor = nil;
static NSColor *sBorderFillColor = nil;
static NSColor *sSPBorderFillColor = nil;

static NSDictionary *sLabelAttrs = nil;
static NSDictionary *sSPLabelAttrs = nil;
static NSDictionary *sValueAttrs = nil;

@implementation ASMemoryLocationListItem

+ (void)initialize {
    if ([ASMemoryLocationListItem class] == self) {
        
        sBorderStrokeColor = [[NSColor blackColor] retain];
        sSPBorderStrokeColor = [[NSColor redColor] retain];
        sBorderFillColor = [[NSColor colorWithDeviceWhite:0.8 alpha:1.0] retain];
        sSPBorderFillColor = [[NSColor colorWithDeviceWhite:0.7 alpha:1.0] retain];
        
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        [shadow setShadowColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.51]];
        [shadow setShadowOffset:NSMakeSize(0.0, -1.0)];
        [shadow setShadowBlurRadius:0.0];
        
        NSMutableParagraphStyle *labelParaStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [labelParaStyle setAlignment:NSLeftTextAlignment];
        [labelParaStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
        sLabelAttrs = [@{
                       NSForegroundColorAttributeName: [NSColor blackColor],
                       NSShadowAttributeName: shadow,
                       NSFontAttributeName: [NSFont boldSystemFontOfSize:LABEL_FONT_SIZE],
                       NSParagraphStyleAttributeName: labelParaStyle,
                       } retain];
        
        sSPLabelAttrs = [@{
                         NSForegroundColorAttributeName: [NSColor redColor],
                         NSShadowAttributeName: shadow,
                         NSFontAttributeName: [NSFont boldSystemFontOfSize:LABEL_FONT_SIZE],
                         NSParagraphStyleAttributeName: labelParaStyle,
                         } retain];
        
        NSMutableParagraphStyle *valueParaStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [valueParaStyle setAlignment:NSLeftTextAlignment];
        [valueParaStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
        sValueAttrs = [@{
                       NSForegroundColorAttributeName: [NSColor blackColor],
                       NSShadowAttributeName: shadow,
                       NSFontAttributeName: [NSFont userFixedPitchFontOfSize:VALUE_FONT_SIZE],
                       NSParagraphStyleAttributeName: valueParaStyle,
                       } retain];
    }
}


+ (NSString *)identifier {
    return NSStringFromClass(self);
}


+ (CGFloat)defaultHeight {
    return DEFAULT_HEIGHT;
}


- (id)init {
    self = [self initWithFrame:CGRectZero reuseIdentifier:[[self class] identifier]];
    return self;
}


- (id)initWithFrame:(NSRect)frame reuseIdentifier:(NSString *)s {
    NSParameterAssert(s);
    
    self = [super initWithFrame:frame];
    if (self) {

    }
    
    return self;
}


- (void)dealloc {
    self.context = nil;
    [super dealloc];
}


- (void)drawRect:(NSRect)dirtyRect {
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGRect bounds = [self bounds];
        
    CGRect spValBorderRect = CGRectZero;
    
    CGRect addrRect = [self stackAddrRectForBounds:bounds];
    CGRect valBorderRect = [self valueBorderRectForStackAddrRect:addrRect];
    CGRect hexValRect = [self hexValueRectForValueBorderRect:valBorderRect];
    CGRect binValRect = [self binaryValueRectForValueBorderRect:valBorderRect];
    CGRect binBorderRect = [self binaryBorderRectForValueBorderRect:valBorderRect];
    CGRect hexBorderRect = [self hexBorderRectForValueBorderRect:valBorderRect];
    CGRect labelTextRect = [self labelTextRectForStackAddrRect:addrRect];
    
    NSColor *fillColor = nil;
    NSColor *strokeColor = nil;
    NSDictionary *labelAttrs = nil;
    
    if (_isStackPointer) {
        spValBorderRect = valBorderRect;
        
        fillColor = sSPBorderFillColor;
        strokeColor = sSPBorderStrokeColor;
        labelAttrs = sSPLabelAttrs;
    } else {
        fillColor = sBorderFillColor;
        strokeColor = sBorderStrokeColor;
        labelAttrs = sLabelAttrs;
    }
    [fillColor setFill];
    
    CGContextFillRect(ctx, valBorderRect);
    
    [[NSColor lightGrayColor] setStroke];
    CGContextStrokeRect(ctx, binBorderRect);
    CGContextStrokeRect(ctx, hexBorderRect);

    [strokeColor setStroke];
    
    // left side
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMinX(valBorderRect), CGRectGetMinY(valBorderRect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(valBorderRect), CGRectGetMaxY(valBorderRect));
    CGContextStrokePath(ctx);
    
    // right side
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMaxX(valBorderRect), CGRectGetMinY(valBorderRect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(valBorderRect), CGRectGetMaxY(valBorderRect));
    CGContextStrokePath(ctx);

    if (_isDwordBoundary) {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, CGRectGetMinX(valBorderRect), CGRectGetMinY(valBorderRect));
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(valBorderRect), CGRectGetMinY(valBorderRect));
        CGContextStrokePath(ctx);
    }
    
    if (_isBelowStackPointer) {
        [sSPBorderStrokeColor setStroke];
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, CGRectGetMinX(valBorderRect), CGRectGetMinY(valBorderRect));
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(valBorderRect), CGRectGetMinY(valBorderRect));
        CGContextStrokePath(ctx);
    }
    
    if (_isLast) {
        [(_isStackPointer ? sSPBorderStrokeColor : sBorderStrokeColor) setStroke];
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, CGRectGetMinX(valBorderRect), CGRectGetMaxY(valBorderRect) - 1.0);
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(valBorderRect), CGRectGetMaxY(valBorderRect) - 1.0);
        CGContextStrokePath(ctx);
    }
    
    ASByte val = [_context byteAtMemoryAddress:_address];
    NSString *hexStr = ASHexStringFromByte(val);
    NSString *binStr = ASBinaryStringFromByte(val);
    NSString *addrStr = ASHexStringFromDword(_address);
    
    //        NSLog(@"drawing addr: %@", addrStr);
    //        NSLog(@"val: %@", valStr);
    
    [hexStr drawAtPoint:hexValRect.origin withAttributes:sValueAttrs];
    [binStr drawAtPoint:binValRect.origin withAttributes:sValueAttrs];
    [addrStr drawAtPoint:labelTextRect.origin withAttributes:labelAttrs];
    
    if (!CGRectIsEmpty(spValBorderRect)) {
        [sSPBorderStrokeColor setStroke];
        CGContextStrokeRect(ctx, spValBorderRect);
    }
}


- (CGRect)stackAddrRectForBounds:(CGRect)bounds {
    CGFloat x = TDAlignFloor(CGRectGetMinX(bounds) + ADDR_MARGIN_X);
    CGFloat y = TDAlignFloor(CGRectGetMinY(bounds) + ADDR_MARGIN_Y);
    CGFloat w = TDRound(bounds.size.width - ADDR_MARGIN_X * 2.0);
    CGFloat h = TDRound(bounds.size.height - ADDR_MARGIN_Y * 2.0);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;    
}


- (CGRect)valueBorderRectForStackAddrRect:(CGRect)addrRect {
    CGFloat x = TDAlignFloor(CGRectGetMinX(addrRect) + STACK_BORDER_MARGIN_X);
    CGFloat y = TDAlignFloor(CGRectGetMinY(addrRect));
    CGFloat w = TDRound(addrRect.size.width * 0.6 - STACK_BORDER_MARGIN_X);
    CGFloat h = STACK_BORDER_HEIGHT;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)hexValueRectForValueBorderRect:(CGRect)brect {
    CGFloat x = TDAlignFloor(CGRectGetMaxX(brect) - (STACK_VALUE_MARGIN_X + VALUE_FONT_SIZE * 2.0));
    CGFloat y = TDAlignFloor(CGRectGetMinY(brect));
    CGFloat w = brect.size.width - x;
    CGFloat h = STACK_BORDER_HEIGHT / 2.0;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)hexBorderRectForValueBorderRect:(CGRect)brect {
    CGRect binRect = [self binaryBorderRectForValueBorderRect:brect];
    
    CGFloat w = CGRectGetMaxX(brect) - CGRectGetMaxX(binRect);

    CGFloat x = CGRectGetMaxX(brect) - w;
    CGFloat y = CGRectGetMinY(brect);
    CGFloat h = brect.size.height;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)binaryBorderRectForValueBorderRect:(CGRect)brect {
    CGFloat x = CGRectGetMinX(brect);
    CGFloat y = CGRectGetMinY(brect);
    CGFloat w = TDRound(brect.size.width * 0.69);
    CGFloat h = brect.size.height;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)binaryValueRectForValueBorderRect:(CGRect)brect {
    CGFloat x = TDAlignFloor(CGRectGetMinX(brect) + STACK_VALUE_MARGIN_X);
    CGFloat y = TDAlignFloor(CGRectGetMinY(brect));
    CGFloat w = brect.size.width;
    CGFloat h = STACK_BORDER_HEIGHT / 2.0;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)labelTextRectForStackAddrRect:(CGRect)addrRect {
    CGFloat w = TDRound(addrRect.size.width * 0.38 - STACK_BORDER_MARGIN_X);
    
    CGFloat x = TDRound(CGRectGetMaxX(addrRect) - w);
    CGFloat y = TDAlignFloor(CGRectGetMinY(addrRect) + STACK_VALUE_MARGIN_Y);
    CGFloat h = STACK_BORDER_HEIGHT;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}

@end

//
//  ASEFlagsView.m
//  Assembly
//
//  Created by Todd Ditchendorf on 3/3/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASEFlagsView.h"

#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASEFlagsRegister.h>

#define FUDGE 0.5
#define TDAlignFloor(x) (floor((x)) + FUDGE)
#define TDRound(x) round((x))

#define WORD_MARGIN_X 10.0
#define WORD_MARGIN_TOP 0.0
#define WORD_MARGIN_BOTTOM 7.0

#define VALUE_MARGIN_Y -1

#define NUM_WORD_BITS 16

#define OVERFLOW_BIT_IDX 11
#define DIRECTION_BIT_IDX 10
#define INTERRUPT_BIT_IDX 9
#define SIGN_BIT_IDX 7
#define ZERO_BIT_IDX 6
#define AUX_CARRY_BIT_IDX 4
#define PARITY_BIT_IDX 2
#define CARRY_BIT_IDX 0

static NSColor *sBorderStrokeColor = nil;
static NSColor *sRegisterStrokeColor = nil;
static NSColor *sBorderFillColor = nil;
static NSColor *sRegisterFillColor = nil;
static NSColor *sLabelTextColor = nil;

static NSDictionary *sLabelAttrs = nil;
static NSDictionary *sValueAttrs = nil;

@implementation ASEFlagsView

+ (void)initialize {
    if ([ASEFlagsView class] == self) {
        
        sBorderStrokeColor = [[NSColor blackColor] retain];
        sRegisterStrokeColor = [[NSColor redColor] retain];
        sBorderFillColor = [[NSColor colorWithDeviceWhite:0.7 alpha:1.0] retain];
        sRegisterFillColor = [[NSColor colorWithDeviceWhite:0.8 alpha:1.0] retain];
        sLabelTextColor = [[NSColor blackColor] retain];
        
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        [shadow setShadowColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.51]];
        [shadow setShadowOffset:NSMakeSize(0.0, -1.0)];
        [shadow setShadowBlurRadius:0.0];
        
        NSMutableParagraphStyle *labelParaStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [labelParaStyle setAlignment:NSCenterTextAlignment];
        [labelParaStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
        sLabelAttrs = [@{
            NSForegroundColorAttributeName: [NSColor blackColor],
            NSShadowAttributeName: shadow,
            NSFontAttributeName: [NSFont boldSystemFontOfSize:12.0],
            NSParagraphStyleAttributeName: labelParaStyle,
        } retain];
        
        NSMutableParagraphStyle *valueParaStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [valueParaStyle setAlignment:NSCenterTextAlignment];
        [valueParaStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
        sValueAttrs = [@{
            NSForegroundColorAttributeName: [NSColor blackColor],
            NSShadowAttributeName: shadow,
            NSFontAttributeName: [NSFont userFixedPitchFontOfSize:13.0],
            NSParagraphStyleAttributeName: valueParaStyle,
        } retain];
    }
}


- (void)dealloc {
    self.context = nil;
    [super dealloc];
}


- (void)awakeFromNib {
    
}


- (void)drawRect:(NSRect)dirtyRect {
    NSAssert(_context, @"");
    
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGRect bounds = [self bounds];

    CGRect wrect = [self lowOrderWordRectForBounds:bounds];
    
    for (NSUInteger i = 0; i < NUM_WORD_BITS; ++i) {
        CGRect bitRect = [self bitRectForLowOrderWordRect:wrect atIndex:i];
        CGRect valBorderRect = [self bitValueBorderRectForBitRect:bitRect];
        CGRect valRect = [self bitValueRectForBitRect:bitRect];
        CGRect labelRect = [self bitLabelRectForBitRect:bitRect];
                
        NSString *labelStr = @"";
        BOOL flag = NO;
        
        switch (i) {
            case OVERFLOW_BIT_IDX:
                labelStr = NSLocalizedString(@"O", @"");
                flag = _context.eFlags.overflowFlag;
                break;
            case DIRECTION_BIT_IDX:
                labelStr = NSLocalizedString(@"D", @"");
                flag = _context.eFlags.directionFlag;
                break;
            case INTERRUPT_BIT_IDX:
                labelStr = NSLocalizedString(@"I", @"");
                flag = _context.eFlags.interruptDisableFlag;
                break;
            case SIGN_BIT_IDX:
                labelStr = NSLocalizedString(@"S", @"");
                flag = _context.eFlags.signFlag;
                break;
            case ZERO_BIT_IDX:
                labelStr = NSLocalizedString(@"Z", @"");
                flag = _context.eFlags.zeroFlag;
                break;
            case AUX_CARRY_BIT_IDX:
                labelStr = NSLocalizedString(@"A", @"");
                flag = _context.eFlags.auxiliaryCarryFlag;
                break;
            case PARITY_BIT_IDX:
                labelStr = NSLocalizedString(@"P", @"");
                flag = _context.eFlags.parityFlag;
                break;
            case CARRY_BIT_IDX:
                labelStr = NSLocalizedString(@"C", @"");
                flag = _context.eFlags.carryFlag;
                break;
            default:
                break;
        }
        
        NSColor *fillColor = sBorderFillColor;
        NSColor *strokeColor = sBorderStrokeColor;
        
        if ([labelStr length]) {
            fillColor = sRegisterFillColor;
            //strokeColor = sRegisterStrokeColor;
        }
        
        [fillColor setFill];
        CGContextFillRect(ctx, valBorderRect);

        [strokeColor setStroke];
        CGContextStrokeRect(ctx, valBorderRect);

        NSString *valStr = flag ? @"1" : @"0";
        
        [labelStr drawInRect:labelRect withAttributes:sLabelAttrs];
        [valStr drawInRect:valRect withAttributes:sValueAttrs];
    }
}


- (CGRect)lowOrderWordRectForBounds:(CGRect)bounds {
    CGFloat x = TDAlignFloor(CGRectGetMinX(bounds) + WORD_MARGIN_X);
    CGFloat y = TDAlignFloor(CGRectGetMinY(bounds) + WORD_MARGIN_TOP);
    CGFloat w = bounds.size.width - WORD_MARGIN_X * 2.0;
    CGFloat h = bounds.size.height - (WORD_MARGIN_TOP + WORD_MARGIN_BOTTOM);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)bitRectForLowOrderWordRect:(CGRect)wrect atIndex:(NSUInteger)idx {
    CGFloat w = wrect.size.width / NUM_WORD_BITS;

    CGFloat x = TDAlignFloor(CGRectGetMaxX(wrect) - w * (idx + 1));
    CGFloat y = TDAlignFloor(CGRectGetMinY(wrect));
    CGFloat h = TDRound(wrect.size.height);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)bitValueBorderRectForBitRect:(CGRect)bitRect {
    CGFloat h = TDRound(bitRect.size.height / 2.0);

    CGFloat x = TDAlignFloor(CGRectGetMinX(bitRect));
    CGFloat y = TDAlignFloor(CGRectGetMaxY(bitRect) - h);
    CGFloat w = ceil(bitRect.size.width);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)bitValueRectForBitRect:(CGRect)bitRect {
    CGRect r = [self bitValueBorderRectForBitRect:bitRect];
    r.origin.y += VALUE_MARGIN_Y;
    return r;
}


- (CGRect)bitLabelRectForBitRect:(CGRect)bitRect {
    CGFloat x = TDAlignFloor(CGRectGetMinX(bitRect));
    CGFloat y = TDAlignFloor(CGRectGetMinY(bitRect) + VALUE_MARGIN_Y);
    CGFloat w = bitRect.size.width;
    CGFloat h = TDRound(bitRect.size.height / 2.0);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}

@end

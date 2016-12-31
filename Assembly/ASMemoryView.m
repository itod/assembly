//
//  ASMemoryView.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/22/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASMemoryView.h"
#import <AssemblyKit/ASUtils.h>
#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASRegister.h>

#define FUDGE 0.5
#define TDAlignFloor(x) (floor((x)) + FUDGE)
#define TDRound(x) round((x))

#define LABEL_FONT_SIZE 12.0
#define VALUE_FONT_SIZE 13.0

#define STACK_BORDER_MARGIN_X 10.0
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

@interface ASMemoryView ()

@end

@implementation ASMemoryView

+ (void)initialize {
    if ([ASMemoryView class] == self) {
        
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


- (void)dealloc {
    self.context = nil;
    [super dealloc];
}


- (void)awakeFromNib {
    
}


- (void)drawRect:(NSRect)dirtyRect {
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGRect bounds = [self bounds];

    CGRect stackRect = [self stackRectForBounds:bounds];

    ASDword spAddr = _context.esp.dwordValue;
    ASDword addr = 0xFFFFFFFF;
    NSInteger numAddrs = 50;
    
    CGRect spValBorderRect = CGRectZero;
    
    for (NSInteger i = 0; i < numAddrs; ++i) {
        CGRect addrRect = [self stackAddrRectForStackRect:stackRect atIndex:i];
        CGRect valBorderRect = [self valueBorderRectForStackAddrRect:addrRect];
        CGRect hexValRect = [self hexValueRectForValueBorderRect:valBorderRect];
        CGRect binValRect = [self binaryValueRectForValueBorderRect:valBorderRect];
        CGRect binBorderRect = [self binaryBorderRectForValueBorderRect:valBorderRect];
        CGRect labelTextRect = [self labelTextRectForStackAddrRect:addrRect];

        NSColor *fillColor = nil;
        NSColor *strokeColor = nil;
        NSDictionary *labelAttrs = nil;
        
        if (addr == spAddr) {
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

        [[NSColor grayColor] setStroke];
        CGContextStrokeRect(ctx, binBorderRect);
        
        [strokeColor setStroke];
        CGContextStrokeRect(ctx, valBorderRect);
        
        ASByte val = [_context byteAtMemoryAddress:addr];
        NSString *hexStr = ASHexStringFromByte(val);
        NSString *binStr = ASBinaryStringFromByte(val);
        NSString *addrStr = ASHexStringFromDword(addr);
        
//        NSLog(@"drawing addr: %@", addrStr);
//        NSLog(@"val: %@", valStr);
        
        [hexStr drawAtPoint:hexValRect.origin withAttributes:sValueAttrs];
        [binStr drawAtPoint:binValRect.origin withAttributes:sValueAttrs];
        [addrStr drawAtPoint:labelTextRect.origin withAttributes:labelAttrs];
        --addr;
    }
    
    if (!CGRectIsEmpty(spValBorderRect)) {
        [sSPBorderStrokeColor setStroke];
        CGContextStrokeRect(ctx, spValBorderRect);
    }
}


#pragma mark -
#pragma mark Rects

- (CGRect)stackRectForBounds:(CGRect)bounds {
    return bounds;
//    CGFloat w = bounds.size.width / 3.0;
//    
//    CGFloat x = TDAlignFloor(CGRectGetMaxX(bounds) - w);
//    CGFloat y = CGRectGetMinY(bounds);
//    CGFloat h = bounds.size.height;
//    
//    CGRect r = CGRectMake(x, y, w, h);
//    return r;
}


- (CGRect)stackAddrRectForStackRect:(CGRect)stackRect atIndex:(NSUInteger)idx {
    CGFloat x = CGRectGetMinX(stackRect);
    CGFloat y = TDAlignFloor(CGRectGetMinY(stackRect) + STACK_BORDER_MARGIN_Y + (idx * STACK_BORDER_HEIGHT));
    CGFloat w = stackRect.size.width;
    CGFloat h = STACK_BORDER_HEIGHT;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)valueBorderRectForStackAddrRect:(CGRect)addrRect {
    CGFloat x = TDAlignFloor(CGRectGetMinX(addrRect) + STACK_BORDER_MARGIN_X);
    CGFloat y = TDAlignFloor(CGRectGetMinY(addrRect));
    CGFloat w = TDRound(addrRect.size.width * 0.63 - STACK_BORDER_MARGIN_X);
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
    CGFloat w = TDRound(addrRect.size.width * 0.37 - STACK_BORDER_MARGIN_X);

    CGFloat x = TDRound(CGRectGetMaxX(addrRect) - w);
    CGFloat y = TDAlignFloor(CGRectGetMinY(addrRect) + STACK_VALUE_MARGIN_Y);
    CGFloat h = STACK_BORDER_HEIGHT;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}

@end

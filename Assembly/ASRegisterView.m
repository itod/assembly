//
//  ASRegisterView.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASRegisterView.h"

#import <AssemblyKit/ASContext.h>
#import "ASExpression.h"
#import <AssemblyKit/ASRegister.h>

#define FUDGE 0.5
#define TDAlignFloor(x) (floor((x)) + FUDGE)
#define TDRound(x) round((x))

#define NUM_VERT_REGISTERS 4.0

#define BORDER_MARGIN_X 10.0
#define BORDER_MARGIN_Y 10.0

#define LABEL_MARGIN_X 5.0
#define LABEL_MARGIN_Y 0.0

#define VAL_MARGIN_X 4.0

#define REGISTER_MARGIN_X 0.0
#define REGISTER_MARGIN_Y 0.0

#define X_REGISTER_HEIGHT_RATIO 0.9
#define HL_REGISTER_HEIGHT_RATIO 0.7

static NSColor *sBorderStrokeColor = nil;
static NSColor *sRegisterStrokeColor = nil;
static NSColor *sBorderFillColor = nil;
static NSColor *sRegisterFillColor = nil;
static NSColor *sLabelTextColor = nil;

static NSDictionary *sLabelAttrs = nil;
static NSDictionary *sValueAttrs = nil;

@implementation ASRegisterView

+ (void)initialize {
    if ([ASRegisterView class] == self) {
        
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
        [labelParaStyle setAlignment:NSLeftTextAlignment];
        [labelParaStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
        sLabelAttrs = [@{
            NSForegroundColorAttributeName: [NSColor blackColor],
            NSShadowAttributeName: shadow,
            NSFontAttributeName: [NSFont boldSystemFontOfSize:12.0],
            NSParagraphStyleAttributeName: labelParaStyle,
        } retain];
        
        NSMutableParagraphStyle *valueParaStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [valueParaStyle setAlignment:NSLeftTextAlignment];
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
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGRect bounds = [self bounds];
    
    CGRect lrect = [self leftRectForBounds:bounds];
    CGRect rrect = [self rightRectForBounds:bounds];
    
    CGRect eaxBorderRect = [self dwordBorderRectForLeftRightRect:lrect atIndex:0];
    CGRect ebxBorderRect = [self dwordBorderRectForLeftRightRect:lrect atIndex:1];
    CGRect ecxBorderRect = [self dwordBorderRectForLeftRightRect:lrect atIndex:2];
    CGRect edxBorderRect = [self dwordBorderRectForLeftRightRect:lrect atIndex:3];
    
    CGRect eaxRect = [self dwordRegisterRectForBorderRect:eaxBorderRect];
    CGRect ebxRect = [self dwordRegisterRectForBorderRect:ebxBorderRect];
    CGRect ecxRect = [self dwordRegisterRectForBorderRect:ecxBorderRect];
    CGRect edxRect = [self dwordRegisterRectForBorderRect:edxBorderRect];
    
    [sBorderFillColor setFill];
    CGContextFillRect(ctx, eaxBorderRect);
    CGContextFillRect(ctx, ebxBorderRect);
    CGContextFillRect(ctx, ecxBorderRect);
    CGContextFillRect(ctx, edxBorderRect);
    
    [sBorderStrokeColor setStroke];
    CGContextStrokeRect(ctx, eaxBorderRect);
    CGContextStrokeRect(ctx, ebxBorderRect);
    CGContextStrokeRect(ctx, ecxBorderRect);
    CGContextStrokeRect(ctx, edxBorderRect);

    [sRegisterFillColor setFill];
    CGContextFillRect(ctx, eaxRect);
    CGContextFillRect(ctx, ebxRect);
    CGContextFillRect(ctx, ecxRect);
    CGContextFillRect(ctx, edxRect);
    
    [sRegisterStrokeColor setStroke];
    CGContextStrokeRect(ctx, eaxRect);
    CGContextStrokeRect(ctx, ebxRect);
    CGContextStrokeRect(ctx, ecxRect);
    CGContextStrokeRect(ctx, edxRect);
    
    CGRect eaxLabelRect = [self labelRectForBorderRect:eaxBorderRect];
    CGRect ebxLabelRect = [self labelRectForBorderRect:ebxBorderRect];
    CGRect ecxLabelRect = [self labelRectForBorderRect:ecxBorderRect];
    CGRect edxLabelRect = [self labelRectForBorderRect:edxBorderRect];
    
    [_context.eax.name drawAtPoint:eaxLabelRect.origin withAttributes:sLabelAttrs];
    [_context.ebx.name drawAtPoint:ebxLabelRect.origin withAttributes:sLabelAttrs];
    [_context.ecx.name drawAtPoint:ecxLabelRect.origin withAttributes:sLabelAttrs];
    [_context.edx.name drawAtPoint:edxLabelRect.origin withAttributes:sLabelAttrs];
    
    CGRect axBorderRect = [self wordBorderRectForDwordBorderRect:eaxBorderRect];
    CGRect bxBorderRect = [self wordBorderRectForDwordBorderRect:ebxBorderRect];
    CGRect cxBorderRect = [self wordBorderRectForDwordBorderRect:ecxBorderRect];
    CGRect dxBorderRect = [self wordBorderRectForDwordBorderRect:edxBorderRect];
    
    CGRect axRect = [self wordRegisterRectForDwordBorderRect:eaxBorderRect];
    CGRect bxRect = [self wordRegisterRectForDwordBorderRect:ebxBorderRect];
    CGRect cxRect = [self wordRegisterRectForDwordBorderRect:ecxBorderRect];
    CGRect dxRect = [self wordRegisterRectForDwordBorderRect:edxBorderRect];
    
    [sBorderFillColor setFill];
    CGContextFillRect(ctx, axBorderRect);
    CGContextFillRect(ctx, bxBorderRect);
    CGContextFillRect(ctx, cxBorderRect);
    CGContextFillRect(ctx, dxBorderRect);
    
    [sBorderStrokeColor setStroke];
    CGContextStrokeRect(ctx, axBorderRect);
    CGContextStrokeRect(ctx, bxBorderRect);
    CGContextStrokeRect(ctx, cxBorderRect);
    CGContextStrokeRect(ctx, dxBorderRect);
    
    [sRegisterFillColor setFill];
    CGContextFillRect(ctx, axRect);
    CGContextFillRect(ctx, bxRect);
    CGContextFillRect(ctx, cxRect);
    CGContextFillRect(ctx, dxRect);
    
    [sRegisterStrokeColor setStroke];
    CGContextStrokeRect(ctx, axRect);
    CGContextStrokeRect(ctx, bxRect);
    CGContextStrokeRect(ctx, cxRect);
    CGContextStrokeRect(ctx, dxRect);
    
    CGRect axLabelRect = [self labelRectForBorderRect:axBorderRect];
    CGRect bxLabelRect = [self labelRectForBorderRect:bxBorderRect];
    CGRect cxLabelRect = [self labelRectForBorderRect:cxBorderRect];
    CGRect dxLabelRect = [self labelRectForBorderRect:dxBorderRect];
    
    [_context.ax.name drawAtPoint:axLabelRect.origin withAttributes:sLabelAttrs];
    [_context.bx.name drawAtPoint:bxLabelRect.origin withAttributes:sLabelAttrs];
    [_context.cx.name drawAtPoint:cxLabelRect.origin withAttributes:sLabelAttrs];
    [_context.dx.name drawAtPoint:dxLabelRect.origin withAttributes:sLabelAttrs];

    CGRect ahBorderRect = [self hBorderRectForDwordBorderRect:eaxBorderRect];
    CGRect alBorderRect = [self lBorderRectForDwordBorderRect:eaxBorderRect];
    CGRect bhBorderRect = [self hBorderRectForDwordBorderRect:ebxBorderRect];
    CGRect blBorderRect = [self lBorderRectForDwordBorderRect:ebxBorderRect];
    CGRect chBorderRect = [self hBorderRectForDwordBorderRect:ecxBorderRect];
    CGRect clBorderRect = [self lBorderRectForDwordBorderRect:ecxBorderRect];
    CGRect dhBorderRect = [self hBorderRectForDwordBorderRect:edxBorderRect];
    CGRect dlBorderRect = [self lBorderRectForDwordBorderRect:edxBorderRect];
    
    CGRect ahRect = [self hRegisterRectForDwordBorderRect:eaxBorderRect];
    CGRect alRect = [self lRegisterRectForDwordBorderRect:eaxBorderRect];
    CGRect bhRect = [self hRegisterRectForDwordBorderRect:ebxBorderRect];
    CGRect blRect = [self lRegisterRectForDwordBorderRect:ebxBorderRect];
    CGRect chRect = [self hRegisterRectForDwordBorderRect:ecxBorderRect];
    CGRect clRect = [self lRegisterRectForDwordBorderRect:ecxBorderRect];
    CGRect dhRect = [self hRegisterRectForDwordBorderRect:edxBorderRect];
    CGRect dlRect = [self lRegisterRectForDwordBorderRect:edxBorderRect];
    
    [sBorderFillColor setFill];
    CGContextFillRect(ctx, ahBorderRect);
    CGContextFillRect(ctx, alBorderRect);
    CGContextFillRect(ctx, bhBorderRect);
    CGContextFillRect(ctx, blBorderRect);
    CGContextFillRect(ctx, chBorderRect);
    CGContextFillRect(ctx, clBorderRect);
    CGContextFillRect(ctx, dhBorderRect);
    CGContextFillRect(ctx, dlBorderRect);
    
    [sBorderStrokeColor setStroke];
    CGContextStrokeRect(ctx, ahBorderRect);
    CGContextStrokeRect(ctx, alBorderRect);
    CGContextStrokeRect(ctx, bhBorderRect);
    CGContextStrokeRect(ctx, blBorderRect);
    CGContextStrokeRect(ctx, chBorderRect);
    CGContextStrokeRect(ctx, clBorderRect);
    CGContextStrokeRect(ctx, dhBorderRect);
    CGContextStrokeRect(ctx, dlBorderRect);
    
    [sRegisterFillColor setFill];
    CGContextFillRect(ctx, ahRect);
    CGContextFillRect(ctx, alRect);
    CGContextFillRect(ctx, bhRect);
    CGContextFillRect(ctx, blRect);
    CGContextFillRect(ctx, chRect);
    CGContextFillRect(ctx, clRect);
    CGContextFillRect(ctx, dhRect);
    CGContextFillRect(ctx, dlRect);
    
    [sRegisterStrokeColor setStroke];
    CGContextStrokeRect(ctx, ahRect);
    CGContextStrokeRect(ctx, alRect);
    CGContextStrokeRect(ctx, bhRect);
    CGContextStrokeRect(ctx, blRect);
    CGContextStrokeRect(ctx, chRect);
    CGContextStrokeRect(ctx, clRect);
    CGContextStrokeRect(ctx, dhRect);
    CGContextStrokeRect(ctx, dlRect);
    
    CGRect ahLabelRect = [self labelRectForBorderRect:ahBorderRect];
    CGRect alLabelRect = [self labelRectForBorderRect:alBorderRect];
    CGRect bhLabelRect = [self labelRectForBorderRect:bhBorderRect];
    CGRect blLabelRect = [self labelRectForBorderRect:blBorderRect];
    CGRect chLabelRect = [self labelRectForBorderRect:chBorderRect];
    CGRect clLabelRect = [self labelRectForBorderRect:clBorderRect];
    CGRect dhLabelRect = [self labelRectForBorderRect:dhBorderRect];
    CGRect dlLabelRect = [self labelRectForBorderRect:dlBorderRect];
    
    [_context.ah.name drawAtPoint:ahLabelRect.origin withAttributes:sLabelAttrs];
    [_context.al.name drawAtPoint:alLabelRect.origin withAttributes:sLabelAttrs];
    [_context.bh.name drawAtPoint:bhLabelRect.origin withAttributes:sLabelAttrs];
    [_context.bl.name drawAtPoint:blLabelRect.origin withAttributes:sLabelAttrs];
    [_context.ch.name drawAtPoint:chLabelRect.origin withAttributes:sLabelAttrs];
    [_context.cl.name drawAtPoint:clLabelRect.origin withAttributes:sLabelAttrs];
    [_context.dh.name drawAtPoint:dhLabelRect.origin withAttributes:sLabelAttrs];
    [_context.dl.name drawAtPoint:dlLabelRect.origin withAttributes:sLabelAttrs];
    
    CGRect esiBorderRect = [self dwordBorderRectForLeftRightRect:rrect atIndex:0];
    CGRect ediBorderRect = [self dwordBorderRectForLeftRightRect:rrect atIndex:1];
    CGRect ebpBorderRect = [self dwordBorderRectForLeftRightRect:rrect atIndex:2];
    CGRect espBorderRect = [self dwordBorderRectForLeftRightRect:rrect atIndex:3];
    
    CGRect esiRect = [self dwordRegisterRectForBorderRect:esiBorderRect];
    CGRect ediRect = [self dwordRegisterRectForBorderRect:ediBorderRect];
    CGRect ebpRect = [self dwordRegisterRectForBorderRect:ebpBorderRect];
    CGRect espRect = [self dwordRegisterRectForBorderRect:espBorderRect];
    
    [sBorderFillColor setFill];
    CGContextFillRect(ctx, esiBorderRect);
    CGContextFillRect(ctx, ediBorderRect);
    CGContextFillRect(ctx, ebpBorderRect);
    CGContextFillRect(ctx, espBorderRect);
    
    [sBorderStrokeColor setStroke];
    CGContextStrokeRect(ctx, esiBorderRect);
    CGContextStrokeRect(ctx, ediBorderRect);
    CGContextStrokeRect(ctx, ebpBorderRect);
    CGContextStrokeRect(ctx, espBorderRect);
    
    [sRegisterFillColor setFill];
    CGContextFillRect(ctx, esiRect);
    CGContextFillRect(ctx, ediRect);
    CGContextFillRect(ctx, ebpRect);
    CGContextFillRect(ctx, espRect);
    
    [sRegisterStrokeColor setStroke];
    CGContextStrokeRect(ctx, esiRect);
    CGContextStrokeRect(ctx, ediRect);
    CGContextStrokeRect(ctx, ebpRect);
    CGContextStrokeRect(ctx, espRect);
    
    CGRect esiLabelRect = [self labelRectForBorderRect:esiBorderRect];
    CGRect ediLabelRect = [self labelRectForBorderRect:ediBorderRect];
    CGRect ebpLabelRect = [self labelRectForBorderRect:ebpBorderRect];
    CGRect espLabelRect = [self labelRectForBorderRect:espBorderRect];
    
    [_context.esi.name drawAtPoint:esiLabelRect.origin withAttributes:sLabelAttrs];
    [_context.edi.name drawAtPoint:ediLabelRect.origin withAttributes:sLabelAttrs];
    [_context.ebp.name drawAtPoint:ebpLabelRect.origin withAttributes:sLabelAttrs];
    [_context.esp.name drawAtPoint:espLabelRect.origin withAttributes:sLabelAttrs];
    
    CGRect siBorderRect = [self wordBorderRectForDwordBorderRect:esiBorderRect];
    CGRect diBorderRect = [self wordBorderRectForDwordBorderRect:ediBorderRect];
    CGRect bpBorderRect = [self wordBorderRectForDwordBorderRect:ebpBorderRect];
    CGRect spBorderRect = [self wordBorderRectForDwordBorderRect:espBorderRect];
    
    CGRect siRect = [self wordRegisterRectForDwordBorderRect:esiBorderRect];
    CGRect diRect = [self wordRegisterRectForDwordBorderRect:ediBorderRect];
    CGRect bpRect = [self wordRegisterRectForDwordBorderRect:ebpBorderRect];
    CGRect spRect = [self wordRegisterRectForDwordBorderRect:espBorderRect];
    
    [sBorderFillColor setFill];
    CGContextFillRect(ctx, siBorderRect);
    CGContextFillRect(ctx, diBorderRect);
    CGContextFillRect(ctx, bpBorderRect);
    CGContextFillRect(ctx, spBorderRect);
    
    [sBorderStrokeColor setStroke];
    CGContextStrokeRect(ctx, siBorderRect);
    CGContextStrokeRect(ctx, diBorderRect);
    CGContextStrokeRect(ctx, bpBorderRect);
    CGContextStrokeRect(ctx, spBorderRect);
    
    [sRegisterFillColor setFill];
    CGContextFillRect(ctx, siRect);
    CGContextFillRect(ctx, diRect);
    CGContextFillRect(ctx, bpRect);
    CGContextFillRect(ctx, spRect);
    
    [sRegisterStrokeColor setStroke];
    CGContextStrokeRect(ctx, siRect);
    CGContextStrokeRect(ctx, diRect);
    CGContextStrokeRect(ctx, bpRect);
    CGContextStrokeRect(ctx, spRect);
    
    CGRect siLabelRect = [self labelRectForBorderRect:siBorderRect];
    CGRect diLabelRect = [self labelRectForBorderRect:diBorderRect];
    CGRect bpLabelRect = [self labelRectForBorderRect:bpBorderRect];
    CGRect spLabelRect = [self labelRectForBorderRect:spBorderRect];
    
    [_context.si.name drawAtPoint:siLabelRect.origin withAttributes:sLabelAttrs];
    [_context.di.name drawAtPoint:diLabelRect.origin withAttributes:sLabelAttrs];
    [_context.bp.name drawAtPoint:bpLabelRect.origin withAttributes:sLabelAttrs];
    [_context.sp.name drawAtPoint:spLabelRect.origin withAttributes:sLabelAttrs];
    
    [[_context.al asHexString] drawInRect:[self hexValueRectForRegisterRect:alRect] withAttributes:sValueAttrs];
    [[_context.ah asHexString] drawInRect:[self hexValueRectForRegisterRect:ahRect] withAttributes:sValueAttrs];
    [[_context.eax hexStringForWordAtIndex:1] drawInRect:[self hexValueRectForRegisterRect:eaxRect] withAttributes:sValueAttrs];
    
    [[_context.al asBinaryString] drawInRect:[self binValueRectForRegisterRect:alRect] withAttributes:sValueAttrs];
    [[_context.ah asBinaryString] drawInRect:[self binValueRectForRegisterRect:ahRect] withAttributes:sValueAttrs];
    [[_context.eax binaryStringForWordAtIndex:1] drawInRect:[self binValueRectForRegisterRect:eaxRect] withAttributes:sValueAttrs];
    
    [[_context.bl asHexString] drawInRect:[self hexValueRectForRegisterRect:blRect] withAttributes:sValueAttrs];
    [[_context.bh asHexString] drawInRect:[self hexValueRectForRegisterRect:bhRect] withAttributes:sValueAttrs];
    [[_context.ebx hexStringForWordAtIndex:1] drawInRect:[self hexValueRectForRegisterRect:ebxRect] withAttributes:sValueAttrs];

    [[_context.bl asBinaryString] drawInRect:[self binValueRectForRegisterRect:blRect] withAttributes:sValueAttrs];
    [[_context.bh asBinaryString] drawInRect:[self binValueRectForRegisterRect:bhRect] withAttributes:sValueAttrs];
    [[_context.ebx binaryStringForWordAtIndex:1] drawInRect:[self binValueRectForRegisterRect:ebxRect] withAttributes:sValueAttrs];
    
    [[_context.cl asHexString] drawInRect:[self hexValueRectForRegisterRect:clRect] withAttributes:sValueAttrs];
    [[_context.ch asHexString] drawInRect:[self hexValueRectForRegisterRect:chRect] withAttributes:sValueAttrs];
    [[_context.ecx hexStringForWordAtIndex:1] drawInRect:[self hexValueRectForRegisterRect:ecxRect] withAttributes:sValueAttrs];

    [[_context.cl asBinaryString] drawInRect:[self binValueRectForRegisterRect:clRect] withAttributes:sValueAttrs];
    [[_context.ch asBinaryString] drawInRect:[self binValueRectForRegisterRect:chRect] withAttributes:sValueAttrs];
    [[_context.ecx binaryStringForWordAtIndex:1] drawInRect:[self binValueRectForRegisterRect:ecxRect] withAttributes:sValueAttrs];
    
    [[_context.dl asHexString] drawInRect:[self hexValueRectForRegisterRect:dlRect] withAttributes:sValueAttrs];
    [[_context.dh asHexString] drawInRect:[self hexValueRectForRegisterRect:dhRect] withAttributes:sValueAttrs];
    [[_context.edx hexStringForWordAtIndex:1] drawInRect:[self hexValueRectForRegisterRect:edxRect] withAttributes:sValueAttrs];

    [[_context.dl asBinaryString] drawInRect:[self binValueRectForRegisterRect:dlRect] withAttributes:sValueAttrs];
    [[_context.dh asBinaryString] drawInRect:[self binValueRectForRegisterRect:dhRect] withAttributes:sValueAttrs];
    [[_context.edx binaryStringForWordAtIndex:1] drawInRect:[self binValueRectForRegisterRect:edxRect] withAttributes:sValueAttrs];
    
    [[_context.si asHexString] drawInRect:[self hexValueRectForRegisterRect:siRect] withAttributes:sValueAttrs];
    [[_context.esi hexStringForWordAtIndex:1] drawInRect:[self hexValueRectForRegisterRect:esiRect] withAttributes:sValueAttrs];

    [[_context.si asBinaryString] drawInRect:[self binValueRectForRegisterRect:siRect] withAttributes:sValueAttrs];
    [[_context.esi binaryStringForWordAtIndex:1] drawInRect:[self binValueRectForRegisterRect:esiRect] withAttributes:sValueAttrs];
    
    [[_context.di asHexString] drawInRect:[self hexValueRectForRegisterRect:diRect] withAttributes:sValueAttrs];
    [[_context.edi hexStringForWordAtIndex:1] drawInRect:[self hexValueRectForRegisterRect:ediRect] withAttributes:sValueAttrs];

    [[_context.di asBinaryString] drawInRect:[self binValueRectForRegisterRect:diRect] withAttributes:sValueAttrs];
    [[_context.edi binaryStringForWordAtIndex:1] drawInRect:[self binValueRectForRegisterRect:ediRect] withAttributes:sValueAttrs];
    
    [[_context.bp asHexString] drawInRect:[self hexValueRectForRegisterRect:bpRect] withAttributes:sValueAttrs];
    [[_context.ebp hexStringForWordAtIndex:1] drawInRect:[self hexValueRectForRegisterRect:ebpRect] withAttributes:sValueAttrs];

    [[_context.bp asBinaryString] drawInRect:[self binValueRectForRegisterRect:bpRect] withAttributes:sValueAttrs];
    [[_context.ebp binaryStringForWordAtIndex:1] drawInRect:[self binValueRectForRegisterRect:ebpRect] withAttributes:sValueAttrs];
    
    [[_context.sp asHexString] drawInRect:[self hexValueRectForRegisterRect:spRect] withAttributes:sValueAttrs];
    [[_context.esp hexStringForWordAtIndex:1] drawInRect:[self hexValueRectForRegisterRect:espRect] withAttributes:sValueAttrs];

    [[_context.sp asBinaryString] drawInRect:[self binValueRectForRegisterRect:spRect] withAttributes:sValueAttrs];
    [[_context.esp binaryStringForWordAtIndex:1] drawInRect:[self binValueRectForRegisterRect:espRect] withAttributes:sValueAttrs];
    
}


#pragma mark -
#pragma mark Rects

- (CGRect)leftRectForBounds:(CGRect)bounds {
    CGFloat x = TDAlignFloor(CGRectGetMinX(bounds));
    CGFloat y = TDAlignFloor(CGRectGetMinY(bounds));
    CGFloat w = TDRound(bounds.size.width / 2.0 + BORDER_MARGIN_X * 0.5);
    CGFloat h = TDRound(bounds.size.height);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)rightRectForBounds:(CGRect)bounds {
    CGFloat x = TDAlignFloor(CGRectGetMidX(bounds) - BORDER_MARGIN_X * 0.5);
    CGFloat y = TDAlignFloor(CGRectGetMinY(bounds));
    CGFloat w = TDRound(bounds.size.width / 2.0 + BORDER_MARGIN_X * 0.5);
    CGFloat h = TDRound(bounds.size.height);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)labelRectForBorderRect:(CGRect)brect {
    CGFloat x = (CGRectGetMinX(brect) + LABEL_MARGIN_X);
    CGFloat y = (CGRectGetMinY(brect) + LABEL_MARGIN_Y);
    CGFloat w = 0.0;
    CGFloat h = 0.0;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)dwordBorderRectForLeftRightRect:(CGRect)lrect atIndex:(NSInteger)idx {
    CGFloat h = TDRound(((lrect.size.height - BORDER_MARGIN_Y) / NUM_VERT_REGISTERS) - BORDER_MARGIN_Y);
    
    CGFloat x = TDAlignFloor(CGRectGetMinX(lrect) + BORDER_MARGIN_X);
    CGFloat y = TDAlignFloor(CGRectGetMinY(lrect) + BORDER_MARGIN_Y * (idx + 1.0) + (idx * h));
    CGFloat w = TDRound(lrect.size.width - BORDER_MARGIN_X * 2.0);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)dwordRegisterRectForBorderRect:(CGRect)brect {
    CGFloat x = TDAlignFloor(CGRectGetMinX(brect) + REGISTER_MARGIN_X);
    CGFloat y = TDAlignFloor(CGRectGetMidY(brect));
    CGFloat w = TDRound(brect.size.width - REGISTER_MARGIN_X * 2.0);
    CGFloat h = TDRound(brect.size.height / 2.0 - REGISTER_MARGIN_Y);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)wordBorderRectForDwordBorderRect:(CGRect)brect {
    CGFloat w = TDRound(brect.size.width / 2.0);
    CGFloat h = TDRound(brect.size.height * X_REGISTER_HEIGHT_RATIO);

    CGFloat x = CGRectGetMaxX(brect) - w;
    CGFloat y = TDAlignFloor(CGRectGetMinY(brect) + (brect.size.height - h));
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)wordRegisterRectForDwordBorderRect:(CGRect)brect {
    CGFloat w = TDRound(brect.size.width / 2.0);

    CGFloat x = CGRectGetMaxX(brect) - w;
    CGFloat y = TDAlignFloor(CGRectGetMidY(brect));
    CGFloat h = TDRound(brect.size.height / 2.0);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)hBorderRectForDwordBorderRect:(CGRect)brect {
    CGFloat h = TDRound(brect.size.height * HL_REGISTER_HEIGHT_RATIO);
    
    CGFloat x = CGRectGetMaxX(brect) - (TDRound(brect.size.width / 2.0));
    CGFloat y = TDAlignFloor(CGRectGetMinY(brect) + (brect.size.height - h));

    CGRect lBorderRect = [self lBorderRectForDwordBorderRect:brect];
    CGFloat w = lBorderRect.origin.x - x;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)lBorderRectForDwordBorderRect:(CGRect)brect {
    CGFloat w = TDRound(brect.size.width / 4.0);
    CGFloat h = TDRound(brect.size.height * HL_REGISTER_HEIGHT_RATIO);

    CGFloat x = CGRectGetMaxX(brect) - w;
    CGFloat y = TDAlignFloor(CGRectGetMinY(brect) + (brect.size.height - h));
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)hRegisterRectForDwordBorderRect:(CGRect)brect {
    CGRect hBorderRect = [self hBorderRectForDwordBorderRect:brect];

    CGFloat x = hBorderRect.origin.x;
    CGFloat y = TDAlignFloor(CGRectGetMidY(brect));
    CGFloat w = hBorderRect.size.width;
    CGFloat h = TDRound(brect.size.height / 2.0);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)lRegisterRectForDwordBorderRect:(CGRect)brect {
    CGRect lBorderRect = [self lBorderRectForDwordBorderRect:brect];

    CGFloat x = lBorderRect.origin.x;
    CGFloat y = TDAlignFloor(CGRectGetMidY(brect));
    CGFloat w = lBorderRect.size.width;
    CGFloat h = TDRound(brect.size.height / 2.0);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)hexValueRectForRegisterRect:(CGRect)rrect {
    CGFloat x = TDAlignFloor(CGRectGetMinX(rrect) + VAL_MARGIN_X);
    CGFloat y = TDAlignFloor(CGRectGetMinY(rrect));
    CGFloat w = rrect.size.width - VAL_MARGIN_X * 2.0;
    CGFloat h = TDRound(rrect.size.height / 2.0);
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}


- (CGRect)binValueRectForRegisterRect:(CGRect)rrect {
    CGFloat h = TDRound(rrect.size.height / 2.0);

    CGFloat x = TDAlignFloor(CGRectGetMinX(rrect) + VAL_MARGIN_X);
    CGFloat y = TDAlignFloor(CGRectGetMinY(rrect) + h);
    CGFloat w = rrect.size.width - VAL_MARGIN_X;
    
    CGRect r = CGRectMake(x, y, w, h);
    return r;
}

@end

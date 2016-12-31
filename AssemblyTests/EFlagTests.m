//
//  EFlagTests.m
//  EFlagTests
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "EFlagTests.h"

@implementation EFlagTests

- (void)setUp {
    [super setUp];
    
    self.ctx = [[[ASContext alloc] initWithDelegate:nil] autorelease];

    _ctx.eFlags.dwordValue = 0;
}


- (void)tearDown {
    self.ctx = nil;
    
    [super tearDown];
}

	
- (void)testSignAndZeroFlagOn {
    ASDword signOnly = 0x80;
    ASDword zeroOnly = 0x40;
    ASDword both = signOnly | zeroOnly;
    
    _ctx.eFlags.signFlag = YES;
    _ctx.eFlags.zeroFlag = YES;
    
    TDEquals(both, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.signFlag);
    TDEquals(YES, _ctx.eFlags.zeroFlag);

    TDEquals(NO, _ctx.eFlags.carryFlag);
    TDEquals(NO, _ctx.eFlags.overflowFlag);
    TDEquals(NO, _ctx.eFlags.directionFlag);
    TDEquals(NO, _ctx.eFlags.auxiliaryCarryFlag);
    TDEquals(NO, _ctx.eFlags.interruptDisableFlag);
    TDEquals(NO, _ctx.eFlags.parityFlag);
}


- (void)testSignAndZeroAndCarryFlagOn {
    ASDword signOnly = 0x80;
    ASDword zeroOnly = 0x40;
    ASDword carryOnly = 0x1;
    ASDword all = signOnly | zeroOnly | carryOnly;
    
    _ctx.eFlags.signFlag = YES;
    _ctx.eFlags.zeroFlag = YES;
    _ctx.eFlags.carryFlag = YES;
    
    TDEquals(all, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.signFlag);
    TDEquals(YES, _ctx.eFlags.zeroFlag);
    TDEquals(YES, _ctx.eFlags.carryFlag);

    TDEquals(NO, _ctx.eFlags.overflowFlag);
    TDEquals(NO, _ctx.eFlags.directionFlag);
    TDEquals(NO, _ctx.eFlags.auxiliaryCarryFlag);
    TDEquals(NO, _ctx.eFlags.interruptDisableFlag);
    TDEquals(NO, _ctx.eFlags.parityFlag);
}


- (void)testOverflowFlagOn {
    ASDword overflowOnly = 0x800;

    _ctx.eFlags.overflowFlag = YES;
    
    TDEquals(overflowOnly, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.overflowFlag);
}


- (void)testOverflowFlagOff {
    ASDword none = 0x0;
    
    _ctx.eFlags.overflowFlag = NO;
    
    TDEquals(none, _ctx.eFlags.dwordValue);
    TDEquals(NO, _ctx.eFlags.overflowFlag);
}


- (void)testDirectionFlagOn {
    ASDword directionOnly = 0x400;
    
    _ctx.eFlags.directionFlag = YES;
    
    TDEquals(directionOnly, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.directionFlag);
}


- (void)testDirectionFlagOff {
    ASDword none = 0x0;
    
    _ctx.eFlags.directionFlag = NO;
    
    TDEquals(none, _ctx.eFlags.dwordValue);
    TDEquals(NO, _ctx.eFlags.directionFlag);
}


- (void)testInterruptDisableFlagOn {
    ASDword interruptDisableOnly = 0x200;
    
    _ctx.eFlags.interruptDisableFlag = YES;
    
    TDEquals(interruptDisableOnly, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.interruptDisableFlag);
}


- (void)testInterruptDisableFlagOff {
    ASDword none = 0x0;
    
    _ctx.eFlags.interruptDisableFlag = NO;
    
    TDEquals(none, _ctx.eFlags.dwordValue);
    TDEquals(NO, _ctx.eFlags.interruptDisableFlag);
}


- (void)testSignFlagOn {
    ASDword signOnly = 0x80;
    
    _ctx.eFlags.signFlag = YES;
    
    TDEquals(signOnly, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.signFlag);
}


- (void)testSignFlagOff {
    ASDword none = 0x0;
    
    _ctx.eFlags.signFlag = NO;
    
    TDEquals(none, _ctx.eFlags.dwordValue);
    TDEquals(NO, _ctx.eFlags.signFlag);
}


- (void)testZeroFlagOn {
    ASDword zeroOnly = 0x40;
    
    _ctx.eFlags.zeroFlag = YES;
    
    TDEquals(zeroOnly, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.zeroFlag);
}


- (void)testZeroFlagOff {
    ASDword none = 0x0;
    
    _ctx.eFlags.zeroFlag = NO;
    
    TDEquals(none, _ctx.eFlags.dwordValue);
    TDEquals(NO, _ctx.eFlags.zeroFlag);
}


- (void)testAuxCarryFlagOn {
    ASDword auxCarryOnly = 0x10;
    
    _ctx.eFlags.auxiliaryCarryFlag = YES;
    
    TDEquals(auxCarryOnly, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.auxiliaryCarryFlag);
}


- (void)testAuxCarryFlagOff {
    ASDword none = 0x0;
    
    _ctx.eFlags.auxiliaryCarryFlag = NO;
    
    TDEquals(none, _ctx.eFlags.dwordValue);
    TDEquals(NO, _ctx.eFlags.auxiliaryCarryFlag);
}


- (void)testParityFlagOn {
    ASDword parityOnly = 0x4;
    
    _ctx.eFlags.parityFlag = YES;
    
    TDEquals(parityOnly, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.parityFlag);
}


- (void)testParityFlagOff {
    ASDword none = 0x0;
    
    _ctx.eFlags.parityFlag = NO;
    
    TDEquals(none, _ctx.eFlags.dwordValue);
    TDEquals(NO, _ctx.eFlags.parityFlag);
}


- (void)testCarryFlagOn {
    ASDword carryOnly = 0x1;
    
    _ctx.eFlags.carryFlag = YES;
    
    TDEquals(carryOnly, _ctx.eFlags.dwordValue);
    TDEquals(YES, _ctx.eFlags.carryFlag);
}


- (void)testCarryFlagOff {
    ASDword none = 0x0;
    
    _ctx.eFlags.carryFlag = NO;
    
    TDEquals(none, _ctx.eFlags.dwordValue);
    TDEquals(NO, _ctx.eFlags.carryFlag);
}

@end

//
//  ASEFlagsRegister.m
//  Assembly
//
//  Created by Todd Ditchendorf on 3/3/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASEFlagsRegister.h>

#define OVERFLOW_BIT_IDX 11
#define DIRECTION_BIT_IDX 10
#define INTERRUPT_BIT_IDX 9
#define SIGN_BIT_IDX 7
#define ZERO_BIT_IDX 6
#define AUX_CARRY_BIT_IDX 4
#define PARITY_BIT_IDX 2
#define CARRY_BIT_IDX 0

@implementation ASEFlagsRegister

- (id)init {
    self = [super initWithName:@"EFlags"];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    
    [super dealloc];
}


- (BOOL)overflowFlag { return [self boolForBitAtIndex:OVERFLOW_BIT_IDX]; }
- (void)setOverflowFlag:(BOOL)yn { [self setBool:yn forBitAtIndex:OVERFLOW_BIT_IDX]; }

- (BOOL)directionFlag { return [self boolForBitAtIndex:DIRECTION_BIT_IDX]; }
- (void)setDirectionFlag:(BOOL)yn { [self setBool:yn forBitAtIndex:DIRECTION_BIT_IDX]; }

- (BOOL)interruptDisableFlag { return [self boolForBitAtIndex:INTERRUPT_BIT_IDX]; }
- (void)setInterruptDisableFlag:(BOOL)yn { [self setBool:yn forBitAtIndex:INTERRUPT_BIT_IDX]; }

- (BOOL)signFlag { return [self boolForBitAtIndex:SIGN_BIT_IDX]; }
- (void)setSignFlag:(BOOL)yn { [self setBool:yn forBitAtIndex:SIGN_BIT_IDX]; }

- (BOOL)zeroFlag { return [self boolForBitAtIndex:ZERO_BIT_IDX]; }
- (void)setZeroFlag:(BOOL)yn { [self setBool:yn forBitAtIndex:ZERO_BIT_IDX]; }

- (BOOL)auxiliaryCarryFlag { return [self boolForBitAtIndex:AUX_CARRY_BIT_IDX]; }
- (void)setAuxiliaryCarryFlag:(BOOL)yn { [self setBool:yn forBitAtIndex:AUX_CARRY_BIT_IDX]; }

- (BOOL)parityFlag { return [self boolForBitAtIndex:PARITY_BIT_IDX]; }
- (void)setParityFlag:(BOOL)yn { [self setBool:yn forBitAtIndex:PARITY_BIT_IDX]; }

- (BOOL)carryFlag { return [self boolForBitAtIndex:CARRY_BIT_IDX]; }
- (void)setCarryFlag:(BOOL)yn { [self setBool:yn forBitAtIndex:CARRY_BIT_IDX]; }

@end

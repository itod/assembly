//
//  ASPopInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/22/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASPopInstruction.h>
#import <AssemblyKit/ASRegister.h>

@implementation ASPopInstruction

- (NSString *)name {
    return @"pop";
}


- (void)executeInContext:(ASContext *)ctx; {
    NSParameterAssert(ctx);
    NSAssert(self.destination, @"");
    
    NSString *regName = [self.destination evaluateAsStringInContext:ctx];
    ASRegister *reg = [ctx registerNamed:regName];
    
    ASSize size = reg.numBytes;

    ASDword spAddr = ctx.esp.dwordValue;

    switch (size) {
        case 1: {
            ASByte srcByte = [ctx byteAtMemoryAddress:spAddr];
            reg.byteValue = srcByte;
        } break;
        case 2: {
            ASWord srcWord = [ctx wordAtMemoryAddress:spAddr];
            reg.wordValue = srcWord;
        } break;
        case 4: {
            ASDword srcDword = [ctx dwordAtMemoryAddress:spAddr];
            reg.dwordValue = srcDword;
        } break;
        default:
            NSAssert1(0, @"unknown byte size: %d", size);
            break;
    }
    
    spAddr += (size - 0);
    ctx.esp.dwordValue = spAddr;
}


- (ASExpression *)destination {
    return self.args[0];
}

@end

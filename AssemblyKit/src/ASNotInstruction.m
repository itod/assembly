//
//  ASNotInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASNotInstruction.h>
#import <AssemblyKit/ASRegister.h>

@implementation ASNotInstruction

- (NSString *)name {
    return @"not";
}


- (void)executeInContext:(ASContext *)ctx; {
    NSParameterAssert(ctx);
    NSAssert(self.destination, @"");
    
    if ([self.destination isRegister]) {
        NSString *regName = [self.destination evaluateAsStringInContext:ctx];
        ASRegister *reg = [ctx registerNamed:regName];
        
        switch (reg.numBytes) {
            case 1: {
                ASByte oldVal = reg.byteValue;
                reg.byteValue = ~oldVal;
            } break;
            case 2: {
                ASWord oldVal = reg.wordValue;
                reg.wordValue = ~oldVal;
            } break;
            case 4: {
                ASDword oldVal = reg.dwordValue;
                reg.dwordValue = ~oldVal;
            } break;
            default:
                break;
        }

    } else if ([self.destination isMemory]) {
        ASDword addr = [self.destination evaluateAsDwordInContext:ctx];
        
        ASDword oldVal = [ctx dwordAtMemoryAddress:addr];
        ASDword newVal = ~oldVal;
        [ctx setDword:newVal atMemoryAddress:addr];
    }
    
}

@end

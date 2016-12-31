//
//  ASNegInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASNegInstruction.h>
#import <AssemblyKit/ASRegister.h>
#import <AssemblyKit/ASEFlagsRegister.h>

@implementation ASNegInstruction

- (NSString *)name {
    return @"neg";
}


- (void)executeInContext:(ASContext *)ctx; {
    NSParameterAssert(ctx);
    NSAssert(self.destination, @"");
    
    ASInteger i = 0;
    
    if ([self.destination isRegister]) {
        NSString *regName = [self.destination evaluateAsStringInContext:ctx];
        ASRegister *reg = [ctx registerNamed:regName];
        i = reg.integerValue;
        i = -i;
        reg.integerValue = i;        
    } else if ([self.destination isMemory]) {
        ASDword addr = [self.destination evaluateAsDwordInContext:ctx];
        
        i = [ctx dwordAtMemoryAddress:addr];
        i = -i;
        [ctx setDword:i atMemoryAddress:addr];
    }

    BOOL isNegative = i < 0;
    ctx.eFlags.signFlag = isNegative;
}

@end

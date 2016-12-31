//
//  ASDyadicInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASDyadicInstruction.h>
#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASRegister.h>

@implementation ASDyadicInstruction

- (void)compile {
    [self checkArgumentCountForMin:2 max:2];
    
    self.args[0] = [self.args[0] simplify];
    self.args[1] = [self.args[1] simplify];
    
    if (![self.source isValue] && ![self.source isRegister] && ![self.source isMemory]) {
        [self raise:@"%@: Illegal source argument : %@", self.name, self.source];
    }
    
    if (![self.destination isRegister] && ![self.destination isMemory]) {
        [self raise:@"%@: Illegal dest argument : %@", self.name, self.destination];
    }
}


- (ASByte)byteOp:(ASByte)src dest:(ASByte)dest {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (ASWord)wordOp:(ASWord)src dest:(ASWord)dest {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (ASDword)dwordOp:(ASDword)src dest:(ASDword)dest {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (void)executeInContext:(ASContext *)ctx; {
    NSParameterAssert(ctx);
    NSAssert(self.source, @"");
    NSAssert(self.destination, @"");
    
    ASSize size = self.destination.numBytes;
    switch (size) {
        case 1: {
            ASByte srcByte = [self byteFromExpression:self.source inContext:ctx];
            ASByte destByte = [self byteFromExpression:self.destination inContext:ctx];
            ASByte resByte = [self byteOp:srcByte dest:destByte];
            
            if ([self.destination isRegister]) {
                NSString *regName = [self.destination evaluateAsStringInContext:ctx];
                ASRegister *reg = [ctx registerNamed:regName];
                reg.byteValue = resByte;
            } else if ([self.destination isMemory]) {
                ASDword addr = [self.destination evaluateAsDwordInContext:ctx];
                [ctx setByte:resByte atMemoryAddress:addr];
            }
        } break;
        case 2: {
            ASWord srcWord = [self wordFromExpression:self.source inContext:ctx];
            ASWord destWord = [self wordFromExpression:self.destination inContext:ctx];
            ASWord resWord = [self wordOp:srcWord dest:destWord];
            
            if ([self.destination isRegister]) {
                NSString *regName = [self.destination evaluateAsStringInContext:ctx];
                ASRegister *reg = [ctx registerNamed:regName];
                reg.wordValue = resWord;
            } else if ([self.destination isMemory]) {
                ASDword addr = [self.destination evaluateAsDwordInContext:ctx];
                [ctx setWord:resWord atMemoryAddress:addr];
            }
        } break;
        case 4: {
            ASDword srcDword = [self dwordFromExpression:self.source inContext:ctx];
            ASDword destDword = [self dwordFromExpression:self.destination inContext:ctx];
            ASDword resDword = [self dwordOp:srcDword dest:destDword];
            
            if ([self.destination isRegister]) {
                NSString *regName = [self.destination evaluateAsStringInContext:ctx];
                ASRegister *reg = [ctx registerNamed:regName];
                reg.dwordValue = resDword;
            } else if ([self.destination isMemory]) {
                ASDword addr = [self.destination evaluateAsDwordInContext:ctx];
                [ctx setDword:resDword atMemoryAddress:addr];
            }
        } break;
        default:
            NSAssert1(0, @"unknown byte size: %d", size);
            break;
    }
}


- (ASExpression *)source {
    return self.args[0];
}


- (ASMutableStorageExpression *)destination {
    return self.args[1];
}

@end

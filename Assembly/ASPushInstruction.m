//
//  ASPushInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/22/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASPushInstruction.h>
#import <AssemblyKit/ASRegister.h>
#import <AssemblyKit/ASUtils.h>

@implementation ASPushInstruction

- (NSString *)name {
    return @"push";
}


- (void)executeInContext:(ASContext *)ctx; {
    NSParameterAssert(ctx);
    NSAssert(self.destination, @"");
    
    NSString *regName = [self.destination evaluateAsStringInContext:ctx];
    ASRegister *reg = [ctx registerNamed:regName];
    
    ASSize size = reg.numBytes;

    ASDword spAddr = ctx.esp.dwordValue;
    //NSLog(@"old sp %@", ASHexStringFromDword(spAddr));
    spAddr -= size;
    //NSLog(@"mew sp %@", ASHexStringFromDword(spAddr));
    ctx.esp.dwordValue = spAddr;

    switch (size) {
        case 1: {
            ASByte srcByte = reg.byteValue;
            [ctx setByte:srcByte atMemoryAddress:spAddr];
        } break;
        case 2: {
            ASWord srcWord = reg.wordValue;
            [ctx setWord:srcWord atMemoryAddress:spAddr];
        } break;
        case 4: {
            ASDword srcDword = reg.dwordValue;
            //NSLog(@"src %@", ASHexStringFromDword(srcDword));
            [ctx setDword:srcDword atMemoryAddress:spAddr];
        } break;
        default:
            NSAssert1(0, @"unknown byte size: %d", size);
            break;
    }
}

@end

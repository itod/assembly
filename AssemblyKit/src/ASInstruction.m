//
//  ASInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASInstruction.h"
#import "ASRegisterExpression.h"
#import "ASValue.h"
#import <AssemblyKit/ASRegister.h>

@interface ASInstruction ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSMutableArray *args;
@end

@implementation ASInstruction

- (id)initWithName:(NSString *)n lineNumber:(NSUInteger)lineNum {
    self = [super initWithLineNumber:lineNum];
    if (self) {
        self.name = n;
        self.args = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    self.args = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, _name];
}


- (void)raise:(NSString *)format, ... {
    va_list vargs;
    va_start(vargs, format);
    
    NSString *msg = [[[NSString alloc] initWithFormat:format arguments:vargs] autorelease];
    
    va_end(vargs);

    [NSException raise:NSInvalidArgumentException format:@"Line : %lu\n%@", self.lineNumber, msg];
}


- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max {
    NSUInteger num = [self.args count];
    if (min == max && num != min) {
        [self raise:@"Invalid numer of args supplied to %@() instruction. %d expected. %d given.", [self name], min, num];
    }
    if (num < min) {
        [self raise:@"Invalid numer of args supplied to %@() instruction. at least %d expected. %d given.", [self name], min, num];
    }
    if (num > max) {
        [self raise:@"Invalid numer of args supplied to %@() instruction. only %d accepted. %d given.", [self name], max, num];
    }
    return num;
}


- (ASByte)byteFromExpression:(ASExpression *)expr inContext:(ASContext *)ctx {
    ASByte byte = 0;
    
    if ([expr isValue]) {
        byte = [expr evaluateAsByteInContext:ctx];
    } else if ([expr isRegister]) {
        byte = [self byteFromRegister:(ASRegisterExpression *)expr inContext:ctx];
    } else if ([expr isMemory]) {
        byte = [self byteFromAddress:(ASAddressExpression *)expr inContext:ctx];
    }
    
    return byte;
}


- (ASWord)wordFromExpression:(ASExpression *)expr inContext:(ASContext *)ctx {
    ASWord word = 0;
    
    if ([expr isValue]) {
        word = [expr evaluateAsWordInContext:ctx];
    } else if ([expr isRegister]) {
        word = [self wordFromRegister:(ASRegisterExpression *)expr inContext:ctx];
    } else if ([expr isMemory]) {
        word = [self wordFromAddress:(ASAddressExpression *)expr inContext:ctx];
    }
    
    return word;
}


- (ASDword)dwordFromExpression:(ASExpression *)expr inContext:(ASContext *)ctx {
    ASDword dword = 0;
    
    if ([expr isValue]) {
        dword = [expr evaluateAsDwordInContext:ctx];
    } else if ([expr isRegister]) {
        dword = [self dwordFromRegister:(ASRegisterExpression *)expr inContext:ctx];
    } else if ([expr isMemory]) {
        dword = [self dwordFromAddress:(ASAddressExpression *)expr inContext:ctx];
    }
    
    return dword;
}


- (ASByte)byteFromRegister:(ASRegisterExpression *)regExpr inContext:(ASContext *)ctx {
    NSString *regName = [regExpr evaluateAsStringInContext:ctx];
    ASRegister *reg = [ctx registerNamed:regName];
    ASByte byte = reg.byteValue;
    return byte;
}


- (ASWord)wordFromRegister:(ASRegisterExpression *)regExpr inContext:(ASContext *)ctx {
    NSString *regName = [regExpr evaluateAsStringInContext:ctx];
    ASRegister *reg = [ctx registerNamed:regName];
    ASWord word = reg.wordValue;
    return word;
}


- (ASDword)dwordFromRegister:(ASRegisterExpression *)regExpr inContext:(ASContext *)ctx {
    NSString *regName = [regExpr evaluateAsStringInContext:ctx];
    ASRegister *reg = [ctx registerNamed:regName];
    ASDword dword = reg.dwordValue;
    return dword;
}


- (ASByte)byteFromAddress:(ASAddressExpression *)addrExpr inContext:(ASContext *)ctx {
    ASDword addr = [addrExpr evaluateAsDwordInContext:ctx];
    ASByte byte = [ctx byteAtMemoryAddress:addr];
    return byte;
}


- (ASWord)wordFromAddress:(ASAddressExpression *)addrExpr inContext:(ASContext *)ctx {
    ASDword addr = [addrExpr evaluateAsDwordInContext:ctx];
    ASWord word = [ctx wordAtMemoryAddress:addr];
    return word;
}


- (ASDword)dwordFromAddress:(ASAddressExpression *)addrExpr inContext:(ASContext *)ctx {
    ASDword addr = [addrExpr evaluateAsDwordInContext:ctx];
    ASDword dword = [ctx dwordAtMemoryAddress:addr];
    return dword;
}

@end

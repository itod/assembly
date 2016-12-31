//
//  ASMemoryRegisterIndirect.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/24/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASAddressRegisterIndirectExpression.h"
#import "AS32BitRegisterExpression.h"

#import <AssemblyKit/ASRegister.h>

@implementation ASAddressRegisterIndirectExpression

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p [%@]>", [self class], self, self.baseRegister.name];
}


- (ASExpression *)simplify {
    return self;
}


- (ASDword)evaluateAsDwordInContext:(ASContext *)ctx {
    NSString *regName = self.baseRegister.name;
    ASRegister *reg = [ctx registerNamed:regName];
    ASDword dword = reg.dwordValue;
    return dword;
}

@end

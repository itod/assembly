//
//  ASMemoryIndexed.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/24/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASAddressIndexedExpression.h"
#import "AS32BitRegisterExpression.h"
#import "ASValue.h"

#import <AssemblyKit/ASRegister.h>

@interface ASAddressIndexedExpression ()
@property (nonatomic, retain, readwrite) ASValue *displacement;
@end

@implementation ASAddressIndexedExpression

- (id)initWithBaseRegister:(AS32BitRegisterExpression *)reg displacement:(ASValue *)d {
    self = [super initWithBaseRegister:reg];
    if (self) {
        self.displacement = d;
    }
    return self;
}


- (void)dealloc {
    self.displacement = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@[%@]>", [self class], self, [_displacement asDecimalString], self.baseRegister.name];
}


- (ASExpression *)simplify {
    return self;
}


- (ASDword)evaluateAsDwordInContext:(ASContext *)ctx {
    NSString *regName = self.baseRegister.name;
    ASRegister *reg = [ctx registerNamed:regName];
    ASDword regVal = reg.dwordValue;

    ASInteger disp = [self.displacement evaluateAsIntegerInContext:ctx];

    ASDword addr = regVal + disp;
    return addr;
}

@end

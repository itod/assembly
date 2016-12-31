//
//  ASMemoryLocation.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/23/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASAddressExpression.h>
#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASUtils.h>
#import "ASValue.h"
#import "AS32BitRegisterExpression.h"

@interface ASAddressExpression ()
@property (nonatomic, retain, readwrite) AS32BitRegisterExpression *baseRegister;
@end

@interface ASAddressExpression ()
@property (nonatomic, assign, readwrite) ASDword effectiveAddress;
@end

@implementation ASAddressExpression

- (id)initWithBaseRegister:(AS32BitRegisterExpression *)reg {
    self = [super init];
    if (self) {
        self.baseRegister = reg;
    }
    return self;
}


- (void)dealloc {
    self.baseRegister = nil;
    self.context = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p [%@]>", [self class], self, _baseRegister.name];
}


- (BOOL)isMemory {
    return YES;
}


- (ASSize)numBytes {
    return 4; // dword by default
}


- (ASExpression *)simplify {
    return self;
}


- (ASExpression *)evaluateInContext:(ASContext *)ctx {
    ASDword dword = [self evaluateAsDwordInContext:ctx];
    ASValue *val = [ASValue valueWithDword:dword];
    return val;
}


- (ASDword)evaluateAsDwordInContext:(ASContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}

@end

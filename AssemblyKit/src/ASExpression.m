//
//  ASExpression.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASExpression.h"
#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASUtils.h>

@implementation ASExpression

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %d>", [self class], self, self.numBytes];
}


- (void)raise:(NSString *)format, ... {
    va_list vargs;
    va_start(vargs, format);
    
    NSString *str = [[[NSString alloc] initWithFormat:format arguments:vargs] autorelease];

    va_end(vargs);

    [NSException raise:NSInvalidArgumentException format:@"%@", str];
}


- (ASSize)numBytes {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (ASExpression *)simplify {
    return self;
}


- (ASExpression *)evaluateInContext:(ASContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (ASDword)evaluateAsDwordInContext:(ASContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (ASWord)evaluateAsWordInContext:(ASContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (ASByte)evaluateAsByteInContext:(ASContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (ASInteger)evaluateAsIntegerInContext:(ASContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return 0;
}


- (NSString *)evaluateAsStringInContext:(ASContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (BOOL)isValue {
    return NO;
}


- (BOOL)isRegister {
    return NO;
}


- (BOOL)isMemory {
    return NO;
}


@end

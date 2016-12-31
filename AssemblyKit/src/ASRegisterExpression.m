//
//  ASRegisterExpression.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/24/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASRegisterExpression.h"

@interface ASRegisterExpression ()
@property (nonatomic, copy, readwrite) NSString *name;
@end

@implementation ASRegisterExpression

- (id)initWithName:(NSString *)n {
    self = [super init];
    if (self) {
        self.name = n;
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    [super dealloc];
}


- (ASExpression *)simplify {
    return self;
}


- (NSString *)evaluateAsStringInContext:(ASContext *)ctx {
    return self.name;
}


- (BOOL)isRegister {
    return YES;
}

@end

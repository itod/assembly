//
//  ASStatement.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASStatement.h>
#import <AssemblyKit/ASContext.h>

@interface ASStatement ()
@property (nonatomic, assign, readwrite) NSUInteger lineNumber;
@end

@implementation ASStatement

- (id)initWithLineNumber:(NSUInteger)n {
    self = [super init];
    if (self) {
        self.lineNumber = n;
    }
    return self;
}


- (void)dealloc {

    [super dealloc];
}


- (void)compile {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}


- (void)executeInContext:(ASContext *)ctx {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}

@end
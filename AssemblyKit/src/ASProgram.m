//
//  ASProgram.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASProgram.h>
#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASStatement.h>

@interface ASProgram ()
@property (nonatomic, retain, readwrite) NSArray *statements;
@property (nonatomic, assign) NSUInteger currentStatementIndex;
@property (nonatomic, assign, readwrite, getter=isSteppingBlocked) BOOL steppingBlocked;
@end

@implementation ASProgram

- (id)initWithStatements:(NSArray *)stats {
    self = [super init];
    if (self) {
        self.statements = stats;
        [self reset];
    }
    return self;
}


- (void)dealloc {
    self.statements = nil;
    [super dealloc];
}


- (void)compile {
    self.currentStatementIndex = 0;
    for (ASStatement *stat in _statements) {
        self.currentStatementIndex++;
        [stat compile];
    }
    self.currentStatementIndex = 0;
}


- (void)executeInContext:(ASContext *)ctx {
    NSParameterAssert(ctx);
    
    self.currentStatementIndex = 0;
    for (ASStatement *stat in _statements) {
        self.currentStatementIndex++;
        [stat executeInContext:ctx];
    }
}


- (void)stepInContext:(ASContext *)ctx {
    NSParameterAssert(ctx);
    
    //NSLog(@"%lu", _currentStatementIndex);
    ASStatement *stat = _statements[_currentStatementIndex];
    [stat executeInContext:ctx];
    self.currentStatementIndex++;
    
    if (![self isRunning]) {
        self.steppingBlocked = YES;
    }
}


- (BOOL)isRunning {
    BOOL running = NSNotFound != _currentStatementIndex && _currentStatementIndex < [_statements count];
    return running;
}


- (void)reset {
    self.steppingBlocked = NO;
    self.currentStatementIndex = 0;
}


- (NSUInteger)currentLineNumber {
    if (![self isRunning]) {
        return NSNotFound;
    }
    
    ASStatement *stat = _statements[_currentStatementIndex];
    return stat.lineNumber;
}

@end

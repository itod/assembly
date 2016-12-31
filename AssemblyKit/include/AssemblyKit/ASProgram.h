//
//  ASProgram.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASContext;

@interface ASProgram : NSObject

- (id)initWithStatements:(NSArray *)stats;

// throws ASErrorCompiliationPhase
- (void)compile;

// throws ASErrorRuntimePhase
- (void)executeInContext:(ASContext *)ctx;

// throws ASErrorRuntimePhase
- (void)stepInContext:(ASContext *)ctx;

- (BOOL)isRunning;
- (BOOL)isSteppingBlocked;
- (void)reset;

@property (nonatomic, retain, readonly) NSArray *statements;
@property (nonatomic, assign, readonly) NSUInteger currentLineNumber;
@end

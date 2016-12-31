//
//  ASProgramRunner.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASContext;
@class ASProgram;

extern const NSInteger ASErrorCodeCompilationPhaseSyntactic;
extern const NSInteger ASErrorCodeCompilationPhaseSemantic;
extern const NSInteger ASErrorCodeRuntimePhase;

extern NSString * const ASErrorDomainCompilationPhaseSyntactic;
extern NSString * const ASErrorDomainCompilationPhaseSemantic;
extern NSString * const ASErrorDomainRuntimePhase;

@interface ASProgramRunner : NSObject

- (id)initWithContext:(ASContext *)ctx;

- (ASProgram *)compiledProgramFromInput:(NSString *)input error:(NSError **)outErr;

// YES for success
- (BOOL)runProgram:(ASProgram *)prog error:(NSError **)outErr;

// YES for success
- (BOOL)stepProgram:(ASProgram *)prog error:(NSError **)outErr;

@property (nonatomic, retain, readonly) ASContext *context;
@end

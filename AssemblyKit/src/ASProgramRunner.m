//
//  ASProgramRunner.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASProgramRunner.h>
#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASProgram.h>
#import <AssemblyKit/ASStatement.h>
#import <AssemblyKit/ASContext.h>

#import "ASProgramAssembler.h"

#import <ParseKit/ParseKit.h>

const NSInteger ASErrorCodeCompilationPhaseSyntactic = 100;
const NSInteger ASErrorCodeCompilationPhaseSemantic = 110;
const NSInteger ASErrorCodeRuntimePhase = 200;

NSString * const ASErrorDomainCompilationPhaseSyntactic = @"ASErrorDomainCompilationPhaseSyntactic";
NSString * const ASErrorDomainCompilationPhaseSemantic = @"ASErrorDomainCompilationPhaseSemantic";
NSString * const ASErrorDomainRuntimePhase = @"ASErrorDomainRuntimePhase";

@interface ASProgramRunner ()
@property (nonatomic, retain) PKParser *parser;
@property (nonatomic, retain) ASProgramAssembler *programAssembler;

@property (nonatomic, retain, readwrite) ASContext *context;
@end

@implementation ASProgramRunner

- (id)initWithContext:(ASContext *)ctx {
    self = [super init];
    if (self) {
        self.context = ctx;
        [self setUpParser];
    }
    return self;
}


- (void)dealloc {
    self.context = nil;
    self.parser = nil;
    self.programAssembler = nil;
    [super dealloc];
}


- (ASProgram *)compiledProgramFromInput:(NSString *)input error:(NSError **)outErr {
    NSAssert(_parser, @"");
    NSAssert(_programAssembler, @"");
    NSAssert([input length], @"");
    
    [_programAssembler reset];

    NSError *parseErr = nil;
    [_parser parse:input error:&parseErr];
    
    ASProgram *prog = _programAssembler.program;
    if (!prog || parseErr) {
        if (outErr) {
            NSString *desc = NSLocalizedString(@"A syntactic compile-time error ocurred.\n", @"");
            NSString *reason = [parseErr userInfo][NSLocalizedFailureReasonErrorKey];
            
            NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : desc,
                NSLocalizedFailureReasonErrorKey : reason,
            };
            *outErr = [NSError errorWithDomain:ASErrorDomainCompilationPhaseSyntactic code:ASErrorCodeCompilationPhaseSyntactic userInfo:userInfo];
        }
        return nil;
    }
    
    @try {
        [prog compile];
    }
    @catch (NSException *ex) {
        if (outErr) {
            NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : NSLocalizedString(@"A semantic compile-time error ocurred.\n", @""),
                NSLocalizedFailureReasonErrorKey : [ex reason],
            };
            *outErr = [NSError errorWithDomain:ASErrorDomainCompilationPhaseSemantic code:ASErrorCodeCompilationPhaseSemantic userInfo:userInfo];
        }
        return nil;
    }
    
    return prog;
}


- (BOOL)runProgram:(ASProgram *)prog error:(NSError **)outErr {
    NSParameterAssert(prog);
    
    if (!prog) return NO;
    
    @try {
        [prog executeInContext:_context];
    }
    @catch (NSException *ex) {
        if (outErr) {
            NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : NSLocalizedString(@"A run-time error ocurred.", @""),
                NSLocalizedFailureReasonErrorKey : [ex reason],
           };
            *outErr = [NSError errorWithDomain:ASErrorDomainRuntimePhase code:ASErrorCodeRuntimePhase userInfo:userInfo];
        }
        return NO;
    }
    
    return YES;
}


- (BOOL)stepProgram:(ASProgram *)prog error:(NSError **)outErr {
    NSParameterAssert(prog);
    
    if (!prog) return NO;
            
    @try {
        [prog stepInContext:_context];
    }
    @catch (NSException *ex) {
        if (outErr) {
            NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : NSLocalizedString(@"A run-time error ocurred.", @""),
                NSLocalizedFailureReasonErrorKey : [ex reason],
            };
            *outErr = [NSError errorWithDomain:ASErrorDomainRuntimePhase code:ASErrorCodeRuntimePhase userInfo:userInfo];
        }
        return NO;
    }
    
    return YES;
}


- (void)setUpParser {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"assembly" ofType:@"g"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSAssert([g length], @"");
    
    NSAssert(_context, @"");
    
    NSError *err = nil;
    self.programAssembler = [[[ASProgramAssembler alloc] initWithContext:_context] autorelease];
    PKParser *p = [[PKParserFactory factory] parserFromGrammar:g assembler:_programAssembler error:&err];
    NSAssert(p, @"");
    
    self.parser = p;
}

@end
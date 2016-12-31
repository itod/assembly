//
//  ASProgramAssembler.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/AssemblyKit.h>
#import <ParseKit/ParseKit.h>
#import "ASProgramAssembler.h"

#import "ASValue.h"

#import "ASMovInstruction.h"
#import "ASAndInstruction.h"
#import "ASOrInstruction.h"
#import "ASXorInstruction.h"
#import "ASNegInstruction.h"
#import "ASNotInstruction.h"
#import "ASShlInstruction.h"
#import "ASShrInstruction.h"
#import "ASPushInstruction.h"
#import "ASPopInstruction.h"

#import "AS32BitRegisterExpression.h"
#import "AS16BitRegisterExpression.h"
#import "AS8BitRegisterExpression.h"

#import "ASAddressRegisterIndirectExpression.h"
#import "ASAddressIndexedExpression.h"

@interface ASProgramAssembler ()
@property (nonatomic, retain, readwrite) ASContext *context;
@property (nonatomic, retain, readwrite) ASProgram *program;
@property (nonatomic, retain) NSMutableArray *statements;
@property (nonatomic, retain) PKToken *openParen;
@property (nonatomic, retain) NSDictionary *instructionTab;
@end

@implementation ASProgramAssembler

- (id)initWithContext:(ASContext *)ctx {
    self = [super init];
    if (self) {
        self.context = ctx;
        self.openParen = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"(" floatValue:0.0];
        
        self.instructionTab = @{
            @"mov" : [ASMovInstruction class],
            @"and" : [ASAndInstruction class],
            @"or"  : [ASOrInstruction class],
            @"xor" : [ASXorInstruction class],
            @"neg" : [ASNegInstruction class],
            @"not" : [ASNotInstruction class],
            @"shl" : [ASShlInstruction class],
            @"shr" : [ASShrInstruction class],
            @"push": [ASPushInstruction class],
            @"pop" : [ASPopInstruction class],
        };
    }
    return self;
}


- (void)dealloc {
    self.context = nil;
    self.program = nil;
    self.statements = nil;
    self.openParen = nil;
    self.instructionTab = nil;
    [super dealloc];
}


- (void)reset {
    self.statements = [NSMutableArray array];
    self.program = [[[ASProgram alloc] initWithStatements:_statements] autorelease];
}


- (void)parser:(PKParser *)p didMatchConstant:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
    PKToken *tok = [a pop];
    NSAssert(tok.isNumber, @"");
    
    ASDword dword = tok.floatValue;
    ASValue *c = [ASValue valueWithDword:dword];
    [a push:c];
}


- (void)parser:(PKParser *)p didMatchReg32Bit:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
    PKToken *tok = [a pop];
    NSAssert(tok.isWord, @"");
    
    NSString *regName = tok.stringValue;
    NSAssert(_context, @"");
    NSAssert([regName length], @"");
    
    ASRegisterExpression *regExpr = [[[AS32BitRegisterExpression alloc] initWithName:regName] autorelease];
    NSAssert(regExpr, @"");
    NSAssert(4 == regExpr.numBytes, @"");
    
    [a push:regExpr];
}


- (void)parser:(PKParser *)p didMatchReg16Bit:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
    PKToken *tok = [a pop];
    NSAssert(tok.isWord, @"");
    
    NSString *regName = tok.stringValue;
    NSAssert(_context, @"");
    NSAssert([regName length], @"");
    
    ASRegisterExpression *regExpr = [[[AS16BitRegisterExpression alloc] initWithName:regName] autorelease];
    NSAssert(regExpr, @"");
    NSAssert(2 == regExpr.numBytes, @"");
    
    [a push:regExpr];
}


- (void)parser:(PKParser *)p didMatchReg8Bit:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
    PKToken *tok = [a pop];
    NSAssert(tok.isWord, @"");
    
    NSString *regName = tok.stringValue;
    NSAssert(_context, @"");
    NSAssert([regName length], @"");
    
    ASRegisterExpression *regExpr = [[[AS8BitRegisterExpression alloc] initWithName:regName] autorelease];
    NSAssert(regExpr, @"");
    NSAssert(1 == regExpr.numBytes, @"");
    
    [a push:regExpr];
}


- (void)parser:(PKParser *)p didMatchMemRegIndirect:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
    AS32BitRegisterExpression *regExpr = [a pop];
    NSAssert(regExpr, @"");
    NSAssert([regExpr isKindOfClass:[AS32BitRegisterExpression class]], @"");
    
    ASAddressExpression *mem = [[[ASAddressRegisterIndirectExpression alloc] initWithBaseRegister:regExpr] autorelease];
    
    [a push:mem];
}


- (void)parser:(PKParser *)p didMatchMemIndexed:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
    AS32BitRegisterExpression *regExpr = [a pop];
    NSAssert(regExpr, @"");
    NSAssert([regExpr isKindOfClass:[AS32BitRegisterExpression class]], @"");
    
    ASValue *disp = [a pop];
    NSAssert([disp isKindOfClass:[ASValue class]], @"");
    
    ASAddressExpression *mem = [[[ASAddressIndexedExpression alloc] initWithBaseRegister:regExpr displacement:disp] autorelease];

    [a push:mem];
}


- (void)parser:(PKParser *)p didMatchInstruction:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
    NSArray *origArgs = [a objectsAbove:_openParen];
    NSUInteger argc = [origArgs count];
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:argc];
    for (id obj in [origArgs reverseObjectEnumerator]) {
        [args addObject:obj];
    }
    
    [a pop]; // discard paren
    
    PKToken *funcTok = [a pop];
    NSAssert(funcTok.isWord, @"");
    
    NSString *funcName = funcTok.stringValue;
    NSAssert([funcName isKindOfClass:[NSString class]], @"");
    
    NSUInteger lineNum = funcTok.lineNumber;
    NSAssert(lineNum > 0, @"");
    NSAssert(lineNum != NSNotFound, @"");
    
    Class cls = _instructionTab[funcName];
    ASInstruction *instr = [[[cls alloc] initWithName:funcName lineNumber:lineNum] autorelease];
    
    if (argc > 0) {
        ASExpression *expr = args[0];
        NSAssert([expr isKindOfClass:[ASExpression class]], @"");
        [instr.args addObject:expr];
    }

    if (argc > 1) {
        ASExpression *expr = args[1];
        NSAssert([expr isKindOfClass:[ASExpression class]], @"");
        [instr.args addObject:expr];
    }
    
    [a push:instr];
}


- (void)parser:(PKParser *)p didMatchStat:(PKAssembly *)a {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, a);
    
    ASInstruction *instr = [a pop];
    NSAssert(instr, @"");
    NSAssert([instr isKindOfClass:[ASInstruction class]], @"");
    
    if (instr) {
        [self.statements addObject:instr];
    }
}

@end

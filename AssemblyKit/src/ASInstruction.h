//
//  ASInstruction.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASStatement.h"
#import <AssemblyKit/ASTypes.h>

@class ASExpression;
@class ASRegisterExpression;
@class ASAddressExpression;

@interface ASInstruction : ASStatement

- (id)initWithName:(NSString *)n lineNumber:(NSUInteger)lineNum;

- (void)raise:(NSString *)format, ...;

- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;

- (ASByte)byteFromExpression:(ASExpression *)expr inContext:(ASContext *)ctx;
- (ASWord)wordFromExpression:(ASExpression *)expr inContext:(ASContext *)ctx;
- (ASDword)dwordFromExpression:(ASExpression *)expr inContext:(ASContext *)ctx;

- (ASByte)byteFromRegister:(ASRegisterExpression *)regExpr inContext:(ASContext *)ctx;
- (ASWord)wordFromRegister:(ASRegisterExpression *)regExpr inContext:(ASContext *)ctx;
- (ASDword)dwordFromRegister:(ASRegisterExpression *)regExpr inContext:(ASContext *)ctx;

- (ASByte)byteFromAddress:(ASAddressExpression *)addrExpr inContext:(ASContext *)ctx;
- (ASWord)wordFromAddress:(ASAddressExpression *)addrExpr inContext:(ASContext *)ctx;
- (ASDword)dwordFromAddress:(ASAddressExpression *)addrExpr inContext:(ASContext *)ctx;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, retain, readonly) NSMutableArray *args;
@end

//
//  ASExpression.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASContext.h>

@interface ASExpression : NSObject

- (void)raise:(NSString *)format, ...;

- (ASExpression *)simplify;
- (ASExpression *)evaluateInContext:(ASContext *)ctx;

- (ASDword)evaluateAsDwordInContext:(ASContext *)ctx;
- (ASWord)evaluateAsWordInContext:(ASContext *)ctx;
- (ASByte)evaluateAsByteInContext:(ASContext *)ctx;
- (ASInteger)evaluateAsIntegerInContext:(ASContext *)ctx;
- (NSString *)evaluateAsStringInContext:(ASContext *)ctx;

- (BOOL)isValue;
- (BOOL)isRegister;
- (BOOL)isMemory;

@property (nonatomic, assign, readonly) ASSize numBytes;
@end

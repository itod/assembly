//
//  ASDyadicInstruction.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASInstruction.h"
#import "ASMutableStorageExpression.h"

@interface ASDyadicInstruction : ASInstruction

- (ASByte)byteOp:(ASByte)src dest:(ASByte)dest;
- (ASWord)wordOp:(ASWord)src dest:(ASWord)dest;
- (ASDword)dwordOp:(ASDword)src dest:(ASDword)dest;

@property (nonatomic, retain, readonly) ASExpression *source;
@property (nonatomic, retain, readonly) ASMutableStorageExpression *destination;
@end

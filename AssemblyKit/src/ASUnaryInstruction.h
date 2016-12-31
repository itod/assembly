//
//  ASUnaryInstruction.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASInstruction.h"
#import "ASMutableStorageExpression.h"

@interface ASUnaryInstruction : ASInstruction

//- (ASByte)byteOp:(ASByte)dest;
//- (ASWord)wordOp:(ASWord)dest;
//- (ASDword)dwordOp:(ASDword)dest;

@property (nonatomic, retain, readonly) ASMutableStorageExpression *destination;
@end

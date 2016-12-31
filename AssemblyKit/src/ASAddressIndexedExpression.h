//
//  ASMemoryIndexed.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/24/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASAddressExpression.h"

@class ASValue;
@class AS32BitRegisterExpression;

@interface ASAddressIndexedExpression : ASAddressExpression

- (id)initWithBaseRegister:(AS32BitRegisterExpression *)reg displacement:(ASValue *)d;

@property (nonatomic, retain, readonly) ASValue *displacement;
@end

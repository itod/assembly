//
//  ASMemoryLocation.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/23/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASMutableStorageExpression.h"

@class AS32BitRegisterExpression;

@interface ASAddressExpression : ASMutableStorageExpression

- (id)initWithBaseRegister:(AS32BitRegisterExpression *)reg;

@property (nonatomic, retain, readonly) AS32BitRegisterExpression *baseRegister;

@property (nonatomic, retain) ASContext *context;
@end

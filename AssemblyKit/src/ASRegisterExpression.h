//
//  ASRegisterExpression.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/24/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASMutableStorageExpression.h"

@interface ASRegisterExpression : ASMutableStorageExpression

- (id)initWithName:(NSString *)n;

@property (nonatomic, copy, readonly) NSString *name;
@end

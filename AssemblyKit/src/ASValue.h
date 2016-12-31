//
//  ASValue.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASExpression.h"

@interface ASValue : ASExpression

+ (ASValue *)valueWithDword:(ASDword)dword;
+ (ASValue *)valueWithWord:(ASWord)word;
+ (ASValue *)valueWithByte:(ASByte)byte;

- (id)initWithDword:(ASDword)dword;
- (id)initWithWord:(ASWord)word;
- (id)initWithByte:(ASByte)byte;

- (NSString *)asDecimalString;
- (NSString *)asHexString;
- (NSString *)asBinaryString;

@end

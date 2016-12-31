//
//  AS16BitRegister.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "AS16BitRegister.h"

@implementation AS16BitRegister

- (ASSize)numBytes {
    return 2;
}


- (NSString *)asDecimalString {
    NSString *str = [NSString stringWithFormat:@"%hd", self.wordValue];
    return str;
}


- (NSString *)asHexString {
    NSString *str = [self hexStringForWordAtIndex:0];
    return str;
}


- (NSString *)asBinaryString {
    NSString *str = [self binaryStringForWordAtIndex:0];
    return str;
}


- (ASInteger)integerValue {
    ASInteger i = self.wordValue;
    return i;
}


- (void)setIntegerValue:(ASInteger)integerValue {
    [self setWord:integerValue atIndex:0];
}


- (ASByte)byteValue {
    return [self byteAtIndex:0];
}


- (void)setByteValue:(ASByte)byte {
    [self setByte:byte atIndex:0];
}


- (ASWord)wordValue {
    return [self wordAtIndex:0];
}


- (void)setWordValue:(ASWord)word {
    [self setWord:word atIndex:0];
}

@end

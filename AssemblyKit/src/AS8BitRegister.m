//
//  AS8BitRegister.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "AS8BitRegister.h"

@interface AS8BitRegister ()
@property (nonatomic, assign, readwrite) BOOL isHighOrderByte;
@end

@implementation AS8BitRegister

- (id)initWithName:(NSString *)n parent:(ASRegister *)r isHighOrderByte:(BOOL)yn {
    NSParameterAssert(r);
    
    self = [super initWithName:n parent:r];
    if (self) {
        self.isHighOrderByte = yn;
    }
    return self;
}


- (ASSize)numBytes {
    return 1;
}


- (NSString *)asDecimalString {
    NSString *str = [NSString stringWithFormat:@"%hhd", self.byteValue];
    return str;
}


- (NSString *)asHexString {
    NSString *str = [self hexStringForByteAtIndex:_isHighOrderByte];
    return str;
}


- (NSString *)asBinaryString {
    NSString *str = [self binaryStringForByteAtIndex:_isHighOrderByte];
    return str;
}


- (ASInteger)integerValue {
    ASInteger i = self.byteValue;
    return i;
}


- (void)setIntegerValue:(ASInteger)i {
    [self setByte:i atIndex:_isHighOrderByte];
}


- (ASByte)byteValue {
    return [self byteAtIndex:_isHighOrderByte];
}


- (void)setByteValue:(ASByte)byte {
    [self setByte:byte atIndex:_isHighOrderByte];
}


- (ASWord)wordValue {
    [self raise:@"cannot retrieve word value from %@", self.name];
    return 0;
}


- (void)setWordValue:(ASWord)word {
    [self raise:@"cannot set word value on %@", self.name];
}

@end

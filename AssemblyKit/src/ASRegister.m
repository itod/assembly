//
//  ASRegister.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASRegister.h>
#import <AssemblyKit/ASUtils.h>

@interface ASRegister ()
@property (nonatomic, copy, readwrite) NSString *name;
@end

@implementation ASRegister

- (id)initWithName:(NSString *)n {
    self = [super init];
    if (self) {
        self.name = n;
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, _name];
}


- (void)raise:(NSString *)format, ... {
    va_list vargs;
    va_start(vargs, format);
    
    NSString *str = [[[NSString alloc] initWithFormat:format arguments:vargs] autorelease];
    
    va_end(vargs);
    
    [NSException raise:NSInvalidArgumentException format:@"%@", str];
}


- (ASSize)numBytes {
    return 4;
}


- (NSString *)hexStringForWordAtIndex:(ASIndex)idx {
    NSParameterAssert(idx < 2);

    NSString *str = ASHexStringFromWord([self wordAtIndex:idx]);
    return str;
}


- (NSString *)hexStringForByteAtIndex:(ASIndex)idx {
    NSParameterAssert(idx < 4);

    NSString *str = ASHexStringFromByte([self byteAtIndex:idx]);
    return str;
}


- (NSString *)binaryStringForWordAtIndex:(ASIndex)idx {
    NSParameterAssert(idx < 2);

    NSString *str = ASBinaryStringFromWord([self wordAtIndex:idx]);
    return str;
}


- (NSString *)binaryStringForByteAtIndex:(ASIndex)idx {
    NSParameterAssert(idx < 4);

    NSString *str = ASBinaryStringFromByte([self byteAtIndex:idx]);
    return str;
}

@end

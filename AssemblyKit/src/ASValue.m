//
//  ASValue.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASValue.h"
#import <AssemblyKit/ASUtils.h>
#import <AssemblyKit/ASStorage.h>

@interface ASValue ()
@property (nonatomic, retain) ASStorage *storage;
@end

@implementation ASValue

+ (ASValue *)valueWithDword:(ASDword)dword {
    return [[[ASValue alloc] initWithDword:dword] autorelease];
}


+ (ASValue *)valueWithWord:(ASWord)word {
    return [[[ASValue alloc] initWithWord:word] autorelease];
}


+ (ASValue *)valueWithByte:(ASByte)byte {
    return [[[ASValue alloc] initWithByte:byte] autorelease];
}


- (id)initWithByte:(ASByte)byte {
    ASStorage *store = [[[ASStorage alloc] initWithByte:byte] autorelease];
    return [self initWithStorage:store];
}


- (id)initWithWord:(ASWord)word {
    ASStorage *store = [[[ASStorage alloc] initWithWord:word] autorelease];
    return [self initWithStorage:store];
}


- (id)initWithDword:(ASDword)dword {
    ASStorage *store = [[[ASStorage alloc] initWithDword:dword] autorelease];
    return [self initWithStorage:store];
}


- (id)initWithStorage:(ASStorage *)store {
    self = [super init];
    if (self) {
        self.storage = store;
    }
    return self;
}


- (void)dealloc {
    self.storage = nil;
    [super dealloc];
}


- (ASSize)numBytes {
    return _storage.numBytes;
}


- (BOOL)isValue {
    return YES;
}


- (ASExpression *)simplify {
    return self;
}


- (NSString *)asDecimalString {
    return [_storage asDecimalString];
}


- (NSString *)asHexString {
    return [_storage asHexString];
}


- (NSString *)asBinaryString {
    return [_storage asBinaryString];
}


- (ASExpression *)evaluateInContext:(ASContext *)ctx {
    return self;
}


- (ASDword)evaluateAsDwordInContext:(ASContext *)ctx {
    return _storage.dwordValue;
}


- (ASWord)evaluateAsWordInContext:(ASContext *)ctx {
    return _storage.wordValue;
}


- (ASByte)evaluateAsByteInContext:(ASContext *)ctx {
    return _storage.byteValue;
}


- (ASInteger)evaluateAsIntegerInContext:(ASContext *)ctx {
    return _storage.integerValue;
}


- (NSString *)evaluateAsStringInContext:(ASContext *)ctx {
    return [_storage asHexString];
}

@end

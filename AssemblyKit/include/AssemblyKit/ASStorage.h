//
//  ASStorage.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/24/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssemblyKit/ASTypes.h>

@interface ASStorage : NSObject

- (id)initWithByte:(ASByte)byte;
- (id)initWithWord:(ASWord)word;
- (id)initWithDword:(ASDword)dword;

- (NSString *)asDecimalString;
- (NSString *)asHexString;
- (NSString *)asBinaryString;

- (ASByte)byteAtIndex:(ASIndex)idx;
- (ASWord)wordAtIndex:(ASIndex)idx;
- (ASDword)dwordAtIndex:(ASIndex)idx;

- (BOOL)boolForBitAtIndex:(ASIndex)idx;

@property (nonatomic, assign, readonly) ASSize numBytes;

@property (nonatomic, assign, readonly) ASByte byteValue;
@property (nonatomic, assign, readonly) ASWord wordValue;
@property (nonatomic, assign, readonly) ASDword dwordValue;
@property (nonatomic, assign, readonly) ASInteger integerValue;

@property (nonatomic, copy, readonly) NSString *stringValue;
@end

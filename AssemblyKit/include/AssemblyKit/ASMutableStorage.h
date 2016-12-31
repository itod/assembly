//
//  ASDestination.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/23/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASStorage.h>

@interface ASMutableStorage : ASStorage

- (void)setByte:(ASByte)byte atIndex:(ASIndex)idx;
- (void)setWord:(ASWord)word atIndex:(ASIndex)idx;
- (void)setDword:(ASDword)dword atIndex:(ASIndex)idx;

- (void)setBool:(BOOL)yn forBitAtIndex:(ASIndex)idx;

@property (nonatomic, assign, readwrite) ASByte byteValue;
@property (nonatomic, assign, readwrite) ASWord wordValue;
@property (nonatomic, assign, readwrite) ASDword dwordValue;
@property (nonatomic, assign, readwrite) ASInteger integerValue;

@property (nonatomic, copy, readonly) NSString *stringValue;
@end

//
//  ASRegister.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASMutableStorage.h>

@interface ASRegister : ASMutableStorage

- (id)initWithName:(NSString *)n;

- (void)raise:(NSString *)format, ...;

- (NSString *)hexStringForWordAtIndex:(ASIndex)idx;
- (NSString *)hexStringForByteAtIndex:(ASIndex)idx;

- (NSString *)binaryStringForWordAtIndex:(ASIndex)idx;
- (NSString *)binaryStringForByteAtIndex:(ASIndex)idx;

@property (nonatomic, copy, readonly) NSString *name;
@end

//
//  ASSubRegister.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASSubRegister.h"

@interface ASSubRegister ()
@property (nonatomic, retain) ASRegister *parent;
@end

@implementation ASSubRegister

- (id)initWithName:(NSString *)n parent:(ASRegister *)r {
    NSParameterAssert(r);
    
    self = [super initWithName:n];
    if (self) {
        self.parent = r;
    }
    return self;
}


- (void)dealloc {
    self.parent = nil;
    [super dealloc];
}


- (NSString *)hexStringForByteAtIndex:(ASIndex)idx {
    NSAssert(_parent, @"");
    return [_parent hexStringForByteAtIndex:idx];
}


- (NSString *)binaryStringForByteAtIndex:(ASIndex)idx {
    NSAssert(_parent, @"");
    return [_parent binaryStringForByteAtIndex:idx];
}


- (NSString *)hexStringForWordAtIndex:(ASIndex)idx {
    NSAssert(_parent, @"");
    return [_parent hexStringForWordAtIndex:idx];
}


- (NSString *)binaryStringForWordAtIndex:(ASIndex)idx {
    NSAssert(_parent, @"");
    return [_parent binaryStringForWordAtIndex:idx];
}


- (ASByte)byteAtIndex:(ASIndex)idx {
    NSAssert(_parent, @"");
    return [_parent byteAtIndex:idx];
}


- (ASWord)wordAtIndex:(ASIndex)idx {
    NSAssert(_parent, @"");
    return [_parent wordAtIndex:idx];
}


- (void)setByte:(ASByte)byte atIndex:(ASIndex)idx {
    NSAssert(_parent, @"");
    [_parent setByte:byte atIndex:idx];
}


- (void)setWord:(ASWord)word atIndex:(ASIndex)idx {
    NSAssert(_parent, @"");
    [_parent setWord:word atIndex:idx];
}


- (ASDword)dwordValue {
    [self raise:@"cannot retrieve dword value from %@", self.name];
    return 0;
}


- (void)setDwordValue:(ASDword)dword {
    [self raise:@"cannot set dword value on %@", self.name];
}

@end

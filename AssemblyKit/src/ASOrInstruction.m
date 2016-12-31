//
//  ASOrInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASOrInstruction.h>

@implementation ASOrInstruction

- (NSString *)name {
    return @"or";
}


- (ASByte)byteOp:(ASByte)src dest:(ASByte)dest {
    return src | dest;
}


- (ASWord)wordOp:(ASWord)src dest:(ASWord)dest {
    return src | dest;
}


- (ASDword)dwordOp:(ASDword)src dest:(ASDword)dest {
    return src | dest;
}

@end

//
//  ASMovInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASMovInstruction.h>
#import <AssemblyKit/ASContext.h>

@implementation ASMovInstruction

- (NSString *)name {
    return @"mov";
}


- (ASByte)byteOp:(ASByte)src dest:(ASByte)dest {
    return src;
}


- (ASWord)wordOp:(ASWord)src dest:(ASWord)dest {
    return src;
}


- (ASDword)dwordOp:(ASDword)src dest:(ASDword)dest {
    return src;
}

@end

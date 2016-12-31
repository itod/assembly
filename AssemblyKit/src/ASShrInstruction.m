//
//  ASShrInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASShrInstruction.h>

@implementation ASShrInstruction

- (NSString *)name {
    return @"shr";
}


- (ASByte)byteOp:(ASByte)src dest:(ASByte)dest {
    return dest >> src;
}


- (ASWord)wordOp:(ASWord)src dest:(ASWord)dest {
    return dest >> src;
}


- (ASDword)dwordOp:(ASDword)src dest:(ASDword)dest {
    return dest >> src;
}

@end

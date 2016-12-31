//
//  ASEFlagsRegister.h
//  Assembly
//
//  Created by Todd Ditchendorf on 3/3/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASRegister.h>

@interface ASEFlagsRegister : ASRegister

@property (nonatomic, assign) BOOL overflowFlag;
@property (nonatomic, assign) BOOL directionFlag;
@property (nonatomic, assign) BOOL interruptDisableFlag;
@property (nonatomic, assign) BOOL signFlag;
@property (nonatomic, assign) BOOL zeroFlag;
@property (nonatomic, assign) BOOL auxiliaryCarryFlag;
@property (nonatomic, assign) BOOL parityFlag;
@property (nonatomic, assign) BOOL carryFlag;
@end

//
//  ASUnaryInstruction.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASUnaryInstruction.h>

@implementation ASUnaryInstruction

- (void)compile {
    [self checkArgumentCountForMin:1 max:1];
    
    self.args[0] = [self.args[0] simplify];
    
    if (![self.destination isRegister] && ![self.destination isMemory]) {
        [self raise:@"%@: Illegal dest argument : %@", self.name, self.destination];
    }
}


//- (ASByte)byteOp:(ASByte)dest {
//    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
//    return 0;
//}
//
//
//- (ASWord)wordOp:(ASWord)dest {
//    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
//    return 0;
//}
//
//
//- (ASDword)dwordOp:(ASDword)dest {
//    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
//    return 0;
//}


- (ASMutableStorageExpression *)destination {
    return self.args[0];
}

@end
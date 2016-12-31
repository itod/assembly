//
//  ASSubRegister.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASRegister.h>

@interface ASSubRegister : ASRegister

- (id)initWithName:(NSString *)n parent:(ASRegister *)r;
@end

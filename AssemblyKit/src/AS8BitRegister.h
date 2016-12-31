//
//  AS8BitRegister.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASSubRegister.h"

@interface AS8BitRegister : ASSubRegister

- (id)initWithName:(NSString *)n parent:(ASRegister *)r isHighOrderByte:(BOOL)yn;

@property (nonatomic, assign, readonly) BOOL isHighOrderByte;
@end

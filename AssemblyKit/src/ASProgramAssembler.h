//
//  ASProgramAssembler.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/17/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASContext;
@class ASProgram;

@interface ASProgramAssembler : NSObject

- (id)initWithContext:(ASContext *)ctx;

- (void)reset;

@property (nonatomic, retain, readonly) ASContext *context;
@property (nonatomic, retain, readonly) ASProgram *program;
@end

//
//  ASStatement.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASContext;

@interface ASStatement : NSObject

- (id)initWithLineNumber:(NSUInteger)n;

- (void)compile;
- (void)executeInContext:(ASContext *)ctx;

@property (nonatomic, assign, readonly) NSUInteger lineNumber;
@end
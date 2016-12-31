//
//  ASMemoryHeaderListItem.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/26/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASMemoryHeaderListItem.h"

#define DEFAULT_HEIGHT 8.0

@implementation ASMemoryHeaderListItem

+ (NSString *)identifier {
    return NSStringFromClass(self);
}


+ (CGFloat)defaultHeight {
    return DEFAULT_HEIGHT;
}


- (id)init {
    self = [self initWithFrame:CGRectZero reuseIdentifier:[[self class] identifier]];
    return self;
}


- (id)initWithFrame:(NSRect)frame reuseIdentifier:(NSString *)s {
    NSParameterAssert(s);
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}


- (void)dealloc {

    [super dealloc];
}

@end
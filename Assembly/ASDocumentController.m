//
//  ASDocumentController.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/18/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ASDocumentController.h"

@interface ASDocumentController ()
- (void)setFullScreenOptions;
@end

@implementation ASDocumentController

- (void)awakeFromNib {
    [self setFullScreenOptions];
}


- (void)setFullScreenOptions {
    NSApplicationPresentationOptions opts = [NSApp presentationOptions];
    opts |= NSApplicationPresentationFullScreen;
    @try {
        [NSApp setPresentationOptions:opts];
    } @catch (NSException *ex) {
        NSLog(@"can't go fullscreeen");
    }
}

@end

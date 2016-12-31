//
//  MemoryTests.m
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "MemoryTests.h"

@implementation MemoryTests

- (void)setUp {
    [super setUp];
    
    self.ctx = [[[ASContext alloc] initWithDelegate:nil] autorelease];
}


- (void)tearDown {
    self.ctx = nil;
    
    [super tearDown];
}


- (void)testByteStorage {
    
    ASByte b = 0xFE;
    ASDword addr = 0x000FFFFF;
    
    [_ctx setByte:b atMemoryAddress:addr];
    ASByte res = [_ctx byteAtMemoryAddress:addr];
    
    TDEquals(b, res);
    
    b = 0xD3;
    [_ctx setByte:b atMemoryAddress:addr];
    res = [_ctx byteAtMemoryAddress:addr];
    
    TDEquals(b, res);
}


- (void)testWordStorage {
    
    ASWord w = 0x00FF;
    ASDword addr = 0x00FFFFFF;
    
    [_ctx setWord:w atMemoryAddress:addr];
    ASWord res = [_ctx wordAtMemoryAddress:addr];
    
    TDEquals(w, res);
    
    w = 0xD3FF;
    [_ctx setWord:w atMemoryAddress:addr];
    res = [_ctx wordAtMemoryAddress:addr];
    
    TDEquals(w, res);
}


- (void)testDwordStorage {
    
    ASDword d = 0x00FF00FF;
    ASDword addr = 0x00FFFFFF;
    
    [_ctx setDword:d atMemoryAddress:addr];
    ASDword res = [_ctx dwordAtMemoryAddress:addr];
    
    TDEquals(d, res);
    
    d = 0xD3FF00;
    [_ctx setDword:d atMemoryAddress:addr];
    res = [_ctx dwordAtMemoryAddress:addr];
    
    TDEquals(d, res);
}


@end

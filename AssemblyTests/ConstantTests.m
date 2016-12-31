//
//  ConstantTests.m
//  ConstantTests
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "ConstantTests.h"

@implementation ConstantTests

- (void)setUp {
    [super setUp];
    
}


- (void)tearDown {
    self.expr = nil;
    
    [super tearDown];
}


- (void)testintegerValue0xffffffff {
    
    ASDword dword = 0xffffffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    ASInteger i = -1;
    
    self.expr = [[[ASMutableStorage alloc] initWithDword:dword] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
    
    TDEquals(i, _expr.integerValue);
    
    TDEqualObjects(@"%1111_1111_1111_1111_1111_1111_1111_1111", [_expr asBinaryString]);
    TDEqualObjects(@"$FFFF_FFFF", [_expr asHexString]);
    TDEqualObjects(@"-1", [_expr asDecimalString]);
}


- (void)testintegerValue_1 {
    
    ASDword dword = 0xffffffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    ASInteger i = -1;
    
    self.expr = [[[ASMutableStorage alloc] initWithDword:i] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
    
    TDEquals(i, _expr.integerValue);
    
    TDEqualObjects(@"%1111_1111_1111_1111_1111_1111_1111_1111", [_expr asBinaryString]);
    TDEqualObjects(@"$FFFF_FFFF", [_expr asHexString]);
    TDEqualObjects(@"-1", [_expr asDecimalString]);
}


- (void)testDword0xffffffff {
    
    ASDword dword = 0xffffffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    self.expr = [[[ASMutableStorage alloc] initWithDword:dword] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
    
    TDEqualObjects(@"%1111_1111_1111_1111_1111_1111_1111_1111", [_expr asBinaryString]);
    TDEqualObjects(@"$FFFF_FFFF", [_expr asHexString]);
    TDEqualObjects(@"-1", [_expr asDecimalString]);
}


- (void)testDword0x80000000 {
    
    ASDword dword = 0x80000000;
    ASWord word = 0x0000;
    ASByte byte = 0x00;
    
    self.expr = [[[ASMutableStorage alloc] initWithDword:dword] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
    
    TDEqualObjects(@"%1000_0000_0000_0000_0000_0000_0000_0000", [_expr asBinaryString]);
    TDEqualObjects(@"$8000_0000", [_expr asHexString]);
    TDEqualObjects(@"-2147483648", [_expr asDecimalString]);
}


- (void)testDword0x00008000 {
    
    ASDword dword = 0x00008000;
    ASWord word = 0x8000;
    ASByte byte = 0x00;
    
    self.expr = [[[ASMutableStorage alloc] initWithDword:dword] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
    
    TDEqualObjects(@"%0000_0000_0000_0000_1000_0000_0000_0000", [_expr asBinaryString]);
    TDEqualObjects(@"$0000_8000", [_expr asHexString]);
    TDEqualObjects(@"32768", [_expr asDecimalString]);
}


- (void)testWord0x00008000 {
    
    ASDword dword = 0x00008000;
    ASWord word = 0x8000;
    ASByte byte = 0x00;
    
    self.expr = [[[ASMutableStorage alloc] initWithWord:word] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
    
    TDEqualObjects(@"%0000_0000_0000_0000_1000_0000_0000_0000", [_expr asBinaryString]);
    TDEqualObjects(@"$0000_8000", [_expr asHexString]);
    TDEqualObjects(@"32768", [_expr asDecimalString]);
}


- (void)testDword0x0000ffff {
    ASDword dword = 0x0000ffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    self.expr = [[[ASMutableStorage alloc] initWithDword:dword] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
}


- (void)testDword0x000000ff {
    ASDword dword = 0x000000ff;
    ASWord word = 0x00ff;
    ASByte byte = 0xff;
    
    self.expr = [[[ASMutableStorage alloc] initWithDword:dword] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
}


- (void)testDword0x00000000 {
    ASDword dword = 0x00000000;
    ASWord word = 0x0000;
    ASByte byte = 0x00;
    
    self.expr = [[[ASMutableStorage alloc] initWithDword:dword] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
}


- (void)testWord0xffff {
    ASDword dword = 0x0000ffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    self.expr = [[[ASMutableStorage alloc] initWithWord:word] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);

    TDEqualObjects(@"%0000_0000_0000_0000_1111_1111_1111_1111", [_expr asBinaryString]);
    TDEqualObjects(@"$0000_FFFF", [_expr asHexString]);
    TDEqualObjects(@"65535", [_expr asDecimalString]);
}


- (void)testWord0x00ff {
    ASDword dword = 0x000000ff;
    ASWord word = 0x00ff;
    ASByte byte = 0xff;
    
    self.expr = [[[ASMutableStorage alloc] initWithWord:word] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
    
    TDEqualObjects(@"%0000_0000_0000_0000_0000_0000_1111_1111", [_expr asBinaryString]);
    TDEqualObjects(@"$0000_00FF", [_expr asHexString]);
    TDEqualObjects(@"255", [_expr asDecimalString]);
}


- (void)testWord0x007f {
    ASDword dword = 0x0000007f;
    ASWord word = 0x007f;
    ASByte byte = 0x7f;
    
    self.expr = [[[ASMutableStorage alloc] initWithWord:word] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
    
    TDEqualObjects(@"%0000_0000_0000_0000_0000_0000_0111_1111", [_expr asBinaryString]);
    TDEqualObjects(@"$0000_007F", [_expr asHexString]);
    TDEqualObjects(@"127", [_expr asDecimalString]);
}


- (void)testWord0x0000 {
    ASDword dword = 0x00000000;
    ASWord word = 0x0000;
    ASByte byte = 0x00;
    
    self.expr = [[[ASMutableStorage alloc] initWithWord:word] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
}


- (void)testByte0xff {
    ASDword dword = 0x000000ff;
    ASWord word = 0x00ff;
    ASByte byte = 0xff;
    
    self.expr = [[[ASMutableStorage alloc] initWithByte:byte] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
}


- (void)testByte0x00 {
    ASDword dword = 0x00000000;
    ASWord word = 0x0000;
    ASByte byte = 0x00;
    
    self.expr = [[[ASMutableStorage alloc] initWithByte:byte] autorelease];
    TDNotNil(_expr);
    TDEquals(dword, _expr.dwordValue);
    TDEquals(word, _expr.wordValue);
    TDEquals(byte, _expr.byteValue);
}

@end

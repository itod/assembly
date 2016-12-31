//
//  RegisterTests.m
//  RegisterTests
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "RegisterTests.h"

@implementation RegisterTests

- (void)setUp {
    [super setUp];
    
    self.ctx = [[[ASContext alloc] initWithDelegate:nil] autorelease];
}


- (void)tearDown {
    
    [super tearDown];
}


- (void)testAxDecimal15 {
    ASDword dword = 0x0000000f;
    ASWord word = 0x000f;
    ASByte hob = 0x00;
    ASByte lob = 0x0f;
    
    ASInteger i = 15;
    
    _ctx.ax.integerValue = i;
    
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(lob, _ctx.eax.byteValue);
    
    TDEquals(word, _ctx.ax.wordValue);
    TDEquals(lob, _ctx.ax.byteValue);
    
    TDEquals(hob, _ctx.ah.byteValue);
    TDEquals(lob, _ctx.al.byteValue);
    
}


- (void)testAxDecimal256 {
    ASDword dword = 0x00000100;
    ASWord word = 0x0100;
    ASByte hob = 0x01;
    ASByte lob = 0x00;
    
    ASInteger i = 256;
    
    _ctx.ax.integerValue = i;
    
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(lob, _ctx.eax.byteValue);
    
    TDEquals(word, _ctx.ax.wordValue);
    TDEquals(lob, _ctx.ax.byteValue);
    
    TDEquals(hob, _ctx.ah.byteValue);
    TDEquals(lob, _ctx.al.byteValue);
    
}


- (void)testAxDecimal16 {
    ASDword dword = 0x00000010;
    ASWord word = 0x0010;
    ASByte hob = 0x00;
    ASByte lob = 0x10;
    
    ASInteger i = 16;
    
    _ctx.ax.integerValue = i;
    
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(lob, _ctx.eax.byteValue);
    
    TDEquals(word, _ctx.ax.wordValue);
    TDEquals(lob, _ctx.ax.byteValue);
    
    TDEquals(hob, _ctx.ah.byteValue);
    TDEquals(lob, _ctx.al.byteValue);
    
}


- (void)testAxDword0x0000ffff {
    
    ASDword dword = 0x0000ffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    _ctx.ax.wordValue = word;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
    
    TDEquals(word, _ctx.ax.wordValue);
    TDEquals(byte, _ctx.ax.byteValue);
    
    TDEquals(byte, _ctx.ah.byteValue);
    TDEquals(byte, _ctx.al.byteValue);
    
    TDEqualObjects(@"%0000_0000_0000_0000_1111_1111_1111_1111", [_ctx.eax asBinaryString]);
    TDEqualObjects(@"$0000_FFFF", [_ctx.eax asHexString]);
    TDEqualObjects(@"65535", [_ctx.eax asDecimalString]);
    
    TDEqualObjects(@"%1111_1111_1111_1111", [_ctx.ax asBinaryString]);
    TDEqualObjects(@"$FFFF", [_ctx.ax asHexString]);
    TDEqualObjects(@"-1", [_ctx.ax asDecimalString]);
    
    TDEqualObjects(@"%1111_1111", [_ctx.al asBinaryString]);
    TDEqualObjects(@"$FF", [_ctx.al asHexString]);
    TDEqualObjects(@"-1", [_ctx.al asDecimalString]);

    TDEqualObjects(@"%1111_1111", [_ctx.ah asBinaryString]);
    TDEqualObjects(@"$FF", [_ctx.ah asHexString]);
    TDEqualObjects(@"-1", [_ctx.ah asDecimalString]);
}


- (void)testAxDword0x0000f0ff {
    
    ASDword dword = 0x0000f0ff;
    ASWord word = 0xf0ff;
    ASByte hob = 0xf0;
    ASByte lob = 0xff;
    
    _ctx.ax.wordValue = word;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(lob, _ctx.eax.byteValue);
    
    TDEquals(word, _ctx.ax.wordValue);
    TDEquals(lob, _ctx.ax.byteValue);
    
    TDEquals(hob, _ctx.ah.byteValue);
    TDEquals(lob, _ctx.al.byteValue);
    
    TDEqualObjects(@"%0000_0000_0000_0000_1111_0000_1111_1111", [_ctx.eax asBinaryString]);
    TDEqualObjects(@"$0000_F0FF", [_ctx.eax asHexString]);
    TDEqualObjects(@"61695", [_ctx.eax asDecimalString]);
    
    TDEqualObjects(@"%1111_0000_1111_1111", [_ctx.ax asBinaryString]);
    TDEqualObjects(@"$F0FF", [_ctx.ax asHexString]);
    TDEqualObjects(@"-3841", [_ctx.ax asDecimalString]);
    
    TDEqualObjects(@"%1111_1111", [_ctx.al asBinaryString]);
    TDEqualObjects(@"$FF", [_ctx.al asHexString]);
    TDEqualObjects(@"-1", [_ctx.al asDecimalString]);
    
    TDEqualObjects(@"%1111_0000", [_ctx.ah asBinaryString]);
    TDEqualObjects(@"$F0", [_ctx.ah asHexString]);
    TDEqualObjects(@"-16", [_ctx.ah asDecimalString]);
}


- (void)testAlDword0x000000ff {
    
    ASDword dword = 0x000000ff;
    ASWord word = 0x00ff;
    ASByte hob = 0x00;
    ASByte lob = 0xff;
    
    _ctx.al.byteValue = lob;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(lob, _ctx.eax.byteValue);
    
    TDEquals(word, _ctx.ax.wordValue);
    TDEquals(lob, _ctx.ax.byteValue);
    
    TDEquals(hob, _ctx.ah.byteValue);
    TDEquals(lob, _ctx.al.byteValue);
    
    TDEqualObjects(@"%0000_0000_0000_0000_0000_0000_1111_1111", [_ctx.eax asBinaryString]);
    TDEqualObjects(@"$0000_00FF", [_ctx.eax asHexString]);
    TDEqualObjects(@"255", [_ctx.eax asDecimalString]);
    
    TDEqualObjects(@"%0000_0000_1111_1111", [_ctx.ax asBinaryString]);
    TDEqualObjects(@"$00FF", [_ctx.ax asHexString]);
    TDEqualObjects(@"255", [_ctx.ax asDecimalString]);
    
    TDEqualObjects(@"%1111_1111", [_ctx.al asBinaryString]);
    TDEqualObjects(@"$FF", [_ctx.al asHexString]);
    TDEqualObjects(@"-1", [_ctx.al asDecimalString]);
    
    TDEqualObjects(@"%0000_0000", [_ctx.ah asBinaryString]);
    TDEqualObjects(@"$00", [_ctx.ah asHexString]);
    TDEqualObjects(@"0", [_ctx.ah asDecimalString]);
}


- (void)testAhDword0x000000ff {
    
    ASDword dword = 0x0000ff00;
    ASWord word = 0xff00;
    ASByte hob = 0xff;
    ASByte lob = 0x00;
    
    _ctx.ah.byteValue = hob;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(lob, _ctx.eax.byteValue);
    
    TDEquals(word, _ctx.ax.wordValue);
    TDEquals(lob, _ctx.ax.byteValue);
    
    TDEquals(hob, _ctx.ah.byteValue);
    TDEquals(lob, _ctx.al.byteValue);
    
    TDEqualObjects(@"%0000_0000_0000_0000_1111_1111_0000_0000", [_ctx.eax asBinaryString]);
    TDEqualObjects(@"$0000_FF00", [_ctx.eax asHexString]);
    TDEqualObjects(@"65280", [_ctx.eax asDecimalString]);
    
    TDEqualObjects(@"%1111_1111_0000_0000", [_ctx.ax asBinaryString]);
    TDEqualObjects(@"$FF00", [_ctx.ax asHexString]);
    TDEqualObjects(@"-256", [_ctx.ax asDecimalString]);
    
    TDEqualObjects(@"%0000_0000", [_ctx.al asBinaryString]);
    TDEqualObjects(@"$00", [_ctx.al asHexString]);
    TDEqualObjects(@"0", [_ctx.al asDecimalString]);
    
    TDEqualObjects(@"%1111_1111", [_ctx.ah asBinaryString]);
    TDEqualObjects(@"$FF", [_ctx.ah asHexString]);
    TDEqualObjects(@"-1", [_ctx.ah asDecimalString]);

    TDEqualObjects(@"$0000", [_ctx.eax hexStringForWordAtIndex:1]);
    TDEqualObjects(@"$FF00", [_ctx.eax hexStringForWordAtIndex:0]);

    TDEqualObjects(@"$00", [_ctx.eax hexStringForByteAtIndex:0]);
    TDEqualObjects(@"$FF", [_ctx.eax hexStringForByteAtIndex:1]);
    TDEqualObjects(@"$00", [_ctx.eax hexStringForByteAtIndex:2]);
    TDEqualObjects(@"$00", [_ctx.eax hexStringForByteAtIndex:3]);

    TDEqualObjects(@"%0000_0000_0000_0000", [_ctx.eax binaryStringForWordAtIndex:1]);
    TDEqualObjects(@"%1111_1111_0000_0000", [_ctx.eax binaryStringForWordAtIndex:0]);
    
    TDEqualObjects(@"%0000_0000", [_ctx.eax binaryStringForByteAtIndex:0]);
    TDEqualObjects(@"%1111_1111", [_ctx.eax binaryStringForByteAtIndex:1]);
    TDEqualObjects(@"%0000_0000", [_ctx.eax binaryStringForByteAtIndex:2]);
    TDEqualObjects(@"%0000_0000", [_ctx.eax binaryStringForByteAtIndex:3]);
}


- (void)testBxDword0x0000ffff {
    
    ASDword dword = 0x0000ffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    _ctx.bx.wordValue = word;
    TDEquals(dword, _ctx.ebx.dwordValue);
    TDEquals(word, _ctx.ebx.wordValue);
    TDEquals(byte, _ctx.ebx.byteValue);
    
    TDEquals(word, _ctx.bx.wordValue);
    TDEquals(byte, _ctx.bx.byteValue);
    
    TDEquals(byte, _ctx.bh.byteValue);
    TDEquals(byte, _ctx.bl.byteValue);
}


- (void)testBxDword0x0000f0ff {
    
    ASDword dword = 0x0000f0ff;
    ASWord word = 0xf0ff;
    ASByte hob = 0xf0;
    ASByte lob = 0xff;
    
    _ctx.bx.wordValue = word;
    TDEquals(dword, _ctx.ebx.dwordValue);
    TDEquals(word, _ctx.ebx.wordValue);
    TDEquals(lob, _ctx.ebx.byteValue);
    
    TDEquals(word, _ctx.bx.wordValue);
    TDEquals(lob, _ctx.bx.byteValue);
    
    TDEquals(hob, _ctx.bh.byteValue);
    TDEquals(lob, _ctx.bl.byteValue);
}


- (void)testCxDword0x0000ffff {
    
    ASDword dword = 0x0000ffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    _ctx.cx.wordValue = word;
    TDEquals(dword, _ctx.ecx.dwordValue);
    TDEquals(word, _ctx.ecx.wordValue);
    TDEquals(byte, _ctx.ecx.byteValue);
    
    TDEquals(word, _ctx.cx.wordValue);
    TDEquals(byte, _ctx.cx.byteValue);
    
    TDEquals(byte, _ctx.ch.byteValue);
    TDEquals(byte, _ctx.cl.byteValue);
}


- (void)testCxDword0x0000f0ff {
    
    ASDword dword = 0x0000f0ff;
    ASWord word = 0xf0ff;
    ASByte hob = 0xf0;
    ASByte lob = 0xff;
    
    _ctx.cx.wordValue = word;
    TDEquals(dword, _ctx.ecx.dwordValue);
    TDEquals(word, _ctx.ecx.wordValue);
    TDEquals(lob, _ctx.ecx.byteValue);
    
    TDEquals(word, _ctx.cx.wordValue);
    TDEquals(lob, _ctx.cx.byteValue);
    
    TDEquals(hob, _ctx.ch.byteValue);
    TDEquals(lob, _ctx.cl.byteValue);
}


- (void)testDxDword0x0000ffff {
    
    ASDword dword = 0x0000ffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    _ctx.dx.wordValue = word;
    TDEquals(dword, _ctx.edx.dwordValue);
    TDEquals(word, _ctx.edx.wordValue);
    TDEquals(byte, _ctx.edx.byteValue);
    
    TDEquals(word, _ctx.dx.wordValue);
    TDEquals(byte, _ctx.dx.byteValue);
    
    TDEquals(byte, _ctx.dh.byteValue);
    TDEquals(byte, _ctx.dl.byteValue);
}


- (void)testDxDword0x0000f0ff {
    
    ASDword dword = 0x0000f0ff;
    ASWord word = 0xf0ff;
    ASByte hob = 0xf0;
    ASByte lob = 0xff;
    
    _ctx.dx.wordValue = word;
    TDEquals(dword, _ctx.edx.dwordValue);
    TDEquals(word, _ctx.edx.wordValue);
    TDEquals(lob, _ctx.edx.byteValue);
    
    TDEquals(word, _ctx.dx.wordValue);
    TDEquals(lob, _ctx.dx.byteValue);
    
    TDEquals(hob, _ctx.dh.byteValue);
    TDEquals(lob, _ctx.dl.byteValue);
}


- (void)testEaxDword0xffffffff {
    
    ASDword dword = 0xffffffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;

    _ctx.eax.dwordValue = dword;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
}


- (void)testEaxDword0x0000ffff {
    TDNotNil(_ctx.eax);

    ASDword dword = 0x0000ffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    _ctx.eax.dwordValue = dword;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
}


- (void)testEaxDword0x000000ff {
    TDNotNil(_ctx.eax);

    ASDword dword = 0x000000ff;
    ASWord word = 0x00ff;
    ASByte byte = 0xff;
    
    _ctx.eax.dwordValue = dword;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
}


- (void)testEaxDword0x00000000 {
    TDNotNil(_ctx.eax);

    ASDword dword = 0x00000000;
    ASWord word = 0x0000;
    ASByte byte = 0x00;
    
    _ctx.eax.dwordValue = dword;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
}


- (void)testEaxWord0xffff {
    TDNotNil(_ctx.eax);

    ASDword dword = 0x0000ffff;
    ASWord word = 0xffff;
    ASByte byte = 0xff;
    
    _ctx.eax.wordValue = word;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
}


- (void)testEaxWord0x00ff {
    TDNotNil(_ctx.eax);
    
    ASDword dword = 0x000000ff;
    ASWord word = 0x00ff;
    ASByte byte = 0xff;
    
    _ctx.eax.wordValue = word;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
}


- (void)testEaxWord0x0000 {
    TDNotNil(_ctx.eax);
    
    ASDword dword = 0x00000000;
    ASWord word = 0x0000;
    ASByte byte = 0x00;
    
    _ctx.eax.wordValue = word;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
}


- (void)testEaxByte0xff {
    TDNotNil(_ctx.eax);
    
    ASDword dword = 0x000000ff;
    ASWord word = 0x00ff;
    ASByte byte = 0xff;
    
    _ctx.eax.byteValue = byte;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
}


- (void)testEaxByte0x00 {
    TDNotNil(_ctx.eax);
    
    ASDword dword = 0x00000000;
    ASWord word = 0x0000;
    ASByte byte = 0x00;
    
    _ctx.eax.byteValue = byte;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(word, _ctx.eax.wordValue);
    TDEquals(byte, _ctx.eax.byteValue);
}



@end

//
//  InstructionTests.m
//  InstructionTests
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import "InstructionTests.h"

@implementation InstructionTests

- (void)setUp {
    [super setUp];
    
    self.ctx = [[[ASContext alloc] initWithDelegate:nil] autorelease];
    self.runner = [[[ASProgramRunner alloc] initWithContext:_ctx] autorelease];
}


- (void)tearDown {
    self.ctx = nil;
    self.runner = nil;
    
    [super tearDown];
}


- (void)testPackedDate {
    NSString *input =
        @"mov(4, al);"
        @"shl(5, ax);"
        @"or(2, al);"
        @"shl(7, ax);"
        @"or(1, al);";
    
    NSError *err = nil;
    ASProgram *prog = [_runner compiledProgramFromInput:input error:&err];
    TDNotNil(prog);
    TDNil(err);
    
    BOOL success = [_runner runProgram:prog error:&err];
    TDTrue(success);
    TDNil(err);
    
    ASDword res = 0x4101;
    TDEquals(res, _ctx.eax.dwordValue);
}


- (void)testHexBin {
    NSString *input =
        @"mov($ffff_ffff, eax);"
        @"mov(%1000_0010, bl);";
    
    NSError *err = nil;
    ASProgram *prog = [_runner compiledProgramFromInput:input error:&err];
    TDNotNil(prog);
    TDNil(err);
    
    BOOL success = [_runner runProgram:prog error:&err];
    TDTrue(success);
    TDNil(err);
    
    ASDword dword = 0xffffffff;
    ASByte byte = 0x82;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(byte, _ctx.bl.byteValue);
}


- (void)testPushPopDword {
    NSString *input =
        @"mov(esp, ecx);"
        @"mov($FFEE_EEFF, eax);"
        @"push(eax);"
        @"mov(esp, edx);"
        @"pop(ebx);";
    
    NSError *err = nil;
    ASProgram *prog = [_runner compiledProgramFromInput:input error:&err];
    TDNotNil(prog);
    TDNil(err);
    
    BOOL success = [_runner runProgram:prog error:&err];
    TDTrue(success);
    TDNil(err);
    
    ASDword dword = 0xFFEEEEFF;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(dword, _ctx.ebx.dwordValue);
    TDEquals(_ctx.esp.dwordValue, _ctx.ecx.dwordValue);
    TDEquals(_ctx.esp.dwordValue, _ctx.edx.dwordValue + 4);
}


- (void)testPushPopDword2 {
    NSString *input =
        @"mov($1234_5678, eax);"
        @"mov($CCCC_DDDD, ebx);"
        @"push(eax);"
        @"push(ebx);"
        @"pop(eax);"
        @"pop(ebx);"
    ;
    
    NSError *err = nil;
    ASProgram *prog = [_runner compiledProgramFromInput:input error:&err];
    TDNotNil(prog);
    TDNil(err);
    
    BOOL success = [_runner runProgram:prog error:&err];
    TDTrue(success);
    TDNil(err);
    
    ASDword d1 = 0xCCCCDDDD;
    ASDword d2 = 0x12345678;
    TDEquals(d1, _ctx.eax.dwordValue);
    TDEquals(d2, _ctx.ebx.dwordValue);
}


- (void)testPushPopWord {
    NSString *input =
        @"mov(sp, cx);"
        @"mov($EEFF, ax);"
        @"push(ax);"
        @"mov(sp, dx);"
        @"pop(bx);";
    
    NSError *err = nil;
    ASProgram *prog = [_runner compiledProgramFromInput:input error:&err];
    TDNotNil(prog);
    TDNil(err);
    
    BOOL success = [_runner runProgram:prog error:&err];
    TDTrue(success);
    TDNil(err);
    
    ASWord word = 0xEEFF;
    TDEquals(word, _ctx.ax.wordValue);
    TDEquals(word, _ctx.bx.wordValue);
    TDEquals(_ctx.sp.wordValue, _ctx.cx.wordValue);
    
    word = _ctx.dx.wordValue + 2;
    TDEquals(_ctx.sp.wordValue, word);
}


- (void)testMemoryRegisterIndirect {
    NSString *input =
        @"mov($ffff_fffc, eax);"
        @"push(eax);"
        @"mov([eax], ebx);"
    ;
    
    NSError *err = nil;
    ASProgram *prog = [_runner compiledProgramFromInput:input error:&err];
    TDNotNil(prog);
    TDNil(err);
    
    BOOL success = [_runner runProgram:prog error:&err];
    TDTrue(success);
    TDNil(err);
    
    ASDword dword = 0xFFFFFFFC;
    TDEquals(dword, _ctx.eax.dwordValue);
    TDEquals(dword, _ctx.ebx.dwordValue);
    TDEquals(dword, [_ctx dwordAtMemoryAddress:dword]);
}


- (void)testMemoryRegisterIndexed {
    NSString *input =
        @"mov($ffff_fffc, eax);"
        @"push(eax);"
        @"mov($ffff_fff8, eax);"
        @"mov(4[eax], ebx);"
    ;
    
    NSError *err = nil;
    ASProgram *prog = [_runner compiledProgramFromInput:input error:&err];
    TDNotNil(prog);
    TDNil(err);
    
    BOOL success = [_runner runProgram:prog error:&err];
    TDTrue(success);
    TDNil(err);
    
    ASDword aVal = 0xFFFFFFF8;
    ASDword bVal = 0xFFFFFFFC;
    TDEquals(aVal, _ctx.eax.dwordValue);
    TDEquals(bVal, _ctx.ebx.dwordValue);
    TDEquals(bVal, [_ctx dwordAtMemoryAddress:bVal]);
}

@end
//
//  ASContext.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASContext.h>
#import <AssemblyKit/ASRegister.h>
#import <AssemblyKit/ASEFlagsRegister.h>
#import <AssemblyKit/ASUtils.h>

#import "AS16BitRegister.h"
#import "AS8BitRegister.h"

#define MIN_ADDR 1024 * 128 // 128kb of storage reserved by system

@interface ASContext ()
- (void)addRegister:(ASRegister *)r;
@property (nonatomic, retain) NSMutableDictionary *regTab;
@property (nonatomic, retain) NSMutableDictionary *memory;
@end

@implementation ASContext

- (id)init {
    return [self initWithDelegate:nil];
}


- (id)initWithDelegate:(id <ASContextDelegate>)d {
    self = [super init];
    if (self) {
        self.delegate = d;
        [self reset];
    }
    return self;
}


- (void)dealloc {
    self.delegate = nil;
    self.regTab = nil;
    self.memory = nil;
    
    self.eFlags = nil;
    
	self.al = nil;
	self.ah = nil;
	self.bl = nil;
	self.bh = nil;
	self.cl = nil;
	self.ch = nil;
	self.dl = nil;
	self.dh = nil;
    
	self.si = nil;
	self.di = nil;
	self.bp = nil;
	self.sp = nil;
    
	self.ax = nil;
	self.bx = nil;
	self.cx = nil;
	self.dx = nil;
    
	self.esi = nil;
	self.edi = nil;
	self.ebp = nil;
	self.esp = nil;

	self.eax = nil;
	self.ebx = nil;
	self.ecx = nil;
	self.edx = nil;
    
    [super dealloc];
}


- (void)reset {
    self.memory = [NSMutableDictionary dictionary];
    self.regTab = [NSMutableDictionary dictionary];
    
    self.eFlags = [[[ASEFlagsRegister alloc] init] autorelease];
    
	self.eax = [[[ASRegister alloc] initWithName:@"EAX"] autorelease];
	self.ebx = [[[ASRegister alloc] initWithName:@"EBX"] autorelease];
	self.ecx = [[[ASRegister alloc] initWithName:@"ECX"] autorelease];
	self.edx = [[[ASRegister alloc] initWithName:@"EDX"] autorelease];
    
	self.esi = [[[ASRegister alloc] initWithName:@"ESI"] autorelease];
	self.edi = [[[ASRegister alloc] initWithName:@"EDI"] autorelease];
	self.ebp = [[[ASRegister alloc] initWithName:@"EBP"] autorelease];
	self.esp = [[[ASRegister alloc] initWithName:@"ESP"] autorelease];
    
	self.ax = [[[AS16BitRegister alloc] initWithName:@"AX" parent:_eax] autorelease];
	self.bx = [[[AS16BitRegister alloc] initWithName:@"BX" parent:_ebx] autorelease];
	self.cx = [[[AS16BitRegister alloc] initWithName:@"CX" parent:_ecx] autorelease];
	self.dx = [[[AS16BitRegister alloc] initWithName:@"DX" parent:_edx] autorelease];
    
	self.si = [[[AS16BitRegister alloc] initWithName:@"SI" parent:_esi] autorelease];
	self.di = [[[AS16BitRegister alloc] initWithName:@"DI" parent:_edi] autorelease];
	self.bp = [[[AS16BitRegister alloc] initWithName:@"BP" parent:_ebp] autorelease];
	self.sp = [[[AS16BitRegister alloc] initWithName:@"SP" parent:_esp] autorelease];

	self.al = [[[AS8BitRegister alloc] initWithName:@"AL" parent:_eax isHighOrderByte:NO] autorelease];
	self.ah = [[[AS8BitRegister alloc] initWithName:@"AH" parent:_eax isHighOrderByte:YES] autorelease];
	self.bl = [[[AS8BitRegister alloc] initWithName:@"BL" parent:_ebx isHighOrderByte:NO] autorelease];
	self.bh = [[[AS8BitRegister alloc] initWithName:@"BH" parent:_ebx isHighOrderByte:YES] autorelease];
	self.cl = [[[AS8BitRegister alloc] initWithName:@"CL" parent:_ecx isHighOrderByte:NO] autorelease];
	self.ch = [[[AS8BitRegister alloc] initWithName:@"CH" parent:_ecx isHighOrderByte:YES] autorelease];
	self.dl = [[[AS8BitRegister alloc] initWithName:@"DL" parent:_edx isHighOrderByte:NO] autorelease];
	self.dh = [[[AS8BitRegister alloc] initWithName:@"DH" parent:_edx isHighOrderByte:YES] autorelease];
    
    [self addRegister:_eax];
    [self addRegister:_ebx];
    [self addRegister:_ecx];
    [self addRegister:_edx];
    
    [self addRegister:_esi];
    [self addRegister:_edi];
    [self addRegister:_ebp];
    [self addRegister:_esp];
    
    [self addRegister:_ax];
    [self addRegister:_bx];
    [self addRegister:_cx];
    [self addRegister:_dx];
    
    [self addRegister:_si];
    [self addRegister:_di];
    [self addRegister:_bp];
    [self addRegister:_sp];
    
    [self addRegister:_ah];
    [self addRegister:_bh];
    [self addRegister:_ch];
    [self addRegister:_dh];
    [self addRegister:_al];
    [self addRegister:_bl];
    [self addRegister:_cl];
    [self addRegister:_dl];
    
    self.esp.dwordValue = 0;
}


- (void)log:(NSString *)format, ... {
    va_list vargs;
    va_start(vargs, format);

    NSString *str = [[[NSString alloc] initWithFormat:format arguments:vargs] autorelease];
    
    va_end(vargs);

    [_delegate context:self didLog:str];
}


- (ASRegister *)registerNamed:(NSString *)name {
    NSParameterAssert([name length]);
    
    name = [name lowercaseString];
    
    ASRegister *r = _regTab[name];
    NSAssert(r, @"");
    return r;
}


- (ASByte)byteAtMemoryAddress:(ASDword)addr {
    NSAssert(_memory, @"");

    if (addr < MIN_ADDR) {
        [NSException raise:@"" format:@""];
        return 0;
    }
    
    NSNumber *key = [NSNumber numberWithUnsignedInt:addr];
    NSValue *val = _memory[key];
    
    ASByte b = 0x00;
    
    if (val) {
        [val getValue:&b];
    }
    
    return b;
}


- (ASWord)wordAtMemoryAddress:(ASDword)addr {
    NSParameterAssert(addr > 0);
    NSAssert(_memory, @"");

    ASWord result = 0;
    
    ASSize numBytes = 2;
    
    ASDword lastAddr = addr + (numBytes - 1);

    if (self.isBigEndian) {
        for (ASDword currAddr = addr; currAddr <= lastAddr; ++currAddr) {
            if (currAddr < MIN_ADDR) break;

            ASByte b = [self byteAtMemoryAddress:currAddr];
            result |= b;

            if (currAddr < lastAddr) {
                result <<= 8;
            }
        }
    } else {
        for (ASDword currAddr = lastAddr; currAddr >= addr; --currAddr) {
            if (currAddr < MIN_ADDR) break;

            ASByte b = [self byteAtMemoryAddress:currAddr];
            result |= b;

            if (currAddr > addr) {
                result <<= 8;
            }
        }
    }
    
    return result;
}


- (ASDword)dwordAtMemoryAddress:(ASDword)addr {
    NSParameterAssert(addr > 0);
    NSAssert(_memory, @"");
    
    ASDword result = 0;
    
    ASSize numBytes = 4;
    
    ASDword lastAddr = addr + (numBytes - 1);

//    NSLog(@"addr %@", ASHexStringFromDword(addr));
//    NSLog(@"lastAddr %@", ASHexStringFromDword(lastAddr));
    
    if (self.isBigEndian) {
        for (ASDword currAddr = addr; currAddr <= lastAddr; ++currAddr) {
            if (currAddr < MIN_ADDR) break;
            
            ASByte b = [self byteAtMemoryAddress:currAddr];
            result |= b;
            
            if (currAddr < lastAddr) {
                result <<= 8;
            }
        }
    } else {
        for (ASDword currAddr = lastAddr; currAddr >= addr; --currAddr) {
            if (currAddr < MIN_ADDR) break;
            
            ASByte b = [self byteAtMemoryAddress:currAddr];
            result |= b;
            
            if (currAddr > addr) {
                result <<= 8;
            }
        }
    }
    
//    NSLog(@"res %@", ASHexStringFromDword(result));
    return result;
}


- (void)setByte:(ASByte)b atMemoryAddress:(ASDword)addr {
    NSAssert(_memory, @"");
    
    if (addr < MIN_ADDR) {
        [NSException raise:@"" format:@""];
    }

    NSNumber *key = [NSNumber numberWithUnsignedInt:addr];
    NSValue *val = [NSValue valueWithBytes:&b objCType:@encode(ASByte)];
    _memory[key] = val;
}


- (void)setWord:(ASWord)w atMemoryAddress:(ASDword)addr {
    NSAssert(_memory, @"");
    
    ASSize numBytes = 2;

    ASDword lastAddr = addr + (numBytes - 1);
    if (self.isBigEndian) {
        for (ASDword currAddr = lastAddr; currAddr >= addr; --currAddr) {
            if (currAddr < MIN_ADDR) break;
            
            if (currAddr < lastAddr) {
                w >>= 8;
            }
            
            ASByte b = w & 0x00FF;
            [self setByte:b atMemoryAddress:currAddr];
        }
    } else {
        for (ASDword currAddr = addr; currAddr <= lastAddr; ++currAddr) {
            if (currAddr < MIN_ADDR) break;
            
            if (currAddr > addr) {
                w >>= 8;
            }
            
            ASByte b = w & 0x00FF;
            [self setByte:b atMemoryAddress:currAddr];
        }
    }
}


- (void)setDword:(ASDword)d atMemoryAddress:(ASDword)addr {
    NSAssert(_memory, @"");
    
    ASSize numBytes = 4;

//    NSLog(@"in Addr: %@", ASHexStringFromDword(addr));
//    NSLog(@"last Addr: %@", ASHexStringFromDword(addr + numBytes));

    ASDword lastAddr = addr + (numBytes - 1);
    if (self.isBigEndian) {
        for (ASDword currAddr = lastAddr; currAddr >= addr; --currAddr) {
            if (currAddr < MIN_ADDR) break;
            
            if (currAddr < lastAddr) {
                d >>= 8;
            }
            
            ASByte b = d & 0x000000FF;
            [self setByte:b atMemoryAddress:currAddr];
        }
    } else {
        for (ASDword currAddr = addr; currAddr <= lastAddr; ++currAddr) {
            if (currAddr < MIN_ADDR) break;
            
            if (currAddr > addr) {
                d >>= 8;
            }
            
            ASByte b = d & 0x000000FF;
    //        NSLog(@"currAddr: %@", ASHexStringFromDword(currAddr));
    //        NSLog(@"b: %@", ASHexStringFromByte(b));
            [self setByte:b atMemoryAddress:currAddr];
        }
    }
}


#pragma mark -
#pragma mark Private 

- (void)addRegister:(ASRegister *)r {
    NSParameterAssert(r);
    NSAssert(_regTab, @"");
    
    NSString *name = [r.name lowercaseString];
    NSAssert([name length], @"");

    _regTab[name] = r;
}

@end

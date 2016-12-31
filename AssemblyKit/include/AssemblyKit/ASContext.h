//
//  ASContext.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssemblyKit/ASTypes.h>

@class ASContext;
@class ASRegister;
@class ASEFlagsRegister;

@protocol ASContextDelegate <NSObject>
- (void)context:(ASContext *)ctx didLog:(NSString *)str;
@end

@interface ASContext : NSObject

- (id)initWithDelegate:(id <ASContextDelegate>)d;

- (void)reset;
- (void)log:(NSString *)format, ...;

- (ASRegister *)registerNamed:(NSString *)name;

- (ASByte)byteAtMemoryAddress:(ASDword)addr;
- (ASWord)wordAtMemoryAddress:(ASDword)addr;
- (ASDword)dwordAtMemoryAddress:(ASDword)addr;

- (void)setByte:(ASByte)b atMemoryAddress:(ASDword)addr;
- (void)setWord:(ASWord)w atMemoryAddress:(ASDword)addr;
- (void)setDword:(ASDword)d atMemoryAddress:(ASDword)addr;

@property (nonatomic, assign) id <ASContextDelegate>delegate;

@property (nonatomic, retain) ASEFlagsRegister *eFlags;
@property (nonatomic, assign) BOOL isBigEndian;

@property (nonatomic, retain) ASRegister *al;
@property (nonatomic, retain) ASRegister *ah;
@property (nonatomic, retain) ASRegister *bl;
@property (nonatomic, retain) ASRegister *bh;
@property (nonatomic, retain) ASRegister *cl;
@property (nonatomic, retain) ASRegister *ch;
@property (nonatomic, retain) ASRegister *dl;
@property (nonatomic, retain) ASRegister *dh;

@property (nonatomic, retain) ASRegister *ax;
@property (nonatomic, retain) ASRegister *bx;
@property (nonatomic, retain) ASRegister *cx;
@property (nonatomic, retain) ASRegister *dx;

@property (nonatomic, retain) ASRegister *eax;
@property (nonatomic, retain) ASRegister *ebx;
@property (nonatomic, retain) ASRegister *ecx;
@property (nonatomic, retain) ASRegister *edx;

@property (nonatomic, retain) ASRegister *si;
@property (nonatomic, retain) ASRegister *di;
@property (nonatomic, retain) ASRegister *bp;
@property (nonatomic, retain) ASRegister *sp;

@property (nonatomic, retain) ASRegister *esi;
@property (nonatomic, retain) ASRegister *edi;
@property (nonatomic, retain) ASRegister *ebp;
@property (nonatomic, retain) ASRegister *esp;
@end

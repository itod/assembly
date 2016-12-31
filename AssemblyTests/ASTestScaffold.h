//
//  ASTestScaffold.h
//  Assembly
//
//  Created by Todd Ditchendorf on 2/16/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#ifndef Assembly_ASTestScaffold_h
#define Assembly_ASTestScaffold_h

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

#import <AssemblyKit/AssemblyKit.h>

#import "ASValue.h"

#import "ASMovInstruction.h"
#import "ASAndInstruction.h"
#import "ASOrInstruction.h"
#import "ASXorInstruction.h"
#import "ASNegInstruction.h"
#import "ASNotInstruction.h"
#import "ASShlInstruction.h"
#import "ASShrInstruction.h"
#import "ASPushInstruction.h"
#import "ASPopInstruction.h"

#import "AS32BitRegisterExpression.h"
#import "AS16BitRegisterExpression.h"
#import "AS8BitRegisterExpression.h"

#import "ASAddressRegisterIndirectExpression.h"
#import "ASAddressIndexedExpression.h"

#define TDTrue(e) STAssertTrue((e), @"")
#define TDFalse(e) STAssertFalse((e), @"")
#define TDNil(e) STAssertNil((e), @"")
#define TDNotNil(e) STAssertNotNil((e), @"")
#define TDEquals(e1, e2) STAssertEquals((e1), (e2), @"")
#define TDEqualObjects(e1, e2) STAssertEqualObjects((e1), (e2), @"")

#endif

//
//  ASUtils.m
//  Assembly
//
//  Created by Todd Ditchendorf on 2/23/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <AssemblyKit/ASUtils.h>

const ASIndex ASNotFound = UINT8_MAX;

static NSString *ASBinaryStringForLength(ASDword x, size_t len);

NSString *ASHexStringFromByte(ASByte byte) {
    NSString *str = [NSString stringWithFormat:@"$%02X", byte];
    return str;
}


NSString *ASHexStringFromWord(ASWord word) {
    NSString *str = [NSString stringWithFormat:@"$%04X", word];
    return str;
}


NSString *ASHexStringFromDword(ASDword dword) {
    ASWord words[2];
    
    words[1] = ((dword >> 16) & 0x0000FFFF);
    words[0] = ((dword >>  0) & 0x0000FFFF);
    
    NSString *str = [NSString stringWithFormat:@"$%04X_%04X", words[1], words[0]];
    
    return str;
}


NSString *ASBinaryStringFromByte(ASByte x) {
    return ASBinaryStringForLength(x, 10);
}


NSString *ASBinaryStringFromWord(ASWord x) {
    return ASBinaryStringForLength(x, 20);
}


NSString *ASBinaryStringFromDword(ASDword x) {
    return ASBinaryStringForLength(x, 40);
}


static NSString *ASBinaryStringForLength(ASDword x, size_t len) {
    unichar zBitStr[len];
    
    size_t bitIdx = 0;
    size_t strIdx = 0;
    
    while (strIdx < len) {
        if (!(bitIdx & 3)) { // 0 == bitIdx % 4
            zBitStr[len - strIdx] = '_';
            strIdx++;
        }
        
        unichar bit;
        if (x & 1) {
            bit = '1';
        } else {
            bit = '0';
        }
        zBitStr[len - strIdx] = bit;
        x >>= 1;
        
        strIdx++;
        bitIdx++;
    }
    
    zBitStr[0] = '%';
    
    NSString *str = [NSString stringWithCharacters:zBitStr length:len];
    return str;
}


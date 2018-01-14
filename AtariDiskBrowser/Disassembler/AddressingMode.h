//
//  AddressingMode.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 02/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#ifndef AddressingMode_h
#define AddressingMode_h

typedef NS_ENUM(NSUInteger, AddressingMode) {    
    Unknown = 0,
    // A
    Accumulator,
    // i
    Implied,
    // #
    Immediate,
    // a
    Absolute,
    // zp
    ZeroPage,
    // r
    Relative,
    // a,x
    AbsoluteIndexedX,
    // a,y
    AbsoluteIndexedY,
    // zp,x
    ZeroPageIndexedX,
    // zp,y
    ZeroPageIndexedY,
    // (ind)
    Indirect,
    // (zp,x)
    IndexedIndirect,
    // (zp),y
    IndirectIndexed
};

#endif /* AddressingMode_h */

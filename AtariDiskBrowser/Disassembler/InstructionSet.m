//
//  InstructionSet.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 02/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import "InstructionSet.h"
#import "Instruction.h"
#import "AddressingMode.h"

@implementation InstructionSet

- (id)init {
    self = [super init];
    if (self) {
        instructionTable[0x00] = [[Instruction alloc] initWithCode:0x00 Mnem:@"BRK" Mode:Implied Bytes:1 Cycles:7];
        instructionTable[0x01] = [[Instruction alloc] initWithCode:0x01 Mnem:@"ORA" Mode:IndexedIndirect Bytes:2 Cycles:6]; //izx 6
        instructionTable[0x02] = [[Instruction alloc] initWithCode:0x02 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; ; // *
        instructionTable[0x03] = [[Instruction alloc] initWithCode:0x03 Mnem:@"SLO" Mode:IndexedIndirect Bytes:2 Cycles:8]; //* izx 8 = ASO
        instructionTable[0x04] = [[Instruction alloc] initWithCode:0x04 Mnem:@"NOP" Mode:ZeroPage Bytes:2 Cycles:3]; //* zp 3
        instructionTable[0x05] = [[Instruction alloc] initWithCode:0x05 Mnem:@"ORA" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0x06] = [[Instruction alloc] initWithCode:0x06 Mnem:@"ASL" Mode:ZeroPage Bytes:2 Cycles:5]; //zp 5
        instructionTable[0x07] = [[Instruction alloc] initWithCode:0x07 Mnem:@"SLO" Mode:ZeroPage Bytes:2 Cycles:5]; //* zp 5 = ASO
        instructionTable[0x08] = [[Instruction alloc] initWithCode:0x08 Mnem:@"PHP" Mode:Implied Bytes:1 Cycles:3]; //3
        instructionTable[0x09] = [[Instruction alloc] initWithCode:0x09 Mnem:@"ORA" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0x0A] = [[Instruction alloc] initWithCode:0x0A Mnem:@"ASL" Mode:Accumulator Bytes:1 Cycles:2]; //2
        instructionTable[0x0B] = [[Instruction alloc] initWithCode:0x0B Mnem:@"ANC" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0x0C] = [[Instruction alloc] initWithCode:0x0C Mnem:@"NOP" Mode:Absolute Bytes:3 Cycles:4]; //* abs 4
        instructionTable[0x0D] = [[Instruction alloc] initWithCode:0x0D Mnem:@"ORA" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0x0E] = [[Instruction alloc] initWithCode:0x0E Mnem:@"ASL" Mode:Absolute Bytes:3 Cycles:6]; //abs 6
        instructionTable[0x0F] = [[Instruction alloc] initWithCode:0x0F Mnem:@"SLO" Mode:Absolute Bytes:3 Cycles:6]; //* abs 6 = ASO
        
        instructionTable[0x10] = [[Instruction alloc] initWithCode:0x10 Mnem:@"BPL" Mode:Relative Bytes:2 Cycles:3]; //rel 2 *
        instructionTable[0x11] = [[Instruction alloc] initWithCode:0x11 Mnem:@"ORA" Mode:IndirectIndexed Bytes:2 Cycles:5]; //izy 5 *
        instructionTable[0x12] = [[Instruction alloc] initWithCode:0x12 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0x13] = [[Instruction alloc] initWithCode:0x13 Mnem:@"SLO" Mode:IndirectIndexed Bytes:2 Cycles:8]; //* izy 8
        instructionTable[0x14] = [[Instruction alloc] initWithCode:0x14 Mnem:@"NOP" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //* zpx 4
        instructionTable[0x15] = [[Instruction alloc] initWithCode:0x15 Mnem:@"ORA" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0x16] = [[Instruction alloc] initWithCode:0x16 Mnem:@"ASL" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //zpx 6
        instructionTable[0x17] = [[Instruction alloc] initWithCode:0x17 Mnem:@"SLO" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //* zpx 6
        instructionTable[0x18] = [[Instruction alloc] initWithCode:0x18 Mnem:@"CLC" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x19] = [[Instruction alloc] initWithCode:0x19 Mnem:@"ORA" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //aby 4 *
        instructionTable[0x1A] = [[Instruction alloc] initWithCode:0x1A Mnem:@"NOP" Mode:Implied Bytes:1 Cycles:2]; //* 2
        instructionTable[0x1B] = [[Instruction alloc] initWithCode:0x1B Mnem:@"SLO" Mode:AbsoluteIndexedY Bytes:3 Cycles:7]; //* aby 7
        instructionTable[0x1C] = [[Instruction alloc] initWithCode:0x1C Mnem:@"NOP" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //* abx 4 *
        instructionTable[0x1D] = [[Instruction alloc] initWithCode:0x1D Mnem:@"ORA" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //abx 4 *
        instructionTable[0x1E] = [[Instruction alloc] initWithCode:0x1E Mnem:@"ASL" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //abx 7
        instructionTable[0x1F] = [[Instruction alloc] initWithCode:0x1F Mnem:@"SLO" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //* abx 7
        
        instructionTable[0x20] = [[Instruction alloc] initWithCode:0x20 Mnem:@"JSR" Mode:Absolute Bytes:3 Cycles:6]; //abs 6
        instructionTable[0x21] = [[Instruction alloc] initWithCode:0x21 Mnem:@"AND" Mode:IndexedIndirect Bytes:2 Cycles:6]; //izx 6
        instructionTable[0x22] = [[Instruction alloc] initWithCode:0x22 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0x23] = [[Instruction alloc] initWithCode:0x23 Mnem:@"RLA" Mode:IndexedIndirect Bytes:2 Cycles:8]; //* izx 8
        instructionTable[0x24] = [[Instruction alloc] initWithCode:0x24 Mnem:@"BIT" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0x25] = [[Instruction alloc] initWithCode:0x25 Mnem:@"AND" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0x26] = [[Instruction alloc] initWithCode:0x26 Mnem:@"ROL" Mode:ZeroPage Bytes:2 Cycles:5]; //zp 5
        instructionTable[0x27] = [[Instruction alloc] initWithCode:0x27 Mnem:@"RLA" Mode:ZeroPage Bytes:2 Cycles:5]; //* zp 5
        instructionTable[0x28] = [[Instruction alloc] initWithCode:0x28 Mnem:@"PLP" Mode:Implied Bytes:1 Cycles:4]; //4
        instructionTable[0x29] = [[Instruction alloc] initWithCode:0x29 Mnem:@"AND" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0x2A] = [[Instruction alloc] initWithCode:0x2A Mnem:@"ROL" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x2B] = [[Instruction alloc] initWithCode:0x2B Mnem:@"ANC" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0x2C] = [[Instruction alloc] initWithCode:0x2C Mnem:@"BIT" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0x2D] = [[Instruction alloc] initWithCode:0x2D Mnem:@"AND" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0x2E] = [[Instruction alloc] initWithCode:0x2E Mnem:@"ROL" Mode:Absolute Bytes:3 Cycles:6]; //abs 6
        instructionTable[0x2F] = [[Instruction alloc] initWithCode:0x2F Mnem:@"RLA" Mode:Absolute Bytes:3 Cycles:6]; //* abs 6
        
        instructionTable[0x30] = [[Instruction alloc] initWithCode:0x30 Mnem:@"BMI" Mode:Relative Bytes:2 Cycles:2]; //rel 2 *
        instructionTable[0x31] = [[Instruction alloc] initWithCode:0x31 Mnem:@"AND" Mode:IndirectIndexed Bytes:2 Cycles:5]; //izy 5 *
        instructionTable[0x32] = [[Instruction alloc] initWithCode:0x32 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0x33] = [[Instruction alloc] initWithCode:0x33 Mnem:@"RLA" Mode:IndirectIndexed Bytes:2 Cycles:8]; //* izy 8
        instructionTable[0x34] = [[Instruction alloc] initWithCode:0x34 Mnem:@"NOP" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //* zpx 4
        instructionTable[0x35] = [[Instruction alloc] initWithCode:0x35 Mnem:@"AND" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0x36] = [[Instruction alloc] initWithCode:0x36 Mnem:@"ROL" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //zpx 6
        instructionTable[0x37] = [[Instruction alloc] initWithCode:0x37 Mnem:@"RLA" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //* zpx 6
        instructionTable[0x38] = [[Instruction alloc] initWithCode:0x38 Mnem:@"SEC" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x39] = [[Instruction alloc] initWithCode:0x39 Mnem:@"AND" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //aby 4 *
        instructionTable[0x3A] = [[Instruction alloc] initWithCode:0x3A Mnem:@"NOP" Mode:Implied Bytes:1 Cycles:2]; //* 2
        instructionTable[0x3B] = [[Instruction alloc] initWithCode:0x3B Mnem:@"RLA" Mode:AbsoluteIndexedY Bytes:3 Cycles:7]; //* aby 7
        instructionTable[0x3C] = [[Instruction alloc] initWithCode:0x3C Mnem:@"NOP" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //* abx 4 *
        instructionTable[0x3D] = [[Instruction alloc] initWithCode:0x3D Mnem:@"AND" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //abx 4 *
        instructionTable[0x3E] = [[Instruction alloc] initWithCode:0x3E Mnem:@"ROL" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //abx 7
        instructionTable[0x3F] = [[Instruction alloc] initWithCode:0x3F Mnem:@"RLA" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //* abx 7
        
        instructionTable[0x40] = [[Instruction alloc] initWithCode:0x40 Mnem:@"RTI" Mode:Implied Bytes:1 Cycles:6]; //6
        instructionTable[0x41] = [[Instruction alloc] initWithCode:0x41 Mnem:@"EOR" Mode:IndexedIndirect Bytes:2 Cycles:6]; //izx 6
        instructionTable[0x42] = [[Instruction alloc] initWithCode:0x42 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0x43] = [[Instruction alloc] initWithCode:0x43 Mnem:@"SRE" Mode:IndexedIndirect Bytes:2 Cycles:8]; //* izx 8
        instructionTable[0x44] = [[Instruction alloc] initWithCode:0x44 Mnem:@"NOP" Mode:ZeroPage Bytes:2 Cycles:3]; //* zp 3
        instructionTable[0x45] = [[Instruction alloc] initWithCode:0x45 Mnem:@"EOR" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0x46] = [[Instruction alloc] initWithCode:0x46 Mnem:@"LSR" Mode:ZeroPage Bytes:2 Cycles:5]; //zp 5
        instructionTable[0x47] = [[Instruction alloc] initWithCode:0x47 Mnem:@"SRE" Mode:ZeroPage Bytes:2 Cycles:5]; //* zp 5
        instructionTable[0x48] = [[Instruction alloc] initWithCode:0x48 Mnem:@"PHA" Mode:Implied Bytes:1 Cycles:3]; //3
        instructionTable[0x49] = [[Instruction alloc] initWithCode:0x49 Mnem:@"EOR" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0x4A] = [[Instruction alloc] initWithCode:0x4A Mnem:@"LSR" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x4B] = [[Instruction alloc] initWithCode:0x4B Mnem:@"ALR" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0x4C] = [[Instruction alloc] initWithCode:0x4C Mnem:@"JMP" Mode:Absolute Bytes:3 Cycles:3]; //abs 3
        instructionTable[0x4D] = [[Instruction alloc] initWithCode:0x4D Mnem:@"EOR" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0x4E] = [[Instruction alloc] initWithCode:0x4E Mnem:@"LSR" Mode:Absolute Bytes:3 Cycles:6]; //abs 6
        instructionTable[0x4F] = [[Instruction alloc] initWithCode:0x4F Mnem:@"SRE" Mode:Absolute Bytes:3 Cycles:6]; //* abs 6
        
        instructionTable[0x50] = [[Instruction alloc] initWithCode:0x50 Mnem:@"BVC" Mode:Relative Bytes:2 Cycles:3]; //rel 2 * = cycles 2 (+1 if branch succeeds, +2 if to a new page)
        instructionTable[0x51] = [[Instruction alloc] initWithCode:0x51 Mnem:@"EOR" Mode:IndirectIndexed Bytes:2 Cycles:5]; //izy 5 *
        instructionTable[0x52] = [[Instruction alloc] initWithCode:0x52 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0x53] = [[Instruction alloc] initWithCode:0x53 Mnem:@"SRE" Mode:IndirectIndexed Bytes:2 Cycles:8]; //* izy 8
        instructionTable[0x54] = [[Instruction alloc] initWithCode:0x54 Mnem:@"NOP" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //* zpx 4
        instructionTable[0x55] = [[Instruction alloc] initWithCode:0x55 Mnem:@"EOR" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0x56] = [[Instruction alloc] initWithCode:0x56 Mnem:@"LSR" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //zpx 6
        instructionTable[0x57] = [[Instruction alloc] initWithCode:0x57 Mnem:@"SRE" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //* zpx 6
        instructionTable[0x58] = [[Instruction alloc] initWithCode:0x58 Mnem:@"CLI" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x59] = [[Instruction alloc] initWithCode:0x59 Mnem:@"EOR" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //aby 4 *
        instructionTable[0x5A] = [[Instruction alloc] initWithCode:0x5A Mnem:@"NOP" Mode:Implied Bytes:1 Cycles:2]; //* 2
        instructionTable[0x5B] = [[Instruction alloc] initWithCode:0x5B Mnem:@"SRE" Mode:AbsoluteIndexedY Bytes:3 Cycles:7]; //* aby 7
        instructionTable[0x5C] = [[Instruction alloc] initWithCode:0x5C Mnem:@"NOP" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //* abx 4 *
        instructionTable[0x5D] = [[Instruction alloc] initWithCode:0x5D Mnem:@"EOR" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //abx 4 *
        instructionTable[0x5E] = [[Instruction alloc] initWithCode:0x5E Mnem:@"LSR" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //abx 7
        instructionTable[0x5F] = [[Instruction alloc] initWithCode:0x5F Mnem:@"SRE" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //* abx 7
        
        instructionTable[0x60] = [[Instruction alloc] initWithCode:0x60 Mnem:@"RTS" Mode:Implied Bytes:1 Cycles:6]; //6
        instructionTable[0x61] = [[Instruction alloc] initWithCode:0x61 Mnem:@"ADC" Mode:IndexedIndirect Bytes:2 Cycles:6]; //izx 6
        instructionTable[0x62] = [[Instruction alloc] initWithCode:0x62 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0x63] = [[Instruction alloc] initWithCode:0x63 Mnem:@"RRA" Mode:IndexedIndirect Bytes:2 Cycles:8]; //* izx 8
        instructionTable[0x64] = [[Instruction alloc] initWithCode:0x64 Mnem:@"NOP" Mode:ZeroPage Bytes:2 Cycles:3]; //* zp 3
        instructionTable[0x65] = [[Instruction alloc] initWithCode:0x65 Mnem:@"ADC" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0x66] = [[Instruction alloc] initWithCode:0x66 Mnem:@"ROR" Mode:ZeroPage Bytes:2 Cycles:5]; //zp 5
        instructionTable[0x67] = [[Instruction alloc] initWithCode:0x67 Mnem:@"RRA" Mode:ZeroPage Bytes:2 Cycles:5]; //* zp 5
        instructionTable[0x68] = [[Instruction alloc] initWithCode:0x68 Mnem:@"PLA" Mode:Implied Bytes:1 Cycles:4]; //4
        instructionTable[0x69] = [[Instruction alloc] initWithCode:0x69 Mnem:@"ADC" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0x6A] = [[Instruction alloc] initWithCode:0x6A Mnem:@"ROR" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x6B] = [[Instruction alloc] initWithCode:0x6B Mnem:@"ARR" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0x6C] = [[Instruction alloc] initWithCode:0x6C Mnem:@"JMP" Mode:Indirect Bytes:3 Cycles:5]; //ind 5
        instructionTable[0x6D] = [[Instruction alloc] initWithCode:0x6D Mnem:@"ADC" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0x6E] = [[Instruction alloc] initWithCode:0x6E Mnem:@"ROR" Mode:Absolute Bytes:3 Cycles:6]; //abs 6
        instructionTable[0x6F] = [[Instruction alloc] initWithCode:0x6F Mnem:@"RRA" Mode:Absolute Bytes:3 Cycles:6]; //* abs 6
        
        instructionTable[0x70] = [[Instruction alloc] initWithCode:0x70 Mnem:@"BVS" Mode:Relative Bytes:2 Cycles:2]; //rel 2 *
        instructionTable[0x71] = [[Instruction alloc] initWithCode:0x71 Mnem:@"ADC" Mode:IndirectIndexed Bytes:2 Cycles:5]; //izy 5 *
        instructionTable[0x72] = [[Instruction alloc] initWithCode:0x72 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0x73] = [[Instruction alloc] initWithCode:0x73 Mnem:@"RRA" Mode:IndirectIndexed Bytes:2 Cycles:8]; //* izy 8
        instructionTable[0x74] = [[Instruction alloc] initWithCode:0x74 Mnem:@"NOP" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //* zpx 4
        instructionTable[0x75] = [[Instruction alloc] initWithCode:0x75 Mnem:@"ADC" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0x76] = [[Instruction alloc] initWithCode:0x76 Mnem:@"ROR" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //zpx 6
        instructionTable[0x77] = [[Instruction alloc] initWithCode:0x77 Mnem:@"RRA" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //* zpx 6
        instructionTable[0x78] = [[Instruction alloc] initWithCode:0x78 Mnem:@"SEI" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x79] = [[Instruction alloc] initWithCode:0x79 Mnem:@"ADC" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //aby 4 *
        instructionTable[0x7A] = [[Instruction alloc] initWithCode:0x7A Mnem:@"NOP" Mode:Implied Bytes:1 Cycles:2]; //* 2
        instructionTable[0x7B] = [[Instruction alloc] initWithCode:0x7B Mnem:@"RRA" Mode:AbsoluteIndexedY Bytes:3 Cycles:7]; //* aby 7
        instructionTable[0x7C] = [[Instruction alloc] initWithCode:0x7C Mnem:@"NOP" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //* abx 4 *
        instructionTable[0x7D] = [[Instruction alloc] initWithCode:0x7D Mnem:@"ADC" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //abx 4 *
        instructionTable[0x7E] = [[Instruction alloc] initWithCode:0x7E Mnem:@"ROR" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //abx 7
        instructionTable[0x7F] = [[Instruction alloc] initWithCode:0x7F Mnem:@"RRA" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //* abx 7
        
        instructionTable[0x80] = [[Instruction alloc] initWithCode:0x80 Mnem:@"NOP" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0x81] = [[Instruction alloc] initWithCode:0x81 Mnem:@"STA" Mode:IndexedIndirect Bytes:2 Cycles:6]; //izx 6
        instructionTable[0x82] = [[Instruction alloc] initWithCode:0x82 Mnem:@"NOP" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0x83] = [[Instruction alloc] initWithCode:0x83 Mnem:@"SAX" Mode:IndexedIndirect Bytes:2 Cycles:6]; //* izx 6
        instructionTable[0x84] = [[Instruction alloc] initWithCode:0x84 Mnem:@"STY" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0x85] = [[Instruction alloc] initWithCode:0x85 Mnem:@"STA" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0x86] = [[Instruction alloc] initWithCode:0x86 Mnem:@"STX" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0x87] = [[Instruction alloc] initWithCode:0x87 Mnem:@"SAX" Mode:ZeroPage Bytes:2 Cycles:3]; //* zp 3
        instructionTable[0x88] = [[Instruction alloc] initWithCode:0x88 Mnem:@"DEY" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x89] = [[Instruction alloc] initWithCode:0x89 Mnem:@"NOP" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0x8A] = [[Instruction alloc] initWithCode:0x8A Mnem:@"TXA" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x8B] = [[Instruction alloc] initWithCode:0x8B Mnem:@"XAA" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0x8C] = [[Instruction alloc] initWithCode:0x8C Mnem:@"STY" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0x8D] = [[Instruction alloc] initWithCode:0x8D Mnem:@"STA" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0x8E] = [[Instruction alloc] initWithCode:0x8E Mnem:@"STX" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0x8F] = [[Instruction alloc] initWithCode:0x8F Mnem:@"SAX" Mode:Absolute Bytes:3 Cycles:4]; //* abs 4
        
        instructionTable[0x90] = [[Instruction alloc] initWithCode:0x90 Mnem:@"BCC" Mode:Relative Bytes:2 Cycles:3]; //rel 2 *
        instructionTable[0x91] = [[Instruction alloc] initWithCode:0x91 Mnem:@"STA" Mode:IndirectIndexed Bytes:2 Cycles:6]; //izy 6
        instructionTable[0x92] = [[Instruction alloc] initWithCode:0x92 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0x93] = [[Instruction alloc] initWithCode:0x93 Mnem:@"AHX" Mode:IndirectIndexed Bytes:2 Cycles:6]; //* izy 6
        instructionTable[0x94] = [[Instruction alloc] initWithCode:0x94 Mnem:@"STY" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0x95] = [[Instruction alloc] initWithCode:0x95 Mnem:@"STA" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0x96] = [[Instruction alloc] initWithCode:0x96 Mnem:@"STX" Mode:ZeroPageIndexedY Bytes:2 Cycles:4]; //zpy 4
        instructionTable[0x97] = [[Instruction alloc] initWithCode:0x97 Mnem:@"SAX" Mode:ZeroPageIndexedY Bytes:2 Cycles:4]; //* zpy 4
        instructionTable[0x98] = [[Instruction alloc] initWithCode:0x98 Mnem:@"TYA" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x99] = [[Instruction alloc] initWithCode:0x99 Mnem:@"STA" Mode:AbsoluteIndexedY Bytes:3 Cycles:5]; //aby 5
        instructionTable[0x9A] = [[Instruction alloc] initWithCode:0x9A Mnem:@"TXS" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0x9B] = [[Instruction alloc] initWithCode:0x9B Mnem:@"TAS" Mode:AbsoluteIndexedY Bytes:3 Cycles:5]; //* aby 5
        instructionTable[0x9C] = [[Instruction alloc] initWithCode:0x9C Mnem:@"SHY" Mode:AbsoluteIndexedX Bytes:3 Cycles:5]; //* abx 5
        instructionTable[0x9D] = [[Instruction alloc] initWithCode:0x9D Mnem:@"STA" Mode:AbsoluteIndexedX Bytes:3 Cycles:5]; //abx 5
        instructionTable[0x9E] = [[Instruction alloc] initWithCode:0x9E Mnem:@"SHX" Mode:AbsoluteIndexedY Bytes:3 Cycles:5]; //* aby 5
        instructionTable[0x9F] = [[Instruction alloc] initWithCode:0x9F Mnem:@"AHX" Mode:AbsoluteIndexedY Bytes:3 Cycles:5]; //* aby 5
        
        instructionTable[0xA0] = [[Instruction alloc] initWithCode:0xA0 Mnem:@"LDY" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0xA1] = [[Instruction alloc] initWithCode:0xA1 Mnem:@"LDA" Mode:IndexedIndirect Bytes:2 Cycles:6]; //izx 6
        instructionTable[0xA2] = [[Instruction alloc] initWithCode:0xA2 Mnem:@"LDX" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0xA3] = [[Instruction alloc] initWithCode:0xA3 Mnem:@"LAX" Mode:IndexedIndirect Bytes:2 Cycles:6]; //* izx 6
        instructionTable[0xA4] = [[Instruction alloc] initWithCode:0xA4 Mnem:@"LDY" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0xA5] = [[Instruction alloc] initWithCode:0xA5 Mnem:@"LDA" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0xA6] = [[Instruction alloc] initWithCode:0xA6 Mnem:@"LDX" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0xA7] = [[Instruction alloc] initWithCode:0xA7 Mnem:@"LAX" Mode:ZeroPage Bytes:2 Cycles:3]; //* zp 3
        instructionTable[0xA8] = [[Instruction alloc] initWithCode:0xA8 Mnem:@"TAY" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xA9] = [[Instruction alloc] initWithCode:0xA9 Mnem:@"LDA" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0xAA] = [[Instruction alloc] initWithCode:0xAA Mnem:@"TAX" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xAB] = [[Instruction alloc] initWithCode:0xAB Mnem:@"LAX" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0xAC] = [[Instruction alloc] initWithCode:0xAC Mnem:@"LDY" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0xAD] = [[Instruction alloc] initWithCode:0xAD Mnem:@"LDA" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0xAE] = [[Instruction alloc] initWithCode:0xAE Mnem:@"LDX" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0xAF] = [[Instruction alloc] initWithCode:0xAF Mnem:@"LAX" Mode:Absolute Bytes:3 Cycles:4]; //* abs 4
        
        instructionTable[0xB0] = [[Instruction alloc] initWithCode:0xB0 Mnem:@"BCS" Mode:Relative Bytes:2 Cycles:2]; //rel 2 *
        instructionTable[0xB1] = [[Instruction alloc] initWithCode:0xB1 Mnem:@"LDA" Mode:IndirectIndexed Bytes:2 Cycles:5]; //izy 5 *
        instructionTable[0xB2] = [[Instruction alloc] initWithCode:0xB2 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0xB3] = [[Instruction alloc] initWithCode:0xB3 Mnem:@"LAX" Mode:IndirectIndexed Bytes:2 Cycles:5]; //* izy 5 *
        instructionTable[0xB4] = [[Instruction alloc] initWithCode:0xB4 Mnem:@"LDY" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0xB5] = [[Instruction alloc] initWithCode:0xB5 Mnem:@"LDA" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0xB6] = [[Instruction alloc] initWithCode:0xB6 Mnem:@"LDX" Mode:ZeroPageIndexedY Bytes:2 Cycles:4]; //zpy 4
        instructionTable[0xB7] = [[Instruction alloc] initWithCode:0xB7 Mnem:@"LAX" Mode:ZeroPageIndexedY Bytes:2 Cycles:4]; //* zpy 4
        instructionTable[0xB8] = [[Instruction alloc] initWithCode:0xB8 Mnem:@"CLV" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xB9] = [[Instruction alloc] initWithCode:0xB9 Mnem:@"LDA" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //aby 4 *
        instructionTable[0xBA] = [[Instruction alloc] initWithCode:0xBA Mnem:@"TSX" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xBB] = [[Instruction alloc] initWithCode:0xBB Mnem:@"LAS" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //* aby 4 *
        instructionTable[0xBC] = [[Instruction alloc] initWithCode:0xBC Mnem:@"LDY" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //abx 4 *
        instructionTable[0xBD] = [[Instruction alloc] initWithCode:0xBD Mnem:@"LDA" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //abx 4 *
        instructionTable[0xBE] = [[Instruction alloc] initWithCode:0xBE Mnem:@"LDX" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //aby 4 *
        instructionTable[0xBF] = [[Instruction alloc] initWithCode:0xBF Mnem:@"LAX" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //* aby 4 *
        
        instructionTable[0xC0] = [[Instruction alloc] initWithCode:0xC0 Mnem:@"CPY" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0xC1] = [[Instruction alloc] initWithCode:0xC1 Mnem:@"CMP" Mode:IndexedIndirect Bytes:2 Cycles:6]; //izx 6
        instructionTable[0xC2] = [[Instruction alloc] initWithCode:0xC2 Mnem:@"NOP" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0xC3] = [[Instruction alloc] initWithCode:0xC3 Mnem:@"DCP" Mode:IndexedIndirect Bytes:2 Cycles:8]; //* izx 8
        instructionTable[0xC4] = [[Instruction alloc] initWithCode:0xC4 Mnem:@"CPY" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0xC5] = [[Instruction alloc] initWithCode:0xC5 Mnem:@"CMP" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0xC6] = [[Instruction alloc] initWithCode:0xC6 Mnem:@"DEC" Mode:ZeroPage Bytes:2 Cycles:5]; //zp 5
        instructionTable[0xC7] = [[Instruction alloc] initWithCode:0xC7 Mnem:@"DCP" Mode:ZeroPage Bytes:2 Cycles:5]; //* zp 5
        instructionTable[0xC8] = [[Instruction alloc] initWithCode:0xC8 Mnem:@"INY" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xC9] = [[Instruction alloc] initWithCode:0xC9 Mnem:@"CMP" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0xCA] = [[Instruction alloc] initWithCode:0xCA Mnem:@"DEX" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xCB] = [[Instruction alloc] initWithCode:0xCB Mnem:@"AXS" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0xCC] = [[Instruction alloc] initWithCode:0xCC Mnem:@"CPY" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0xCD] = [[Instruction alloc] initWithCode:0xCD Mnem:@"CMP" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0xCE] = [[Instruction alloc] initWithCode:0xCE Mnem:@"DEC" Mode:Absolute Bytes:3 Cycles:6]; //abs 6
        instructionTable[0xCF] = [[Instruction alloc] initWithCode:0xCF Mnem:@"DCP" Mode:Absolute Bytes:3 Cycles:6]; //* abs 6
        
        instructionTable[0xD0] = [[Instruction alloc] initWithCode:0xD0 Mnem:@"BNE" Mode:Relative Bytes:2 Cycles:3]; //rel 2 *
        instructionTable[0xD1] = [[Instruction alloc] initWithCode:0xD1 Mnem:@"CMP" Mode:IndirectIndexed Bytes:2 Cycles:5]; //izy 5 *
        instructionTable[0xD2] = [[Instruction alloc] initWithCode:0xD2 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0xD3] = [[Instruction alloc] initWithCode:0xD3 Mnem:@"DCP" Mode:IndirectIndexed Bytes:2 Cycles:8]; //* izy 8
        instructionTable[0xD4] = [[Instruction alloc] initWithCode:0xD4 Mnem:@"NOP" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //* zpx 4
        instructionTable[0xD5] = [[Instruction alloc] initWithCode:0xD5 Mnem:@"CMP" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0xD6] = [[Instruction alloc] initWithCode:0xD6 Mnem:@"DEC" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //zpx 6
        instructionTable[0xD7] = [[Instruction alloc] initWithCode:0xD7 Mnem:@"DCP" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //* zpx 6
        instructionTable[0xD8] = [[Instruction alloc] initWithCode:0xD8 Mnem:@"CLD" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xD9] = [[Instruction alloc] initWithCode:0xD9 Mnem:@"CMP" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //aby 4 *
        instructionTable[0xDA] = [[Instruction alloc] initWithCode:0xDA Mnem:@"NOP" Mode:Implied Bytes:1 Cycles:2]; //* 2
        instructionTable[0xDB] = [[Instruction alloc] initWithCode:0xDB Mnem:@"DCP" Mode:AbsoluteIndexedY Bytes:3 Cycles:7]; //* aby 7
        instructionTable[0xDC] = [[Instruction alloc] initWithCode:0xDC Mnem:@"NOP" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //* abx 4 *
        instructionTable[0xDD] = [[Instruction alloc] initWithCode:0xDD Mnem:@"CMP" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //abx 4 *
        instructionTable[0xDE] = [[Instruction alloc] initWithCode:0xDE Mnem:@"DEC" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //abx 7
        instructionTable[0xDF] = [[Instruction alloc] initWithCode:0xDF Mnem:@"DCP" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //* abx 7
        
        instructionTable[0xE0] = [[Instruction alloc] initWithCode:0xE0 Mnem:@"CPX" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0xE1] = [[Instruction alloc] initWithCode:0xE1 Mnem:@"SBC" Mode:IndexedIndirect Bytes:2 Cycles:6]; //izx 6
        instructionTable[0xE2] = [[Instruction alloc] initWithCode:0xE2 Mnem:@"NOP" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0xE3] = [[Instruction alloc] initWithCode:0xE3 Mnem:@"ISC" Mode:IndexedIndirect Bytes:2 Cycles:8]; //* izx 8
        instructionTable[0xE4] = [[Instruction alloc] initWithCode:0xE4 Mnem:@"CPX" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0xE5] = [[Instruction alloc] initWithCode:0xE5 Mnem:@"SBC" Mode:ZeroPage Bytes:2 Cycles:3]; //zp 3
        instructionTable[0xE6] = [[Instruction alloc] initWithCode:0xE6 Mnem:@"INC" Mode:ZeroPage Bytes:2 Cycles:5]; //zp 5
        instructionTable[0xE7] = [[Instruction alloc] initWithCode:0xE7 Mnem:@"ISC" Mode:ZeroPage Bytes:2 Cycles:5]; //* zp 5
        instructionTable[0xE8] = [[Instruction alloc] initWithCode:0xE8 Mnem:@"INX" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xE9] = [[Instruction alloc] initWithCode:0xE9 Mnem:@"SBC" Mode:Immediate Bytes:2 Cycles:2]; //imm 2
        instructionTable[0xEA] = [[Instruction alloc] initWithCode:0xEA Mnem:@"NOP" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xEB] = [[Instruction alloc] initWithCode:0xEB Mnem:@"SBC" Mode:Immediate Bytes:2 Cycles:2]; //* imm 2
        instructionTable[0xEC] = [[Instruction alloc] initWithCode:0xEC Mnem:@"CPX" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0xED] = [[Instruction alloc] initWithCode:0xED Mnem:@"SBC" Mode:Absolute Bytes:3 Cycles:4]; //abs 4
        instructionTable[0xEE] = [[Instruction alloc] initWithCode:0xEE Mnem:@"INC" Mode:Absolute Bytes:3 Cycles:6]; //abs 6
        instructionTable[0xEF] = [[Instruction alloc] initWithCode:0xEF Mnem:@"ISC" Mode:Absolute Bytes:3 Cycles:6]; //* abs 6
        
        instructionTable[0xF0] = [[Instruction alloc] initWithCode:0xF0 Mnem:@"BEQ" Mode:Relative Bytes:2 Cycles:2]; //rel 2 *
        instructionTable[0xF1] = [[Instruction alloc] initWithCode:0xF1 Mnem:@"SBC" Mode:IndirectIndexed Bytes:2 Cycles:5]; //izy 5 *
        instructionTable[0xF2] = [[Instruction alloc] initWithCode:0xF2 Mnem:@"KIL" Mode:Unknown Bytes:0 Cycles:0]; //*
        instructionTable[0xF3] = [[Instruction alloc] initWithCode:0xF3 Mnem:@"ISC" Mode:IndirectIndexed Bytes:2 Cycles:8]; //* izy 8
        instructionTable[0xF4] = [[Instruction alloc] initWithCode:0xF4 Mnem:@"NOP" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //* zpx 4
        instructionTable[0xF5] = [[Instruction alloc] initWithCode:0xF5 Mnem:@"SBC" Mode:ZeroPageIndexedX Bytes:2 Cycles:4]; //zpx 4
        instructionTable[0xF6] = [[Instruction alloc] initWithCode:0xF6 Mnem:@"INC" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //zpx 6
        instructionTable[0xF7] = [[Instruction alloc] initWithCode:0xF7 Mnem:@"ISC" Mode:ZeroPageIndexedX Bytes:2 Cycles:6]; //* zpx 6
        instructionTable[0xF8] = [[Instruction alloc] initWithCode:0xF8 Mnem:@"SED" Mode:Implied Bytes:1 Cycles:2]; //2
        instructionTable[0xF9] = [[Instruction alloc] initWithCode:0xF9 Mnem:@"SBC" Mode:AbsoluteIndexedY Bytes:3 Cycles:4]; //aby 4 *
        instructionTable[0xFA] = [[Instruction alloc] initWithCode:0xFA Mnem:@"NOP" Mode:Implied Bytes:1 Cycles:2]; //* 2
        instructionTable[0xFB] = [[Instruction alloc] initWithCode:0xFB Mnem:@"ISC" Mode:AbsoluteIndexedY Bytes:3 Cycles:7]; //* aby 7
        instructionTable[0xFC] = [[Instruction alloc] initWithCode:0xFC Mnem:@"NOP" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //* abx 4 *
        instructionTable[0xFD] = [[Instruction alloc] initWithCode:0xFD Mnem:@"SBC" Mode:AbsoluteIndexedX Bytes:3 Cycles:4]; //abx 4 *
        instructionTable[0xFE] = [[Instruction alloc] initWithCode:0xFE Mnem:@"INC" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //abx 7
        instructionTable[0xFF] = [[Instruction alloc] initWithCode:0xFF Mnem:@"ISC" Mode:AbsoluteIndexedX Bytes:3 Cycles:7]; //* abx 7
    }
    return self;
}

- (Instruction *)getInstructionForOpcode:(NSUInteger)opcode {
    return instructionTable[opcode];
}

@end

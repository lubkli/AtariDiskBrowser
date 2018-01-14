//
//  Instruction.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 02/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import "Instruction.h"
#import "LabelArray.h"

@implementation Instruction

@synthesize code;
@synthesize mnem;
@synthesize mode;
@synthesize bytes;
@synthesize cycles;

- (id)initWithCode:(NSUInteger)code Mnem:(NSString *)mnem Mode:(AddressingMode)mode Bytes:(NSUInteger)bytes Cycles:(NSUInteger)cycles {
    self = [super init];
    if (self) {
        self.code = code;
        self.mnem = mnem;
        self.mode = mode;
        self.bytes = bytes;
        self.cycles = cycles;
    }
    return self;
}

- (NSString *)descriptionWithOperands:(const unsigned char *)codebuffer andLabels:(LabelArray *)labelArray {
    NSString *result;
    NSString *addr;
    
    switch (self.mode) {
        case Accumulator:
            result = [NSString stringWithFormat:@"%@ A", self.mnem];
            break;
            
        case Implied:
            result = [NSString stringWithFormat:@"%@", self.mnem];
            break;
            
        case Immediate:
            result = [NSString stringWithFormat:@"%@ #$%02X", self.mnem, codebuffer[1]];
            break;
            
        case Absolute:
            addr = [labelArray getAddress:@"$%02X%02X" forHighByte:codebuffer[2] andLowByte:codebuffer[1]];
            result = [NSString stringWithFormat:@"%@ %@", self.mnem, addr];
            break;
            
        case ZeroPage:
            result = [NSString stringWithFormat:@"%@ $%02X", self.mnem, codebuffer[1]];
            break;
            
        case Relative:
            result = [NSString stringWithFormat:@"%@ $%02X", self.mnem, codebuffer[1]];
            break;
            
        case AbsoluteIndexedX:
            result = [NSString stringWithFormat:@"%@ $%02X%02X,X", self.mnem, codebuffer[2], codebuffer[1]];
            break;
            
        case AbsoluteIndexedY:
            result = [NSString stringWithFormat:@"%@ $%02X%02X,Y", self.mnem, codebuffer[2], codebuffer[1]];
            break;
            
        case ZeroPageIndexedX:
            result = [NSString stringWithFormat:@"%@ $%02X,X", self.mnem, codebuffer[1]];
            break;
            
        case ZeroPageIndexedY:
            result = [NSString stringWithFormat:@"%@ $%02X,Y", self.mnem, codebuffer[1]];
            break;
            
        case Indirect:
//            result = [NSString stringWithFormat:@"%@ ($%02X%02X)", self.mnem, codebuffer[2], codebuffer[1]];
            addr = [labelArray getAddress:@"$%02X%02X" forHighByte:codebuffer[2] andLowByte:codebuffer[1]];
            result = [NSString stringWithFormat:@"%@ (%@)", self.mnem, addr];
            break;
            
        case IndexedIndirect:
            result = [NSString stringWithFormat:@"%@ ($%02X,X)", self.mnem, codebuffer[1]];
            break;
            
        case IndirectIndexed:
            result = [NSString stringWithFormat:@"%@ ($%02X),Y", self.mnem, codebuffer[1]];
            break;
            
        default:
            result = @"UNKNOWN OPCODE";
            break;
    }
    return result;
}

@end

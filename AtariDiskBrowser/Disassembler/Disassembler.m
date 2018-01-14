//
//  Disassembler.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 02/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import "Disassembler.h"
#import "Instruction.h"

@implementation Disassembler

@synthesize program;

- (id)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        program = data;
        instructionSet = [[InstructionSet alloc] init];
        labelArray = [[LabelArray alloc] init];
    }
    return self;
}

- (void)disassemble {
    const unsigned char* codebuffer = [program bytes];
    //    const uint8_t *opcodes = &codebuffer[16];
    int pc = 18;
    
    while (pc < program.length) {
        Instruction *instruction = [instructionSet getInstructionForOpcode:codebuffer[pc]];
        
        NSMutableString *result = [[NSMutableString alloc] init];
        
        for (int op = 0; op < instruction.bytes; op++){
            [result appendFormat:@"%02X ", codebuffer[pc + op]];
        }
        
        NSString *code = [result stringByPaddingToLength:9 withString:@" " startingAtIndex:0];
        
        NSString *inst = [instruction descriptionWithOperands:&codebuffer[pc] andLabels:labelArray];
        
        NSLog(@"$%04X %@; %@", 0x0700 + pc, code, inst);
        
        pc += instruction.bytes;
    }
}

- (void)dump {
   
    const unsigned char* opcodes = [program bytes];
    //    const uint8_t *opcodes = &codebuffer[16];
    NSString *instruction = @"";
    int pc = 18;
    
    while (pc < program.length) {
        int count = 1;
        switch (opcodes[pc]) {
            case 0x00: instruction = [NSString stringWithFormat:@"BRK"]; break;
            case 0x01: instruction = [NSString stringWithFormat:@"ORA ($%02X,X)", opcodes[pc+1]]; count = 2; break;
            case 0x05: instruction = [NSString stringWithFormat:@"ORA $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x06: instruction = [NSString stringWithFormat:@"ASL $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x08: instruction = [NSString stringWithFormat:@"PHP"]; break;
            case 0x09: instruction = [NSString stringWithFormat:@"ORA #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0x0a: instruction = [NSString stringWithFormat:@"ASL A"]; break;
            case 0x0d: instruction = [NSString stringWithFormat:@"ORA $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x0e: instruction = [NSString stringWithFormat:@"ASL $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x10: instruction = [NSString stringWithFormat:@"BPL $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x11: instruction = [NSString stringWithFormat:@"ORA ($%02X),Y", opcodes[pc+1]]; count = 2; break;
            case 0x15: instruction = [NSString stringWithFormat:@"ORA $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x16: instruction = [NSString stringWithFormat:@"ASL $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x18: instruction = [NSString stringWithFormat:@"CLC"]; break;
            case 0x19: instruction = [NSString stringWithFormat:@"ORA $%02X%02X,Y", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x1d: instruction = [NSString stringWithFormat:@"ORA $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x1e: instruction = [NSString stringWithFormat:@"ASL $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x20: instruction = [NSString stringWithFormat:@"JSR $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x21: instruction = [NSString stringWithFormat:@"AND ($%02X,X)", opcodes[pc+1]]; count = 2; break;
            case 0x24: instruction = [NSString stringWithFormat:@"BIT $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x25: instruction = [NSString stringWithFormat:@"AND $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x26: instruction = [NSString stringWithFormat:@"ROL $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x28: instruction = [NSString stringWithFormat:@"PLP"]; break;
            case 0x29: instruction = [NSString stringWithFormat:@"AND #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0x2a: instruction = [NSString stringWithFormat:@"ROL A"]; break;
            case 0x2c: instruction = [NSString stringWithFormat:@"BIT $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x2d: instruction = [NSString stringWithFormat:@"AND $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x2e: instruction = [NSString stringWithFormat:@"ROL $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x30: instruction = [NSString stringWithFormat:@"BMI $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x31: instruction = [NSString stringWithFormat:@"AND ($%02X),Y", opcodes[pc+1]]; count = 2; break;
            case 0x35: instruction = [NSString stringWithFormat:@"AND $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x36: instruction = [NSString stringWithFormat:@"ROL $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x38: instruction = [NSString stringWithFormat:@"SEC"]; break;
            case 0x39: instruction = [NSString stringWithFormat:@"AND $%02X%02X,Y", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x3d: instruction = [NSString stringWithFormat:@"AND $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x3e: instruction = [NSString stringWithFormat:@"ROL $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x40: instruction = [NSString stringWithFormat:@"RTI"]; break;
            case 0x41: instruction = [NSString stringWithFormat:@"EOR ($%02X,X)", opcodes[pc+1]]; count = 2; break;
            case 0x45: instruction = [NSString stringWithFormat:@"EOR $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x46: instruction = [NSString stringWithFormat:@"LSR $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x48: instruction = [NSString stringWithFormat:@"PHA"]; break;
            case 0x49: instruction = [NSString stringWithFormat:@"EOR #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0x4a: instruction = [NSString stringWithFormat:@"LSR A"]; break;
            case 0x4c: instruction = [NSString stringWithFormat:@"JMP $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x4d: instruction = [NSString stringWithFormat:@"EOR $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x4e: instruction = [NSString stringWithFormat:@"LSR $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x50: instruction = [NSString stringWithFormat:@"BVC $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x51: instruction = [NSString stringWithFormat:@"EOR ($%02X),Y", opcodes[pc+1]]; count = 2; break;
            case 0x55: instruction = [NSString stringWithFormat:@"EOR $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x56: instruction = [NSString stringWithFormat:@"LSR $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x58: instruction = [NSString stringWithFormat:@"CLI"]; break;
            case 0x59: instruction = [NSString stringWithFormat:@"EOR $%02X%02X,Y", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x5d: instruction = [NSString stringWithFormat:@"EOR $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x5e: instruction = [NSString stringWithFormat:@"LSR $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x60: instruction = [NSString stringWithFormat:@"RTS"]; break;
            case 0x61: instruction = [NSString stringWithFormat:@"ADC ($%02X,X)", opcodes[pc+1]]; count = 2; break;
            case 0x65: instruction = [NSString stringWithFormat:@"ADC $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x66: instruction = [NSString stringWithFormat:@"ROR $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x68: instruction = [NSString stringWithFormat:@"PLA"]; break;
            case 0x69: instruction = [NSString stringWithFormat:@"ADC #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0x6a: instruction = [NSString stringWithFormat:@"ROR A"]; break;
            case 0x6c: instruction = [NSString stringWithFormat:@"JMP ($%02X%02X)", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x6d: instruction = [NSString stringWithFormat:@"ADC $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x6e: instruction = [NSString stringWithFormat:@"ROR $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x70: instruction = [NSString stringWithFormat:@"BVS $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x71: instruction = [NSString stringWithFormat:@"ADC ($%02X),Y", opcodes[pc+1]]; count = 2; break;
            case 0x75: instruction = [NSString stringWithFormat:@"ADC $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x76: instruction = [NSString stringWithFormat:@"ROR $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x78: instruction = [NSString stringWithFormat:@"SEI"]; break;
            case 0x79: instruction = [NSString stringWithFormat:@"ADC $%02X%02X,Y", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x7d: instruction = [NSString stringWithFormat:@"ADC $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x7e: instruction = [NSString stringWithFormat:@"ROR $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x81: instruction = [NSString stringWithFormat:@"STA ($%02X,X)", opcodes[pc+1]]; count = 2; break;
            case 0x84: instruction = [NSString stringWithFormat:@"STY $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x85: instruction = [NSString stringWithFormat:@"STA $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x86: instruction = [NSString stringWithFormat:@"STX $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x88: instruction = [NSString stringWithFormat:@"DEY"]; break;
            case 0x8a: instruction = [NSString stringWithFormat:@"TXA"]; break;
            case 0x8c: instruction = [NSString stringWithFormat:@"STY $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x8d: instruction = [NSString stringWithFormat:@"STA $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x8e: instruction = [NSString stringWithFormat:@"STX $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x90: instruction = [NSString stringWithFormat:@"BCC $%02X", opcodes[pc+1]]; count = 2; break;
            case 0x91: instruction = [NSString stringWithFormat:@"STA ($%02X),Y", opcodes[pc+1]]; count = 2; break;
            case 0x94: instruction = [NSString stringWithFormat:@"STY $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x95: instruction = [NSString stringWithFormat:@"STA $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0x96: instruction = [NSString stringWithFormat:@"STX $%02X,Y", opcodes[pc+1]]; count = 2; break;
            case 0x98: instruction = [NSString stringWithFormat:@"TYA"]; break;
            case 0x99: instruction = [NSString stringWithFormat:@"STA $%02X%02X,Y", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0x9a: instruction = [NSString stringWithFormat:@"TXS"]; break;
            case 0x9d: instruction = [NSString stringWithFormat:@"STA $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xa0: instruction = [NSString stringWithFormat:@"LDY #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0xa1: instruction = [NSString stringWithFormat:@"LDA ($%02X,X)", opcodes[pc+1]]; count = 2; break;
            case 0xa2: instruction = [NSString stringWithFormat:@"LDX #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0xa4: instruction = [NSString stringWithFormat:@"LDY $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xa5: instruction = [NSString stringWithFormat:@"LDA $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xa6: instruction = [NSString stringWithFormat:@"LDX $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xa8: instruction = [NSString stringWithFormat:@"TAY"]; break;
            case 0xa9: instruction = [NSString stringWithFormat:@"LDA #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0xaa: instruction = [NSString stringWithFormat:@"TAX"]; break;
            case 0xac: instruction = [NSString stringWithFormat:@"LDY $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xad: instruction = [NSString stringWithFormat:@"LDA $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xae: instruction = [NSString stringWithFormat:@"LDX $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xb0: instruction = [NSString stringWithFormat:@"BCS $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xb1: instruction = [NSString stringWithFormat:@"LDA ($%02X),Y", opcodes[pc+1]]; count = 2; break;
            case 0xb4: instruction = [NSString stringWithFormat:@"LDY $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0xb5: instruction = [NSString stringWithFormat:@"LDA $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0xb6: instruction = [NSString stringWithFormat:@"LDX $%02X,Y", opcodes[pc+1]]; count = 2; break;
            case 0xb8: instruction = [NSString stringWithFormat:@"CLV"]; break;
            case 0xb9: instruction = [NSString stringWithFormat:@"LDA $%02X%02X,Y", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xba: instruction = [NSString stringWithFormat:@"TSX"]; break;
            case 0xbc: instruction = [NSString stringWithFormat:@"LDY $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xbd: instruction = [NSString stringWithFormat:@"LDA $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xbe: instruction = [NSString stringWithFormat:@"LDX $%02X%02X,Y", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xc0: instruction = [NSString stringWithFormat:@"CPY #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0xc1: instruction = [NSString stringWithFormat:@"CMP ($%02X,X)", opcodes[pc+1]]; count = 2; break;
            case 0xc4: instruction = [NSString stringWithFormat:@"CPY $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xc5: instruction = [NSString stringWithFormat:@"CMP $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xc6: instruction = [NSString stringWithFormat:@"DEC $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xc8: instruction = [NSString stringWithFormat:@"INY"]; break;
            case 0xc9: instruction = [NSString stringWithFormat:@"CMP #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0xca: instruction = [NSString stringWithFormat:@"DEX"]; break;
            case 0xcc: instruction = [NSString stringWithFormat:@"CPY $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xcd: instruction = [NSString stringWithFormat:@"CMP $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xce: instruction = [NSString stringWithFormat:@"DEC $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xd0: instruction = [NSString stringWithFormat:@"BNE $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xd1: instruction = [NSString stringWithFormat:@"CMP ($%02X),Y", opcodes[pc+1]]; count = 2; break;
            case 0xd5: instruction = [NSString stringWithFormat:@"CMP $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0xd6: instruction = [NSString stringWithFormat:@"DEC $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0xd8: instruction = [NSString stringWithFormat:@"CLD"]; break;
            case 0xd9: instruction = [NSString stringWithFormat:@"CMP $%02X%02X,Y", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xdd: instruction = [NSString stringWithFormat:@"CMP $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xde: instruction = [NSString stringWithFormat:@"DEC $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xe0: instruction = [NSString stringWithFormat:@"CPX #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0xe1: instruction = [NSString stringWithFormat:@"SBC ($%02X,X)", opcodes[pc+1]]; count = 2; break;
            case 0xe4: instruction = [NSString stringWithFormat:@"CPX $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xe5: instruction = [NSString stringWithFormat:@"SBC $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xe6: instruction = [NSString stringWithFormat:@"INC $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xe8: instruction = [NSString stringWithFormat:@"INX"]; break;
            case 0xe9: instruction = [NSString stringWithFormat:@"SBC #$%02X", opcodes[pc+1]]; count = 2; break;
            case 0xea: instruction = [NSString stringWithFormat:@"NOP"]; break;
            case 0xec: instruction = [NSString stringWithFormat:@"CPX $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xed: instruction = [NSString stringWithFormat:@"SBC $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xee: instruction = [NSString stringWithFormat:@"INC $%02X%02X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xf0: instruction = [NSString stringWithFormat:@"BEQ $%02X", opcodes[pc+1]]; count = 2; break;
            case 0xf1: instruction = [NSString stringWithFormat:@"SBC ($%02X),Y", opcodes[pc+1]]; count = 2; break;
            case 0xf5: instruction = [NSString stringWithFormat:@"SBC $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0xf6: instruction = [NSString stringWithFormat:@"INC $%02X,X", opcodes[pc+1]]; count = 2; break;
            case 0xf8: instruction = [NSString stringWithFormat:@"SED"]; break;
            case 0xf9: instruction = [NSString stringWithFormat:@"SBC $%02X%02X,Y", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xfd: instruction = [NSString stringWithFormat:@"SBC $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
            case 0xfe: instruction = [NSString stringWithFormat:@"INC $%02X%02X,X", opcodes[pc+2], opcodes[pc+1]]; count = 3; break;
                
            default:
                NSLog(@".db $%02X", opcodes[pc]);
        }
        
        switch (count) {
            case 1:
                NSLog(@"%02X       ; %@", opcodes[pc], instruction);
                break;
            case 2:
                NSLog(@"%02X %02X    ; %@", opcodes[pc], opcodes[pc+1], instruction);
                break;
            case 3:
                NSLog(@"%02X %02X %02X ; %@", opcodes[pc], opcodes[pc+1], opcodes[pc+2], instruction);
                break;
        }
        pc += count;
    }
}

@end

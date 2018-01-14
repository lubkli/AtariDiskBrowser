//
//  InstructionSet.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 02/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Instruction.h"

@interface InstructionSet : NSObject {
    Instruction *instructionTable[256];
}

- (Instruction *)getInstructionForOpcode:(NSUInteger)opcode;

@end

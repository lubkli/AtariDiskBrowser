//
//  Disassembler.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 02/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructionSet.h"
#import "LabelArray.h"

@interface Disassembler : NSObject {
    InstructionSet *instructionSet;
    LabelArray *labelArray;
    NSUInteger offset;
}

@property (nonatomic) NSData *program;

- (id)initWithData:(NSData *)data atAddress:(NSUInteger)address;

- (NSString *)disassemble;
- (void)dump;

@end

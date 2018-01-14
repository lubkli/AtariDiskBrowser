//
//  Instruction.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 02/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressingMode.h"
#import "LabelArray.h"

@interface Instruction : NSObject

@property (assign) NSUInteger code;
@property (assign) NSString *mnem;
@property (assign) AddressingMode mode;
@property (assign) NSUInteger bytes;
@property (assign) NSUInteger cycles;

- (id)initWithCode:(NSUInteger)code Mnem:(NSString *)mnem Mode:(AddressingMode)mode Bytes:(NSUInteger)bytes Cycles:(NSUInteger)cycles;
- (NSString *)descriptionWithOperands:(const unsigned char *)codebuffer andLabels:(LabelArray *)labelArray;

@end

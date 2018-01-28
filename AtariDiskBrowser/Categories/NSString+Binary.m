//
//  NSStringExtension.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 11/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "NSString+Binary.h"

@implementation NSString (BinaryStringRepresentation)

+ (NSString *)binaryStringRepresentationOfInt:(long)value
{
    const unsigned int chunkLength = 4;
    unsigned int numberOfDigits = 8;
    return [self binaryStringRepresentationOfInt:value numberOfDigits:numberOfDigits chunkLength:chunkLength];
}

+ (NSString *)binaryStringRepresentationOfInt:(long)value numberOfDigits:(unsigned int)length chunkLength:(unsigned int)chunkLength
{
    NSMutableString *string = [NSMutableString new];
    
    for(int i = 0; i < length; i ++) {
        NSString *divider = i % chunkLength == chunkLength-1 ? @" " : @"";
        NSString *part = [NSString stringWithFormat:@"%@%i", divider, value & (1 << i) ? 1 : 0];
        [string insertString:part atIndex:0];
    }
    
    return string;
}

@end

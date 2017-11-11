//
//  NSStringExtension.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 11/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BinaryStringRepresentation)

+ (NSString *)binaryStringRepresentationOfInt:(long)value;
+ (NSString *)binaryStringRepresentationOfInt:(long)value numberOfDigits:(unsigned int)length chunkLength:(unsigned int)chunkLength;

@end

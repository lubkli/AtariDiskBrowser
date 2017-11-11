//
//  BinaryReader.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 06/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinaryReader : NSObject {
    BOOL littleEndian;
    NSData *data;
    const uint8_t *current;
    NSUInteger offset;
    NSUInteger length;
}

+ (id)binaryReaderWithData:(NSData *)data littleEndian:(BOOL)littleEndian;

- (void)reset;
- (void)moveBy:(NSUInteger)count;
- (NSUInteger)getOffset;

- (uint8_t)readByte;
- (uint16_t)readWord;
- (NSString *)readString:(NSUInteger)bytes;

@end

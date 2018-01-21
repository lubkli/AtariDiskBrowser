//
//  BinaryReader.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 06/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "BinaryReader.h"

@interface BinaryReader (Private)

- (id)initWithData:(NSData *)data littleEndian:(BOOL)littleEndian;

@end

@implementation BinaryReader (Private)

- (id)initWithData:(NSData *)initData littleEndian:(BOOL)isLittleEndian
{
    self = [super init];
    if (self != nil)
    {
        data = initData;
        littleEndian = isLittleEndian;
        current = (const uint8_t *) [data bytes];
        offset = 0;
        length = [data length];
    }
    return self;
}

@end

@implementation BinaryReader

+ (id)binaryReaderWithData:(NSData *)data littleEndian:(BOOL)littleEndian
{
    return [[BinaryReader alloc] initWithData:data littleEndian:littleEndian];
}

- (BOOL)isEOF {
    return offset >= length;
}

- (BOOL)canRead:(NSUInteger)count {
    return offset + count <= length;
}

- (void)reset
{
    current -= offset;
    offset = 0;
}

- (void)moveBy:(NSUInteger)count
{
    if (length - offset < count)
    {
        @throw [NSException exceptionWithName:@"Read after end"
                                       reason:@"Can't perform this operation because of all data has been read."
                                     userInfo:nil];
    }
    
    offset += count;
    current += count;
}

- (NSUInteger)getOffset
{
    return offset;
}

- (NSUInteger)getLength
{
    return length;
}

- (uint8_t)readByte
{
    const uint8_t *old = current;
    [self moveBy:1];
    return old[0];
}

- (uint16_t)readWord
{
    const uint16_t *word = (const uint16_t *) current;
    [self moveBy:sizeof(uint16_t)];
    if (littleEndian)
    {
        return CFSwapInt16LittleToHost(*word);
    }
    else
    {
        return CFSwapInt16BigToHost(*word);
    }
}

- (NSString *)readString:(NSUInteger)bytes
{
    char nm[bytes+1];
    for (int c=0; c<bytes; c++)
        nm[c] = [self readByte];
    nm[bytes] = '\0';    
    return @(nm);
}

- (NSData *)readData:(NSUInteger)bytes
{
    char nm[bytes+1];
    for (int c=0; c<bytes; c++)
        nm[c] = [self readByte];
    nm[bytes] = '\0';
    return [NSData dataWithBytes:nm length:bytes+1];
}

@end

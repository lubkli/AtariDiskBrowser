//
//  BinaryReader.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 06/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "BinaryReader.h"

@interface BinaryReader (Private)

-(id)initWithData:(NSData*)data littleEndian:(BOOL)littleEndian;
-(void)moveBy:(NSUInteger)count;

@end

@implementation BinaryReader (Private)

-(id)initWithData:(NSData*)initData littleEndian:(BOOL)isLittleEndian
{
    self = [super init];
    if (self != nil)
    {
        data = initData;
        littleEndian = isLittleEndian;
        current = (const uint8_t *) [data bytes];
        remain = [data length];
    }
    return self;
}

-(void)moveBy:(NSUInteger)count
{
    if (remain < count)
    {
        @throw [NSException exceptionWithName:@"Read after end"
                                       reason:@"Can't perform this operation because of all data has been read."
                                     userInfo:nil];
    }
    
    remain -= count;
    current += count;
}

@end

@implementation BinaryReader

+(id)binaryReaderWithData:(NSData*)data littleEndian:(BOOL)littleEndian
{
    return [[BinaryReader alloc] initWithData:data littleEndian:littleEndian];
}

-(uint8_t) readByte
{
    const uint8_t *old = current;
    [self moveBy:1];
    return old[0];
}

-(uint16_t) readWord
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

@end

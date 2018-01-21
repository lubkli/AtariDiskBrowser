//
//  DIImage.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 21/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import "DIImage.h"

@implementation DIImage

- (NSData *)decode:(NSData *)data {
    BinaryReader *source = [BinaryReader binaryReaderWithData:data littleEndian:YES];
    NSMutableData *output = [[NSMutableData alloc] init];
    
    // read first part of header
    if (![source canRead:sizeof(header1)])
        return nil;

    NSData *header1Data = [source readData:sizeof(header1)];
    [header1Data getBytes:&header1 length:sizeof(header1)];
    
    if (header1.magic1 != DI_MAGIC1 || header1.magic2 != DI_MAGIC2)
        return nil;
    
    // read creator
    uint8_t ch;
    NSMutableString *s = [[NSMutableString alloc] init];
    while ((ch = [source readByte]) != '\0') {
        [s appendFormat:@"%c",ch];
    }
    creator = s;

    // read second part of header
    if (![source canRead:sizeof(header2)])
        return nil;

    NSData *header2Data = [source readData:sizeof(header2)];
    [header2Data getBytes:&header2 length:sizeof(header2)];

    // calc sizes (Big Endian)
    NSUInteger secTableLen = header2.tracks * ((header2.secpertrackhi << 8) + header2.secpertracklo);
    _headerSize = sizeof(header1) + [creator length] + sizeof(header2) + secTableLen + 1;
    _sectorSize = (header2.secSizehi << 8) + header2.secSizelo;
    _diskSize = _sectorSize * secTableLen;
    
    // read sector table
    sectorTable = [source readData:secTableLen];
    
    // write disk image header
    [output appendBytes:&header1 length:sizeof(header1)];
    const char *creatorBytes = [creator cStringUsingEncoding:NSUTF8StringEncoding];
    [output appendBytes:creatorBytes length:[creator length]];
    char bytesToAppend[1] = {0x00};
    [output appendBytes:bytesToAppend length:sizeof(bytesToAppend)];
    [output appendBytes:&header2 length:sizeof(header2)];
    [output appendBytes:[sectorTable bytes] length:[sectorTable length] - 1];
    
    // write (copy) disk image sectors (included zeros)
    NSData *copySector;
    uint8_t zeroSector[256];
    memset(zeroSector, 0, sizeof(zeroSector));
    const char *bytes = [sectorTable bytes];
    for (int i = 0; i < [sectorTable length]; i++)
    {
        if (bytes[i] == 0) {
            [output appendBytes:zeroSector length:_sectorSize];
        } else {
            copySector = [source readData:_sectorSize];
            [output appendBytes:[copySector bytes] length:[copySector length] - 1];
        }
    }
    
    return [NSData dataWithData:output];
}

- (BOOL)readHeader {
    [reader reset];
    
    [reader readData:_headerSize];
    
    return YES;
}

@end

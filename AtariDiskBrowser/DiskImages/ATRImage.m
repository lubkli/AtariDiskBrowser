//
//  ATRFile.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 08/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "ATRImage.h"
#import "NSStringExtension.h"

@implementation ATRImage

- (id)initWithData:(NSData *)imageData {
    _headerSize = sizeof(header);
    self = [super initWithData:imageData];
    return self;
}


// FROM http://pages.suddenlink.net/wa5bdu/readme.txt
//STRUCTURE OF AN SIO2PC ATARI DISK IMAGE:
//
//It's extremely simple. There is first a 16 byte header with the following
//information:
//
//WORD = special code* indicating this is an Atari disk file
//WORD = size of this disk image, in paragraphs (size/16)
//WORD = sector size. (128 or 256) bytes/sector
//WORD = high part of size, in paragraphs (added by REV 3.00)
//BYTE = disk flags such as copy protection and write protect; see copy
//protection chapter.
//WORD=1st (or typical) bad sector; see copy protection chapter.
//SPARES 5 unused (spare) header bytes (contain zeroes)
//
//After the header comes the disk image. This is just a continuous string of
//bytes, with the first 128 bytes being the contents of disk sector 1, the
//second being sector 2, etc.
//
//* The "code" is the 16 bit sum of the individual ASCII values of the
//string of bytes: "NICKATARI". If you try to load a file without this first
//WORD, you get a "THIS FILE IS NOT AN ATARI DISK FILE" error
//message. Try it.

- (void)update {
    _diskSize = 0x10 * ((header.seccounthi << 8) + header.seccountlo);
    _sectorSize = (header.secsizehi << 8) + header.secsizelo;
    highSize =  (header.hiseccounthi << 8) + header.hiseccountlo;
    diskFlags = header.gash[0];
    badSect = header.gash[2];
}

- (BOOL)readHeader {
    [reader reset];
    
    if ([reader getLength] <= _headerSize)
        return NO;

    NSData *headerData = [reader readData:_headerSize];
    [headerData getBytes:&header length:sizeof(header)];
    
    if (header.magic1 != ATR_MAGIC1 || header.magic2 != ATR_MAGIC2)
        return NO;

    [self update];
    
    return YES;
}

- (void)makeHeaderWithSectorSize:(NSUInteger)sectorsize andSectorCount:(int)sectorcount {
    uint32_t paras = (sectorsize != 256 || sectorcount <= 3)
    ? (sectorcount << 3) /* single density or only boot sectors: sectorcount * 128 / 16 */
    : (sectorcount << 4) - 0x18; /* double density with 128-byte boot sectors: (sectorcount * 256 - 3 * 128) / 16 */
    
    header.magic1 = ATR_MAGIC1;
    header.magic2 = ATR_MAGIC2;
    header.secsizelo = (uint8_t) sectorsize;
    header.secsizehi = (uint8_t) (sectorsize >> 8);
    header.seccountlo = (uint8_t) paras;
    header.seccounthi = (uint8_t) (paras >> 8);
    header.hiseccountlo = (uint8_t) (paras >> 16);
    header.hiseccounthi = (uint8_t) (paras >> 24);
    
    [self update];
}

@end

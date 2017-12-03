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

- (id)init
{
    self = [super init];
    if (self)
    {
        _headerSize = 16;
    }
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

//Density  sides TPS SPT BPS enc total bytes
//SD         1   40  18  128 FM  92160 (90K)
//ED         1   40  26  128 MFM 133120 (130K)
//SS/DD      1   40  18  256 MFM 184320 (180K)
//SS/DD      2   40  18  256 MFM 368640 (360K)

//Single-Sided, Single-Density: 40 tracks with 18 sectors per track, 128 bytes per sector. 90 KB capacity.
//Single-Sided, Double-Density: 40 tracks with 18 sectors per track, 256 bytes per sector. 180 KB capacity. Readable by the XF551, the 815, or modified/upgraded 1050.
//Single-Sided, Enhanced-Density: 40 tracks with 26 sectors per track, 128 bytes per sector. 130 KB capacity. Readable by the 1050 and the XF551.
//Double-Sided, Double-Density: 80 tracks (40 tracks per side) with 18 sectors per track, 256 bytes per sector. 360 KB capacity. Readable by the XF551 only.
- (BOOL)readHeader
{
    BOOL result;
    @try
    {
        [reader reset];
        
        uint16_t sign = [reader readWord];
        NSLog(@"NICKATARI 0x%04x", sign);
        
        _diskSize = 0x10 * [reader readWord];
        _sectorSize = [reader readWord];
        
        uint16_t highSize = [reader readWord];
        NSLog(@"highSize 0x%04x", highSize);
        
        uint8_t diskFlags = [reader readByte];
        NSLog(@"diskFlags 0x%04x", diskFlags);
        
        uint16_t badSect = [reader readWord];
        NSLog(@"badSect 0x%04x", badSect);
        
        for (int i=0; i<5; i++)
            NSLog(@"Z %d", [reader readByte]);
        
        result = YES;
    }
    @catch(NSException *exc)
    {
        NSLog(@"Exception: %@", exc);
//        result = [reader getOffset];
    }
    return result;
}

@end

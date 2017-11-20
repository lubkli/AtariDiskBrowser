//
//  DiskImage.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 17/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "DiskImage.h"
#import "DosFileSystem.h"

@implementation DiskImage

@synthesize headerSize = _headerSize;
@synthesize diskSize = _diskSize;
@synthesize sectorSize = _sectorSize;
@synthesize system = _system;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)readHeader
{
    return NO;
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

// Disk
//    Sector 1: Boot record
//    Sector 2-n: DOS.SYS file (on system disks)
//    Sector n+1-359: User file space
//    Sector 360: VTOC (Volume Table of Contents)
//    Sector 361-368: Directory
//    Sector 369-719: User file space
//    Sector 720: Unused
- (NSInteger)mount:(NSString *)fileName
{
    NSData *fileData = [NSData dataWithContentsOfFile:fileName];
    reader = [BinaryReader binaryReaderWithData:fileData littleEndian:TRUE];
    
    if (![self readHeader])
        return 1;
    
    _system = [[DosFileSystem alloc] initWithBinaryReade:reader headerSize:_headerSize diskSize:_diskSize sectorSize:_sectorSize];
    
    if (![_system readVTOC])
        return 2;
    
    if (![_system readDirectories])
        return 3;
    
    return 0;
}

- (NSData *)readFile:(NSString *)fileName
{
    NSUInteger startSector = 0;
    for (AtariFile *fileInfo in self.system.content)
    {
        if ([fileInfo.name isEqualToString:fileName])
        {
            startSector = fileInfo.start;
        }
    }
    
    if (startSector == 0)
        return nil;
    
    [reader reset];
    [reader moveBy:_headerSize];
    [reader moveBy:startSector * (_sectorSize-1)];
    NSData *data = [reader readData:_sectorSize];
    const char *bytes = [data bytes];
    for (int p=0; p<data.length; p++)
    {
        Byte b = bytes[p];
        NSLog(@"%d 0x%02x", b, b);
    }
    
    return nil;
}

@end

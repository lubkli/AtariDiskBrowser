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
    for (AtariFile *fileInfo in self.system.content)
    {
        if ([fileInfo.name isEqualToString:fileName])
        {
            
        }
    }
    return nil;
}

@end

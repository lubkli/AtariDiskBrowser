//
//  ATRFile.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 08/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "ATRFile.h"
#import "NSStringExtension.h"

@interface ATRFile (Private)

- (NSInteger)readHeader:(BinaryReader *)reader;
- (NSInteger)readVTOC:(BinaryReader *)reader;
- (NSInteger)readDirectories:(BinaryReader *)reader;

@end

@implementation ATRFile (Private)

- (NSInteger)readHeader:(BinaryReader *)reader
{
    NSInteger result;
    @try
    {
        [reader reset];
        
        uint16_t sign = [reader readWord];
        NSLog(@"NICKATARI 0x%04x", sign);
        
        self.diskSize = 0x10 * [reader readWord];
        self.sectorSize = [reader readWord];
        
        uint16_t highSize = [reader readWord];
        NSLog(@"highSize 0x%04x", highSize);
        
        uint8_t diskFlags = [reader readByte];
        NSLog(@"diskFlags 0x%04x", diskFlags);
        
        uint16_t badSect = [reader readWord];
        NSLog(@"badSect 0x%04x", badSect);
        
        for (int i=0; i<5; i++)
            NSLog(@"Z %d", [reader readByte]);
    }
    @catch(NSException *exc)
    {
        NSLog(@"Exception: %@", exc);
        result = [reader getOffset];
    }
    return result;
}

//    Sector 360 is the VTOC. It has this structure:
//    Byte 0: Directory type (always 0)
//    Byte 1-2: Maximum sector number (always 02C5, which is incorrect given that this equals 709 and the actual maximum sector
//              number used by the FMS is 719. Due to this error, this value is ignored.)
//    Byte 3-4: Number of sectors available (starts at 709 and changes as sectors are allocated or deallocated)
//    Byte 10-99: Bitmap showing allocation of sectors. The high-order bit of byte 10 corresponds to (the nonexistent) sector 0
//                (so it is unused), the next-lower bit corresponds to sector 1, and so on through sector 7 for the low-order bit
//                of byte 10, then sector 8 for the high-order bit of byte 11, and so on. These are set to 1 if the sector is
//                available, and 0 if it is in use.
- (NSInteger)readVTOC:(BinaryReader *)reader
{
    NSInteger result;
    @try
    {
        [reader reset];
        
        // skip header
        [reader moveBy:16];
        
        // skip to VTOC ( begining of sector 360 = 0x168 )
        [reader moveBy:self.sectorSize*359];
        
        int8_t dosSign = [reader readByte];
        if (dosSign == 2)
            self.dos = @"DOS 2";
        else
            self.dos = @"DOS ?";
        self.sectorsCount = [reader readWord];
        self.sectorsFree = [reader readWord];
        self.usage = [reader readData:89];
        
        result = 0;
    }
    @catch(NSException *exc)
    {
        NSLog(@"Exception: %@", exc);
        result = [reader getOffset];
    }
    return result;
}

//    Sectors 361-368 comprise the directory, with 8 file entries in each sector, making a maximum of 64 files on the disk.
//    Each file entry has this structure:
//    Byte 0: Flag byte (High bit [bit 7] set if file deleted. Bit 6 set if file in use. Bit 5 set if file locked. Bit 0 set if file open for output.)
//    Byte 1-2: Sector count (number of sectors in file)
//    Byte 3-4: Starting sector number
//    Byte 5-12: Filename (8 characters)
//    Byte 13-15: File extension (3 characters)
//    Filenames are similar to MS-DOS and CP/M in that they consist of (up to) 8 characters in the main filename plus an extension of up to 3 characters.
- (NSInteger)readDirectories:(BinaryReader *)reader
{
    NSInteger result;
    @try
    {
        // prepare
        [self.content removeAllObjects];
        [reader reset];
        
        // skip header
        [reader moveBy:16];
        
        // skip VTOC
        [reader moveBy:self.sectorSize*360];
        
        NSUInteger cnt = 8 * (self.sectorSize/16);
        for (int j=0; j<cnt; j++)
        {
            AtariFile *file = [[AtariFile alloc] init];
            file.flags = [reader readByte];
            file.length = [reader readWord];
            file.start = [reader readWord];
            file.name = [reader readString:8];
            file.ext = [reader readString:3];
            if (file.name.length != 0)
            {
                [self.content addObject:file];
                NSLog(@"%@.%@ (%lu, %lu) - %d", file.name, file.ext, file.start, file.length, file.flags);
            }
        }
        
        result = 0;
    }
    @catch(NSException *exc)
    {
        NSLog(@"Exception: %@", exc);
        result = [reader getOffset];
    }
    return result;
}

@end

@implementation ATRFile

@synthesize diskSize;
@synthesize sectorSize;

@synthesize sectorsCount;
@synthesize sectorsFree;
@synthesize usage;

@synthesize content;

- (id)init{
    self = [super init];
    if (self) {
        self.content = [[NSMutableArray<AtariFile*> alloc] init];
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

// Disk
//    Sector 1: Boot record
//    Sector 2-n: DOS.SYS file (on system disks)
//    Sector n+1-359: User file space
//    Sector 360: VTOC (Volume Table of Contents)
//    Sector 361-368: Directory
//    Sector 369-719: User file space
//    Sector 720: Unused
- (NSInteger)readFromFile:(NSString *)fileName {
    NSData *fileData = [NSData dataWithContentsOfFile:fileName];
    BinaryReader *reader = [BinaryReader binaryReaderWithData:fileData littleEndian:TRUE];
    
    NSInteger error = [self readHeader:reader];
    if (error != 0)
        return error;
    
    error = [self readVTOC:reader];
    if (error != 0)
        return error;
    
    error = [self readDirectories:reader];
    if (error != 0)
        return error;
    
    return 0;
}

@end

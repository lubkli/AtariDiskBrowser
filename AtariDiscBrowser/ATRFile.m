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
    BOOL eof = NO;
    NSInteger errorNo = -1;
    ATRHeader state = ATRHeaderDiskMark;
    uint8_t i8;
    uint16_t i16;
    
    [reader reset];
    
    while(!eof)
    {
        switch (state) {
            case ATRHeaderDiskMark:
                i16 = [reader readWord];
                NSLog(@"NICKATARI 0x%04x",i16);
                if (i16 == 0x0296)
                    state = ATRHeaderDiskSize;
                else
                    state = ATRHeaderError;
                break;
                
            case ATRHeaderDiskSize:
                i16 = [reader readWord];
                self.diskSize = 0x10 * i16;
                state = ATRHeaderSectorSize;
                break;
                
            case ATRHeaderSectorSize:
                i16 = [reader readWord];
                self.sectorSize = i16;
                state = ATRHeaderHighSize;
                break;
                
            case ATRHeaderHighSize:
                i16 = [reader readWord];
                //TODO property
                state = ATRHeaderDiskFlags;
                break;
                
            case ATRHeaderDiskFlags:
                i8 = [reader readByte];
                //TODO property
                state = ATRHeaderBadSector;
                break;
                
            case ATRHeaderBadSector:
                i16 = [reader readWord];
                //TODO property
                state = ATRHeaderZero;
                break;
                
            case ATRHeaderZero:
                for (int i=0; i<5; i++)
                    [reader readByte];
                state = ATRHeaderDiskData;
                break;
                
            case ATRHeaderDiskData:
                eof = YES;
                errorNo = 0;
                break;
                
            case ATRHeaderError:
                eof = YES;
                errorNo = [reader getOffset];
                break;
                
            default:
                eof = YES;
                errorNo = [reader getOffset];
                break;
        }
    }
    return errorNo;
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
        
        dos = [reader readByte];
        self.sectorsCount = [reader readWord];
        self.sectorsFree = [reader readWord];
        
        usage = [[NSMutableArray alloc] init];
        for (int i=0; i<89; i++)
        {
            uint8_t i8 = [reader readByte];
            [usage addObject:[NSNumber numberWithInt:i8]];
            //NSLog(@"%@", [NSString binaryStringRepresentationOfInt:i8 numberOfDigits:8 chunkLength:9]);
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
        [content removeAllObjects];
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
                [content addObject:file];
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

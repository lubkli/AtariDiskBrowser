//
//  DosFileSystem.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 18/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "DosFileSystem.h"

@implementation DosFileSystem

//    Sector 360 is the VTOC. It has this structure:
//    Byte 0: Directory type (always 0)
//    Byte 1-2: Maximum sector number (always 02C5, which is incorrect given that this equals 709 and the actual maximum sector
//              number used by the FMS is 719. Due to this error, this value is ignored.)
//    Byte 3-4: Number of sectors available (starts at 709 and changes as sectors are allocated or deallocated)
//    Byte 10-99: Bitmap showing allocation of sectors. The high-order bit of byte 10 corresponds to (the nonexistent) sector 0
//                (so it is unused), the next-lower bit corresponds to sector 1, and so on through sector 7 for the low-order bit
//                of byte 10, then sector 8 for the high-order bit of byte 11, and so on. These are set to 1 if the sector is
//                available, and 0 if it is in use.
- (BOOL)readVTOC
{
    [reader reset];
    
    // skip header
    [reader moveBy:headerSize];
    
    // skip to VTOC ( begining of sector 360 = 0x168 )
    [reader moveBy:sectorSize*359];
    
    int8_t dosSign = [reader readByte];
    if (dosSign == 1)
        self.fileSystem = @"DOS 1";
    else if (dosSign == 2)
        self.fileSystem = @"DOS 2";
    else
        self.fileSystem = @"DOS ?";
    
    self.sectorsCount = [reader readWord];
    self.sectorsFree = [reader readWord];
    
    for (int i=0; i<5; i++)
        NSLog(@"Z %d", [reader readByte]);
    
    self.usage = [reader readData:90];
    
    return YES;
}

//    Sectors 361-368 comprise the directory, with 8 file entries in each sector, making a maximum of 64 files on the disk.
//    Each file entry has this structure:
//    Byte 0: Flag byte (High bit [bit 7] set if file deleted. Bit 6 set if file in use. Bit 5 set if file locked. Bit 0 set if file open for output.)
//    Byte 1-2: Sector count (number of sectors in file)
//    Byte 3-4: Starting sector number
//    Byte 5-12: Filename (8 characters)
//    Byte 13-15: File extension (3 characters)
//    Filenames are similar to MS-DOS and CP/M in that they consist of (up to) 8 characters in the main filename plus an extension of up to 3 characters.
- (BOOL)readDirectories
{
    // prepare
    [self.content removeAllObjects];
    
    [reader reset];
    
    // skip header
    [reader moveBy:headerSize];
    
    // skip VTOC
    [reader moveBy:sectorSize*360];
    
    NSUInteger cnt = 8 * (sectorSize/16);
    for (int j=0; j<cnt; j++)
    {
        AtariFile *file = [[AtariFile alloc] init];
        file.flags = [reader readByte];
        file.length = [reader readWord];
        file.start = [reader readWord];
        file.name = [reader readString:8];
        file.ext = [reader readString:3];
        
        if ((file.flags & 0x1) > 0) file.OpenForOutput = YES;
        if ((file.flags & 0x2) > 0) file.CreatedInDos2 = YES;
        if ((file.flags & 0x20) > 0) file.Locked = YES;
        if ((file.flags & 0x40) > 0) file.EntryInUse = YES;
        if ((file.flags & 0x80) > 0) file.Deleted = YES;
        
        if (file.name.length != 0)
        {
            [self.content addObject:file];
            NSLog(@"%@.%@ (%lu, %lu) - %d", file.name, file.ext, file.start, file.length, file.flags);
        }
    }

    return YES;
}
@end

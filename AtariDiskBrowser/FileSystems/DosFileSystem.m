//
//  DosFileSystem.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 18/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "DosFileSystem.h"

@implementation DosFileSystem

// Volume table of contents (VTOC)
//
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
    self.isValid = YES;
    
    [reader reset];
    
    // skip header
    [reader moveBy:headerSize];
    
    // skip to VTOC ( begining of sector 360 = 0x168 )
    [reader moveBy:self.sectorSize*359];
    
    //Read this values from BOOT sector in Ctor
    self.sectorsBoot = 3;
    self.sectorsSystem = 9;
    self.bootAddress = 0x700;
    
    int8_t dosSign = [reader readByte];
    if (dosSign == 1)
        self.fileSystem = @"DOS 1";
    else if (dosSign == 2)
        self.fileSystem = @"DOS 2";
    else
        self.fileSystem = @"DOS ?";
    
    self.sectorsCount = [reader readWord];
    self.sectorsFree = [reader readWord];
    self.isValid = self.isValid & (self.sectorsCount >= self.sectorsFree);
    
    for (int i=0; i<5; i++)
    {
        uint8_t zero = [reader readByte];
        self.isValid = self.isValid & (zero == 0);
    }
    
    self.usage = [reader readData:90];
    
    return YES;
}

// File directory
//
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

// Boot record
//
//    Sector 1 is the boot record. It has this structure:
//    Byte 0: 0 (representing boot flag)
//    Byte 1: 1 (representing the number of sectors the boot record takes)
//    Byte 2-3: Boot address (0700)
//    Byte 4-5: Init address
//    Byte 6: 4B (JMP command used with address in following 2 bytes)
//    Byte 7-8: Boot read continuation address
//    Byte 9: Max # of files open concurrently (1-8)
//    Byte 10: Specific drive numbers supported (bitmap where low-order bit means drive 1, next bit drive 2, and so on up to 4)
//    Byte 11: Buffer allocation direction (set to 0)
//    Byte 12-13: Boot image end address + 1
//    Byte 14: Boot flag (must be nonzero if DOS.SYS is on disk)
//    Byte 15: Sector count (not used)
//    Byte 16-17: DOS.SYS starting sector number
//    Byte 18-127: Code for second phase of boot
- (NSData *)readBootRecord
{
    [reader reset];
    [reader moveBy:headerSize];
    NSData *data = [reader readData:self.sectorSize];
    const char *bytes = [data bytes];
    for (int p=0; p<data.length; p++)
    {
        Byte b = bytes[p];
        NSLog(@"%d - %d %c 0x%02x", p, b, b, b);
    }
    return data;
}

// Data sector
//
//    A sector within a file has its first 125 bytes (0-124) used for raw data.
//    Bytes 125-126 contain the number of the next sector in the file, or 0 if this is the last sector, but since not all 16 bits are needed for sector numbers,
//    this is combined with 6 bits of file integrity check information (the highest 6 bits of byte 125); this equals the value of the position number of the file
//    in the directory. If this doesn't match the actual position, error A4 is generated. The remaining 2 bits of that byte are used as the high bits in the sector
//    number, combined with the 8 bits of byte 126 (which makes this quantity big-endian for a change).
//    Byte 127 uses its high bit to indicate a "short sector" (one not entirely filled with data), setting it to 1 if it is such a sector. The remaining bits indicate the number of data bytes stored in this sector.
- (NSData *)readFile:(NSString *)fileName
{
    NSMutableData *completeData;
    NSUInteger start = 0;
    NSUInteger length = 0;
    NSUInteger current = 0;
    BOOL isEOF = NO;
    
    for (AtariFile *fileInfo in self.content)
    {
        if ([fileInfo.name isEqualToString:fileName])
        {
            start = fileInfo.start;
            length = fileInfo.length;
            break;
        }
    }
    
    if (start == 0)
        return nil;
    
    [reader reset];
    [reader moveBy:headerSize];
    [reader moveBy:(start-1) * self.sectorSize];
    
    completeData = [[NSMutableData alloc] init];
    while (!isEOF && current <= length)
    {
        current++;
        NSData *data = [reader readData:self.sectorSize];
        const char *bytes = [data bytes];
//        for (int p=0; p<data.length; p++)
//        {
//            Byte b = bytes[p];
//            NSLog(@"%d - %d %c 0x%02x", p, b, b, b);
//        }
        NSUInteger handle = (bytes[125] & 0xFC) >> 2;
        NSUInteger nextSector = ((bytes[125] & 0x3) << 8) + bytes[126];
        NSUInteger length = bytes[127] & 0x7F;
        [completeData appendBytes:bytes length:length];
        NSLog(@"Processing file No %lu", (unsigned long)handle);
        
        if (nextSector == 0)
            isEOF = YES;
    }
    
    return completeData;
}
@end

//
//  SpartaDos.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 20/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "SpartaDos.h"

@implementation SpartaDos


//Byte Offset    Function
//0    Unused. Usually 0.
//1    Number of sectors to boot. For Atari Dos this is 3. The first three sectors are enough to get as loaded into memory to load the DOS.SYS.
//2 to 3    Boot Load Address. Same as Atari Dos: 1792 ($700)
//4 to 5    Initialization Address. Called after booting requested number of sectors.
//6 to 8    JMP to Boot Continuation Address. This should be a 6502 jump instruction (76/$4C) followed by the address to jump to after booting the requested number of sectors.
//7    $80 for Sparta Dos.  (note: this is also the low byte of the boot continuation adress)
//9/10    First sector of sector map for main directory.
//11/12    Total number of sectors on disk
//13/14    Number of free sectors on disk
//15    #of bitmap sectors (used to track free sectors)  One byte is needed for every 8 sectors.
//16/17    Sector for first bitmap (usually 4?)
//18/19    First available sector (to save time from having to search though bitmap)
//20/21    First available directory sector.  This is the sector the next new directory entry will need to be added to.
//22-29    Volume Name (8 characters - padded with spaces)
//30    bits 0-6: Number of Tracks.  bit 7:Set for double sided.
//31    Size of sectors.  128 for 128 bytes/ 0 for 256 bytes.
//32    Dos major version $11 for sparta 1.1.  $20 for sparta 3.2.
//38    Sequence Number.  Incremented whenever a file is opened for write?
//39    Random Number - filled in at format.
//40/41    First sector map for file being booted.
//42    Write Lock Flag?
//43-47    Reserved.
- (BOOL)readVTOC
{
    self.isValid = YES;
    
    [reader reset];
    
    // skip header
    [reader moveBy:headerSize];
    
    // read Boot sector 0
    self.isValid = ([reader readByte] == 0);
    self.sectorsBoot = [reader readByte];
    self.bootAddress = [reader readWord];
    self.initAddress = [reader readWord];
    self.isValid = ([reader readByte] == 0x4c); // JMP 76
    self.contAddress = [reader readWord];
    uint8_t ui80 = (self.contAddress % 256); // get 7th byte
    self.isValid = self.isValid & (ui80 == 0x80);
    self.sectorMap = [reader readWord];
    self.sectorsCount = [reader readWord];
    self.sectorsFree = [reader readWord];
    self.isValid = self.isValid & (self.sectorsCount >= self.sectorsFree);
    
    [reader readByte]; //15
    [reader readWord];
    [reader readWord];
    [reader readWord];
    [reader readString:8];
    
    [reader readByte]; //30
    mySectorSize = [reader readByte];
    
    self.fileSystem = @"SPARTA DOS";
    
    
//    for (int i=0; i<5; i++)
//    {
//        uint8_t zero = [reader readByte];
//        self.isValid = self.isValid & (zero == 0);
//    }
//
//    self.usage = [reader readData:90];
    
    return YES;
}

- (BOOL)readDirectories
{
    // prepare
    [self.content removeAllObjects];
    
    [reader reset];
    
    // skip header
    [reader moveBy:headerSize];
    
    [reader moveBy:sectorSize*self.sectorMap];
    
    NSData *mainDirEntry = [reader readData:23];
    
    // Next
    for (int i=0; i<23; i++)
    {
        uint8_t zero = [reader readByte];
        NSLog(@"%d - %c 0x%2d", i, zero, zero);
    }

    
//    Byte Offset    Function
//    0    Flag Byte
//    1 to 2     First sector of file's sector map.
//    3,4,5    Length of file in bytes.
//    6-13    File Name (8 characters padded with spaces)
//    14-16    File Extension (8 characters padded with spaces.)
//    17-22    Time and Date Stamp.  Format????
//
    NSUInteger cnt = 3; //(sectorSize/23);
    for (int j=0; j<cnt; j++)
    {
        AtariFile *file = [[AtariFile alloc] init];
        file.flags = [reader readByte];
        file.start = [reader readWord];
        [reader moveBy:3];
        file.length = 1; //[reader readWord];
        
        file.name = [reader readString:8];
        file.ext = [reader readString:3];
        
//        if ((file.flags & 0x1) > 0) file.OpenForOutput = YES;
//        if ((file.flags & 0x2) > 0) file.CreatedInDos2 = YES;
//        if ((file.flags & 0x20) > 0) file.Locked = YES;
//        if ((file.flags & 0x40) > 0) file.EntryInUse = YES;
//        if ((file.flags & 0x80) > 0) file.Deleted = YES;
//
        if (file.name.length != 0)
        {
            [self.content addObject:file];
            NSLog(@"%@.%@ (%lu, %lu) - %d", file.name, file.ext, file.start, file.length, file.flags);
        }
    }

    return YES;
}

- (NSData *)readBootRecord
{
    return nil;
}

- (NSData *)readFile:(NSString *)fileName
{
    return nil;
}

@end

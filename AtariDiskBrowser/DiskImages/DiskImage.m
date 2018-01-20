//
//  DiskImage.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 17/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "DiskImage.h"
#import "DosFileSystem.h"
#import "SpartaDos.h"

@implementation DiskImage

@synthesize headerSize = _headerSize;
@synthesize diskSize = _diskSize;
@synthesize sectorSize = _sectorSize;
@synthesize system = _system;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSData *)decode:(NSData *)data {
    return data;
}

- (BOOL)readHeader {
    return NO;
}

- (NSInteger)loadFromFile:(NSString *)fileName {
    // Load data from file and decode it
    NSData *fileData = [self decode:[NSData dataWithContentsOfFile:fileName]];
    if (fileData == nil)
        return 1;
    
    // Create reader and read header
    reader = [BinaryReader binaryReaderWithData:fileData littleEndian:TRUE];
    if (![self readHeader])
        return 1;

    // Find file system
    _system = [[DosFileSystem alloc] initWithBinaryReader:reader headerSize:_headerSize diskSize:_diskSize sectorSize:_sectorSize];
    
    if (!_system.isValid)
        _system = [[SpartaDos alloc] initWithBinaryReader:reader headerSize:_headerSize diskSize:_diskSize sectorSize:_sectorSize];
    
    if (!_system.isValid)
        return 2;

    // read BOOT sectors
    if (![_system readBOOT])
        return 3;
    
    // read Volume Table Of Content
    if (![_system readVTOC])
        return 4;
    
    // read Main Directory
    if (![_system readDirectories])
        return 5;
    
    return 0;
}

@end

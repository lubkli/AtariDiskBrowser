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

- (id)initWithData:(NSData *)imageData {
    self = [super init];
    if (self) {
        // Decode if needed
        NSData *contentData = [self decode:imageData];
        if (contentData == nil)
            return nil;
        
        // Create reader and read header
        reader = [BinaryReader binaryReaderWithData:contentData littleEndian:TRUE];
        if (![self readHeader])
            return nil;
        
        // Find file system
        _system = [[DosFileSystem alloc] initWithBinaryReader:reader headerSize:_headerSize diskSize:_diskSize sectorSize:_sectorSize];
        
        if (!_system.isValid)
            _system = [[SpartaDos alloc] initWithBinaryReader:reader headerSize:_headerSize diskSize:_diskSize sectorSize:_sectorSize];
        
        if (!_system.isValid)
            return nil;
        
        // read BOOT sectors
        if (![_system readBOOT])
            return nil;
        
        // read Volume Table Of Content
        if (![_system readVTOC])
            return nil;
        
        // read Main Directory
        if (![_system readDirectories])
            return nil;
    }
    return self;
}

- (NSData *)decode:(NSData *)data {
    return data;
}

- (BOOL)readHeader {
    return NO;
}

@end

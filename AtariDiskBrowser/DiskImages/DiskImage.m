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

- (NSInteger)mount:(NSString *)fileName
{
    NSData *fileData = [NSData dataWithContentsOfFile:fileName];
    reader = [BinaryReader binaryReaderWithData:fileData littleEndian:TRUE];
    
    if (![self readHeader])
        return 1;

    _system = [[DosFileSystem alloc] initWithBinaryReader:reader headerSize:_headerSize diskSize:_diskSize sectorSize:_sectorSize];
    
    if (!_system.isValid)
        _system = [[SpartaDos alloc] initWithBinaryReader:reader headerSize:_headerSize diskSize:_diskSize sectorSize:_sectorSize];
    
    if (![_system readVTOC])
        return 2;
    
    if (![_system readDirectories])
        return 3;
    
    return 0;
}

- (NSData *)readFile:(NSString *)fileName
{
    return [_system readFile:fileName];
}

@end

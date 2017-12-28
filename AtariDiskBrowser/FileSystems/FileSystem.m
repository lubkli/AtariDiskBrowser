//
//  FileSystem.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 18/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "FileSystem.h"

@implementation FileSystem

@synthesize isValid;
@synthesize sectorsBoot;
@synthesize bootAddress;
@synthesize initAddress;
@synthesize contAddress;
@synthesize sectorMap;
@synthesize sectorsCount;
@synthesize sectorsFree;
@synthesize usage;
@synthesize content;
@synthesize fileSystem;

- (id)initWithBinaryReader:(BinaryReader*)binaryReaded headerSize:(NSUInteger)header diskSize:(NSUInteger)disk sectorSize:(NSUInteger)sector
{
    self = [super init];
    if (self)
    {
        reader = binaryReaded;
        headerSize = header;
        diskSize = disk;
        sectorSize = sector;
        self.content = [[NSMutableArray<AtariFile*> alloc] init];
        
        [self readVTOC];
    }
    return self;
}

- (NSData *)readSector:(NSUInteger)sector
{
    [reader reset];
    
    // skip header
    [reader moveBy:headerSize];
    
    // skip to VTOC ( begining of sector 360 = 0x168 )
    [reader moveBy:sectorSize*(sector)];
    
    return [reader readData:sectorSize];
}

- (BOOL)readVTOC
{
    return NO;
}

- (BOOL)readDirectories
{
    return NO;
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

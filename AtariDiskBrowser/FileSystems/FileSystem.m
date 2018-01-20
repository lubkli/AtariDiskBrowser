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
@synthesize isBootable;
@synthesize files;
@synthesize drives;
@synthesize sectorSize;
@synthesize sectorsBoot;
@synthesize sectorsSystem;
@synthesize bootAddress;
@synthesize bootEndAddress;
@synthesize initAddress;
@synthesize contAddress;
@synthesize dosAddress;
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

- (BOOL)readBOOT
{
    return NO;
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
    [reader reset];
    [reader moveBy:headerSize];
    NSData *data = [reader readData:self.sectorSize * self.sectorsBoot];
    const char *bytes = [data bytes];
    for (int p=0; p<data.length; p++)
    {
        Byte b = bytes[p];
        NSLog(@"%d - %d %c 0x%02x", p, b, b, b);
    }
    return data;
}

- (NSData *)readSector:(NSUInteger)sector
{
    [reader reset];
    
    // skip header
    [reader moveBy:headerSize];
    
    // skip to requested sector
    [reader moveBy:sectorSize*(sector)];
    
    return [reader readData:sectorSize];
}

- (NSData *)readFile:(NSString *)fileName
{
    return nil;
}
@end

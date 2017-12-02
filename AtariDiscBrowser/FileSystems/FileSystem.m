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

- (id)initWithBinaryReade:(BinaryReader*)binaryReaded headerSize:(NSUInteger)header diskSize:(NSUInteger)disk sectorSize:(NSUInteger)sector
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

- (BOOL)readVTOC
{
    return NO;
}

- (BOOL)readDirectories
{
    return NO;
}
@end

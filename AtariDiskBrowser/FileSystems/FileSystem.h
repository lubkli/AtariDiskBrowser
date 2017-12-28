//
//  FileSystem.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 18/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtariFile.h"
#import "BinaryReader.h"

@interface FileSystem : NSObject {
@protected
    BinaryReader *reader;
    NSUInteger headerSize;
    NSUInteger diskSize;
    NSUInteger sectorSize;
}

@property (assign) BOOL isValid;
@property (assign) NSUInteger sectorsBoot;
@property (assign) NSUInteger bootAddress;
@property (assign) NSUInteger initAddress;
@property (assign) NSUInteger contAddress;
@property (assign) NSUInteger sectorMap;
@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;
@property (nonatomic) NSData *usage;
@property (retain) NSMutableArray<AtariFile*> *content;
@property (copy) NSString *fileSystem;

- (id)initWithBinaryReader:(BinaryReader*)binaryReaded headerSize:(NSUInteger)header diskSize:(NSUInteger)disk sectorSize:(NSUInteger)sector;

- (NSData *)readSector:(NSUInteger)sector;
- (BOOL)readVTOC;
- (BOOL)readDirectories;
- (NSData *)readBootRecord;
- (NSData *)readFile:(NSString *)fileName;

@end

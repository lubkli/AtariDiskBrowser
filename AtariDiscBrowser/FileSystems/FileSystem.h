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

@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;
@property (nonatomic) NSData *usage;
@property (retain) NSMutableArray<AtariFile*> *content;
@property (copy) NSString *fileSystem;

- (id)initWithBinaryReade:(BinaryReader*)binaryReaded headerSize:(NSUInteger)header diskSize:(NSUInteger)disk sectorSize:(NSUInteger)sector;

- (BOOL)readVTOC;
- (BOOL)readDirectories;

@end
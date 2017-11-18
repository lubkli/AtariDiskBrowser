//
//  DiskImage.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 17/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtariFile.h"
#import "BinaryReader.h"

@interface DiskImage : NSObject {
    BinaryReader *reader;
}

@property (assign) NSUInteger diskSize;
@property (assign) NSUInteger sectorSize;

@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;
@property (nonatomic) NSData *usage;

@property (copy) NSString *fileSystem;
@property (retain) NSMutableArray<AtariFile*> *content;

- (NSInteger)readHeader;
- (NSInteger)skipHeader;
- (NSInteger)readVTOC;
- (NSInteger)readDirectories;

- (NSInteger)mount:(NSString *)fileName;
- (NSData *)readFile:(NSString *)fileName;

@end

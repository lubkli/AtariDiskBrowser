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

@interface DiskImage : NSObject

@property (assign) NSUInteger diskSize;
@property (assign) NSUInteger sectorSize;

@property (copy) NSString *dos;
@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;
@property (nonatomic) NSData *usage;

@property (retain) NSMutableArray<AtariFile*> *content;

- (NSInteger)readHeader:(BinaryReader *)reader;
- (NSInteger)skipHeader:(BinaryReader *)reader;
- (NSInteger)readVTOC:(BinaryReader *)reader;
- (NSInteger)readDirectories:(BinaryReader *)reader;

- (NSInteger)readFromFile:(NSString *)fileName;

@end

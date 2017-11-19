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
#import "FileSystem.h"

@interface DiskImage : NSObject {
    BinaryReader *reader;
    FileSystem *_system;
    NSUInteger _headerSize;
    NSUInteger _diskSize;
    NSUInteger _sectorSize;
}

@property (readonly) NSUInteger headerSize;
@property (readonly) NSUInteger diskSize;
@property (readonly) NSUInteger sectorSize;
@property (readonly) FileSystem *system;

- (BOOL)readHeader;

- (NSInteger)mount:(NSString *)fileName;
- (NSData *)readFile:(NSString *)fileName;

@end

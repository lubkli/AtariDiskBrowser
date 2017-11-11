//
//  ATRFile.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 08/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtariFile.h"
#import "BinaryReader.h"

@interface ATRFile : NSObject {
    @private
    NSUInteger dos;
    NSMutableArray *usage;
    NSMutableArray<AtariFile*> *content;
}

@property (assign) NSUInteger diskSize;
@property (assign) NSUInteger sectorSize;
@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;

typedef NS_ENUM(NSInteger, ATRHeader) {
    ATRHeaderError,
    ATRHeaderDiskMark,
    ATRHeaderDiskSize,
    ATRHeaderSectorSize,
    ATRHeaderHighSize,
    ATRHeaderDiskFlags,
    ATRHeaderBadSector,
    ATRHeaderZero,
    ATRHeaderDiskData
};

- (NSInteger)readFromFile:(NSString *)fileName;

@end

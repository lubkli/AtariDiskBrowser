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

@interface ATRFile : NSObject

@property (assign) NSUInteger diskSize;
@property (assign) NSUInteger sectorSize;

@property (copy) NSString *dos;
@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;
@property (nonatomic) NSData *usage;

@property (retain) NSMutableArray<AtariFile*> *content;

- (NSInteger)readFromFile:(NSString *)fileName;

@end

//
//  ViewController.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SectorMap.h"

@interface ViewController : NSViewController {
    IBOutlet NSTableView *table;
    IBOutlet SectorMap *map;
}

@property (copy) NSString *fileName;
@property (assign) NSUInteger diskSize;
@property (assign) NSUInteger sectorSize;
@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;
@property (copy) NSString *sectorsCounted;
@property (copy) NSString *diskFreeCounted;
@property (copy) NSString *dosCounted;
@property (retain) NSMutableArray *list;
@property (assign) NSUInteger percentFree;

@end


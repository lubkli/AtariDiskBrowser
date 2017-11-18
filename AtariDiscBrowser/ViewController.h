//
//  ViewController.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtariFile.h"
#import "DiskImage.h"
#import "SectorMap.h"

@interface ViewController : NSViewController {
    DiskImage *image;
    AtariFile *atariFile;
    IBOutlet NSTableView *table;
    IBOutlet SectorMap *map;
    IBOutlet NSButton *viewButton;
}

@property (copy) NSString *imageFilename;
@property (retain) NSMutableArray *imageContent;

@property (assign) NSUInteger diskSize;
@property (assign) NSUInteger sectorSize;
@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;
@property (copy) NSString *sectorsCounted;
@property (copy) NSString *diskFreeCounted;
@property (copy) NSString *dosCounted;
@property (assign) NSUInteger percentFree;

@end


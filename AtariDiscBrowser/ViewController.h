//
//  ViewController.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ATRFile.h"

@interface ViewController : NSViewController

@property (copy) NSString *fileName;
@property (assign) NSUInteger diskSize;
@property (assign) NSUInteger sectorSize;
@property (assign) NSUInteger sectorsCount;
@property (assign) NSUInteger sectorsFree;
@property (retain) NSMutableArray *list;

@end


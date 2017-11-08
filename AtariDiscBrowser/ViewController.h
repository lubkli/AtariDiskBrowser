//
//  ViewController.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BinaryReader.h"

@interface ViewController : NSViewController

@property (atomic, readwrite, copy) NSString* fileName;
@property (retain) NSNumber* diskSize;
@property (assign) uint16_t sectorSize;

@end


//
//  SectorsViewController.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileSystem.h"
#import "HexField.h"

@interface SectorsViewController : NSViewController {
    NSUInteger _currentSector;
}

@property (nonatomic, strong) FileSystem *fileSystem;
@property (assign) NSUInteger *currentSector;

@property (weak) IBOutlet NSTextField *sectorTextField;
@property (weak) IBOutlet NSButton *previousButton;
@property (weak) IBOutlet NSButton *nextButton;
@property (weak) IBOutlet HexField *hexField;

@end

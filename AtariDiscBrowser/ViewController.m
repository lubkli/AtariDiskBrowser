//
//  ViewController.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (Private)

- (void)openFile;

@end

@implementation ViewController (Private)

- (void)openFile {
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Multiple files not allowed
    [openDlg setAllowsMultipleSelection:NO];
    
    // Can't select a directory
    [openDlg setCanChooseDirectories:NO];
    
    // Display the dialog. If the OK button was pressed,
    // process the files./Users/lubomirklimes/Downloads/adir_src/adsk_atr.cpp
    if ( [openDlg runModal] == NSModalResponseOK )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray *urls = [openDlg URLs];
        
        self.fileName = [urls objectAtIndex:0];
     
        // Create ATR file reader
        ATRFile *image = [[ATRFile alloc] init];
        [image readFromFile:self.fileName];
        
        // Retrieve header info
        self.diskSize = image.diskSize;
        self.sectorSize = image.sectorSize;
        self.sectorsFree = image.sectorsFree;
        self.sectorsCount = image.sectorsCount;
        
        // Retrieve content
        //NSArray<AtariFile*> files = file.content;
    }
}

@end

@implementation ViewController

@synthesize fileName;
@synthesize diskSize;
@synthesize sectorSize;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [self openFile];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)openClick:(NSButton *)sender {
    [self openFile];
}

@end

//
//  ViewController.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()

- (void)openFile;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.fileName = @"";
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)openClick:(NSButton *)sender {
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
        NSArray* urls = [openDlg URLs];
        
        // Loop through all the files and process them.
        /*for(int i = 0; i < [urls count]; i++ )
        {
            NSString* url = [urls objectAtIndex:i];
            NSLog(@"Url: %@", url);
        }*/
        
        self.fileName = [urls objectAtIndex:0];
        
        [self openFile];
    }
}

- (void)openFile {
    
    NSLog(@"Opening file %@", self.fileName);

    //NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: self.fileName];
    //NSData *fileData = [handle readDataOfLength: 3];
    
    NSData *fileData = [NSData dataWithContentsOfFile:self.fileName];
    Byte bytes[16];
    [fileData getBytes:bytes length:sizeof(Byte) * 16];
    //96 02 -> 02 96 ; $0296 (sum of 'NICKATARI')
    //80 16 -> 16 80 ; size of this disk image, in paragraphs (size/$10)
    //WO RD -> sector size. ($80 or $100) bytes/sector
    //BYTE -> high part of size, in paragraphs (added by REV 3.00)
    
    //[handle closeFile];
}

@end

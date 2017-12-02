//
//  AppDelegate.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

- (void)openFile;

@end

@implementation AppDelegate

- (void)openFile {
    // Allowed file types
    NSArray* fileTypes = [NSArray arrayWithObjects:@"ATR", @"XFD", nil];
    
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Multiple files not allowed
    [openDlg setAllowsMultipleSelection:NO];
    
    // Can't select a directory
    [openDlg setCanChooseDirectories:NO];
    
    [openDlg setAllowedFileTypes:fileTypes];
    
    // Display the dialog. If the OK button was pressed,
    // process the files./Users/lubomirklimes/Downloads/adir_src/adsk_atr.cpp
    if ( [openDlg runModal] == NSModalResponseOK )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray *urls = [openDlg URLs];
        NSString *fileName = [urls objectAtIndex:0];
        
        ViewController *viewController = (ViewController*)[_myController contentViewController];
        [viewController openFileName:fileName];
        NSString *theFileName = [[fileName lastPathComponent] stringByDeletingPathExtension];
        [[[viewController view] window] setTitle:theFileName];
        
        [_myController showWindow:self];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // get a reference to the storyboard
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    // instantiate your window controller
    _myController = [storyBoard instantiateControllerWithIdentifier:@"WindowController"];
    // show the window
    // [_myController showWindow:self];
    
    // open file with image
    [self openFile];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)openDocument:(id)sender {
    [self openFile];
}

@end

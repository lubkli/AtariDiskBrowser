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
        // instantiate your window controller
        NSWindowController *myController = [_storyBoard instantiateControllerWithIdentifier:@"WindowController"];
        // get a view controller and open disk image
        ViewController *viewController = (ViewController*)[myController contentViewController];
        [viewController openFileName:fileName];
        // set window title
        NSString *theFileName = [[fileName lastPathComponent] stringByDeletingPathExtension];
        [[[viewController view] window] setTitle:theFileName];
        // show the window
        [myController showWindow:self];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return NO;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // get a reference to the storyboard
    _storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];

    // open file with image
    [self openFile];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)newDocument:(id)sender {
    NSLog(@"New image");
}

- (IBAction)openDocument:(id)sender {
    [self openFile];
}

@end

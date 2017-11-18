//
//  ViewController.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "ViewController.h"
#import "ATRImage.h"
#import "XFDImage.h"

@interface ViewController (Private)

- (void)openFile;

@end

@implementation ViewController (Private)

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
        
        self.imageFilename = [urls objectAtIndex:0];

        //[self.view.window setTitle:[self.fileName lastPathComponent]];
      
        NSString *ext = [[self.imageFilename pathExtension] uppercaseString];
                
        if ([ext isEqualToString:@"ATR"])
        {
            image = [[ATRImage alloc] init];
        }
        else if ([ext isEqualToString:@"XFD"])
        {
            image = [[XFDImage alloc] init];
        }
        else
        {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Alert" defaultButton:@"Ok" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Alert pop up displayed"];
            [alert runModal];
        }
        
        [image mount:self.imageFilename];
        
        // Prepare header info for bindings
        self.diskSize = image.diskSize;
        self.sectorSize = image.sectorSize;
        self.sectorsFree = image.sectorsFree;
        self.sectorsCount = image.sectorsCount;
        self.sectorsCounted = [NSString stringWithFormat:@"%lu sectors", image.diskSize / image.sectorSize];
        self.diskFreeCounted =[NSString stringWithFormat:@"Free %lu kB/%lu kB", (image.sectorsFree * image.sectorSize)/1024, image.diskSize/1024];
        self.percentFree = 10 - (10 * image.sectorsFree * image.sectorSize) / image.diskSize;
        self.dosCounted = image.fileSystem;
        self.imageContent = image.content;
        
        // Prepare sector map data for custom control
        const char *bytes = [image.usage bytes];
        map.sectorsCount = image.diskSize / image.sectorSize; //image.sectorsCount;
        [map applyUsage:bytes size:[image.usage length]];
    }
}

@end

@implementation ViewController

@synthesize imageFilename;
@synthesize imageContent;

@synthesize diskSize;
@synthesize sectorSize;
@synthesize sectorsCount;
@synthesize sectorsFree;
@synthesize sectorsCounted;
@synthesize diskFreeCounted;
@synthesize dosCounted;
@synthesize percentFree;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self openFile];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)tableView:(id)sender {
    NSInteger row = [table selectedRow];
    if (row >= 0)
    {
        atariFile = self.imageContent[row];
        NSUInteger start = atariFile.start-1;
        map.startSelection = start;
        map.endSelection = start + atariFile.length;
        [map setNeedsDisplay:YES];
        [viewButton setEnabled:YES];
    }
    else
    {
        atariFile = nil;
        map.startSelection = 0;
        map.endSelection = 0;
        [map setNeedsDisplay:YES];
        [viewButton setEnabled:NO];
    }
}

- (IBAction)viewClicked:(id)sender {
    if (atariFile == nil)
        return;
    
    NSUInteger start = atariFile.start;
    //TODO:    [image readSector:start];
    [image readFile:@"DOS.SYS"];
}

@end

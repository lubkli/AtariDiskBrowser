//
//  ViewController.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "ViewController.h"
#import "DiskImageFactory.h"

@interface ViewController (Private)

@end

@implementation ViewController (Private)

@end

@implementation ViewController

@synthesize imageFilename;
@synthesize imageContent;

@synthesize diskSize;
@synthesize sectorSize;
@synthesize sectorsUsed;
@synthesize sectorsCount;
@synthesize sectorsFree;
@synthesize sectorsCounted;
@synthesize diskFreeCounted;
@synthesize dosCounted;
@synthesize percentFree;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"sectorsSeque"])
//    {
//        SectorsViewController *sectors = (SectorsViewController*)[segue destinationController];
//        sectors.representedObject = image.system;
//    }
//    else if ([[segue identifier] isEqualToString:@"bootSeque"])
//    {
//        BootViewController *sectors = (BootViewController*)[segue destinationController];
//        sectors.representedObject = image.system;
//    }
    
    if ([segue.destinationController respondsToSelector:@selector(setFileSystem:)]) {
        [segue.destinationController performSelector:@selector(setFileSystem:)
                                              withObject:[image system]];
    }
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
    
    // create the save panel
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // set a new file name
    NSString *name = [atariFile.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *target = [NSString stringWithFormat:@"%@.%@", name, atariFile.ext];
    [panel setNameFieldStringValue:target];
    
    if ( [panel runModal] == NSModalResponseOK )
    {
        NSURL *url = [panel URL];
        NSData *fileContent = [image.system readFile:[NSString stringWithFormat:@"%@", atariFile.name]];
        NSError *error = nil;
        [fileContent writeToFile:[url path] options:NSDataWritingAtomic error:&error];
        NSLog(@"Write returned error: %@", [error localizedDescription]);
    }
}

- (void)openURL:(NSURL *)url {
    
    self.imageFilename = url;
    image = [DiskImageFactory mount:self.imageFilename];
    if (image == nil)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Alert"];
        [alert setInformativeText:@"Unknown disk image format."];
        [alert setAlertStyle:NSAlertStyleWarning];
        [alert runModal];
        return;
    }
    
    // Prepare header info for bindings
    self.diskSize = image.diskSize;
    self.sectorSize = image.sectorSize;
    self.sectorsFree = image.system.sectorsFree;
    self.sectorsCount = image.system.sectorsCount;
    self.sectorsUsed = image.system.sectorsCount - image.system.sectorsFree;
    self.sectorsCounted = [NSString stringWithFormat:@"%lu sectors", image.diskSize / image.sectorSize];
    self.diskFreeCounted =[NSString stringWithFormat:@"Free %lu kB/%lu kB", (image.system.sectorsFree * image.sectorSize)/1024, image.diskSize/1024];
    self.percentFree = 10 - (10 * image.system.sectorsFree * image.sectorSize) / image.diskSize;
    self.dosCounted = image.system.fileSystem;
    self.imageContent = image.system.content;
    
    // Prepare sector map data for custom control
    const char *bytes = [image.system.usage bytes];
    map.sectorsCount = image.diskSize / image.sectorSize; //image.sectorsCount;
    [map applyUsage:bytes size:[image.system.usage length]];
}
@end

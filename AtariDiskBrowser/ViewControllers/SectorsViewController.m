//
//  SectorsViewController.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "SectorsViewController.h"

@interface SectorsViewController ()

@end

@implementation SectorsViewController

@synthesize fileSystem;
@synthesize currentSector;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _currentSector = 1;
    _sectorTextField.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)_currentSector];
    //Move to func
    NSData *fileData = [self.fileSystem readSector:_currentSector];
    self.hexField.data = fileData;
}

- (IBAction)previousClicked:(id)sender {
    _currentSector--;
    _sectorTextField.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)_currentSector];
    
    if (_currentSector == 0)
        [self.previousButton setHidden:YES];
    //Move to func
    NSData *fileData = [self.fileSystem readSector:_currentSector];
    self.hexField.data = fileData;
}

- (IBAction)nextClicked:(id)sender {
    _currentSector++;
    _sectorTextField.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)_currentSector];
    
    [self.previousButton setHidden:NO];
    //Move to func
    NSData *fileData = [self.fileSystem readSector:_currentSector];
    self.hexField.data = fileData;
}

@end

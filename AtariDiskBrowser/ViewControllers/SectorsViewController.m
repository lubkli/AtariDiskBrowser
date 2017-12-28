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
    
    _currentSector = 0;
    _maxSector = fileSystem.sectorsCount + fileSystem.sectorsBoot + fileSystem.sectorsSystem;
    _slider.integerValue = 0;
    
    _slider.maxValue = _maxSector;
    _sectorTextField.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)_currentSector];
    
    [self refreshView];
}

-(void)refreshView {
    NSData *fileData = [self.fileSystem readSector:_currentSector];
    self.hexField.data = fileData;
    
    if (_currentSector <= 0) {
        [self.previousButton setHidden:YES];
    } else {
        [self.previousButton setHidden:NO];
    }
    
    if (_currentSector >= _maxSector) {
        [self.nextButton setHidden:YES];
    } else {
        [self.nextButton setHidden:NO];
    }
}

- (IBAction)previousClicked:(id)sender {
    _currentSector--;
    _sectorTextField.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)_currentSector];
    
    [self refreshView];
}

- (IBAction)nextClicked:(id)sender {
    _currentSector++;
    _sectorTextField.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)_currentSector];
    
    [self refreshView];
}

- (IBAction)sliderMoved:(id)sender {
    _currentSector = _slider.integerValue;
    _sectorTextField.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)_currentSector];
    
    [self refreshView];
}

- (IBAction)textFieldChanged:(id)sender {
    
    _currentSector = _sectorTextField.integerValue;
    _slider.integerValue = _sectorTextField.integerValue;
    _sectorTextField.stringValue = [NSString stringWithFormat:@"%lu", (unsigned long)_currentSector];
    
    [self refreshView];
}

@end

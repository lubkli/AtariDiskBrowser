//
//  BootViewController.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "BootViewController.h"

@interface BootViewController ()

@end

@implementation BootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [_fileSystem readBootRecord];
}

@end
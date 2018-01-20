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
    
    self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);
    
    NSData *data = [_fileSystem readBootRecord];
    dasm = [[Disassembler alloc] initWithData:data atAddress:_fileSystem.bootAddress];
    [self.textView setString:[dasm disassemble]];
}

@end

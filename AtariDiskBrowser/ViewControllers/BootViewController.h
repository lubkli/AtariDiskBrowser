//
//  BootViewController.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/12/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Disassembler.h"
#import "FileSystem.h"

@interface BootViewController : NSViewController {
    @private
    Disassembler *dasm;
}

@property (nonatomic, strong) FileSystem *fileSystem;

@end

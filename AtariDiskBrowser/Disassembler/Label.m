//
//  Label.m
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import "Label.h"

@implementation Label

@synthesize address;
@synthesize label;
@synthesize comment;

- (id)initWithAddres:(NSUInteger)address Label:(NSString *)label Comment:(NSString *)comment {
    self = [super init];
    if (self) {
        self.address = address;
        self.label = label;
        self.comment = comment;
    }
    return self;
}

@end

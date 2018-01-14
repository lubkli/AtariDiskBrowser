//
//  Label.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Label : NSObject

@property (assign) NSUInteger address;
@property (assign) NSString *label;
@property (assign) NSString *comment;

- (id)initWithAddres:(NSUInteger)address Label:(NSString *)label Comment:(NSString *)comment;

@end

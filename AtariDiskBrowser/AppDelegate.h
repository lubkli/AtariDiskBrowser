//
//  AppDelegate.h
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property NSStoryboard *storyBoard;

- (IBAction)newDocument:(id)sender;
- (IBAction)openDocument:(id)sender;

@end


//
//  AppDelegate.m
//  AtariDiscBrowser
//
//  Created by Lubomír Klimeš on 05/11/2017.
//  Copyright © 2017 Lubomír Klimeš. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)openDocument:(id)sender {
    NSLog(@"Open");
}

@end

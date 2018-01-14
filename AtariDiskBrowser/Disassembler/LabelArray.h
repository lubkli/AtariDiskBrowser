//
//  LabelDictionary.h
//  AtariDiskBrowser
//
//  Created by Lubomír Klimeš on 03/01/2018.
//  Copyright © 2018 Lubomír Klimeš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Label.h"

@interface LabelArray : NSObject {
    NSMutableArray<Label *> *labelArray;
}

- (NSString *)getAddress:(NSString *)format forHighByte:(const unsigned char)highByte andLowByte:(const unsigned char)lowByte;

@end

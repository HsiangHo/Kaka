//
//  HAFTransparentView.m
//  Kaka
//
//  Created by Jovi on 8/18/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import "HAFTransparentView.h"

@implementation HAFTransparentView

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor clearColor] set];
    NSRectFill(self.frame);
    // Drawing code here.
}

@end

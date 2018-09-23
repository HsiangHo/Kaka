//
//  FinderSync.m
//  FinderPlugin
//
//  Created by Jovi on 9/23/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import "FinderSync.h"
#import <ShadowstarKit/ShadowstarKit.h>

@interface FinderSync ()

@end

@implementation FinderSync

- (instancetype)init {
    self = [super init];
    
    // Set up the directory we are syncing.
    NSURL *folderURL = [NSURL fileURLWithPath:@"/"];
    [FIFinderSyncController defaultController].directoryURLs = [NSSet setWithObject:folderURL];
    
    return self;
}

#pragma mark - Menu and toolbar item support

- (NSString *)toolbarItemName {
    return @"Kaka FinderPlugin";
}

- (NSString *)toolbarItemToolTip {
    return @"Kaka FinderPlugin: Click the toolbar item for a menu.";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameCaution];
}

- (NSMenu *)menuForMenuKind:(FIMenuKind)whichMenu {
    // Produce a menu for the extension.
    NSMenu *menu = nil;
    if (FIMenuKindContextualMenuForItems == whichMenu) {
        menu = [self itemMenu];
    }else if (FIMenuKindContextualMenuForContainer == whichMenu || FIMenuKindToolbarItemMenu == whichMenu) {
        menu = [self toolbarMenu];
    }
    return menu;
}

-(NSMenu *)toolbarMenu{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    [menu addItemWithTitle:@"Toggle Hidden File Visibility" action:@selector(toggleHiddenFileVisibility_click:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Open Terminal In This Folder" action:@selector(openTerminalInFolder_click:) keyEquivalent:@""];
    NSMenuItem *newFileItem = [menu addItemWithTitle:@"New File" action:@selector(newFile_click:) keyEquivalent:@""];
    NSMenu *menuNewFiles = [[NSMenu alloc] initWithTitle:@""];
    [menuNewFiles addItemWithTitle:@"Word" action:@selector(newFile_click:) keyEquivalent:@""];
    [menuNewFiles addItemWithTitle:@"Txt" action:@selector(newFile_click:) keyEquivalent:@""];
    [menu setSubmenu:menuNewFiles forItem:newFileItem];
    [menu addItemWithTitle:@"Custom New File Templates" action:@selector(customNewFileTemplates_click:) keyEquivalent:@""];
    return menu;
}

-(NSMenu *)itemMenu{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    [menu addItemWithTitle:@"Toggle File Visibility" action:@selector(toggleFileVisibility_click:) keyEquivalent:@""];
    return menu;
}


-(IBAction)toggleHiddenFileVisibility_click:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SSUtility accessFilePath:[NSURL fileURLWithPath:@"/"] persistPermission:YES withParentWindow:nil withActionBlock:^{
            [[SSAppearanceManager sharedManager] setShowAllFiles:![[SSAppearanceManager sharedManager] isShowAllFiles]];
        }];
    });
}

-(IBAction)openTerminalInFolder_click:(id)sender{
    
}

-(IBAction)newFile_click:(id)sender{
    
}

-(IBAction)customNewFileTemplates_click:(id)sender{
    
}

-(IBAction)toggleFileVisibility_click:(id)sender{
    
}

@end


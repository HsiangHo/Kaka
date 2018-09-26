//
//  FinderSync.m
//  FinderPlugin
//
//  Created by Jovi on 9/23/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import "FinderSync.h"
#import <ShadowstarKit/ShadowstarKit.h>

#define TEMPLATE_PATH           [NSHomeDirectory() stringByAppendingPathComponent:@"Templates"]

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
    return [NSImage imageNamed:@"toolbar_icon"];
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
    NSMenuItem *Item = [menu addItemWithTitle:NSLocalizedString(@"Toggle Hidden File Visibility", nil) action:@selector(toggleHiddenFileVisibility_click:) keyEquivalent:@""];
    [Item setImage:[NSImage imageNamed:@"hiddenFileVisibility_icon"]];
    Item = [menu addItemWithTitle:NSLocalizedString(@"Open Terminal In This Folder", nil) action:@selector(openTerminalInFolder_click:) keyEquivalent:@""];
    [Item setImage:[NSImage imageNamed:@"terminal_icon"]];
    NSMenuItem *newFileItem = [menu addItemWithTitle:NSLocalizedString(@"New File", nil) action:@selector(newFile_click:) keyEquivalent:@""];
    [newFileItem setImage:[NSImage imageNamed:@"newFile_icon"]];
    NSMenu *menuNewFiles = [[NSMenu alloc] initWithTitle:@""];
    
    NSURL *directoryURL = [NSURL fileURLWithPath:TEMPLATE_PATH];
    NSArray *keys = [NSArray arrayWithObjects:NSURLIsDirectoryKey,nil];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL includingPropertiesForKeys:keys options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsHiddenFiles errorHandler:^(NSURL *url, NSError *error) {
        return YES;
    }];
    
    NSError *error = nil;
    for (NSURL *url in enumerator) {
        NSString *fileName = nil;
        [url getResourceValue:&fileName forKey:NSURLNameKey error:&error];
        if (nil != fileName) {
            NSMenuItem *subItem = [menuNewFiles addItemWithTitle:fileName action:@selector(newFile_click:) keyEquivalent:@""];
            [subItem setImage:[[NSWorkspace sharedWorkspace] iconForFile:[url path]]];
        }
    }
    
    if (0 == [[menuNewFiles itemArray] count]) {
        [menuNewFiles addItemWithTitle:NSLocalizedString(@"Add New File Templates", nil) action:@selector(customNewFileTemplates_click:) keyEquivalent:@""];
    }
    [menu setSubmenu:menuNewFiles forItem:newFileItem];
    Item = [menu addItemWithTitle:NSLocalizedString(@"Custom New File Templates", nil) action:@selector(customNewFileTemplates_click:) keyEquivalent:@""];
    [Item setImage:[NSImage imageNamed:@"newFileTemplate_icon"]];
    return menu;
}

-(NSMenu *)itemMenu{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    NSMenuItem *Item = [menu addItemWithTitle:NSLocalizedString(@"Toggle File Visibility", nil) action:@selector(toggleFileVisibility_click:) keyEquivalent:@""];
    [Item setImage:[NSImage imageNamed:@"hiddenFileVisibility_icon"]];
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
    NSURL* target = [[FIFinderSyncController defaultController] targetedURL];
    NSString *scptString = [NSString stringWithFormat: @"tell application \"Terminal\"\n\
                            do script \"cd %@\"\n\
                            activate\n\
                            end tell", [target path]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SSUtility accessFilePath:[NSURL fileURLWithPath:@"/"] persistPermission:YES withParentWindow:nil withActionBlock:^{
            [SSUtility execAppleScript:scptString withCompletionHandler:^(NSAppleEventDescriptor * _Nonnull returnDescriptor, NSDictionary * _Nullable error) {
                if(nil == error){ return;}
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSAlert *alert = [NSAlert alertWithMessageText:@"Open terminal in folder failed." defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please enable app's \"Automation\" function in \"SystemPreferences... -> Security & Privacy -> Privacy panel\".",nil];
                        [alert runModal];
                        [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:@"/System/Library/PreferencePanes/Security.prefPane"]];
                    });
                });
            }];
        }];
    });
}

-(IBAction)newFile_click:(id)sender{
    if ([sender isKindOfClass:[NSMenuItem class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SSUtility accessFilePath:[NSURL fileURLWithPath:@"/"] persistPermission:YES withParentWindow:nil withActionBlock:^{
                NSMenuItem *item = (NSMenuItem *)sender;
                NSString *fileName = [item title];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", TEMPLATE_PATH, fileName];
                
                NSURL* target = [[FIFinderSyncController defaultController] targetedURL];
                NSString *destFilePath = [NSString stringWithFormat:@"%@/%@", [target path], fileName];
                if(![[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destFilePath error:nil]){
                    destFilePath = [NSString stringWithFormat:@"%@/(NewFile%ld) %@", [target path],time(NULL), fileName];
                    [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destFilePath error:nil];
                }
            }];
        });
    }
}

-(IBAction)customNewFileTemplates_click:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert *alert = [NSAlert alertWithMessageText: NSLocalizedString(@"How to custom New File Templates",nil) defaultButton:NSLocalizedString(@"Open The Template Folder", nil) alternateButton:nil otherButton:nil informativeTextWithFormat: NSLocalizedString(@"You can customize the \"New File\" menu by adding, deleting, and modifying template files in the template folder.", nil),nil];
        [alert runModal];
        NSString *path = TEMPLATE_PATH;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:path]];
    });
}

-(IBAction)toggleFileVisibility_click:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SSUtility accessFilePath:[NSURL fileURLWithPath:@"/"] persistPermission:YES withParentWindow:nil withActionBlock:^{
            NSArray* items = [[FIFinderSyncController defaultController] selectedItemURLs];
            for (NSURL *fileUrl in items) {
                NSNumber *isHidden = nil;
                NSError *error = nil;
                [fileUrl getResourceValue:&isHidden forKey:NSURLIsHiddenKey error:&error];
                if (nil == error) {
                    isHidden = [NSNumber numberWithBool:![isHidden boolValue]];
                    [fileUrl setResourceValue:isHidden forKey:NSURLIsHiddenKey error: nil];
                }
            }
        }];
    });
}

@end


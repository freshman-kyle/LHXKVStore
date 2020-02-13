//
//  AppDelegate.m
//  LHXKVDemo
//
//  Created by 李华夏 on 2020/1/5.
//  Copyright © 2020 李华夏. All rights reserved.
//

#import "AppDelegate.h"
#import "LHXMainViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) LHXMainViewController *demoVc;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.demoVc = [[LHXMainViewController alloc] initWithNibName:@"LHXMainViewController" bundle:nil];
    self.window.contentView = self.demoVc.view;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end

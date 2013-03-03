//
//  AppDelegate.m
//  CustomPositionLayoutExample
//
//  Created by Denys Telezhkin on 01.03.13.
//  Copyright (c) 2013 Denys Telezhkin. All rights reserved.
//

#import "AppDelegate.h"
#import "CollectionViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    self.controller = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.controller = [[[CollectionViewController alloc] init] autorelease];
    [self.window setRootViewController:self.controller];
    [self.window makeKeyAndVisible];
    
    return YES;
}
@end

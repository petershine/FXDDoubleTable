//
//  FXDAppDelegate.m
//  FXDDoubleTable
//
//  Created by petershine on 11/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDAppDelegate.h"

@implementation FXDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	FXDcontrollerMain *mainController = [[FXDcontrollerMain alloc] initWithNibName:nil bundle:nil];

	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	[self.window setRootViewController:mainController];

    [self.window makeKeyAndVisible];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}


@end

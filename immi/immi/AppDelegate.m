//
//  AppDelegate.m
//  immi
//
//  Created by Ravi on 29/11/16.
//  Copyright (c) 2016 ABI. All rights reserved.
//

#import "AppDelegate.h"

#import "RegisterViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
 /*   self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.registe= [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    self.window.rootViewController = self.registe;
    [self.window makeKeyAndVisible];*/       sleep(3);
    
 
    
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* strToken = [deviceToken description];
    strToken = [strToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    strToken = [strToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSUserDefaults *defaultValues = [NSUserDefaults standardUserDefaults];
    [defaultValues setValue:strToken forKey:@"valToken"];
    [defaultValues synchronize];
    
   // UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"strToken" message:strToken delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
   // [alert show];
    NSLog(@"%@",strToken);
    
    [[NSUserDefaults standardUserDefaults] setValue:strToken forKey:@"device_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//
//  AppDelegate.m
//  weiboDemo
//
//  Created by admin on 12/24/12.
//  Copyright (c) 2012 lihai. All rights reserved.
//

#import "AppDelegate.h"
#define kAppKey         @"892732161"
#define kAppSecret      @"84c82f95151c73641c9783f732252f88"
#define kAppRedirectURI @"http://www.baidu.com"
#import "SinaWeibo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initSinaWeibo];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initSinaWeibo
{
    self.sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:nil];
    // 如果以前登录过还没有过期的话,取出来
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"]
        && [sinaweiboInfo objectForKey:@"UserIDKey"]) {
        self.sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
}
@end

//
//  AppDelegate.m
//  myTalk
//
//  Created by jam on 17/4/8.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "AppDelegate.h"

#define RONG_APP_KEY @"y745wfm8443zv"

@interface AppDelegate ()<RCIMClientReceiveMessageDelegate>

@end

@implementation AppDelegate

/*
 {"code":200,"userId":"jam","token":"vvEQ0x0yR27wcnRQQFj4MhzW2SeFZ+o7/punDJxCX7yYIzjEZYQJU90QzH6sSb/dM/bUxrHzuMcQmJ6c+Dpfww=="}
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[RCIMClient sharedRCIMClient]initWithAppKey:RONG_APP_KEY];
    [[RCIMClient sharedRCIMClient]connectWithToken:@"vvEQ0x0yR27wcnRQQFj4MhzW2SeFZ+o7/punDJxCX7yYIzjEZYQJU90QzH6sSb/dM/bUxrHzuMcQmJ6c+Dpfww==" success:^(NSString *userId) {
        NSLog(@"connect success, userid:%@",userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"connect error code:%d",(int)status);
    } tokenIncorrect:^{
        NSLog(@"token incorrect");
    }];
    [[RCIMClient sharedRCIMClient]setReceiveMessageDelegate:self object:nil];
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.window makeKeyAndVisible];
    
    UINavigationController* nav=[[UINavigationController alloc]init];
    ChatListController* chatlist=[[ChatListController alloc]init];
    [nav pushViewController:chatlist animated:NO];
    
    self.window.rootViewController=nav;
    
    return YES;
}

-(void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    [dic setValue:message forKey:@"message"];
    [dic setValue:[NSNumber numberWithInt:nLeft] forKey:@"nLeft"];
    [dic setValue:object forKey:@"object"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:ReceiveNewMessageNotificationKey object:nil userInfo:dic];
    });
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

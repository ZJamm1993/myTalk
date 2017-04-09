//
//  AppDelegate.h
//  myTalk
//
//  Created by jam on 17/4/8.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>
#import "ChatListController.h"

#define ReceiveNewMessageNotificationKey @"ReceiveNewMessageNotificationKey"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString* currentUserId;

@end


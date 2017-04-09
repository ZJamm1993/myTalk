//
//  ChatViewController.h
//  myTalk
//
//  Created by jam on 17/4/8.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

@interface ChatViewController : UIViewController

@property (nonatomic,assign) RCConversationType conversationType;
@property (nonatomic,strong) NSString* targetId;

@end

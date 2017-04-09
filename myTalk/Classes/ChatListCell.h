//
//  ChatListCell.h
//  myTalk
//
//  Created by jam on 17/4/8.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

@interface ChatListCell : UITableViewCell

@property (nonatomic,strong) RCConversation* conversation;

@end

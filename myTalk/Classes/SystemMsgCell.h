//
//  SystemMsgCell.h
//  myTalk
//
//  Created by jam on 17/4/10.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

#define SYS_MSG_ID @"sys__msg_id"

@interface SystemMsgCell : UITableViewCell

@property (nonatomic,strong) RCMessage* message;

@end

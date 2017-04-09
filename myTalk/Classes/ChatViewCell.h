//
//  ChatViewCell.h
//  myTalk
//
//  Created by jam on 17/4/9.
//  Copyright © 2017年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

@interface ChatViewCell : UITableViewCell

@property (nonatomic,strong) RCMessage* message;

@end

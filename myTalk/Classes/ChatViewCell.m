//
//  ChatViewCell.m
//  myTalk
//
//  Created by jam on 17/4/9.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ChatViewCell.h"

@implementation ChatViewCell

-(void)setMessage:(RCMessage *)message
{
    _message=message;
    
    NSString* name=message.senderUserId;
    
    RCMessageContent* msgContent=message.content;
    NSString* detail=@"未知消息类型";
    if ([msgContent isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage* textMsg=(RCTextMessage*)msgContent;
        detail=textMsg.content;
    }
    else if([msgContent isKindOfClass:[RCImageMessage class]])
    {
        detail=@"图片";
    }
    else if([msgContent isKindOfClass:[RCVoiceMessage class]])
    {
        detail=@"语音";
    }
    else if([msgContent isKindOfClass:[RCFileMessage class]])
    {
        detail=@"文件";
    }
    else if([msgContent isKindOfClass:[RCLocationMessage class]])
    {
        detail=@"位置";
    }
    else
    {
        
    }
    
    self.textLabel.text=name;
    self.detailTextLabel.text=detail;
}

@end

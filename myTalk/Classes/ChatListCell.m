//
//  ChatListCell.m
//  myTalk
//
//  Created by jam on 17/4/8.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ChatListCell.h"\

@implementation ChatListCell

-(void)setConversation:(RCConversation *)conversation
{
    _conversation=conversation;
    
    RCMessageContent* lastMsg=_conversation.lastestMessage;
    self.textLabel.text=conversation.targetId;
    NSString* detail=@"未知消息类型";
    if ([lastMsg isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage* textMsg=(RCTextMessage*)lastMsg;
        detail=textMsg.content;
    }
    else if([lastMsg isKindOfClass:[RCImageMessage class]])
    {
        detail=@"图片";
    }
    else if([lastMsg isKindOfClass:[RCVoiceMessage class]])
    {
        detail=@"语音";
    }
    else if([lastMsg isKindOfClass:[RCFileMessage class]])
    {
        detail=@"文件";
    }
    else if([lastMsg isKindOfClass:[RCLocationMessage class]])
    {
        detail=@"位置";
    }
    else
    {
        
    }
    self.detailTextLabel.text=detail;
    
    self.imageView.image=[UIImage imageNamed:@"frog"];
}

@end

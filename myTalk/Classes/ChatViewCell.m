//
//  ChatViewCell.m
//  myTalk
//
//  Created by jam on 17/4/9.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ChatViewCell.h"
#import "Masonry.h"

@implementation ChatViewCell
{
    UIImageView* headImageView;
    UILabel* nameLabel;
    UIImageView* bubbleView;
    UILabel* contentLabel;
    UIImage* leftBubbleImage;
    UIImage* rightBubbleImage;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView=[[UIImageView alloc]init];
        [self.contentView addSubview:headImageView];
//        headImageView.backgroundColor=[UIColor grayColor];
        
        nameLabel=[[UILabel alloc]init];
        [self.contentView addSubview:nameLabel];
//        nameLabel.backgroundColor=[UIColor yellowColo/r];
        
        bubbleView=[[UIImageView alloc]init];
        [self.contentView addSubview:bubbleView];
//        bubbleView.backgroundColor=[UIColor cyanColor];
        
        contentLabel=[[UILabel alloc]init];
        [self.contentView addSubview:contentLabel];
//        contentLabel.backgroundColor=[UIColor magentaColor];
        contentLabel.numberOfLines=0;
        
        UIImage* l=[UIImage imageNamed:@"bubble_left"];
        leftBubbleImage=[l stretchableImageWithLeftCapWidth:l.size.width/2 topCapHeight:l.size.height/2];
        UIImage* r=[UIImage imageNamed:@"bubble_right"];
        rightBubbleImage=[r stretchableImageWithLeftCapWidth:r.size.width/2 topCapHeight:r.size.height/2];
    }
    return self;
}

-(UIEdgeInsets)defaultInsets
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

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
    
    headImageView.image=[UIImage imageNamed:@"frog"];;
    nameLabel.text=name;
    contentLabel.text=detail;
    self.isRight=self.isRight;
}

-(void)setIsRight:(BOOL)isRight
{
    _isRight=isRight;

    if (isRight) {
        bubbleView.image=rightBubbleImage;
    }
    else
    {
        bubbleView.image=leftBubbleImage;
    }
    
    [headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.equalTo(@(44));
        make.top.equalTo(self.contentView).offset(10);
        if (isRight) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }
        else
        {
            make.left.equalTo(self.contentView.mas_left).offset(10);
        }
    }];
    
    [nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(headImageView.mas_top);
        if (isRight) {
            make.right.equalTo(headImageView.mas_left).offset(-10);
            make.left.greaterThanOrEqualTo(self.contentView.mas_left).offset(10);
        }
        else
        {
            make.left.equalTo(headImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-10);
        }
    }];
    
    [bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        if (isRight) {
            make.right.equalTo(nameLabel.mas_right);
            make.left.equalTo(contentLabel.mas_left).offset(-10);
            
        }
        else
        {
            make.left.equalTo(nameLabel.mas_left);
            make.right.equalTo(contentLabel.mas_right).offset(10);
        }
    }];

    [contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.lessThanOrEqualTo(@(160));
        make.top.equalTo(bubbleView.mas_top).offset(10);
        make.bottom.equalTo(bubbleView.mas_bottom).offset(-10);
        if (isRight) {
            make.right.equalTo(bubbleView.mas_right).offset(-20);
        }
        else
        {
            make.left.equalTo(bubbleView.mas_left).offset(20);
        }
        
    }];
}

@end

//
//  SystemMsgCell.m
//  myTalk
//
//  Created by jam on 17/4/10.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "SystemMsgCell.h"
#import "Masonry.h"

@implementation SystemMsgCell
{
    UIView* bgView;
    UILabel* textLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bgView=[[UIView alloc]init];
        bgView.backgroundColor=[UIColor lightGrayColor];
        bgView.layer.cornerRadius=3;
        [self.contentView addSubview:bgView];
        
        textLabel=[[UILabel alloc]init];
        textLabel.textColor=[UIColor whiteColor];
        textLabel.font=[UIFont systemFontOfSize:10];
        textLabel.numberOfLines=0;
        [self.contentView addSubview:textLabel];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            UIEdgeInsets ins=UIEdgeInsetsMake(-4, -4, -4, -4);
            make.left.right.top.bottom.equalTo(textLabel).insets(ins);
        }];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo(@(240));
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    return self;
}

-(void)setMessage:(RCMessage *)message
{
    _message=message;
    textLabel.text=message.extra;
}

@end

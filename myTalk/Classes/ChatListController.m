//
//  ChatListController.m
//  myTalk
//
//  Created by jam on 17/4/8.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ChatListController.h"
#import "Masonry.h"
#import <RongIMLib/RongIMLib.h>
#import "ChatListCell.h"
#import "AppDelegate.h"
#import "ChatViewController.h"

@interface ChatListController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSArray* _dataSource;
    UIRefreshControl* _refreshControl;
}
@end

@implementation ChatListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"会话";
    
    _tableView=[[UITableView alloc]init];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=64;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    _refreshControl=[[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refreshChatList) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewMessage:) name:ReceiveNewMessageNotificationKey object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshChatList];
}

-(void)receiveNewMessage:(NSNotification*)notification
{
    NSDictionary* userInfo=notification.userInfo;
    int nLeft=[[userInfo valueForKey:@"nLeft"]intValue];
    if (nLeft==0) {
        [self refreshChatList];
    }
}

- (void)refreshChatList
{
    _dataSource=[[RCIMClient sharedRCIMClient]getConversationList:[NSArray arrayWithObjects:
                                                                   @(ConversationType_PRIVATE),
                                                                   @(ConversationType_DISCUSSION),
                                                                   @(ConversationType_GROUP),
                                                                   @(ConversationType_SYSTEM),
                                                                   @(ConversationType_APPSERVICE),
                                                                @(ConversationType_PUBLICSERVICE),nil]];
    [_tableView reloadData];
    [_refreshControl endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* idd=@"ChatListCell";
    ChatListCell* cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=[[ChatListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idd];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    RCConversation *conversation=[_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text=conversation.targetId;
    cell.detailTextLabel.text=conversation.lastestMessage.rawJSONData.description;
    cell.conversation=conversation;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController* chatView=[[ChatViewController alloc]init];
    RCConversation *conversation=[_dataSource objectAtIndex:indexPath.row];
    chatView.targetId=conversation.targetId;
    chatView.conversationType=conversation.conversationType;
    [self.navigationController pushViewController:chatView animated:YES];
}

@end

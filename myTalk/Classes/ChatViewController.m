//
//  ChatViewController.m
//  myTalk
//
//  Created by jam on 17/4/8.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "ChatViewController.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "ChatViewCell.h"

@interface ChatViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField* _inputTextField;
    UITableView* _tableView;
    NSMutableArray* _dataSource;
    UIRefreshControl* _refreshControl;
    NSInteger _loadedCount;
    NSString* _myUserId;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=self.targetId;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    
    _loadedCount=10;
    _dataSource=[NSMutableArray array];
    _myUserId=[[RCIMClient sharedRCIMClient]currentUserInfo].userId;
    
    _tableView=[[UITableView alloc]init];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.rowHeight=UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight=66;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _inputTextField=[[UITextField alloc]init];
    _inputTextField.delegate=self;
    _inputTextField.backgroundColor=[UIColor redColor];
    _inputTextField.returnKeyType=UIReturnKeySend;
    [self.view addSubview:_inputTextField];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.bottom.equalTo(_inputTextField.mas_top);
    }];
    
    [_inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    
    _refreshControl=[[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refreshMoreMessages) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewMessage:) name:ReceiveNewMessageNotificationKey object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self refreshMessages];
    [self performSelector:@selector(tableViewScrollToBottom:) withObject:_tableView afterDelay:0];
}

-(void)refreshMoreMessages
{
    _loadedCount=_loadedCount+10;
    [self refreshMessages];
}

-(void)refreshMessages
{
    NSArray* msgs=[[RCIMClient sharedRCIMClient]getLatestMessages:self.conversationType targetId:self.targetId count:_loadedCount];
    NSArray *sortedMsgs = [msgs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        RCMessage* ms1=(RCMessage*)obj1;
        RCMessage* ms2=(RCMessage*)obj2;
        return ms1.sentTime>ms2.sentTime;
    }];
    NSInteger oldRows=_dataSource.count;
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:sortedMsgs];
    NSInteger newRows=_dataSource.count;
    [_tableView reloadData];
    [_refreshControl endRefreshing];
    if (newRows>oldRows) {
        NSInteger stillRow=newRows-oldRows;
        NSInteger sec=[_tableView numberOfSections];
        if (sec>0) {
            sec=sec-1;
            NSInteger row=[_tableView numberOfRowsInSection:sec];
            if (row>stillRow) {
                NSIndexPath* indexPath=[NSIndexPath indexPathForRow:stillRow inSection:sec];
                [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self performSelector:@selector(tableViewScrollToBottom:) withObject:_tableView afterDelay:0];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length>0) {
        [self sendTextMessage:textField.text];
        textField.text=@"";
    }
    return NO;
}

-(void)sendTextMessage:(NSString*)text
{
    RCTextMessage* textMsg=[RCTextMessage messageWithContent:text];
    [[RCIMClient sharedRCIMClient]sendMessage:self.conversationType targetId:self.targetId content:textMsg pushContent:nil pushData:nil success:^(long messageId) {
        NSLog(@"send success: %ld",messageId);
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"send error: %d messageid: %ld",nErrorCode,messageId);
    }];
    [self didSendNewMessage];
}

-(void)didSendNewMessage
{
    _loadedCount=10;
    [self refreshMessages];
    [self performSelector:@selector(tableViewScrollToBottom:) withObject:_tableView afterDelay:0.25];
}

-(void)receiveNewMessage:(NSNotification*)notification
{
    NSDictionary* userInfo=notification.userInfo;
    RCMessage* msg=[userInfo valueForKey:@"message"];
    if (msg.conversationType==self.conversationType) {
        if ([msg.targetId isEqualToString:self.targetId]) {
            [_dataSource addObject:msg];
            [_tableView reloadData];
            [self tableViewScrollToBottom:_tableView];
        }
    }
}
     
-(void)keyboardWillShow:(NSNotification*)notification
{
//    NSLog(@"%@",notification.userInfo.description);
    NSValue* value=[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect=[value CGRectValue];
    CGFloat y=rect.origin.y;
    CGRect fra=self.view.frame;
    fra.size.height=y;
    self.view.frame=fra;
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    [self keyboardWillShow:notification];
}

-(void)tableViewScrollToBottom:(UITableView*)tableView
{
    NSInteger sec=[tableView numberOfSections];
    if (sec>0) {
        sec=sec-1;
        NSInteger row=[tableView numberOfRowsInSection:sec];
        if (row>0) {
            row=row-1;
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:row inSection:sec];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_inputTextField resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 100;
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* idd=@"ChatViewCell";
    ChatViewCell* cell=[tableView dequeueReusableCellWithIdentifier:idd];
    if (cell==nil) {
        cell=[[ChatViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idd];
    }
    RCMessage* msg=[_dataSource objectAtIndex:indexPath.row];
    BOOL isRight=[msg.senderUserId isEqualToString:_myUserId];
    cell.isRight=isRight;
    cell.message=msg;
    return cell;
}

@end

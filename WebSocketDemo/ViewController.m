//
//  ViewController.m
//  WebSocketDemo
//
//  Created by apple on 2016/10/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import <SocketRocket/SRWebSocket.h>

@interface ViewController ()<SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 100, 50);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self webSocketConnect];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
}

// 初始化
- (void)webSocketConnect
{
    self.webSocket.delegate = self;
    [self.webSocket close];
    
    // 172.16.2.173
    // 172.16.2.246
    // 172.16.2.1
    // ws://172.16.6.142:8090/dzfchat
    
//    ws://172.16.6.142:8090/dzfchat/rqQpVqnbmh/qpsTcFjOO94GKMxGJ8vChkmH+HFmaH7w=/chatservlet.ws
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://172.16.6.142:8090/dzfchat/bca7fb5d1df27929163ea63a4de71dde74d91e1290571dbee34e3818e4daea90/chatservlet.ws"]]];
    self.webSocket.delegate = self;
    self.title = @"Opening Connecting";
    NSLog(@"------222------");
    [self.webSocket open];
    
//    self.manager = [MessageManager sharedInstance];
//    self.manager.socketHost = @"ws://172.16.6.142:8090/dzfchat/bca7fb5d1df27929163ea63a4de71dde74d91e1290571dbee34e3818e4daea90/chatservlet.ws";
//    [self.manager socketConnect];
}

#pragma mark - SendButton Response
- (void)sendAction:(id)sender {
    
    
//username: mine.username
//    ,avatar:mine.avatar
//    ,id: mine.id
//    ,type:  to.type
//    ,content:mine.content
//    ,message_type: 'chatMessage'
//    ,to_id:to.id
//    ,to_username:to.username
//    ,to_avatar:to.avatar
    
    NSDictionary *dict = @{@"username" : @"123",
                           @"avatar":@"",
                           @"id":@"appuse00000000aAosRX0001",
                           @"type":@"friend",
                           @"content":@"nihao1234567890",
                           @"message_type":@"chatMessage",
                           @"to_id":@"00000100000000d2fSVy0002",
                           @"to_username":@"456",
                           @"to_avatar":@"",};
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    [self.view endEditing:YES];
    
    NSLog(@"%@",[self DataTOjsonString:dict]);
    
    // WebSocket
//    if (self.webSocket) {
//        [self.webSocket send:[self DataTOjsonString:dict]];
//    }
    [self.manager.socket send:[self DataTOjsonString:dict]];
}

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//连接成功
//代理方法实现
#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"WebSocket Connect");
    self.title = @"Connected!";
}

// 连接失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Websocket Failed With Error --- %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    self.webSocket = nil;
}

// 接收到新消息的处理
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"接收到Message-----%@",message);
}

// 连接关闭
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Closed Reason:%@",reason);
    self.title = @"Connection Closed! (see logs)";
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"%@",reply);
}


@end

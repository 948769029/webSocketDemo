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
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"自己服务器聊天地址"]]];
    self.webSocket.delegate = self;
    self.title = @"Opening Connecting";
    NSLog(@"------222------");
    [self.webSocket open];
}

#pragma mark - SendButton Response
- (void)sendAction:(id)sender {
    
    // WebSocket
    if (self.webSocket) {
        [self.webSocket send:@"您好~"];
    }
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

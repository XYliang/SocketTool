//
//  AbstractSocketExecutor.m
//  HuiKePay
//
//  Created by 薛银亮 on 16/3/1.
//  Copyright © 2016年 30pay. All rights reserved.
//

#import "AbstractSocketExecutor.h"
#import "XMLDictionary.h"
#import "GCDAsyncSocket.h"
#import "SocketHandleRespDelegate.h"
#import "StringUtil.h"

#define kTCPSenderTag 123

NSString *const SOCKET_SERVER_URL = @"www.baidu.com";

uint16_t const SOCKET_SERVER_PORT = 1108;



@interface AbstractSocketExecutor()<GCDAsyncSocketDelegate,SocketHandleRespDelegate>
{
    GCDAsyncSocket * _asyncSocket;
    NSData         * _data;
    NSTimer        * _heartTimer;   // 心跳计时器
    
}
@property(strong,nonatomic) NSMutableData * receivedData;
@property(nonatomic) NSUInteger dataLength;

@end

@implementation AbstractSocketExecutor

+(AbstractSocketExecutor*)socketExecutor
{
    AbstractSocketExecutor * executor = [[self alloc] init];
    return executor;
}

-(id)init {
    self = [super init];
    if(self) {
        self.dataLength = 0;
        self.receivedData = [NSMutableData new];
    }
    return self;
}

/**
 *  执行socket方法
 *
 *  @param params 发送参数
 */
-(int)execute:(NSDictionary*)params
{
    _data = params[@"params"];
    //创建
    [self createGCDAsyncSocket];
    //连接
    [self connectToServer];
    return 0;
}


#pragma mark - Create GCDAsyncSocket object

-(void)createGCDAsyncSocket
{
    _asyncSocket =[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)connectToServer
{
    NSError  * error = nil;
    if (![_asyncSocket connectToHost:SOCKET_SERVER_URL onPort:SOCKET_SERVER_PORT withTimeout:10.f error:&error])
    {
        NSLog(@"配置错误不能连接: %@", error);
    }
    else
    {
        NSLog(@"连接到服务器： \"%@\" 端口： %hu...", SOCKET_SERVER_URL, SOCKET_SERVER_PORT);
    }
}

#pragma mark - GCDAsyncSocket delegate

//连接成功
- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(uint16_t)port {
    
    //发送数据
    [_asyncSocket writeData:_data withTimeout:30.f tag:kTCPSenderTag];
    //读取服务器返回数据
    [_asyncSocket readDataWithTimeout:20.f tag:kTCPSenderTag];
}

// 连接失败
- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err
{
    NSLog(@"连接失败 %@", err);
    //断开连接
    [self clearSocket];

}

//接受服务器返回的数据
- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag
{
    const NSInteger LengthFieldSize = 6;
    if (data) {
        [self.receivedData appendData:data];
        if (self.dataLength==0 && self.receivedData.length>=LengthFieldSize) {
            NSData * lengthData = [self.receivedData subdataWithRange:NSMakeRange(0, LengthFieldSize)];
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString * lengthString = [[NSString alloc] initWithData:lengthData encoding:gbkEncoding];
            self.dataLength = [lengthString integerValue];
        } else {
            
        }
        NSLog(@"Data length:%ld, received:%ld",self.dataLength,self.receivedData.length);
        if (self.dataLength>(self.receivedData.length+LengthFieldSize)) {
            [sock readDataWithTimeout:20.f tag:kTCPSenderTag];
            return;
        } else {
            [self clearSocket];
        }
        if ([self conformsToProtocol:@protocol(SocketHandleRespDelegate)]) {
            [self handleSocketReposoneWithData:self.receivedData tag:tag];
        }
        else{
            
        }
    }
    else{
        [self clearSocket];

    }
}

-(NSDictionary *)processData:(NSData *)data
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *myDictionary = [unarchiver decodeObjectForKey:@"Some Key Value"];
    [unarchiver finishDecoding];
    return myDictionary;
}
#pragma mark - SocketHandleRespDelegate methods

- (void)handleSocketReposoneWithData:(NSData*)data tag:(long)tag{
    
}

#pragma mark - clearSocket methods

- (void)clearSocket
{
    [_asyncSocket setDelegate:nil delegateQueue:NULL];
    
    [_asyncSocket disconnect];
    
    _asyncSocket = nil;
}

@end

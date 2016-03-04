//
//  SocketExecutor.m
//  HuiKePay
//
//  Created by 薛银亮 on 16/3/1.
//  Copyright © 2016年 30pay. All rights reserved.
//

#import "SocketExecutor.h"
#import "XMLDictionary.h"
#import "StringUtil.h"

@implementation SocketExecutor

-(int)execute:(NSDictionary *)params
{
    NSMutableDictionary * socketParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSMutableDictionary * temp;
    temp = socketParams[@"params"];
    NSMutableString *xmlStringBody = [[NSMutableString alloc] init];
    [xmlStringBody appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    NSString * dicToXMLString = [temp XMLString];
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [xmlStringBody appendString:dicToXMLString];
    NSUInteger xmlLength = [xmlStringBody lengthOfBytesUsingEncoding:gbkEncoding];
    NSMutableString * xmlString = [NSMutableString stringWithFormat:@"%@",[StringUtil fillZeroOnFrontOfInteger:xmlLength]];
    [xmlString appendString:xmlStringBody];
    NSData * xmlData = [xmlString dataUsingEncoding:gbkEncoding];
    NSDictionary * socketDatas = @{@"params":xmlData};
    
    return [super execute:socketDatas];
}

-(void)handleSocketReposoneWithData:(NSData *)data tag:(long)tag{
    
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *retData = [[NSString alloc] initWithData:data encoding:gbkEncoding];
    
    NSString * newData = [retData substringFromIndex:44];
    
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:newData];
    
    //socket连接请求成功，业务逻辑数据正常
    //成功
    if ([xmlDoc[@"main_data"][@"respCode"] isEqualToString:@"EO0000"])
    {
        NSString *barCode = xmlDoc[@"main_data"][@"barcode"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getBarCodeSuccessNotification" object:self userInfo:@{@"barCode":barCode}];
    }
    //socket连接请求成功，业务逻辑数据获取失败
    else{
        
        NSLog(@"失败");
    }
}


#pragma mark - private methods

-(NSString *)getDescStringWithXMLInfo:(NSDictionary *)xmlDic{
    NSString * desc;
    if(xmlDic[@"comm_head"][@"rspMsg"]){
        desc = xmlDic[@"comm_head"][@"rspMsg"];
    }
    else{
        
        
    }
    return desc;
}
-(NSDictionary*) buildPackageWithRespons:(NSDictionary*)responseObject andError:(NSError*)error
{
    NSString * desc;
    int returnCode;
    
    if ([responseObject[@"respCode"] isEqualToString:@"E00000"]) {
        desc = responseObject[@"respMsg"];
    }
    else
    {
        desc = @"Success";
    }
    
    if (responseObject[@"respCode"])
        returnCode = [(NSNumber*)responseObject[@"return_code"] intValue];
    else
        returnCode = 0;
    
    NSMutableDictionary * retPackage = [NSMutableDictionary dictionary];
    retPackage[@"success"] = error ? @(NO) : @(YES);
    retPackage[@"code"] = error ? @(error.code) : @(returnCode);
    retPackage[@"message"] = error ? error.description : desc;
    if (responseObject ) {
        retPackage[@"data"]  = responseObject;
    } else {
        retPackage[@"data"] = [NSNull null];
    }
    return retPackage;
}

//格式化->获取订单查询（批量）成功接口数据

-(NSDictionary *)reformatOrderBatchQueryInfo:(NSDictionary *)data
{
    NSMutableDictionary * retData = [data mutableCopy];
    NSMutableDictionary * mainData = [data[@"main_data"] mutableCopy];
    NSMutableArray * lists = [[NSMutableArray alloc] init];
    if ([mainData[@"list"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary * listObjDic = mainData[@"list"];
        NSArray * keys = [listObjDic allKeys];
        for (int i = 1; i<=[keys count]; i++) {
            NSString * listKey = [NSString stringWithFormat:@"list_%d",i];
            NSDictionary * temp = listObjDic[listKey];
            [lists addObject:temp];
        }
        [mainData removeObjectForKey:@"list"];
        [mainData setObject:lists forKey:@"list"];
        [retData removeObjectForKey:@"main_data"];
        [retData setObject:mainData forKey:@"main_data"];
        return retData;
    }else{
        return data;
    }
}

@end

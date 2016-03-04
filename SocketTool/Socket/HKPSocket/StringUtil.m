//
//  StringUtil.m
//  HuiKePay
//
//  Created by 薛银亮 on 16/3/1.
//  Copyright © 2016年 30pay. All rights reserved.
//

#import "StringUtil.h"

NSString * const STRING_UTIL_TRUE = @"true";
NSString * const STRING_UTIL_FALSE = @"false";
@implementation StringUtil
+(BOOL)boolFromString:(NSString *)string
{
    if ([STRING_UTIL_TRUE isEqualToString:string]) {
        return YES;
    }
    return NO;
}
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else
    {
        return nil;
    }
}
+ (NSDictionary*)jsonStringToDictionary:(NSString *)string
{
    NSError *jsonError;
    NSData *objectData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    if (json!=nil && jsonError == nil)
    {
        return json;
    }
    else
    {
        return nil;
    }
    
}
+ (NSString *)toJSONString:(id)theData;
{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}



+ (NSString *)generatePicIDWithPrfix:(NSString*)prefix
{
    static int timeAccurates[5] = {0x100000,0x10000,0x1000,0x100,0x10,0x1};//this has 6 elements but array length is 5
    NSString *ID;
    char rand[5];
    for (int i = 0; i < 4; i++) {
        rand[i] = 'A' + (arc4random() % 26);
    }
    rand[4] = '\0';
    
    if (prefix.length >=5)
    {
        prefix = [prefix substringToIndex:4];
    }
    double timeDouble = [[NSDate date]timeIntervalSince1970]*1000;
    timeDouble = timeDouble * timeAccurates[prefix.length];
    NSString *timeString = [NSString stringWithFormat:@"%llx",(long long)timeDouble];
    if(timeString.length>(20-4-prefix.length))
    {
        timeString = [timeString substringFromIndex:timeString.length-(20-4-prefix.length-1)];
    }
    ID = [NSString stringWithFormat:@"%@%@%s", prefix, timeString, rand];
    return ID;
}

+ (NSString *)fillZeroOnFrontOfInteger:(NSUInteger)aInteger
{
    float result = aInteger/100;
    NSString * ret ;
    if (result < 0.1)
    {
        //1位数
        ret = [NSString stringWithFormat:@"00000%lu",(unsigned long)aInteger];
    }
    else if(result < 1)
    {
        //2位数
        ret = [NSString stringWithFormat:@"0000%lu",(unsigned long)aInteger];
    }
    else if(result < 10)
    {
        //3位数
        ret = [NSString stringWithFormat:@"000%lu",(unsigned long)aInteger];
    }
    else if (result < 100)
    {
        //4位数
        ret = [NSString stringWithFormat:@"00%lu",(unsigned long)aInteger];
    }
    else if (result < 1000)
    {
        //5位数
        ret = [NSString stringWithFormat:@"0%lu",(unsigned long)aInteger];
    }
    return ret;
}
+ (NSDictionary*)jsonObjectToDictionary:(id)jsonObject isDecrypt:(BOOL)isDecrypt
{
    NSString *jSONString;
    NSString *toDecryptString = [[NSString alloc] initWithData:(NSData*)jsonObject encoding:NSUTF8StringEncoding];
    if (isDecrypt)
    {
//        jSONString = [Security3DES tripleDES:toDecryptString encryptOrDecrypt:kCCDecrypt];
    }
    else
    {
        jSONString = toDecryptString;
    }
    
    NSLog(@"--------------------------jSONString-------------------%@",jSONString);
    NSError *jsonError;
    if(nil != jSONString){
        NSData *objectData = [jSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jSONDic = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError.code == 3840) {
            return @{@"desc":@"JSON字符串无效！"};
        }
        else
            return jSONDic;
    }
    else
    {
        return @{@"desc":@"JSON字符串为空！"};
    }
    
}
@end
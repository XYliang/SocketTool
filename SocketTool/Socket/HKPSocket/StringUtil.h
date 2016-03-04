//
//  StringUtil.h
//  HuiKePay
//
//  Created by 薛银亮 on 16/3/1.
//  Copyright © 2016年 30pay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject
+ (BOOL)boolFromString:(NSString *)string;
//+ (NSString *)toJSONString:(id)theData;
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary;
+ (NSDictionary*)jsonStringToDictionary:(NSString *)string;
+ (NSDictionary*)jsonObjectToDictionary:(id)jsonObject isDecrypt:(BOOL)isDecrypt;
+ (NSString *)fillZeroOnFrontOfInteger:(NSUInteger)aInteger;
+ (NSString *)generatePicIDWithPrfix:(NSString*)prefix;
@end

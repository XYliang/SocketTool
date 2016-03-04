//
//  AbstractSocketExecutor.h
//  HuiKePay
//
//  Created by 薛银亮 on 16/3/1.
//  Copyright © 2016年 30pay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractSocketExecutor : NSObject

@property(nonatomic,strong) NSString * type;
+(AbstractSocketExecutor*)socketExecutor;
-(int)execute:(NSDictionary*)params;

@end

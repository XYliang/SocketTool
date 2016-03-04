//
//  HKPSocketTool.h
//  HuiKePay
//
//  Created by 薛银亮 on 16/3/4.
//  Copyright © 2016年 30pay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKPUserObject.h"
#import "SocketExecutor.h"

@interface HKPSocketTool : NSObject

/**
 *  请求二维码信息
 */
-(void)getBinaryCodeInfo;
@end

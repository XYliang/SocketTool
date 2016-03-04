//
//  SocketExecutor.h
//  HuiKePay
//
//  Created by 薛银亮 on 16/3/1.
//  Copyright © 2016年 30pay. All rights reserved.
//

#import "AbstractSocketExecutor.h"
#import "SocketHandleRespDelegate.h"

typedef void (^ShowPaycode)();

@interface SocketExecutor : AbstractSocketExecutor<SocketHandleRespDelegate>


//-(int)execute:(NSDictionary *)params completion:(ShowPaycode)showPaycode;
@end

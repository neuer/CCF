//
//  CCFFormList.h
//  CCF
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCFThread.h"

@interface CCFNormalThread : CCFThread

@property (nonatomic, assign) BOOL isTopThread;             // 是否置顶帖子

@end

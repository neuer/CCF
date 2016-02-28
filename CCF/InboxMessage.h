//
//  InboxMessage.h
//  CCF
//
//  Created by 迪远 王 on 16/2/28.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InboxMessage : NSObject

@property (nonatomic, assign) BOOL isReaded;
@property (nonatomic, strong) NSString *pmTitle;
@property (nonatomic, strong) NSString *pmAuthor;

@property (nonatomic, strong) NSString *pmTime;

@end
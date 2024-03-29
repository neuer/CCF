//
//  CCFThreadListCell.h
//  CCF
//
//  Created by 迪远 王 on 16/1/2.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCFNormalThread;

@interface CCFThreadListCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *threadAuthor;
@property (weak, nonatomic) IBOutlet UILabel *threadTitle;
@property (weak, nonatomic) IBOutlet UILabel *threadPostCount;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *threadCreateTime;
@property (weak, nonatomic) IBOutlet UILabel *threadType;

-(void) setThreadList:(CCFNormalThread *) threadList;

@end

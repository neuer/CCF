//
//  CCFThreadListCell.m
//  CCF
//
//  Created by 迪远 王 on 16/1/2.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import "CCFThreadListCell.h"
#import "CCFThreadList.h"
#import "CCFBrowser.h"
#import "CCFUrlBuilder.h"
#import "NSString+Regular.h"
#import <UIImageView+AFNetworking.h>
#import "CCFCoreDataManager.h"
#import "CCFUserEntry+CoreDataProperties.h"


@implementation CCFThreadListCell{
    CCFBrowser *_browser;
    CCFCoreDataManager *_coreDateManager;
    
}

@synthesize threadAuthor = _threadAuthor;
@synthesize threadPostCount = _threadPostCount;
@synthesize threadTitle = _threadTitle;
@synthesize threadCreateTime = _threadCreateTime;
@synthesize threadType = _threadType;
@synthesize avatarImage = _avatarImage;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _browser = [[CCFBrowser alloc]init];
        _coreDateManager = [[CCFCoreDataManager alloc] initWithCCFCoreDataEntry:CCFCoreDataEntryUser];
        
        [self.avatarImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        self.avatarImage.contentMode =  UIViewContentModeScaleAspectFit;
        self.avatarImage.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.avatarImage.clipsToBounds  = YES;

    }
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setThreadList:(CCFThreadList *)threadList{
    self.threadAuthor.text = threadList.threadAuthorName;
    
    NSString * type = [threadList.threadTitle stringWithRegular:@"【.{1,4}】"];
    
    self.threadTitle.text = type == nil ? threadList.threadTitle : [threadList.threadTitle substringFromIndex:type.length];
    
    self.threadType.text = type == nil ? @"【讨论】" : type;
    
    self.threadPostCount.text = [NSString stringWithFormat:@"%ld", threadList.threadTotalPostCount];
    
    NSMutableArray * users = [[_coreDateManager selectData:^NSPredicate *{
       return [NSPredicate predicateWithFormat:@"userID = %@", threadList.threadAuthorID];
    }] copy];
    
    if (users == nil || users.count == 0) {
        NSURL * url = [CCFUrlBuilder buildMemberURL:threadList.threadAuthorID];
        
        [_browser browseWithUrl:url :^(BOOL isSuccess, NSString* result) {
            
            NSString * regular = [NSString stringWithFormat:@"/avatar%@_(\\d+).gif", threadList.threadAuthorID];
            
            NSString * avatar = [result stringWithRegular:regular];
            
            [_coreDateManager insertOneData:^(id src) {
                
                CCFUserEntry * user =(CCFUserEntry *)src;
                
                user.userID = threadList.threadAuthorID;
                user.userAvatar = avatar;
            }];
            
            [self.avatarImage setImageWithURL:[CCFUrlBuilder buildAvatarURL:avatar]];
           
        }];

    } else{
        
        CCFUserEntry * user = users.firstObject;
        if (user.userAvatar == nil) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"jpg"];
            NSURL* url = [NSURL fileURLWithPath:path];

            [self.avatarImage setImageWithURL:url];
        } else{
            
            NSLog(@"+++++++++++++++++++++++++++++++++++++++++++%@", user.userAvatar);
            
            NSURL * url = [CCFUrlBuilder buildAvatarURL:user.userAvatar];
            
            [self.avatarImage setImageWithURL:url];
        }
        
    }
    
    
}
@end

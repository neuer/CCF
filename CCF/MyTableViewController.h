//
//  MyTableViewController.h
//  MyTableView
//
//  Created by 迪远 王 on 16/1/1.
//  Copyright © 2016年 andforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>     // for MFMailComposeViewControllerDelegate
#import "CCFFormHeaderView.h"    // for SectionHeaderViewDelegate

@interface MyTableViewController : UITableViewController<MFMailComposeViewControllerDelegate, SectionHeaderViewDelegate>

//@property (nonatomic) NSArray *plays;

@property (nonatomic, strong) NSMutableArray *plays;

@end

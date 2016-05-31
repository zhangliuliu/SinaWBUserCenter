//
//  BaseTableViewController.h
//  SinaWBUserCenter
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 zhangliuliu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen  mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static NSInteger const HEADER_IMAGE_HEIGHT    = 220;
static NSInteger const SECTION_CONTROL_HEIGHT = 44;
static NSInteger const NAVIGATION_BAR_HEIGHT   = 64;

@protocol BaseTableViewScrollDelegate <NSObject>

@required

-(void)tableViewDidScroll:(UITableView *)tableView;

-(void)tableViewWillBeginDragging:(UITableView *)tableView;

-(void)tableViewWillBeginDecelerating:(UITableView *)tableView;

-(void)tableViewDidEndDragging:(UITableView *)tableView;

-(void)tableViewDidEndDecelerating:(UITableView *)tableView;


@end

@interface BaseTableViewController : UITableViewController

@property (nonatomic,weak) id<BaseTableViewScrollDelegate> scrollDelegate;

@end

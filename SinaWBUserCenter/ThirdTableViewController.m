//
//  ThirdTableViewController.m
//  SinaWBUserCenter
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 zhangliuliu. All rights reserved.
//

#import "ThirdTableViewController.h"

@implementation ThirdTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
}

#pragma mark - TableView Data source
#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"xiangce";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"相册 %zd", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


@end

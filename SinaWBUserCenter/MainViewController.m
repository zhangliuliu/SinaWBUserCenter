//
//  MainViewController.m
//  SinaWBUserCenter
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 zhangliuliu. All rights reserved.
//

#import "MainViewController.h"
#import "UserCenterController.h"

@interface MainViewController ()

@property (nonatomic,strong) UIButton *btnCenter;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"代码牛";
    [self.view addSubview:self.btnCenter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - selector
#pragma mark -

-(void)toUserCenter:(id)sender{
    
    [self.navigationController pushViewController:[UserCenterController new] animated:YES];
}

#pragma mark - getter
#pragma mark -

-(UIButton *)btnCenter{
    if (!_btnCenter) {
        _btnCenter=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        _btnCenter.center=self.view.center;
        [_btnCenter setTitle:@"个人主页" forState:UIControlStateNormal];
        _btnCenter.titleLabel.font=[UIFont systemFontOfSize:16];
        [_btnCenter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnCenter addTarget:self action:@selector(toUserCenter:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnCenter;
}

@end

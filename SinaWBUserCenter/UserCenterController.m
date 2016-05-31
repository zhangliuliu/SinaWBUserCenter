//
//  UserCenterController.m
//  SinaWBUserCenter
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 zhangliuliu. All rights reserved.
//

#import "UserCenterController.h"
#import "UIImage+Util.h"
#import "CommonHeaderView.h"
#import <HMSegmentedControl.h>
#import "FirstTableViewController.h"
#import "SecondTableViewController.h"
#import "ThirdTableViewController.h"

#define HEADER_INIT_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_IMAGE_HEIGHT+SECTION_CONTROL_HEIGHT)

@interface UserCenterController ()<BaseTableViewScrollDelegate>

@property (nonatomic,strong) CommonHeaderView        *headerView;

@property (nonatomic,strong) NSMutableArray          *viewControllers;
@property (nonatomic,strong) BaseTableViewController *currentViewController;
@property (nonatomic,strong) NSArray                 *sectionTitles;
@property (nonatomic,strong) NSMutableDictionary     *cachedOffsetYDic;//用于存储每个tableview的偏移量
@property (nonatomic,assign) BOOL                    statusBarColorIsBlack;


@end

@implementation UserCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    self.sectionTitles = @[@"主页", @"微博", @"相册"];
    [self configViewControllers];
    [self configHeaderView];
    [self displayContentController:self.viewControllers[0]];
    [self.view addSubview:self.headerView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //navigationbar 背景为一张透明的image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    //该方法 设置navigationbar为无色，但前提是不能设置sel.title，否则navigationBar为系统默认颜色,因此采用了上面的那个方法
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarColorIsBlack? UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
}

#pragma mark - BaseTableViewScrollDelegate
#pragma mark -

-(void)tableViewDidScroll:(UITableView *)tableView{
    CGFloat offsetY=tableView.contentOffset.y;
    NSLog(@"scroll offsetY=%f",offsetY);
    
    if (offsetY<=HEADER_IMAGE_HEIGHT-NAVIGATION_BAR_HEIGHT) {
        //header 跟着tableview一起移动
        if (![_headerView.superview isEqual:tableView]) {
            for (UIView *view in tableView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [tableView insertSubview:_headerView belowSubview:view];
                    break;
                }
            }
        }
        
        CGFloat delta = 0.0f;
        CGRect rect = HEADER_INIT_FRAME;
        // Only allow the header to stretch if pulled down
        if (offsetY < 0.0f){
            //开始下拉
            delta = fabs(MIN(0.0f, tableView.contentOffset.y*1.3));
            rect.origin.y -= delta;
            rect.size.height += delta;
        }
        
        self.headerView.frame = rect;
        
    }else{
        //header image超出可见范围 section 吸附于navigationbar
        if (![self.headerView.superview isEqual:self.view]) {
            [self.view insertSubview:self.headerView aboveSubview:self.currentViewController.tableView];
        }
        CGRect rect=HEADER_INIT_FRAME;
        rect.origin.y=NAVIGATION_BAR_HEIGHT-HEADER_IMAGE_HEIGHT;
        self.headerView.frame=rect;
        
    }
    
    
    if (offsetY>0) {
        CGFloat alpha = offsetY/136;
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1.f alpha:alpha]] forBarMetrics:UIBarMetricsDefault];
        
        if (alpha > 0.75 && !_statusBarColorIsBlack) {
            
            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
            _statusBarColorIsBlack = YES;
            self.title=@"代码牛1号";
            [self setNeedsStatusBarAppearanceUpdate];
            
        } else if (alpha <= 0.75 && _statusBarColorIsBlack) {
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            _statusBarColorIsBlack = NO;
            self.title=nil;
            [self setNeedsStatusBarAppearanceUpdate];
        }
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1.f alpha:0]] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _statusBarColorIsBlack = NO;
        self.title=nil;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(void)tableViewWillBeginDragging:(UITableView *)tableView{
    //滑动过程中 header不允许点击
    self.headerView.userInteractionEnabled=NO;
}

-(void)tableViewWillBeginDecelerating:(UITableView *)tableView{
    self.headerView.userInteractionEnabled=NO;
}

-(void)tableViewDidEndDragging:(UITableView *)tableView{
    self.headerView.userInteractionEnabled=YES;
    
    CGFloat offsetY=tableView.contentOffset.y;
    NSString *currentKey=NSStringFromClass([self.currentViewController class]);
    if (offsetY<=HEADER_IMAGE_HEIGHT-NAVIGATION_BAR_HEIGHT) {
        //header 和tableview一起滑动 这时候 其他的tableview的offset要和当前显示的tableview的offset保持一致，因为如果不保持一致的话 这时候切换其他的tableview就会出现header抖动的情况，和之前的位置会发生偏移
        [self.cachedOffsetYDic enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            self.cachedOffsetYDic[key] = @(offsetY);
        }];
        
    } else {
        //这时候section 会固定住
        [self.cachedOffsetYDic enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([currentKey isEqualToString:key]) {
                self.cachedOffsetYDic[key]=@(offsetY);
            }else{
                //如果其他的tableview的offset 小于header image 的高度切换tableview的时候会发生抖动，所以在这里做控制
                if ([_cachedOffsetYDic[key] floatValue] <HEADER_IMAGE_HEIGHT-NAVIGATION_BAR_HEIGHT) {
                    _cachedOffsetYDic[key]=@(HEADER_IMAGE_HEIGHT-NAVIGATION_BAR_HEIGHT);
                }
            }
        }];
    }
}

-(void)tableViewDidEndDecelerating:(UITableView *)tableView{
    self.headerView.userInteractionEnabled=YES;
    
    CGFloat offsetY=tableView.contentOffset.y;
    NSString *currentKey=NSStringFromClass([self.currentViewController class]);
    if (offsetY<=HEADER_IMAGE_HEIGHT-NAVIGATION_BAR_HEIGHT) {
        
        [self.cachedOffsetYDic enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            self.cachedOffsetYDic[key] = @(offsetY);
        }];
        
    } else {
        
        [self.cachedOffsetYDic enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([currentKey isEqualToString:key]) {
                self.cachedOffsetYDic[key]=@(offsetY);
            }else{
                
                if ([_cachedOffsetYDic[key] floatValue] <HEADER_IMAGE_HEIGHT-NAVIGATION_BAR_HEIGHT) {
                    _cachedOffsetYDic[key]=@(HEADER_IMAGE_HEIGHT-NAVIGATION_BAR_HEIGHT);
                }
            }
        }];
    }
}

#pragma mark -private

-(void)configViewControllers{
    if (!self.viewControllers) {
        self.viewControllers=[NSMutableArray array];
    }
    
    FirstTableViewController *firstVc=[FirstTableViewController new];
    SecondTableViewController *secondVc=[SecondTableViewController new];
    ThirdTableViewController *thirdVc=[ThirdTableViewController new];
    firstVc.scrollDelegate=self;
    secondVc.scrollDelegate=self;
    thirdVc.scrollDelegate=self;
    [self.viewControllers addObject:firstVc];
    [self.viewControllers addObject:secondVc];
    [self.viewControllers addObject:thirdVc];
}

-(void)configHeaderView{
    
    self.headerView=[[CommonHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HEADER_IMAGE_HEIGHT+SECTION_CONTROL_HEIGHT) sectionTitles:self.sectionTitles];
    __weak UserCenterController *weakSelf = self;
    [self.headerView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        
        NSLog(@"segmentedControlChangedValue index=%ld",index);
        [weakSelf hideContentController:weakSelf.currentViewController];
        [weakSelf displayContentController:weakSelf.viewControllers[index]];
        
        NSString *key=NSStringFromClass([weakSelf.currentViewController class]);
        CGFloat offsetY=[weakSelf.cachedOffsetYDic[key] floatValue];
        weakSelf.currentViewController.tableView.contentOffset=CGPointMake(0, offsetY);
        
        if (offsetY<=HEADER_IMAGE_HEIGHT-NAVIGATION_BAR_HEIGHT) {
            [weakSelf.currentViewController.view addSubview:weakSelf.headerView];
            for (UIView *view in weakSelf.view.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [weakSelf.view insertSubview:weakSelf.headerView belowSubview:view];
                    break;
                }
            }
            CGRect rect=weakSelf.headerView.frame;;
            rect.origin.y=0;
            weakSelf.headerView.frame=rect;
        }else{
            
            [weakSelf.view insertSubview:weakSelf.headerView aboveSubview:weakSelf.currentViewController.tableView];
            CGRect rect=weakSelf.headerView.frame;
            rect.origin.y=NAVIGATION_BAR_HEIGHT-HEADER_IMAGE_HEIGHT;
            weakSelf.headerView.frame=rect;
            
        }
        
    }];
    
}

- (void) displayContentController: (BaseTableViewController*) content {
    [self addChildViewController:content];
    
    content.view.frame=CGRectMake(0, 0,
                                  CGRectGetWidth(self.view.bounds),
                                  CGRectGetHeight(self.view.bounds));
    
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
    self.currentViewController=content;
}

- (void) hideContentController: (BaseTableViewController*) content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

#pragma mark - getter
#pragma mark -

-(NSMutableDictionary *)cachedOffsetYDic{
    
    if (!_cachedOffsetYDic) {
        _cachedOffsetYDic=[NSMutableDictionary dictionary];
        
        for (BaseTableViewController *vc in self.viewControllers) {
            NSString *key=NSStringFromClass([vc class]);
            _cachedOffsetYDic[key]=@(0);
        }
    }
    
    return _cachedOffsetYDic;
}

@end

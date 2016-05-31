//
//  CommonHeaderView.h
//  SinaWBUserCenter
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 zhangliuliu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMSegmentedControl;

@interface CommonHeaderView : UIView

@property (nonatomic,strong,readonly) HMSegmentedControl *segmentControl;

-(instancetype)initWithFrame:(CGRect)frame sectionTitles:(NSArray*)titles;

@end

//
//  CommonHeaderView.m
//  SinaWBUserCenter
//
//  Created by zhang on 16/5/31.
//  Copyright © 2016年 zhangliuliu. All rights reserved.
//

#import "CommonHeaderView.h"
#import <HMSegmentedControl.h>
#import "Masonry.h"
#import "UIColor+expanded.h"

@interface CommonHeaderView (){
    NSArray *_titles;
}

@property (nonatomic,strong) HMSegmentedControl *segmentControl;
@property (nonatomic,strong) UILabel            *nameL;
@property (nonatomic,strong) UIImageView        *cover;

@end

@implementation CommonHeaderView

-(instancetype)initWithFrame:(CGRect)frame sectionTitles:(NSArray *)titles{
    
    self=[super initWithFrame:frame];
    if (self) {
        _titles=titles;
        [self addSubview:self.cover];
        [self addSubview:self.segmentControl];
        [self addSubview:self.nameL];
        
        [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(44);
            make.right.equalTo(self).offset(-44);
            make.height.equalTo(@(44));
        }];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.segmentControl.mas_top).offset(-44);
            make.left.right.equalTo(self);
        }];
        [self.cover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(self.segmentControl.mas_top);
        }];
        
    }
    
    return self;
    
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

#pragma mark - selector
#pragma mark -
- (void)segmentedControlChangedValue:(HMSegmentedControl*)sender {
    NSLog(@"segmentedControlChangedValue index=%ld",sender.selectedSegmentIndex);
}

#pragma mark - getter
#pragma mark -

-(HMSegmentedControl *)segmentControl{
    
    if (!_segmentControl) {
        _segmentControl=[[HMSegmentedControl alloc] initWithSectionTitles:_titles];
        _segmentControl.backgroundColor=[UIColor colorWithHexString:@"0xF2F2F2"];
        self.backgroundColor=_segmentControl.backgroundColor;
        _segmentControl.selectionIndicatorColor=[UIColor colorWithHexString:@"0xEF7307"];
        _segmentControl.selectionIndicatorHeight=2.f;
        _segmentControl.selectionStyle=HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentControl.selectionIndicatorLocation=HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"0x6A6A6A"], NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"0xEF7307"]};
        //[_segmentControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segmentControl;
}

-(UIImageView *)cover{
    
    if (!_cover) {
        _cover=({
            UIImageView *imageView=[UIImageView new];
            imageView.contentMode=UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds=YES;
            imageView.image=[UIImage imageNamed:@"cover"];
            imageView;
        });
    }
    
    return _cover;
}

-(UILabel *)nameL{
    if (!_nameL) {
        _nameL=({
            UILabel *label=[UILabel new];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:18];
            label.textColor=[UIColor whiteColor];
            label.text=@"代码牛1号";
            label;
        });
    }
    
    return _nameL;
}

@end

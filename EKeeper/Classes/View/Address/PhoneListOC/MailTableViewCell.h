//
//  MailTableViewCell.h
//  BusinessEnterprise
//
//  Created by HG on 16/10/15.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^MenuButtonBlock)(id sender);

@interface MailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headImageView;   //头像
@property (nonatomic, strong) UILabel *nameLabel;           //名字
@property (nonatomic, strong) UILabel *titleLabel;          //头衔
@property (nonatomic, strong) UIImageView *lineImageView;   //下划线

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *bnamelabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UIView *selectedView;

//滑动事件
@property (nonatomic, assign) float startX;
@property (nonatomic, assign) float cellX;

@property (nonatomic, copy) MenuButtonBlock block;


- (void)initCellFrame:(float)x;

@end

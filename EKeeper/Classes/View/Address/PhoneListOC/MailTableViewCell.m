//
//  MailTableViewCell.m
//  BusinessEnterprise
//
//  Created by HG on 16/10/15.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "MailTableViewCell.h"
#import "MailListTableView.h"


@class MailListTableView;

@implementation MailTableViewCell
@synthesize startX;
@synthesize cellX;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createBottomView];
        [self createBGView];
        [self addEvent];
    }
    return self;
}

-(void)addEvent
{
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPanGes:)];
    panGes.delegate = self;
    panGes.delaysTouchesBegan = YES;
    panGes.cancelsTouchesInView = NO;
    [self addGestureRecognizer:panGes];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGes:)];
    tapGes.delegate = self;
    tapGes.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGes];
    
}

-(void)createBGView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
    [_bgView setBackgroundColor:[UIColor colorWithRed:253/255.0 green:253/255.0 blue:254/255.0 alpha:1]];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 35, 35)];
    _headImageView.image = [UIImage imageNamed:@"head_default"];
    [_headImageView setContentMode:UIViewContentModeScaleAspectFit];
    [_bgView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.frame.origin.x + _headImageView.frame.size.width + 8, _headImageView.frame.origin.y + 4, _bgView.frame.size.width - _headImageView.frame.origin.x - _headImageView.frame.size.width - 20 , 15)];
    _nameLabel.font = HGFont(14);
    _nameLabel.text = @"啦啦";
    _nameLabel.textColor = [UIColor colorWithRed:96/255.0 green:99/255.0 blue:102/255.0 alpha:1];
    [_bgView addSubview:_nameLabel];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 3, _nameLabel.frame.size.width, 14)];
    _titleLabel.font = HGFont(11);
    _titleLabel.textColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1];
    _titleLabel.text = @"杭州遗忘科技 技术总监";
    [_bgView addSubview:_titleLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, _bgView.frame.size.height - .5, _bgView.frame.size.width - 5, .5)];
    [lineImageView setBackgroundColor:HGRGBCOLOR(238, 238, 238)];
    [_bgView addSubview:lineImageView];
    
    [self addSubview:_bgView];
}

-(void)createBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
    [_bottomView setBackgroundColor:HGRGBCOLOR(231, 96, 73)];
    [self addSubview:_bottomView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, _bottomView.frame.size.height)];
    [lineImageView setBackgroundColor:HGRGBCOLOR(210, 199, 7)];
    [_bottomView addSubview:lineImageView];
    
    
    _bnamelabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 100, 14)];
    _bnamelabel.text = @"马云";
    _bnamelabel.textColor = [UIColor whiteColor];
    _bnamelabel.font = HGFont(13);
    [_bottomView addSubview:_bnamelabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bnamelabel.frame.origin.x, _bnamelabel.frame.origin.y + _bnamelabel.frame.size.height + 3, 100, 14)];
    _phoneLabel.text = @"13838137991";
    _phoneLabel.textColor = [UIColor whiteColor];
    _phoneLabel.font = HGFont(11);
    [_bottomView addSubview:_phoneLabel];
    
    NSArray *imageNameArr = [NSArray arrayWithObjects:@"b_top",@"b_edit",@"b_msg",@"b_phone", nil];
    
    for (int i = 0; i < 4; i++) {
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        menuBtn.tag = i + 10;
        [menuBtn setFrame:CGRectMake(kScreenWidth - 15 - 47 * (i + 1), 0, 47, 47)];
        [menuBtn setImage:[UIImage imageNamed:imageNameArr[3-i]] forState:UIControlStateNormal];
        [_bottomView addSubview:menuBtn];
        
        if (i == 0) {
            continue;
        }
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(menuBtn.frame.origin.x + menuBtn.frame.size.width , 0, .5, menuBtn.frame.size.height)];
        [lineImageView setBackgroundColor:HGRGBCOLOR(234, 117, 97)];
        [_bottomView addSubview:lineImageView];
        
    }
}


- (void)initCellFrame:(float)x{
    CGRect frame = _bgView.frame;
    frame.origin.x = x;
    
    MailListTableView *tablView = [self myTableView];
    if (x == -kScreenWidth) {
        tablView.isMove = YES;
    }else
    {
        tablView.isMove = NO;
    }
    
    _bgView.frame = frame;
}

#pragma mark - method
-(void)cellPanGes:(UIPanGestureRecognizer *)panGes{
    if ([self myTableView].isMove) {
        [self backToStart];
        panGes.cancelsTouchesInView = YES;
        return;
    }
    
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    CGPoint pointer = [panGes locationInView:self.contentView];
    if (panGes.state == UIGestureRecognizerStateBegan) {
        startX = pointer.x;
        cellX = self.bgView.frame.origin.x;
    }else if (panGes.state == UIGestureRecognizerStateChanged){
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        [self cellReset:pointer.x - startX];
        return;
    }else if (panGes.state == UIGestureRecognizerStateCancelled){
        [self cellReset:pointer.x - startX];
        return;
    }
    
    if (cellX + pointer.x - startX <= 0) {
        
    }
    
    [self cellViewMoveToX:cellX + pointer.x - startX];
}

-(void)cellReset:(float)moveX{
    if (cellX <= -kScreenWidth) {
        if (moveX <= 0) {
            return;
        }else if(moveX > 20){
            [UIView animateWithDuration:0.2 animations:^{
                [self initCellFrame:0];
            } completion:^(BOOL finished) {
            }];
        }else if (moveX <= 20){
            [UIView animateWithDuration:0.2 animations:^{
                [self initCellFrame:-kScreenWidth];
            } completion:^(BOOL finished) {
            }];
        }
    }else{
        if (moveX >= 0) {
            [self initCellFrame:0];
            return;
        }else if(moveX < -20){
            NSLog(@"< -20");
            [UIView animateWithDuration:0.2 animations:^{
                [self initCellFrame:-kScreenWidth];
            } completion:^(BOOL finished) {
            }];
        }else if (moveX >= -20){
            NSLog(@">= -20");
            [UIView animateWithDuration:0.2 animations:^{
                [self initCellFrame:0];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

-(void)cellViewMoveToX:(float)x{
    if (x <= -(kScreenWidth+20)) {
        x = -(kScreenWidth+20);
    }else if (x >= 0 && _bgView.frame.origin.x == 0)
    {
        return;
    }
    else if (x >= 50){
        x = 50;
    }
    _bgView.frame = CGRectMake(x, 0, kScreenWidth, 47);
    if (x == -(kScreenWidth+20)) {
        [UIView animateWithDuration:0.2 animations:^{
            [self initCellFrame:-kScreenWidth];
        } completion:^(BOOL finished) {
        }];
    }
    if (x == 50) {
        [UIView animateWithDuration:0.2 animations:^{
            [self initCellFrame:0];
        } completion:^(BOOL finished) {
//            self.menuViewHidden = YES;
//            [self.menuActionDelegate tableMenuDidHideInCell:self];
        }];
    }
}

-(void)cellTapGes:(UITapGestureRecognizer *)ges
{
    [self backToStart];
}

//还原
-(void)backToStart
{
    for (MailTableViewCell *cell in [(MailListTableView *)[self superview] subviews]) {
        if (cell.bgView.frame.origin.x < 0 ) {
            [UIView animateWithDuration:.2 animations:^{
                [cell initCellFrame:0];
            }];
            break;
        }
    }
}

//获取tableview
- (MailListTableView *)myTableView{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[MailListTableView class]]) {
            return (MailListTableView*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        MailListTableView *tablView = [self myTableView];
        return tablView.isMove;
    }
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        if ([self myTableView].isMove) {
            return YES;
        }
        if (fabs(translation.x) > fabs(translation.y) && translation.x < 0) {
            return YES;
        }
        return NO;
    }
    return YES;
}


#pragma mark - button event
-(void)menuBtnClick:(id)sender
{
    if (self.block) {
        self.block(sender);
    }
}

-(void)setBlock:(MenuButtonBlock)block
{
    _block = block;
}

@end

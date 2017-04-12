//
//  MailListTableView.m
//  BusinessEnterprise
//
//  Created by HG on 16/10/15.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "MailListTableView.h"
//#import "ContactModel.h"
//#import "ComPhoneModel.h"
//#import "YYModel.h"

@implementation MailListTableView
{
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    [self getList:dataArr];
}


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withData:(NSMutableArray *)dataList
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self setBackgroundColor:[UIColor clearColor]];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self getList:dataList];
    }
    return self;
}

#pragma mark - method
-(void)getList:(NSMutableArray *)dataList
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }else
    {
        if (_dataArr.count > 0) {
            [_dataArr removeAllObjects];
        }
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray *comList = [def objectForKey:@"comList"];
    NSArray *localList = [def objectForKey:@"localList"];
    
    
    
    for (id model in dataList) {
        
        
    }
    [self reloadSectionRows];
    [self reloadData];
}


-(void)reloadSectionRows
{
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:_rowArr.count];
    return _rowArr.count;
}

//返回section列
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_rowArr[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    
    UIView *bgView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    UILabel *label = (UILabel *)[bgView viewWithTag:1];
    if (!bgView) {
        bgView = [[UIView alloc] init];
//        [bgView setBackgroundColor:HGRGBCOLOR(247, 249, 248)];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 22)];
        [label setTag:1];
        [label setFont:[UIFont systemFontOfSize:12.5f]];
//        [label setTextColor:HGRGBCOLOR(85, 85, 85)];
//        [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
        [bgView addSubview:label];
    }
    NSMutableAttributedString *attribute;
    long count = [_rowArr[section] count];
    if ([_sectionArr[section] isEqualToString:@"♡"]) {
        attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"置顶联系人 %lu",count]];
        
        [attribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Light" size:9] range:NSMakeRange(6, attribute.string.length - 6)];
    }else
    {
        attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %lu",_sectionArr[section],count]];
        
        [attribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Light" size:9] range:NSMakeRange(2, attribute.string.length - 2)];
    }
    [label setAttributedText:attribute];
    return bgView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[MailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//        cell.backgroundColor = HGRandomColor;
        
        __weak __typeof(&*self)ws = self;
        
        cell.block = ^(id sender){
            
            NSInteger tag = [(UIButton *)sender tag] - 10;
            NSString *msg = @"";
            if (tag == 0) {
                msg = @"拨打";
            }else if (tag == 1) {
                msg = @"短信";
            }else if (tag == 2) {
                msg = @"编辑";
            }else if (tag == 3) {
                msg = @"置顶";
            }
            
            MailTableViewCell *cell = (MailTableViewCell *)[[sender superview] superview];
            NSIndexPath *indexPath = [ws indexPathForCell:cell];
            UserPhoneModel *model=_rowArr[indexPath.section][indexPath.row];
                [UIView animateWithDuration:.2 animations:^{
                    [cell initCellFrame:0];
                } completion:^(BOOL finished) {
                    
                    if (tag == 0) {
                        //拨打
                        NSString *moblie = model.mobile;
                        moblie = [[moblie componentsSeparatedByString:ARRAY_CLIP] objectAtIndex:0];
                        if ([moblie componentsSeparatedByString:SUB_ARRAY_CLIP].count > 1) {
                            moblie = [[moblie componentsSeparatedByString:SUB_ARRAY_CLIP] objectAtIndex:1];
                        }
                        
                        NSString * str=[[NSString alloc] initWithFormat:@"telprompt://%@",moblie];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                    }else if(tag == 1)
                    {//短信
                    }else if(tag == 2){
                        //编辑
                    }else if (tag == 3) {
                        //置顶
                        CGRect rect = cell.bgView.frame;
                        rect.origin.x = 0;
                        
                        model.isTop = [NSNumber numberWithBool:![model.isTop boolValue]];
                        [ws reloadSectionRows];
                        [ws reloadData];
                        
                        if (!_isLocal) {
                            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                            NSArray *list = [def objectForKey:@"comList"];
                            NSMutableArray *topList;
                            if (list) {
                                topList = [NSMutableArray arrayWithArray:list];
                            }else
                            {
                                topList = [NSMutableArray array];
                            }
                            
                            if ([model.isTop boolValue]) {
                                [topList addObject:model.tbid];
                            }else
                            {
                                [topList removeObject:model.tbid];
                            }
                            
                            [def setObject:topList forKey:@"comList"];
                            [def synchronize];
                        }else
                        {
                            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                            NSArray *list = [def objectForKey:@"localList"];
                            NSMutableArray *topList;
                            if (list) {
                                topList = [NSMutableArray arrayWithArray:list];
                            }else
                            {
                                topList = [NSMutableArray array];
                            }
                            
                            if ([model.isTop boolValue]) {
                                [topList addObject:model.tbid];
                            }else
                            {
                                [topList removeObject:model.tbid];
                            }
                            
                            [def setObject:topList forKey:@"localList"];
                            [def synchronize];
                        }
                    }
                }];
            };
        };
    
    UserPhoneModel *model=_rowArr[indexPath.section][indexPath.row];
    [cell.nameLabel setText:model.name];
    if ([model.head isKindOfClass:[NSString class]]) {
//        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"head_default"]];
        cell.headImageView.backgroundColor =HGRandomColor;
    }else
    {
        if (model.head != nil) {
            [cell.headImageView setImage:[UIImage imageWithData:model.head]];
        }else
        {
//            [cell.headImageView setImage:[UIImage imageNamed:@"head_default"]];
            cell.headImageView.backgroundColor =HGRandomColor;

        }
    }
    
    cell.bnamelabel.text = model.name;
    NSString *moblie = model.mobile;
    moblie = [[moblie componentsSeparatedByString:ARRAY_CLIP] objectAtIndex:0];
    if ([moblie componentsSeparatedByString:SUB_ARRAY_CLIP].count > 1) {
      moblie = [[moblie componentsSeparatedByString:SUB_ARRAY_CLIP] objectAtIndex:1];
    }
    cell.phoneLabel.text = moblie;
    cell.titleLabel.text = moblie;
    
    UIButton *topBtn = [cell viewWithTag:13];
    if ([model.isTop boolValue]) {
        [topBtn setImage:[UIImage imageNamed:@"b_top_cancel"] forState:UIControlStateNormal];
    }else
    {
        [topBtn setImage:[UIImage imageNamed:@"b_top"] forState:UIControlStateNormal];
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _sectionArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
}




@end

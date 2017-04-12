//
//  MailListTableView.h
//  BusinessEnterprise
//
//  Created by HG on 16/10/15.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailTableViewCell.h"
//#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
#import "UITableView+EmptyData.h"

@interface MailListTableView : UITableView<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic,strong) NSArray *serverDataArr;//数据源
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic) BOOL isLocal;
@property (nonatomic) BOOL isMove;
@property (nonatomic, weak) id vc;


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withData:(NSMutableArray *)dataList;

@end

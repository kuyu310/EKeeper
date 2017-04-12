//
//  UITableView+EmptyData.h
//  BusinessEnterprise
//
//  Created by HG on 16/10/20.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)

- (void)tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end

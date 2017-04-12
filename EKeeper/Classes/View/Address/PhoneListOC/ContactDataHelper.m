//
//  ContactDataHelper.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "ContactDataHelper.h"
//#import "ContactModel.h"//model



@implementation ContactDataHelper

+ (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//排序
        int i;
        NSString *strA = ((UserPhoneModel *)obj1).namepy;
        NSString *strB = ((UserPhoneModel *)obj2).namepy;
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;//上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;//下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    NSMutableArray *cares = [[NSMutableArray alloc] init];
    
    
    for (UserPhoneModel *user in serializeArray) {
        char c = [user.namepy characterAtIndex:0];
        if ([user.isTop boolValue]) {
            [cares addObject:user];
        }
        else if (!isalpha(c)) {
            [oth addObject:user];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:user];
        }
        else {
            [data addObject:user];
        }
    }
    //先添加特别关注
    if (cares.count > 0) {
        if (ans.count > 0) {
            [ans insertObject:cares atIndex:0];
        }
    }
    //英文字母
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    //其他字符
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    return ans;
}

+ (NSMutableArray *)getFriendListSectionBy:(NSMutableArray *)array{
    NSMutableArray *section = [[NSMutableArray alloc] init];
    for (NSArray *item in array) {
        UserPhoneModel *user = [item objectAtIndex:0];
        if ([user.isTop boolValue]) {
            [section addObject:@"♡"];
            continue;
        }
        char c = [user.namepy characterAtIndex:0];
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}

@end

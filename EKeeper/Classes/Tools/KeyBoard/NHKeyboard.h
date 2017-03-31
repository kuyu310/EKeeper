//
//  NHKeyboard.h
//  NHKeyboardPro
//
//  Created by hu jiaju on 16/3/15.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    NHKBTypeNumberPad = 1 << 0,
    NHKBTypeDecimalPad = 1 << 1,
    NHKBTypeASCIICapable = 1 << 2
}NHKBType;

/*!
 *  @brief Dependency:Masonry framework
 */

@interface NHKeyboard : UIView

/*!
 *  @brief create safe keyboard
 *
 *  @param type kb's type
 *
 *  @return the kb's instance
 */
+ (nonnull instancetype)keyboardWithType:(NHKBType)type;

/*!
 *  @brief kb's icon logo to show user
 */
@property (nullable, nonatomic, copy) NSString *icon;

/*!
 *  @brief kb's title to show user
 */
@property (nonatomic, nullable, copy) NSString *enterprise;

/*!
 *  @brief such as UITextField,UITextView,UISearchBar
 */
@property (nonatomic, nullable, strong) UIView *inputSource;

@end

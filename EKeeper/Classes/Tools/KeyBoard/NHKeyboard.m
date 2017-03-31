//
//  NHKeyboard.m
//  NHKeyboardPro
//
//  Created by hu jiaju on 16/3/15.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHKeyboard.h"

enum {
    NHKBImageLeft = 0,
    NHKBImageInner,
    NHKBImageRight,
    NHKBImageMax
};

@interface UIImage (PBHelper)

+ (nullable UIImage *)pb_imageFromColor:(nullable UIColor *)color;

- (nullable UIImage *)pb_drawRectWithRoundCorner:(CGFloat)radius toSize:(CGSize)size;

@end

@interface NHChar : UIButton

- (void)shift:(BOOL)shift;

- (void)updateChar:(nullable NSString *)chars;

- (void)updateChar:(nullable NSString *)chars shift:(BOOL)shift;

- (void)addPopup;

@end

#define NHKBH                           216
#define NHICONH                         35
#define NHCHAR_CORNER                   8
#define NHKBFontSize                    18
#define NHKBFont(s)                        [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
#define NHFormat(format, ...)           [NSString stringWithFormat:format, ##__VA_ARGS__]
#ifndef NHSCREEN_WIDTH
#define NHSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif

@interface NHKeyboard ()

@property (nonatomic, assign) NHKBType type;
@property (nonatomic, assign) BOOL shiftEnable,showSymbol,showMoreSymbol;
@property (nonatomic, strong) NSMutableArray *charsBtn;

@property (nonatomic, strong) UIButton *shiftBtn,*charSymSwitch;

@property (nonatomic, strong) UIImageView *iconFlag;
@property (nonatomic, strong) UILabel *iconLabel;

@end

static UIColor *NHColor(int r, int g, int b) {
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f];
}

@implementation NHKeyboard

+ (nullable)keyboardWithType:(NHKBType)type {
    return [[NHKeyboard alloc] initWithFrame:CGRectMake(0, 0, NHSCREEN_WIDTH, NHKBH+NHICONH) withType:type];
}

- (id)initWithFrame:(CGRect)frame withType:(NHKBType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self _initSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.type = NHKBTypeNumberPad;
        [self _initSetup];
    }
    return self;
}

- (CGFloat)widthForInfo:(NSString *)info {
    if (info.length == 0) {
        return 0;
    }
    NSDictionary *attributs = [NSDictionary dictionaryWithObjectsAndKeys:NHKBFont(NHKBFontSize-5), NSFontAttributeName, nil];
    return [info sizeWithAttributes:attributs].width;
}

- (void)setIcon:(NSString *)icon {
    _icon = [icon copy];
    UIImage *image = [UIImage imageNamed:self.icon];
    self.iconFlag.image = image;
}

- (void)setEnterprise:(NSString *)enterprise {
    if (enterprise.length > 0) {
        _enterprise = [enterprise copy];
        CGFloat iconH = NHICONH;
        CGFloat icon_w_h = iconH*0.5;
        CGFloat width = [self widthForInfo:enterprise];
        CGFloat wwww = icon_w_h*1.5+width;
        CGFloat start_x = (NHSCREEN_WIDTH-wwww)*0.5+icon_w_h*1.5;
        CGRect bounds = CGRectMake(start_x, NHICONH*0.25, width, NHICONH*0.5);
        self.iconLabel.frame = bounds;
        self.iconLabel.text = enterprise;
        
        bounds.origin.x -= icon_w_h*1.5;
        bounds.size = CGSizeMake(icon_w_h, icon_w_h);
        self.iconFlag.frame = bounds;
    }
}

- (UILabel *)iconLabel {
    if (!_iconLabel) {
        _iconLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _iconLabel.backgroundColor = [UIColor clearColor];
        _iconLabel.font = NHKBFont(NHKBFontSize-5);
        _iconLabel.textColor = NHColor(174, 174, 174);
        _iconLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_iconLabel];
    }
    return _iconLabel;
}

- (UIImageView *)iconFlag {
    if (!_iconFlag) {
        UIImage *image = [UIImage imageNamed:self.icon];
        _iconFlag = [[UIImageView alloc] initWithImage:image];
        _iconFlag.contentMode = UIViewContentModeScaleAspectFit;
        _iconFlag.layer.cornerRadius = NHICONH*0.25;
        _iconFlag.layer.masksToBounds = true;
        [_iconFlag sizeToFit];
        [self addSubview:_iconFlag];
    }
    return _iconFlag;
}

- (void)_initSetup {
    //默认信息
    self.icon = @"58";
    self.enterprise = @"安全输入";
    CGFloat iconH = NHICONH;
    CGFloat kbH = NHKBH;
    UIColor *bgColor = NHColor(124, 124,124);
    CGRect bounds = self.bounds;
    bounds.size.height = kbH+iconH;
    self.bounds = bounds;
    self.backgroundColor = bgColor;
    //seperate line
    CGFloat lineH = 1;
    bounds = CGRectMake(0, NHICONH-lineH, NHSCREEN_WIDTH,lineH);
    UIView *line = [[UIView alloc] initWithFrame:bounds];
    line.backgroundColor = NHColor(101, 101, 101);
    [self addSubview:line];
    
    //创建键盘
    if (NHKBTypeNumberPad == self.type) {
        [self reloadNumberPad:false];
    }else if (NHKBTypeDecimalPad == self.type){
        [self reloadNumberPad:true];
    }else if (NHKBTypeASCIICapable == self.type){
        [self setupASCIICapableLayout:true];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    //NSLog(@"%s--%@",__FUNCTION__,newSuperview);
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    //NSLog(@"%s--%@",__FUNCTION__,newWindow);
    if (!newWindow && self.type != NHKBTypeASCIICapable) {
        [self loadRandomNumber];
    }
}

#pragma mark -- 数字键盘 --

- (void)reloadNumberPad:(BOOL)decimal {
    if (self.type != NHKBTypeASCIICapable) {
        
        int cols = 3;
        int rows = 4;
        UIColor *lineColor = NHColor(101, 101, 101);
        UIColor *titleColor = NHColor(247, 247, 247);
        UIColor *touchColor = NHColor(250, 250, 250);
        UIFont *titleFont = NHKBFont(NHKBFontSize);
        CGFloat itemH = NHKBH/rows;
        CGFloat itemW = NHSCREEN_WIDTH/cols;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                CGRect bounds = CGRectMake(j*itemW, i*itemH+NHICONH, itemW, itemH);
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setHighlighted:true];
                btn.exclusiveTouch = true;
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = lineColor.CGColor;
                btn.frame = bounds;
                btn.titleLabel.font = titleFont;
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.textColor = titleColor;
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
                [btn setTitleColor:touchColor forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
                [btn addTarget:self action:@selector(touchCancelAction:) forControlEvents:UIControlEventTouchDragOutside];
                SEL selector;
                
                if (i*(rows-1)+j == (rows*cols-2-1)) {
                    selector = decimal?@selector(numberOrDecimalAction:):@selector(doneAction:);
                }else if (i*(rows-1)+j == (rows*cols-1)){
                    selector = @selector(deleteAction:);
                }else if (i*(rows-1)+j == (rows*cols-1-1)){
                    selector = @selector(numberOrDecimalAction:);
                }else{
                    selector = @selector(numberOrDecimalAction:);
                }
                NSInteger tag = i*(rows-1)+j;
                [btn setTag:tag];
                [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                
            }
        }
        
        [self loadRandomNumber];
    }
}

- (void)loadRandomNumber {
    BOOL decimal = (self.type == NHKBTypeDecimalPad);
    NSArray *titles = [self generateRandomNumberWithDecimal:decimal];
    NSArray *subviews = self.subviews;
    [subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *tmp = (UIButton *)obj;
            NSInteger __tag = tmp.tag;
            NSString *title ;
            if (__tag == 9) {
                title = decimal?[titles objectAtIndex:__tag]:@"确认";
            }else if (__tag == 10) {
                title = [titles lastObject];
            }else if (__tag == 11){
                title = @"删除";
            }else {
                title = [titles objectAtIndex:__tag];
            }
            [tmp setTitle:title forState:UIControlStateNormal];
        }
    }];
}

#pragma mark -- 数字键盘 Action --

- (void)touchDownAction:(UIButton *)btn {
    UIColor *touchColor = NHColor(43, 116, 224);
    [btn setBackgroundColor:touchColor];
}

- (void)touchCancelAction:(UIButton *)btn {
    [btn setBackgroundColor:[UIColor clearColor]];
}

- (void)doneAction:(UIButton *)btn {
    [btn setBackgroundColor:[UIColor clearColor]];
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate textFieldShouldEndEditing:tmp];
                [tmp endEditing:ret];
            }else{
                [tmp resignFirstResponder];
            }
            
        }else if ([self.inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate textViewShouldEndEditing:tmp];
                [tmp endEditing:ret];
            }else{
                [tmp resignFirstResponder];
            }
            
        }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate searchBarShouldEndEditing:tmp];
                [tmp endEditing:ret];
            }else{
                [tmp resignFirstResponder];
            }
        }
    }
}

- (void)deleteAction:(UIButton *)btn {
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            [tmp deleteBackward];
//            NSString *tmpInfo = tmp.text;
//            if (tmpInfo.length > 0) {
//                if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
//                    NSRange range = NSMakeRange(tmpInfo.length-1, 1);
//                    BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:tmpInfo];
//                    if (ret) {
//                        [tmp deleteBackward];
//                    }
//                }else{
//                    [tmp deleteBackward];
//                }
//            }
            
        }else if ([self.inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)self.inputSource;
            [tmp deleteBackward];
        }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString *info = [NSMutableString stringWithString:tmp.text];
            if (info.length > 0) {
                NSString *s = [info substringToIndex:info.length-1];
                [tmp setText:s];
            }
        }
    }
    [btn setBackgroundColor:[UIColor clearColor]];
}

- (void)numberOrDecimalAction:(UIButton *)btn {
    NSString *title = [btn titleLabel].text;
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:title];
                if (ret) {
                    [tmp insertText:title];
                }
            }else{
                [tmp insertText:title];
            }
            
        }else if ([self.inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate textView:tmp shouldChangeTextInRange:range replacementText:title];
                if (ret) {
                    [tmp insertText:title];
                }
            }else{
                [tmp insertText:title];
            }
            
        }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString *info = [NSMutableString stringWithString:tmp.text];
            [info appendString:title];
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate searchBar:tmp shouldChangeTextInRange:range replacementText:title];
                if (ret) {
                    [tmp setText:[info copy]];
                }
            }else{
                [tmp setText:[info copy]];
            }
        }
    }
    [btn setBackgroundColor:[UIColor clearColor]];
}

- (void)change2System {
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            tmp.inputView = nil;
            [tmp reloadInputViews];
        }else if ([self.inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)self.inputSource;
            tmp.inputView = nil;
            [tmp reloadInputViews];
        }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            tmp.inputViewController.inputView = nil;
            [tmp reloadInputViews];
        }
    }
}

- (void)change2Custom {
    if (self.inputSource) {
        
    }
}

// 选择一个n以下的随机整数
// 计算m, 2的幂略高于n, 然后采用 random() 模数m,
// 如果在n和m之间就扔掉随机数
// (更多单纯的方法, 比如采用random()模数n, 介绍一个偏置)
// 倾向范围内较小的数字
static int random_below(int n) {
    int m = 1;
    //计算比n更大的两个最小的幂
    do {
        m <<= 1;
    } while(m < n);

    int ret;
    do {
        ret = random() % m;
    } while(ret >= n);
    return ret;
}

static inline int random_int(int low, int high) {
    return (arc4random() % (high-low+1)) + low;
}

- (NSArray *)generateRandomNumberWithDecimal:(BOOL)decimal {
    NSMutableArray *tmp = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *c = NHFormat(@"%d",i);
        [tmp addObject:c];
    }
    if (decimal) {
        [tmp addObject:@"."];
    }
    int len = (int)[tmp count];
    int max = random_below(len);
    NSLog(@"max :%d",max);
    for (int i = 0; i < max; i++) {
        int t = random_int(0, len-1);
        int index = (t+max)%len;
        [tmp exchangeObjectAtIndex:t withObjectAtIndex:index];
    }
    return [tmp copy];
}

#pragma mark -- 密码键盘 --

#define Characters @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"]
#define Symbols  @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"-",@"/",@":",@";",@"(",@")",@"$",@"&",@"@",@"\"",@".",@",",@"?",@"!",@"'"]
#define moreSymbols  @[@"[",@"]",@"{",@"}",@"#",@"%",@"^",@"*",@"+",@"=",@"_",@"\\",@"|",@"~",@"<",@">",@"€",@"£",@"¥",@"•",@".",@",",@"?",@"!",@"'"]
//布局键盘
- (void)setupASCIICapableLayout:(BOOL)init {
    
    if (!init) {
        //不是初始化创建 重新布局字母或字符界面
        NSArray *subviews = self.subviews;
        [subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NHChar class]]) {
                [obj removeFromSuperview];
            }
        }];
    }
    if (_charsBtn || _charsBtn.count) {
        [_charsBtn removeAllObjects];
        _charsBtn = nil;
    }
    _charsBtn = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *charSets ;NSArray *rangs;
    if (!self.showSymbol) {
        charSets = Characters;
        rangs = @[@10,@19,@26];
    }else{
        charSets = self.showMoreSymbol? moreSymbols:Symbols;
        rangs = @[@10,@20,@25];
    }
    
    //第一排
    NSInteger loc = 0;
    NSInteger length = [[rangs objectAtIndex:0] integerValue];
    NSArray *chars = [charSets subarrayWithRange:NSMakeRange(loc, length)];
    //NSLog(@"第一排:%@",chars);
    NSInteger len = [chars count];
    CGFloat char_h_dis = 7;
    CGFloat char_v_dis = 13;
    CGFloat char_uper_dis = 10;
    CGFloat char_width = (NHSCREEN_WIDTH-char_h_dis*len)/len;
    CGFloat char_heigh = (NHKBH-char_uper_dis*2-char_v_dis*3)/4;
    UIFont *titleFont = NHKBFont(NHKBFontSize);
    UIColor *titleColor = NHColor(247, 247, 247);
    UIColor *bgColor = NHColor(64, 66, 68);
    UIImage *bgImg = [UIImage pb_imageFromColor:bgColor];
    CGFloat cur_y = NHICONH+char_uper_dis;
    
    int n = 0;
    UIImage *charbgImg = [bgImg pb_drawRectWithRoundCorner:NHCHAR_CORNER toSize:CGSizeMake(char_width, char_heigh)];
    for (int i = 0 ; i < len; i ++) {
        CGRect bounds = CGRectMake(char_h_dis*0.5+(char_width+char_h_dis)*i, cur_y, char_width, char_heigh);
        //NSString *title = [chars objectAtIndex:i];
        NHChar *btn = [NHChar buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        //btn.chars = title;
        btn.exclusiveTouch = true;
        //消耗性能
        //[btn addRoundCornerBackdround];
        btn.userInteractionEnabled = false;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setBackgroundImage:charbgImg forState:UIControlStateNormal];
        [btn setTag:n+i];
        //[btn addTarget:self action:@selector(characterTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.charsBtn addObject:btn];
    }
    n+=len;
    
    //第二排
    cur_y += char_heigh+char_v_dis;
    loc = [[rangs objectAtIndex:0] integerValue];
    length = [[rangs objectAtIndex:1] integerValue];
    chars = [charSets subarrayWithRange:NSMakeRange(loc, length-loc)];
    //NSLog(@"第二排:%@",chars);
    len = [chars count];
    CGFloat start_x = (NHSCREEN_WIDTH-char_width*len-char_h_dis*(len-1))/2;
    for (int i = 0 ; i < len; i ++) {
        CGRect bounds = CGRectMake(start_x+(char_width+char_h_dis)*i, cur_y, char_width, char_heigh);
        //NSString *title = [chars objectAtIndex:i];
        NHChar *btn = [NHChar buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        //btn.chars = title;
        btn.exclusiveTouch = true;
        //[btn addRoundCornerBackdround];
        //btn.backgroundColor = NHColor(64, 66, 68);
        btn.userInteractionEnabled = false;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setBackgroundImage:charbgImg forState:UIControlStateNormal];
        [btn setTag:n+i];
        //[btn addTarget:self action:@selector(characterTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.charsBtn addObject:btn];
    }
    n+=len;
    
    //第三排
    cur_y += char_heigh+char_v_dis;
    loc = [[rangs objectAtIndex:1] integerValue];
    length = [[rangs objectAtIndex:2] integerValue];
    chars = [charSets subarrayWithRange:NSMakeRange(loc, length-loc)];
    //NSLog(@"第三排:%@",chars);
    len = [chars count];
    //CGFloat shift_dis = char_h_dis*1.5;
    CGFloat shiftWidth = char_width*1.5;
    char_width = (NHSCREEN_WIDTH-char_h_dis*4-shiftWidth*2-char_h_dis*(len-1))/len;
    charbgImg = [bgImg pb_drawRectWithRoundCorner:NHCHAR_CORNER toSize:CGSizeMake(char_width, char_heigh)];
    CGRect bounds;UIButton *btn;
    if (init) {
        UIImage *roundImg = [bgImg pb_drawRectWithRoundCorner:NHCHAR_CORNER toSize:CGSizeMake(shiftWidth, char_heigh)];
        bounds = CGRectMake(char_h_dis*0.5, cur_y, shiftWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        //btn.backgroundColor = NHColor(64, 66, 68);
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitle:self.shiftEnable?@"☟":@"☝︎" forState:UIControlStateNormal];
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shiftAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.shiftBtn = btn;
        
        bounds = CGRectMake(NHSCREEN_WIDTH-char_h_dis*0.5-shiftWidth, cur_y, shiftWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        //btn.backgroundColor = NHColor(64, 66, 68);
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitle:@"删" forState:UIControlStateNormal];
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(charDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    for (int i = 0 ; i < len; i ++) {
        CGRect bounds = CGRectMake(char_h_dis*2+shiftWidth+(char_width+char_h_dis)*i, cur_y, char_width, char_heigh);
        //NSString *title = [chars objectAtIndex:i];
        NHChar *btn = [NHChar buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        //btn.chars = title;
        btn.exclusiveTouch = true;
        //[btn addRoundCornerBackdround];
        //btn.backgroundColor = NHColor(64, 66, 68);
        btn.userInteractionEnabled = false;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setBackgroundImage:charbgImg forState:UIControlStateNormal];
        [btn setTag:n+i];
        //[btn addTarget:self action:@selector(characterTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.charsBtn addObject:btn];
    }
    
    //第四排
    if (init) {
        cur_y += char_heigh+char_v_dis;
        CGFloat numWidth = shiftWidth*2;
        UIImage *roundImg = [bgImg pb_drawRectWithRoundCorner:NHCHAR_CORNER toSize:CGSizeMake(numWidth, char_heigh)];
        bounds = CGRectMake(char_h_dis*0.5, cur_y, numWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        //btn.backgroundColor = NHColor(64, 66, 68);
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitle:@"#+123" forState:UIControlStateNormal];
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(charSymbolSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.charSymSwitch = btn;
        bounds = CGRectMake(NHSCREEN_WIDTH-char_h_dis*0.5-numWidth, cur_y, numWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        //btn.backgroundColor = NHColor(64, 66, 68);
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(charDoneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        CGFloat spaceWidth = (NHSCREEN_WIDTH-char_h_dis*3-numWidth*2);
        bounds = CGRectMake(char_h_dis*1.5+numWidth, cur_y, spaceWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        //btn.backgroundColor = NHColor(64, 66, 68);
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitle:@"空  格" forState:UIControlStateNormal];
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(charSpaceAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    [self loadCharacters:charSets];
}

//加载键盘符号
- (void)loadCharacters:(NSArray *)array {
    
    NSInteger len = [array count];
    if (!array || len == 0) {
        return;
    }
    NSArray *subviews = self.subviews;
    [subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:[NHChar class]]) {
            NHChar *tmp = (NHChar *)obj;
            NSInteger __tag = tmp.tag;
            //NSLog(@"__tag:%zd---index:%d",__tag,idx);
            if (__tag < len) {
                NSString *tmpTitle = [array objectAtIndex:__tag];
                //NSLog(@"char:%@",tmpTitle);
                if (self.showSymbol) {
                    [tmp updateChar:tmpTitle];
                }else{
                    [tmp updateChar:tmpTitle shift:self.shiftEnable];
                }
            }
        }
    }];
}

#pragma mark -- 字符键盘 Action --

- (void)shiftAction:(UIButton *)btn {
    if (self.showSymbol) {
        //正显示字符符号 无需切换大写
        self.showMoreSymbol = !self.showMoreSymbol;
        [self updateShiftBtnTitleState];
        NSArray *__symbols = self.showMoreSymbol?moreSymbols:Symbols;
        [self loadCharacters:__symbols];
    }else{
        self.shiftEnable = !self.shiftEnable;
        NSArray *subChars = [self subviews];
        [btn setTitle:self.shiftEnable?@"☟":@"☝︎" forState:UIControlStateNormal];
        [subChars enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NHChar class]]) {
                NHChar *tmp = (NHChar *)obj;
                [tmp shift:self.shiftEnable];
            }
        }];
    }
}
//字母 符号切换
- (void)charSymbolSwitch:(UIButton *)btn {
    self.showSymbol = !self.showSymbol;
    NSString *title = self.showSymbol?@"ABC":@"#+123";
    [self.charSymSwitch setTitle:title forState:UIControlStateNormal];
    [self updateShiftBtnTitleState];
    [self setupASCIICapableLayout:false];
}

- (void)updateShiftBtnTitleState {
    NSString *title ;
    if (self.showSymbol) {
        title = self.showMoreSymbol?@"123":@"#+=";
    }else{
        title = self.shiftEnable?@"☟":@"☝︎";
    }
    [self.shiftBtn setTitle:title forState:UIControlStateNormal];
}

- (void)characterTouchAction:(NHChar *)btn {
    NSString *title = [btn titleLabel].text;
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:title];
                if (ret) {
                    [tmp insertText:title];
                }
            }else{
                [tmp insertText:title];
            }
            
        }else if ([self.inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate textView:tmp shouldChangeTextInRange:range replacementText:title];
                if (ret) {
                    [tmp insertText:title];
                }
            }else{
                [tmp insertText:title];
            }
            
        }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString *info = [NSMutableString stringWithString:tmp.text];
            [info appendString:title];
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate searchBar:tmp shouldChangeTextInRange:range replacementText:title];
                if (ret) {
                    [tmp setText:[info copy]];
                }
            }else{
                [tmp setText:[info copy]];
            }
        }
    }
}

- (void)charSpaceAction:(UIButton *)btn {
    NSString *title = @" ";
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:title];
                if (ret) {
                    [tmp insertText:title];
                }
            }else{
                [tmp insertText:title];
            }
            
        }else if ([self.inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate textView:tmp shouldChangeTextInRange:range replacementText:title];
                if (ret) {
                    [tmp insertText:title];
                }
            }else{
                [tmp insertText:title];
            }
            
        }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString *info = [NSMutableString stringWithString:tmp.text];
            [info appendString:title];
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
                NSRange range = NSMakeRange(tmp.text.length, 1);
                BOOL ret = [tmp.delegate searchBar:tmp shouldChangeTextInRange:range replacementText:title];
                if (ret) {
                    [tmp setText:[info copy]];
                }
            }else{
                [tmp setText:[info copy]];
            }
        }
    }
}

- (void)charDeleteAction:(UIButton *)btn {
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            [tmp deleteBackward];
            //            NSString *tmpInfo = tmp.text;
            //            if (tmpInfo.length > 0) {
            //                if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            //                    NSRange range = NSMakeRange(tmpInfo.length-1, 1);
            //                    BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:tmpInfo];
            //                    if (ret) {
            //                        [tmp deleteBackward];
            //                    }
            //                }else{
            //                    [tmp deleteBackward];
            //                }
            //            }
            
        }else if ([self.inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)self.inputSource;
            [tmp deleteBackward];
        }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString *info = [NSMutableString stringWithString:tmp.text];
            if (info.length > 0) {
                NSString *s = [info substringToIndex:info.length-1];
                [tmp setText:s];
            }
        }
    }
}

- (void)charDoneAction:(UIButton *)btn {
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate textFieldShouldEndEditing:tmp];
                [tmp endEditing:ret];
            }else{
                [tmp resignFirstResponder];
            }
            
        }else if ([self.inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate textViewShouldEndEditing:tmp];
                [tmp endEditing:ret];
            }else{
                [tmp resignFirstResponder];
            }
            
        }else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate searchBarShouldEndEditing:tmp];
                [tmp endEditing:ret];
            }else{
                [tmp resignFirstResponder];
            }
        }
    }
}

- (BOOL)resignFirstResponder {
    if (self.inputSource) {
        [self.inputSource resignFirstResponder];
    }
    return[super resignFirstResponder];
}

#pragma mark -- 键盘Pan --

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"_%s_",__FUNCTION__);
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    for (NHChar *tmp in self.charsBtn) {
        NSArray *subs = [tmp subviews];
        if (subs.count == 3) {
            [[subs lastObject] removeFromSuperview];
        }
        if (CGRectContainsPoint(tmp.frame, touchPoint)) {
            [tmp addPopup];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"_%s_",__FUNCTION__);
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    for (NHChar *tmp in self.charsBtn) {
        NSArray *subs = [tmp subviews];
        if (subs.count == 3) {
            [[subs lastObject] removeFromSuperview];
        }
        if (CGRectContainsPoint(tmp.frame, touchPoint)) {
            [tmp addPopup];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"_%s_",__FUNCTION__);
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    for (NHChar *tmp in self.charsBtn) {
        NSArray *subs = [tmp subviews];
        if (subs.count == 3) {
            [[subs lastObject] removeFromSuperview];
        }
        if (CGRectContainsPoint(tmp.frame, touchPoint)) {
            [self characterTouchAction:tmp];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //NSLog(@"_%s_",__FUNCTION__);
    for (NHChar *tmp in self.charsBtn) {
        NSArray *subs = [tmp subviews];
        if (subs.count == 3) {
            [[subs lastObject] removeFromSuperview];
        }
    }
}

@end

@implementation UIImage (PBHelper)

/* UI Utilities */

+ (UIImage *)pb_imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)pb_drawRectWithRoundCorner:(CGFloat)radius toSize:(CGSize)size {
    CGRect bounds = CGRectZero;
    bounds.size = size;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    [self drawInRect:bounds];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

@end

@interface NHChar ()

@property (nonatomic, copy, nullable) NSString *chars;
@property (nonatomic, assign) BOOL isShift;

@end

@implementation NHChar

- (void)addRoundCornerBackdround {
    CGSize size = [self bounds].size;
    UIImage *backImg = [UIImage pb_imageFromColor:NHColor(64, 66, 68)];
    backImg = [backImg pb_drawRectWithRoundCorner:NHCHAR_CORNER toSize:size];
    [self setBackgroundImage:backImg forState:UIControlStateNormal];
}

- (void)updateChar:(nullable NSString *)chars {
    if (chars.length > 0) {
        _chars = [chars copy];
        [self updateTitleState];
    }
}

- (void)updateChar:(nullable NSString *)chars shift:(BOOL)shift {
    if (chars.length > 0) {
        _chars = [chars copy];
        self.isShift = shift;
        [self updateTitleState];
    }
}

- (void)shift:(BOOL)shift {
    if (shift == self.isShift) {
        return;
    }
    self.isShift = shift;
    [self updateTitleState];
}

- (void)updateTitleState {
    NSString *tmp = self.isShift?[self.chars uppercaseString]:[self.chars lowercaseString];
    if ([[NSThread currentThread] isMainThread]) {
        [self setTitle:tmp forState:UIControlStateNormal];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:tmp forState:UIControlStateNormal];
        });
    }
}
/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self addPopup];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *subviews = [self subviews];
    if (subviews.count == 2) {
        [[[self subviews] objectAtIndex:1] removeFromSuperview];
    }else if (subviews.count == 3) {
        [[[self subviews] objectAtIndex:2] removeFromSuperview];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *subviews = [self subviews];
    if (subviews.count == 2) {
        [[[self subviews] objectAtIndex:1] removeFromSuperview];
    }else if (subviews.count == 3) {
        [[[self subviews] objectAtIndex:2] removeFromSuperview];
    }
}
*/

#define _UPPER_WIDTH   (50.0 * [[UIScreen mainScreen] scale])
#define _LOWER_WIDTH   (30.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPER_RADIUS  (7.0 * [[UIScreen mainScreen] scale])
#define _PAN_LOWER_RADIUS  (7.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPDER_WIDTH   (_UPPER_WIDTH-_PAN_UPPER_RADIUS*2)
#define _PAN_UPPER_HEIGHT    (60.0 * [[UIScreen mainScreen] scale])

#define _PAN_LOWER_WIDTH     (_LOWER_WIDTH-_PAN_LOWER_RADIUS*2)
#define _PAN_LOWER_HEIGHT    (30.0 * [[UIScreen mainScreen] scale])

#define _PAN_UL_WIDTH        ((_UPPER_WIDTH-_LOWER_WIDTH)/2)

#define _PAN_MIDDLE_HEIGHT    (11.0 * [[UIScreen mainScreen] scale])

#define _PAN_CURVE_SIZE      (7.0 * [[UIScreen mainScreen] scale])

#define _PADDING_X     (15 * [[UIScreen mainScreen] scale])
#define _PADDING_Y     (11 * [[UIScreen mainScreen] scale])
#define _WIDTH   (_UPPER_WIDTH + _PADDING_X*2)
#define _HEIGHT   (_PAN_UPPER_HEIGHT + _PAN_MIDDLE_HEIGHT + _PAN_LOWER_HEIGHT + _PADDING_Y*2)


#define _OFFSET_X    -20 * [[UIScreen mainScreen] scale])
#define _OFFSET_Y    59 * [[UIScreen mainScreen] scale])


- (CGImageRef)createKeytopImageWithKind:(int)kind
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint p = CGPointMake(_PADDING_X, _PADDING_Y);
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathMoveToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPDER_WIDTH;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 3.0*M_PI/2.0,
                 4.0*M_PI/2.0,
                 false);
    
    p.x += _PAN_UPPER_RADIUS;
    p.y += _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    switch (kind) {
        case NHKBImageLeft:
            p.x -= _PAN_UL_WIDTH*2;
            break;
            
        case NHKBImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case NHKBImageRight:
            break;
    }
    
    p.y += _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y += _PAN_LOWER_HEIGHT - _PAN_CURVE_SIZE - _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 4.0*M_PI/2.0,
                 1.0*M_PI/2.0,
                 false);
    
    p.x -= _PAN_LOWER_WIDTH;
    p.y += _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 1.0*M_PI/2.0,
                 2.0*M_PI/2.0,
                 false);
    
    p.x -= _PAN_LOWER_RADIUS;
    p.y -= _PAN_LOWER_HEIGHT - _PAN_LOWER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    
    switch (kind) {
        case NHKBImageLeft:
            break;
            
        case NHKBImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case NHKBImageRight:
            p.x -= _PAN_UL_WIDTH*2;
            break;
    }
    
    p.y -= _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y -= _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 2.0*M_PI/2.0,
                 3.0*M_PI/2.0,
                 false);
    //----
    CGContextRef context;
    UIGraphicsBeginImageContext(CGSizeMake(_WIDTH,
                                           _HEIGHT));
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, _HEIGHT);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    //----
    
    // draw gradient
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGFloat components[] = {
        0.25f, 0.258f,
        0.266, 1.0f,
        0.48f, 0.48f,
        0.48f, 1.0f};
    
    
    size_t count = sizeof(components)/ (sizeof(CGFloat)* 2);
    
    CGRect frame = CGPathGetBoundingBox(path);
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = frame.origin;
    endPoint.y = frame.origin.y + frame.size.height;
    
    CGGradientRef gradientRef =
    CGGradientCreateWithColorComponents(colorSpaceRef, components, NULL, count);
    
    CGContextDrawLinearGradient(context,
                                gradientRef,
                                startPoint,
                                endPoint,
                                kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    CFRelease(path);
    
    return imageRef;
}

- (void)addPopup {
    UIImageView *keyPop;
    CGFloat scale = [UIScreen mainScreen].scale;
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(_PADDING_X/scale, _PADDING_Y/scale, _UPPER_WIDTH/scale, _PAN_UPPER_HEIGHT/scale)];
    
    if ([self.chars isEqualToString:@"q"]||[self.chars isEqualToString:@"a"]) {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:NHKBImageRight] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        keyPop.frame = CGRectMake(-16, -71, keyPop.frame.size.width, keyPop.frame.size.height);
    }
    else if ([self.chars isEqualToString:@"p"]||[self.chars isEqualToString:@"l"]) {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:NHKBImageLeft] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        keyPop.frame = CGRectMake(-38, -71, keyPop.frame.size.width, keyPop.frame.size.height);
    }
    else {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:NHKBImageInner] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        keyPop.frame = CGRectMake(-27, -71, keyPop.frame.size.width, keyPop.frame.size.height);
    }
    NSString *tmp = self.isShift?[self.chars uppercaseString]:[self.chars lowercaseString];
    [text setFont:[UIFont fontWithName:NHKBFont(NHKBFontSize).fontName size:44]];
    [text setTextColor: NHColor(247, 247, 247)];
    [text setTextAlignment:NSTextAlignmentCenter];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setShadowColor:[UIColor whiteColor]];
    [text setText:tmp];
    
    keyPop.layer.shadowColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    keyPop.layer.shadowOffset = CGSizeMake(0, 3.0);
    keyPop.layer.shadowOpacity = 1;
    keyPop.layer.shadowRadius = 5.0;
    keyPop.clipsToBounds = NO;
    
    [keyPop addSubview:text];
    [self addSubview:keyPop];
}

@end

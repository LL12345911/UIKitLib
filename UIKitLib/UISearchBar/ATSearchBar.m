//
//  ATSearchBar.m
//  HighwayDoctor
//
//  Created by Mars on 2019/7/1.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "ATSearchBar.h"

@interface ATSearchBar () <UITextFieldDelegate>

// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;

@end

// icon宽度
static CGFloat const searchIconW = 20.0f;
// icon与textField间距
static CGFloat const iconSpacing = 5.0f;
// 默认系统占位文字的字体大小 用于设置间距
static CGFloat const placeHolderFont = 17.0f;


@implementation ATSearchBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.layer.cornerRadius = 5.0f;
    self.textField.layer.masksToBounds = YES;
     if (@available(iOS 13.0, *)) {
         
     }else{
//         // 先默认居中placeholder
//         // 顺便设置Icon 与 textField 的间距
//         if (@available(iOS 11.0, *)) {
//             self.searchTextPositionAdjustment = UIOffsetMake(iconSpacing, 0);
//             [self setPositionAdjustment:UIOffsetMake((self.textField.frame.size.width - self.placeholderWidth) / 2, 0) forSearchBarIcon:UISearchBarIconSearch];
//         }
     }
}

// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 继续传递代理方法
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}

// 结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.delegate searchBarShouldEndEditing:self];
    }
    // 没输入文字时占位符居中
    if (textField.text.length == 0) {
        if (@available(iOS 11.0, *)) {
            [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width - self.placeholderWidth) / 2, 0) forSearchBarIcon:UISearchBarIconSearch];
        }
    }
    return YES;
}

- (void)cleanOtherSubViews {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
        }
    }
}

#pragma mark - setter & getter
// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
        _placeholderWidth = size.width + iconSpacing + searchIconW;
    }
    return _placeholderWidth;
}

- (UITextField *)textField {
    if (@available(iOS 13.0, *)) {
         return self.searchTextField;
    }else{
        return [self valueForKey:@"searchField"];
    }
}


@end

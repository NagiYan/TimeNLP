//
//  NSString+NGPreHanding.m
//  TimeNLP
//
//  Created by NAGI on 2017/10/13.
//  Copyright © 2017年 NAGI. All rights reserved.
//

#import "NSString+NGPreHanding.h"

@implementation NSString (NGPreHanding)

- (NSArray<NSTextCheckingResult *>*)match:(NSString*)rule {
    NSError *error = nil;
    NSRegularExpression* regularExp = [[NSRegularExpression alloc] initWithPattern:rule options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *>* match = [regularExp matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    
    return match;
    
}

/**
 * 该方法删除一字符串中所有匹配某一规则字串
 * 可用于清理一个字符串中的空白符和语气助词
 *
 * @param rules 删除规则
 * @return 清理工作完成后的字符串
 */
- (NSString*)delKeyword:(NSString*)rules {
    NSString* result = [self copy];
    NSArray<NSTextCheckingResult *>* match = [self match:rules];
    while (match.count > 0) {
        // 将匹配到的去掉
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@""];
        match = [result match:rules];
    }

    return result;
}

/**
 * 该方法可以将字符串中所有的用汉字表示的数字转化为用阿拉伯数字表示的数字
 * 如"这里有一千两百个人，六百零五个来自中国"可以转化为
 * "这里有1200个人，605个来自中国"
 * 此外添加支持了部分不规则表达方法
 * 如两万零六百五可转化为20650
 * 两百一十四和两百十四都可以转化为214
 * 一六零加一五八可以转化为160+158
 * 该方法目前支持的正确转化范围是0-99999999
 * 该功能模块具有良好的复用性
 *
 * @return 转化完毕后的字符串
 */
- (NSString*)numberTranslator {
    NSString* result = [self copy];
    NSString* rules = @"[一二两三四五六七八九123456789]万[一二两三四五六七八九123456789](?!(千|百|十))";
    NSArray<NSTextCheckingResult *>* match = [result match:rules];
    while (match.count > 0) {
        NSArray<NSString*>* s = [[result substringWithRange:match[0].range] componentsSeparatedByString:@"万"];
        NSInteger num = 0;
        if (s.count == 2) {
            num += [s[0] p_wordToNumber]*10000 + [s[1] p_wordToNumber]*1000;
        }
        
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@(num).stringValue];
        match = [result match:rules];
    }
    
    rules = @"[一二两三四五六七八九123456789]千[一二两三四五六七八九123456789](?!(百|十))";
    match = [result match:rules];
    while (match.count > 0) {
        NSArray<NSString*>* s = [[result substringWithRange:match[0].range] componentsSeparatedByString:@"千"];
        NSInteger num = 0;
        if (s.count == 2) {
            num += [s[0] p_wordToNumber]*1000 + [s[1] p_wordToNumber]*100;
        }
        
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@(num).stringValue];
        match = [result match:rules];
    }
    
    rules = @"[一二两三四五六七八九123456789]百[一二两三四五六七八九123456789](?!十)";
    match = [result match:rules];
    while (match.count > 0) {
        NSArray<NSString*>* s = [[result substringWithRange:match[0].range] componentsSeparatedByString:@"百"];
        NSInteger num = 0;
        if (s.count == 2) {
            num += [s[0] p_wordToNumber]*100 + [s[1] p_wordToNumber]*10;
        }
        
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@(num).stringValue];
        match = [result match:rules];
    }
    
    rules = @"[零一二两三四五六七八九]";
    match = [result match:rules];
    while (match.count > 0) {
        NSInteger num = [[result substringWithRange:match[0].range] p_wordToNumber];
        
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@(num).stringValue];
        match = [result match:rules];
    }
    
    rules = @"(?<=(周|星期))[末天日]";
    match = [result match:rules];
    while (match.count > 0) {
        NSInteger num = [[result substringWithRange:match[0].range] p_wordToNumber];
        
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@(num).stringValue];
        match = [result match:rules];
    }

    rules = @"(?<!(周|星期))0?[0-9]?十[0-9]?";
    match = [result match:rules];
    while (match.count > 0) {
        NSArray<NSString*>* s = [[result substringWithRange:match[0].range] componentsSeparatedByString:@"十"];
        NSInteger num = 0;
        if (s.count == 0)
        {
            num += 10;
        }
        else if(s.count == 1)
        {
            NSInteger ten = [s[0] integerValue];
            if(ten == 0)
                num += 10;
            else
                num += ten*10;
        }
        else if(s.count == 2)
        {
            if(s[0].length == 0)
                num += 10;
            else
            {
                NSInteger ten = [s[0] integerValue];
                if(ten == 0)
                    num += 10;
                else
                    num += ten*10;
            }
            num += [s[1] integerValue];
        }
        
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@(num).stringValue];
        match = [result match:rules];
    }
    
    rules = @"0?[1-9]百[0-9]?[0-9]?";
    match = [result match:rules];
    while (match.count > 0) {
        NSArray<NSString*>* s = [[result substringWithRange:match[0].range] componentsSeparatedByString:@"百"];
        NSInteger num = 0;
        if(s.count == 1)
        {
            NSInteger hundred = [s[0] integerValue];
            num += hundred*100;;
        }
        else if(s.count == 2){
            NSInteger hundred = [s[0] integerValue];
            num += hundred*100;
            num += [s[1] integerValue];
        }
        
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@(num).stringValue];
        match = [result match:rules];
    }
    
    rules = @"0?[1-9]千[0-9]?[0-9]?[0-9]?";
    match = [result match:rules];
    while (match.count > 0) {
        NSArray<NSString*>* s = [[result substringWithRange:match[0].range] componentsSeparatedByString:@"千"];
        NSInteger num = 0;
        if(s.count == 1)
        {
            NSInteger thousand = [s[0] integerValue];
            num += thousand*1000;;
        }
        else if(s.count == 2) {
            NSInteger thousand = [s[0] integerValue];
            num += thousand*1000;
            num += [s[1] integerValue];
        }
        
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@(num).stringValue];
        match = [result match:rules];
    }
    
    rules = @"[0-9]+万[0-9]?[0-9]?[0-9]?[0-9]?";
    match = [result match:rules];
    while (match.count > 0) {
        NSArray<NSString*>* s = [[result substringWithRange:match[0].range] componentsSeparatedByString:@"万"];
        NSInteger num = 0;
        if(s.count == 1)
        {
            NSInteger tenthousand = [s[0] integerValue];
            num += tenthousand*10000;;
        }
        else if(s.count == 2) {
            NSInteger tenthousand = [s[0] integerValue];
            num += tenthousand*10000;
            num += [s[1] integerValue];
        }
        
        result = [result stringByReplacingOccurrencesOfString:[result substringWithRange:match[0].range] withString:@(num).stringValue];
        match = [result match:rules];
    }
    
    return result;
}

/**
 * 方法numberTranslator的辅助方法，可将[零-九]正确翻译为[0-9]
 *
 * @return 对应的整形数，如果不是大写数字返回-1
 */
- (NSInteger)p_wordToNumber {
    NSArray<NSArray<NSString*>*>* dictionary = @[@[@"零", @"0"],
                                                 @[@"一", @"1"],
                                                 @[@"二", @"两", @"2"],
                                                 @[@"三", @"3"],
                                                 @[@"四", @"4"],
                                                 @[@"五", @"5"],
                                                 @[@"六", @"6"],
                                                 @[@"七", @"天", @"日", @"末", @"7"],
                                                 @[@"八", @"8"],
                                                 @[@"九", @"9"]];
    __block NSInteger result = -1;
    [dictionary enumerateObjectsUsingBlock:^(NSArray<NSString *> * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(NSString * _Nonnull word, NSUInteger idx, BOOL * _Nonnull stopWord) {
            if ([word isEqualToString:self] ) {
                result = index;
                *stopWord = YES;
            }
        }];
        if (result >= 0) {
            *stop = YES;
        }
    }];
    
    return result;
}

@end

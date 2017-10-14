//
//  NSString+NGPreHanding.h
//  TimeNLP
//
//  Created by NAGI on 2017/10/13.
//  Copyright © 2017年 NAGI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NGPreHanding)

/**
 * 该方法删除一字符串中所有匹配某一规则字串
 * 可用于清理一个字符串中的空白符和语气助词
 *
 * @param rules 删除规则
 * @return 清理工作完成后的字符串
 */
- (NSString*)delKeyword:(NSString*)rules;

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
- (NSString*)numberTranslator;

- (NSArray<NSTextCheckingResult *>*)match:(NSString*)rule;

@end

//
//  NSArray+NGPattern.h
//  TimeNLP
//
//  Created by NAGI on 2017/10/14.
//  Copyright © 2017年 NAGI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NGPattern)

// 正则表达式校验结果匹配到的第一个结果
- (NSString*)ng_group:(NSString*)source;

// 正则表达式匹配到的第一个结果的结束位
- (NSInteger)ng_end;
@end

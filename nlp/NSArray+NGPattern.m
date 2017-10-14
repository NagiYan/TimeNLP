//
//  NSArray+NGPattern.m
//  TimeNLP
//
//  Created by NAGI on 2017/10/14.
//  Copyright © 2017年 NAGI. All rights reserved.
//

#import "NSArray+NGPattern.h"

@implementation NSArray (NGPattern)

- (NSString*)ng_group:(NSString*)source {
    if (self.count > 0) {
        if ([self[0] isKindOfClass:[NSTextCheckingResult class]]) {
            NSTextCheckingResult* result = (NSTextCheckingResult*)self[0];
            return [source substringWithRange:result.range];
        }
    }
    return source;
}

// 正则表达式匹配到的第一个结果的结束位
- (NSInteger)ng_end {
    if (self.count > 0) {
        if ([self[0] isKindOfClass:[NSTextCheckingResult class]]) {
            NSTextCheckingResult* result = (NSTextCheckingResult*)self[0];
            return result.range.location + result.range.length;
        }
    }
    return -1;
}
@end

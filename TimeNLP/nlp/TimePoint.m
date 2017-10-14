//
//  TimePoint.m
//  TimeNLP
//
//  Created by NAGI on 2017/10/13.
//  Copyright © 2017年 NAGI. All rights reserved.
//

#import "TimePoint.h"

@implementation TimePoint

- (instancetype)init {
    self = [super init];
    if (self) {
        _tunit = [@[@(-1), @(-1), @(-1), @(-1), @(-1), @(-1)] mutableCopy];
    }
    return self;
}

@end

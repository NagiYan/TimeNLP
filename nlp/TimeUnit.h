//
//  TimeUnit.h
//  TimeNLP
//
//  Created by NAGI on 2017/10/13.
//  Copyright © 2017年 NAGI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimePoint.h"

@class TimeNormalizer;

typedef enum : NSUInteger {
    rt_day_break        = 3,
    rt_early_morning    = 8, //早
    rt_morning          = 10, //上午
    rt_noon             = 12, //中午、午间
    rt_afternoon        = 15, //下午、午后
    rt_night            = 18, //晚上、傍晚
    rt_late_night       = 20, //晚、晚间
    rt_mid_night        = 23  //深夜
} RangeTime;

@interface TimeUnit : NSObject
@property (nonatomic, copy)NSString* timeExpression;
@property (nonatomic, copy)NSString* timeNorm;
@property(nonatomic, strong)NSDate* time;
@property (nonatomic, strong)NSMutableArray<NSNumber*>* timeFull;
@property (nonatomic, strong)NSMutableArray<NSNumber*>* timeOrigin;
@property (nonatomic, strong)TimePoint* tp;
@property (nonatomic, strong)TimePoint* tpOrigin;
@property(nonatomic, assign)BOOL isAllDayTime;
@property(nonatomic, weak)TimeNormalizer* normalizer;

/**
 * 时间表达式规范化的入口
 * <p>
 * 时间表达式识别后，通过此入口进入规范化阶段，
 * 具体识别每个字段的值
 */
- (void)timeNormalization;
@end

//
//  TimePoint.h
//  TimeNLP
//
//  Created by NAGI on 2017/10/13.
//  Copyright © 2017年 NAGI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimePoint : NSObject


/**
 * 时间表达式单元规范化对应的内部类,
 * 对应时间表达式规范化的每个字段，
 * 六个字段分别是：年-月-日-时-分-秒，
 * 每个字段初始化为-1
 */
@property (nonatomic, strong)NSMutableArray<NSNumber*>* tunit;

@end

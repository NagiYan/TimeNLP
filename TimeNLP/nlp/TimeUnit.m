//
//  TimeUnit.m
//  TimeNLP
//
//  Created by NAGI on 2017/10/13.
//  Copyright © 2017年 NAGI. All rights reserved.
//

#import "TimeUnit.h"
#import "NSDate+NGFSExtension.h"
#import "TimeNormalizer.h"

@interface TimeUnit()


@property(nonatomic, assign)BOOL isFirstTimeSolveContext;


@end

@implementation TimeUnit

- (instancetype)init {
    self = [super init];
    if (self) {
        _isAllDayTime = YES;
        _isFirstTimeSolveContext = YES;
        _timeNorm = @"";
        _tp = [TimePoint new];
        _tpOrigin = [TimePoint new];
    }
    return self;
}

/**
 * 时间表达式规范化的入口
 * <p>
 * 时间表达式识别后，通过此入口进入规范化阶段，
 * 具体识别每个字段的值
 */
- (void)timeNormalization {
    [self normSetYear];
    [self normSetMonth];
    [self normSetDay];
    [self normSetMonthFuzzyDay];
    [self normSetBaseRelated];
    [self normSetCurRelated];
    [self normSetHour];
    [self normSetMinute];
    [self normSetSecond];
    [self normSetTotal];
    [self modifyTimeBase];
    
    _tpOrigin.tunit = [_tp.tunit mutableCopy];
    
    NSArray<NSString*>* time_grid = [self.normalizer.timeBase componentsSeparatedByString:@"-"];
    
    int tunitpointer = 5;
    while (tunitpointer >= 0 && [_tp.tunit[tunitpointer] integerValue] < 0) {
        tunitpointer--;
    }
    for (int i = 0; i < tunitpointer; i++) {
        if ([_tp.tunit[i] integerValue] < 0)
            _tp.tunit[i] = @([time_grid[i] integerValue]);
    }
    NSMutableArray<NSString*>* result_tmp = [NSMutableArray<NSString*> new];
    result_tmp[0] = _tp.tunit[0].stringValue;
    if ([_tp.tunit[0] integerValue] >= 10 && [_tp.tunit[0] integerValue] < 100) {
        result_tmp[0] = [NSString stringWithFormat:@"19%@", _tp.tunit[0].stringValue];
    }
    if ([_tp.tunit[0] integerValue] > 0 && [_tp.tunit[0] integerValue] < 10) {
        result_tmp[0] = [NSString stringWithFormat:@"200%@", _tp.tunit[0].stringValue];
    }
    
    for (int i = 1; i < 6; i++) {
        result_tmp[i] = _tp.tunit[i].stringValue;
    }
    
    NSDate* date = [self p_now];
    
    if ([result_tmp[0] integerValue] != -1)
    {
        self.timeNorm = [NSString stringWithFormat:@"%@%@年", self.timeNorm, result_tmp[0]];
        date = [date ng_fs_setYear:[result_tmp[0] integerValue]];
        if ([result_tmp[1] integerValue] != -1)
        {
            self.timeNorm = [NSString stringWithFormat:@"%@%@月", self.timeNorm, result_tmp[1]];
            date = [date ng_fs_setMonth:[result_tmp[1] integerValue]];
            if ([result_tmp[2] integerValue] != -1)
            {
                self.timeNorm = [NSString stringWithFormat:@"%@%@日", self.timeNorm, result_tmp[2]];
                date = [date ng_fs_setDay:[result_tmp[2] integerValue]];
                if ([result_tmp[3] integerValue] != -1)
                {
                    self.timeNorm = [NSString stringWithFormat:@"%@%@时", self.timeNorm, result_tmp[3]];
                    date = [date ng_fs_setHour:[result_tmp[3] integerValue]];
                    if ([result_tmp[4] integerValue] != -1)
                    {
                        self.timeNorm = [NSString stringWithFormat:@"%@%@分", self.timeNorm, result_tmp[4]];
                        date = [date ng_fs_setMinute:[result_tmp[4] integerValue]];
                        if ([result_tmp[5] integerValue] != -1)
                        {
                            self.timeNorm = [NSString stringWithFormat:@"%@%@秒", self.timeNorm, result_tmp[5]];
                            date = [date ng_fs_setSecond:[result_tmp[5] integerValue]];
                        }
                        else {
                            date = [date ng_fs_setSecond:0];
                        }
                    }
                    else {
                        date = [date ng_fs_setMinute:0];
                        date = [date ng_fs_setSecond:0];
                    }
                }
                else {
                    date = [date ng_fs_setHour:8];
                    date = [date ng_fs_setMinute:0];
                    date = [date ng_fs_setSecond:0];
                }
            }
        }
        self.time = date;
    }
    else {
        self.time = nil;
    }

    
    self.timeFull = [_tp.tunit copy];
}

/**
 * 年-规范化方法
 * <p>
 * 该方法识别时间表达式单元的年字段
 */
- (void)normSetYear {
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"[0-9]{2}(?=年)"];
    if (match.count > 0) {
        _tp.tunit[0] = @([[self.timeExpression substringWithRange:match[0].range] integerValue]);
        if ([_tp.tunit[0] integerValue] >= 0 && [_tp.tunit[0] integerValue]< 100) {
            if ([_tp.tunit[0] integerValue] < 30) /**30以下表示2000年以后的年份*/
                _tp.tunit[0] = @([_tp.tunit[0] integerValue] + 2000);
            else/**否则表示1900年以后的年份*/
                _tp.tunit[0] = @([_tp.tunit[0] integerValue] + 1900);
        }
    }
    
    /**不仅局限于支持1XXX年和2XXX年的识别，可识别三位数和四位数表示的年份*/
    match = [self p_matchTimeExpressionWithRule:@"[0-9]?[0-9]{3}(?=年)"];
    if (match.count > 0)/**如果有3位数和4位数的年份，则覆盖原来2位数识别出的年份*/ {
        _tp.tunit[0] = @([[self.timeExpression substringWithRange:match[0].range] integerValue]);
    }
}

/**
 * 月-规范化方法
 * <p>
 * 该方法识别时间表达式单元的月字段
 */
- (void)normSetMonth {
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"((10)|(11)|(12)|([1-9]))(?=月)"];
    if (match.count > 0) {
         _tp.tunit[1] = @([[self.timeExpression substringWithRange:match[0].range] integerValue]);
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:1];
    }
}

/**
 * 月-日 兼容模糊写法
 * <p>
 * 该方法识别时间表达式单元的月、日字段
 * <p>
 * add by kexm
 */
- (void)normSetMonthFuzzyDay {
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"((10)|(11)|(12)|(0[1-9])|([1-9]))(月|\\.|-|/)([0-3][0-9]|[1-9])(?!(\\.|-|/))"];
    if (match.count > 0) {
        NSString* matchStr = [self.timeExpression substringWithRange:match[0].range];
        match = [self p_match:matchStr WithRule:@"(月|\\.|-|/)"];
        if (match.count > 0) {
            NSString* month = [matchStr substringWithRange:NSMakeRange(0, match[0].range.location)];
            NSString* date = [matchStr substringFromIndex:match[0].range.location+1];
            
            _tp.tunit[1] = @([month integerValue]);
            _tp.tunit[2] = @([date integerValue]);
            
            [self p_preferFuture:1];
        }
    }
}

/**
 * 日-规范化方法
 * <p>
 * 该方法识别时间表达式单元的日字段
 */
- (void)normSetDay {
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"((?<!\\d))([0-3][0-9]|[1-9])(?=(日|号))"];
    if (match.count > 0) {
        _tp.tunit[2] = @([[self.timeExpression substringWithRange:match[0].range] integerValue]);
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:2];
    }
}

/**
 * 时-规范化方法
 * <p>
 * 该方法识别时间表达式单元的时字段
 */
- (void)normSetHour {
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"(?<!(周|星期|礼拜))([0-2]?[0-9])(?=(点|时))"];
    if (match.count > 0) {
        _tp.tunit[3] = @([[self.timeExpression substringWithRange:match[0].range] integerValue]);
        self.isAllDayTime = NO;
    }
    
    /*
     * 对关键字：早（包含早上/早晨/早间），上午，中午,午间,下午,午后,晚上,傍晚,晚间,晚,pm,PM的正确时间计算
     * 规约：
     * 1.中午/午间0-10点视为12-22点
     * 2.下午/午后0-11点视为12-23点
     * 3.晚上/傍晚/晚间/晚1-11点视为13-23点，12点视为0点
     * 4.0-11点pm/PM视为12-23点
     *
     * add by kexm
     */
    match = [self p_matchTimeExpressionWithRule:@"凌晨"];
    if (match.count > 0) {
        if ([_tp.tunit[3] integerValue] == -1) /**增加对没有明确时间点，只写了“凌晨”这种情况的处理 @author kexm*/
            _tp.tunit[3] = @(rt_day_break);
        self.isAllDayTime = NO;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"早上|早晨|早间|晨间|今早|明早"];
    if (match.count > 0) {
        if ([_tp.tunit[3] integerValue] == -1) /**增加对没有明确时间点，只写了“早上/早晨/早间”这种情况的处理 @author kexm*/
            _tp.tunit[3] = @(rt_early_morning);
        self.isAllDayTime = NO;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"上午"];
    if (match.count > 0) {
        if ([_tp.tunit[3] integerValue] == -1) /**增加对没有明确时间点，只写了“上午”这种情况的处理 @author kexm*/
            _tp.tunit[3] = @(rt_morning);
        self.isAllDayTime = NO;
    }

    match = [self p_matchTimeExpressionWithRule:@"(中午)|(午间)"];
    if (match.count > 0) {
        if ([_tp.tunit[3] integerValue] >= 0 && [_tp.tunit[3] integerValue] <= 10)
            _tp.tunit[3] = @([_tp.tunit[3] integerValue] + 12);
        if ([_tp.tunit[3] integerValue] == -1) /**增加对没有明确时间点，只写了“中午/午间”这种情况的处理 @author kexm*/
            _tp.tunit[3] = @(rt_noon);
        self.isAllDayTime = NO;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(下午)|(午后)|(pm)|(PM)"];
    if (match.count > 0) {
        if ([_tp.tunit[3] integerValue] >= 0 && [_tp.tunit[3] integerValue] <= 11)
            _tp.tunit[3] = @([_tp.tunit[3] integerValue] + 12);
        if ([_tp.tunit[3] integerValue] == -1) /**增加对没有明确时间点，只写了“下午|午后”这种情况的处理  @author kexm*/
            _tp.tunit[3] = @(rt_afternoon);
        self.isAllDayTime = NO;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"晚上|夜间|夜里|今晚|明晚"];
    if (match.count > 0) {
        if ([_tp.tunit[3] integerValue] >= 1 && [_tp.tunit[3] integerValue] <= 11)
            _tp.tunit[3] = @([_tp.tunit[3] integerValue] + 12);
        else if ([_tp.tunit[3] integerValue] == 12)
            _tp.tunit[3] = @(0);
        if ([_tp.tunit[3] integerValue] == -1) /**增加对没有明确时间点，只写了“下午|午后”这种情况的处理  @author kexm*/
            _tp.tunit[3] = @(rt_night);
        self.isAllDayTime = NO;
    }
    
    [self p_preferFuture:3];
}

/**
 * 分-规范化方法
 * <p>
 * 该方法识别时间表达式单元的分字段
 */
- (void)normSetMinute {
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"([0-5]?[0-9](?=分(?!钟)))|((?<=((?<!小)[点时]))[0-5]?[0-9](?!刻))"];
    if (match.count > 0) {
        _tp.tunit[4] = @([[self.timeExpression substringWithRange:match[0].range] integerValue]);
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:4];
        self.isAllDayTime = NO;
    }

    /** 加对一刻，半，3刻的正确识别（1刻为15分，半为30分，3刻为45分）*/
    match = [self p_matchTimeExpressionWithRule:@"(?<=[点时])[1一]刻(?!钟)"];
    if (match.count > 0) {
        _tp.tunit[4] = @(15);
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:4];
        self.isAllDayTime = NO;
    }

    match = [self p_matchTimeExpressionWithRule:@"(?<=[点时])半"];
    if (match.count > 0) {
        _tp.tunit[4] = @(30);
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:4];
        self.isAllDayTime = NO;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(?<=[点时])[3三]刻(?!钟)"];
    if (match.count > 0) {
        _tp.tunit[4] = @(45);
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:4];
        self.isAllDayTime = NO;
    }
}

/**
 * 秒-规范化方法
 * <p>
 * 该方法识别时间表达式单元的秒字段
 */
- (void)normSetSecond {
    /*
     * 添加了省略“分”说法的时间
     * 如17点15分32
     * modified by 曹零
     */
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"([0-5]?[0-9](?=秒))|((?<=分)[0-5]?[0-9])"];
    if (match.count > 0) {
        _tp.tunit[5] = @([[self.timeExpression substringWithRange:match[0].range] integerValue]);
        self.isAllDayTime = NO;
    }
}

/**
 * 特殊形式的规范化方法
 * <p>
 * 该方法识别特殊形式的时间表达式单元的各个字段
 */
- (void)normSetTotal {
    NSArray<NSString*>* tmpParser;
    NSString* tmpTarget = @"";
    
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"(?<!(周|星期|礼拜))([0-2]?[0-9]):[0-5]?[0-9]:[0-5]?[0-9]"];
    if (match.count > 0) {
        tmpTarget = [self.timeExpression substringWithRange:match[0].range];
        tmpParser = [tmpTarget componentsSeparatedByString:@":"];
        _tp.tunit[3] = @([tmpParser[0] integerValue]);
        _tp.tunit[4] = @([tmpParser[1] integerValue]);
        _tp.tunit[5] = @([tmpParser[2] integerValue]);
        
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:3];
        self.isAllDayTime = NO;
    }
    else {
        match = [self p_matchTimeExpressionWithRule:@"(?<!(周|星期))([0-2]?[0-9]):[0-5]?[0-9]"];
        if (match.count > 0) {
            tmpTarget = [self.timeExpression substringWithRange:match[0].range];
            tmpParser = [tmpTarget componentsSeparatedByString:@":"];
            _tp.tunit[3] = @([tmpParser[0] integerValue]);
            _tp.tunit[4] = @([tmpParser[1] integerValue]);
            
            /**处理倾向于未来时间的情况  @author kexm*/
            [self p_preferFuture:3];
            self.isAllDayTime = NO;
        }
    }
    
    /*
     * 增加了:固定形式时间表达式的
     * 中午,午间,下午,午后,晚上,傍晚,晚间,晚,pm,PM
     * 的正确时间计算，规约同上
     */
    match = [self p_matchTimeExpressionWithRule:@"(中午)|(午间)"];
    if (match.count > 0) {
        if ([_tp.tunit[3] integerValue] >= 0 && [_tp.tunit[3] integerValue] <= 10)
            _tp.tunit[3] = @([_tp.tunit[3] integerValue] + 12);
        if ([_tp.tunit[3] integerValue] == -1) /**增加对没有明确时间点，只写了“中午/午间”这种情况的处理 @author kexm*/
            _tp.tunit[3] = @(rt_noon);
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:3];
        self.isAllDayTime = NO;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(下午)|(午后)|(pm)|(PM)"];
    if (match.count > 0) {
        if ([_tp.tunit[3] integerValue] >= 0 && [_tp.tunit[3] integerValue] <= 11)
            _tp.tunit[3] = @([_tp.tunit[3] integerValue] + 12);
        if ([_tp.tunit[3] integerValue] == -1) /**增加对没有明确时间点，只写了“下午|午后”这种情况的处理  @author kexm*/
            _tp.tunit[3] = @(rt_afternoon);
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:3];
        self.isAllDayTime = NO;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"晚"];
    if (match.count > 0) {
        if ([_tp.tunit[3] integerValue] >= 1 && [_tp.tunit[3] integerValue] <= 11)
            _tp.tunit[3] = @([_tp.tunit[3] integerValue] + 12);
        else if ([_tp.tunit[3] integerValue] == 12)
            _tp.tunit[3] = @(0);
        if ([_tp.tunit[3] integerValue] == -1) /**增加对没有明确时间点，只写了“下午|午后”这种情况的处理  @author kexm*/
            _tp.tunit[3] = @(rt_night);
        /**处理倾向于未来时间的情况  @author kexm*/
        [self p_preferFuture:3];
        self.isAllDayTime = NO;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"[0-9]?[0-9]?[0-9]{2}-((10)|(11)|(12)|([1-9]))-((?<!\\d))([0-3][0-9]|[1-9])"];
    if (match.count > 0) {
        tmpTarget = [self.timeExpression substringWithRange:match[0].range];
        tmpParser = [tmpTarget componentsSeparatedByString:@"-"];
        _tp.tunit[0] = @([tmpParser[0] integerValue]);
        _tp.tunit[1] = @([tmpParser[1] integerValue]);
        _tp.tunit[2] = @([tmpParser[2] integerValue]);
    }
    
    match = [self p_matchTimeExpressionWithRule:@"((10)|(11)|(12)|([1-9]))/((?<!\\d))([0-3][0-9]|[1-9])/[0-9]?[0-9]?[0-9]{2}"];
    if (match.count > 0) {
        tmpTarget = [self.timeExpression substringWithRange:match[0].range];
        tmpParser = [tmpTarget componentsSeparatedByString:@"/"];
        _tp.tunit[0] = @([tmpParser[2] integerValue]);
        _tp.tunit[1] = @([tmpParser[0] integerValue]);
        _tp.tunit[2] = @([tmpParser[1] integerValue]);
    }
    
    /*
     * 增加了:固定形式时间表达式 年.月.日 的正确识别
     * add by 曹零
     */
    match = [self p_matchTimeExpressionWithRule:@"[0-9]?[0-9]?[0-9]{2}\\.((10)|(11)|(12)|([1-9]))\\.((?<!\\d))([0-3][0-9]|[1-9])"];
    if (match.count > 0) {
        tmpTarget = [self.timeExpression substringWithRange:match[0].range];
        tmpParser = [tmpTarget componentsSeparatedByString:@"\\."];
        _tp.tunit[0] = @([tmpParser[0] integerValue]);
        _tp.tunit[1] = @([tmpParser[1] integerValue]);
        _tp.tunit[2] = @([tmpParser[2] integerValue]);
    }
}

/**
 * 设置以上文时间为基准的时间偏移计算
 */
- (void)normSetBaseRelated {
    NSDate* date = [NSDate ng_fs_dateFromString:self.normalizer.timeBase format:@"yyyy-MM-dd-HH-mm-ss"];
    
    bool flag[] = {false, false, false};//观察时间表达式是否因当前相关时间表达式而改变时间
    
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"\\d+(?=天[以之]?前)"];
    if (match.count > 0) {
        flag[2] = true;
        NSInteger day = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        date = [date ng_fs_dateBySubtractingDays:day];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"\\d+(?=天[以之]?后)"];
    if (match.count > 0) {
        flag[2] = true;
        NSInteger day = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        date = [date ng_fs_dateByAddingDays:day];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"\\d+(?=(个)?月[以之]?前)"];
    if (match.count > 0) {
        flag[1] = true;
        NSInteger month = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        date = [date ng_fs_dateBySubtractingMonths:month];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"\\d+(?=(个)?月[以之]?后)"];
    if (match.count > 0) {
        flag[1] = true;
        NSInteger month = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        date = [date ng_fs_dateByAddingMonths:month];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"\\d+(?=年[以之]?前)"];
    if (match.count > 0) {
        flag[0] = true;
        NSInteger year = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        date = [date ng_fs_dateBySubtractingYears:year];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"\\d+(?=年[以之]?后)"];
    if (match.count > 0) {
        flag[0] = true;
        NSInteger year = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        date = [date ng_fs_dateByAddingYears:year];
    }
    
    if (flag[0] || flag[1] || flag[2]) {
        _tp.tunit[0] = @([date ng_fs_year]);
    }
    if (flag[1] || flag[2]) {
        _tp.tunit[1] = @([date ng_fs_month]);
    }
    if (flag[2]) {
        _tp.tunit[2] = @([date ng_fs_day]);
    }
}

/**
 * 设置当前时间相关的时间表达式
 */
- (void)normSetCurRelated {
    NSDate* date = [NSDate ng_fs_dateFromString:self.normalizer.oldTimeBase format:@"yyyy-MM-dd-HH-mm-ss"];
    bool flag[] = {false, false, false};//观察时间表达式是否因当前相关时间表达式而改变时间
    
    NSArray<NSTextCheckingResult *>* match = [self p_matchTimeExpressionWithRule:@"前年"];
    if (match.count > 0) {
        flag[0] = true;
        date = [date ng_fs_dateBySubtractingYears:2];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"去年"];
    if (match.count > 0) {
        flag[0] = true;
        date = [date ng_fs_dateBySubtractingYears:1];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"今年"];
    if (match.count > 0) {
        flag[0] = true;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"后年"];
    if (match.count > 0) {
        flag[0] = true;
        date = [date ng_fs_dateByAddingYears:2];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"上(个)?月"];
    if (match.count > 0) {
        flag[1] = true;
        date = [date ng_fs_dateBySubtractingMonths:1];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(本|这个)月"];
    if (match.count > 0) {
        flag[1] = true;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"下(个)?月"];
    if (match.count > 0) {
        flag[1] = true;
        date = [date ng_fs_dateByAddingMonths:1];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"大前天"];
    if (match.count > 0) {
        flag[2] = true;
        date = [date ng_fs_dateBySubtractingDays:3];
    }

    
    match = [self p_matchTimeExpressionWithRule:@"(?<!大)前天"];
    if (match.count > 0) {
        flag[2] = true;
        date = [date ng_fs_dateBySubtractingDays:2];
    }

    match = [self p_matchTimeExpressionWithRule:@"昨"];
    if (match.count > 0) {
        flag[2] = true;
        date = [date ng_fs_dateBySubtractingDays:1];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"今(?!年)"];
    if (match.count > 0) {
        flag[2] = true;
    }
    
    match = [self p_matchTimeExpressionWithRule:@"明(?!年)"];
    if (match.count > 0) {
        flag[2] = true;
        date = [date ng_fs_dateByAddingDays:1];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(?<!大)后天"];
    if (match.count > 0) {
        flag[2] = true;
        date = [date ng_fs_dateByAddingDays:2];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"大后天"];
    if (match.count > 0) {
        flag[2] = true;
        date = [date ng_fs_dateByAddingDays:3];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(?<=(上上(周|星期|礼拜)))[1-7]?"];
    if (match.count > 0) {
        flag[2] = true;
        
        NSInteger week = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        week = MAX(week, 1);
        
        date = [date ng_fs_dateBySubtractingWeeks:2];
        NSInteger weekday = [date ng_fs_weekday];
        weekday = weekday == 1?7:--weekday;
        date = [date ng_fs_dateByAddingDays:(week - weekday)];
        date = [self p_preferFutureWeek:week date:date];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(?<=((?<!上)上(周|星期|礼拜)))[1-7]?"];
    if (match.count > 0) {
        flag[2] = true;
        
        NSInteger week = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        week = MAX(week, 1);
        
        date = [date ng_fs_dateBySubtractingWeeks:1];
        NSInteger weekday = [date ng_fs_weekday];
        weekday = weekday == 1?7:--weekday;
        date = [date ng_fs_dateByAddingDays:(week - weekday)];
        date = [self p_preferFutureWeek:week date:date];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(?<=((?<!下)下(周|星期|礼拜)))[1-7]?"];
    if (match.count > 0) {
        flag[2] = true;
        
        NSInteger week = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        week = MAX(week, 1);
        
        date = [date ng_fs_dateByAddingWeeks:1];
        NSInteger weekday = [date ng_fs_weekday];
        weekday = weekday == 1?7:--weekday;
        date = [date ng_fs_dateByAddingDays:(week - weekday)];
        date = [self p_preferFutureWeek:week date:date];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(?<=(下下(周|星期|礼拜)))[1-7]?"];
    if (match.count > 0) {
        flag[2] = true;
        
        NSInteger week = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        week = MAX(week, 1);
        
        date = [date ng_fs_dateByAddingWeeks:2];
        NSInteger weekday = [date ng_fs_weekday];
        weekday = weekday == 1?7:--weekday;
        date = [date ng_fs_dateByAddingDays:(week - weekday)];
        date = [self p_preferFutureWeek:week date:date];
    }
    
    match = [self p_matchTimeExpressionWithRule:@"(?<=((?<!(上|下))(周|星期|礼拜)))[1-7]?"];
    if (match.count > 0) {
        flag[2] = true;
        // 这周几
        NSInteger week = [[self.timeExpression substringWithRange:match[0].range] integerValue];
        week = MAX(week, 1);
        
        //
        NSInteger weekday = [date ng_fs_weekday];
        weekday = weekday == 1?7:--weekday;
        date = [date ng_fs_dateByAddingDays:(week - weekday)];
        date = [self p_preferFutureWeek:week date:date];
    }
        
    if (flag[0] || flag[1] || flag[2]) {
        _tp.tunit[0] = @([date ng_fs_year]);
    }
    if (flag[1] || flag[2]) {
        _tp.tunit[1] = @([date ng_fs_month]);
    }
    if (flag[2]) {
        _tp.tunit[2] = @([date ng_fs_day]);
    }
}

/**
 * 该方法用于更新timeBase使之具有上下文关联性
 */
- (void)modifyTimeBase {
    NSArray<NSString*>* time_grid = [self.normalizer.timeBase componentsSeparatedByString:@"-"];
    NSMutableString* s = [[NSMutableString alloc] initWithString:@""];

    for (int i = 0; i < 6; i++) {
        if (i != 0) {
            [s appendString:@"-"];
        }

        if ([_tp.tunit[i] integerValue] != -1){
            [s appendString:_tp.tunit[i].stringValue];
        }
        else {
            [s appendString:time_grid[i]];
        }
    }
    [self.normalizer setTimeBase:s];
}

///MARK: -
- (NSArray<NSTextCheckingResult *>*)p_matchTimeExpressionWithRule:(NSString*)rule {
    return [self p_match:self.timeExpression WithRule:rule];
}

- (NSArray<NSTextCheckingResult *>*)p_match:(NSString*)string WithRule:(NSString*)rule {
    NSError *error = nil;
    NSRegularExpression* regularExp = [[NSRegularExpression alloc] initWithPattern:rule options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *>* match = [regularExp matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, [string length])];
    
    return match;
}

/**
 * 根据上下文时间补充时间信息
 */
- (void)p_checkContextTime:(NSInteger)checkTimeIndex {
    for (int i = 0; i < checkTimeIndex; i++) {
        if ([_tp.tunit[i] integerValue] == -1 && [_tpOrigin.tunit[i] integerValue] != -1) {
            _tp.tunit[i] = @([_tpOrigin.tunit[i] integerValue]);
        }
    }
    /**在处理小时这个级别时，如果上文时间是下午的且下文没有主动声明小时级别以上的时间，则也把下文时间设为下午*/
    if (self.isFirstTimeSolveContext == YES && checkTimeIndex == 3 && [_tpOrigin.tunit[checkTimeIndex] integerValue] >= 12 && [_tp.tunit[checkTimeIndex] integerValue]< 12) {
        _tp.tunit[checkTimeIndex] = @([_tp.tunit[checkTimeIndex] integerValue] + 12);
    }
    self.isFirstTimeSolveContext = NO;
}

/**
 * 如果用户选项是倾向于未来时间，检查checkTimeIndex所指的时间是否是过去的时间，如果是的话，将大一级的时间设为当前时间的+1。
 * <p>
 * 如在晚上说“早上8点看书”，则识别为明天早上;
 * 12月31日说“3号买菜”，则识别为明年1月的3号。
 *
 * @param checkTimeIndex _tp.tunit时间数组的下标
 */
- (void)p_preferFuture:(NSInteger)checkTimeIndex {
    /**1. 检查被检查的时间级别之前，是否没有更高级的已经确定的时间，如果有，则不进行处理.*/
    for (int i = 0; i < checkTimeIndex; i++) {
        if ([_tp.tunit[i] integerValue] != -1) return;
    }
    /**2. 根据上下文补充时间*/
    [self p_checkContextTime:checkTimeIndex];
    /**3. 根据上下文补充时间后再次检查被检查的时间级别之前，是否没有更高级的已经确定的时间，如果有，则不进行倾向处理.*/
    for (int i = 0; i < checkTimeIndex; i++) {
        if ([_tp.tunit[i] integerValue] != -1) return;
    }
    /**4. 确认用户选项*/
    if (!self.normalizer.isPreferFuture) {
        return;
    }
    /**5. 获取当前时间，如果识别到的时间小于当前时间，则将其上的所有级别时间设置为当前时间，并且其上一级的时间步长+1*/
    NSDate* date = [self p_now];
    if (self.normalizer.timeBase.length > 0) {
        date = [NSDate ng_fs_dateFromString:self.normalizer.timeBase format:@"yyyy-MM-dd-HH-mm-ss"];
    }
    NSInteger curTime = [date ng_fs_valueBy:checkTimeIndex];
    
    if (curTime <= [_tp.tunit[checkTimeIndex] integerValue]) {
        return;
    }
    //准备增加的时间单位是被检查的时间的上一级，将上一级时间+1
    if ([_tp.tunit[checkTimeIndex] integerValue] != -1) {
        date = [date ng_fs_dateByAddingValue:1 byIndex:checkTimeIndex - 1];
        
        for (int i = 0; i < checkTimeIndex; i++) {
            _tp.tunit[i] = @([date ng_fs_valueBy:i]);
        }
    }
}

/**
 * 如果用户选项是倾向于未来时间，检查所指的day_of_week是否是过去的时间，如果是的话，设为下周。
 * <p>
 * 如在周五说：周一开会，识别为下周一开会
 *
 * @param weekday 识别出是周几（范围1-7）
 */
- (NSDate*)p_preferFutureWeek:(NSInteger)weekday date:(NSDate*)date {
    /**1. 确认用户选项*/
    if (!self.normalizer.isPreferFuture) {
        return date;
    }
    /**2. 检查被检查的时间级别之前，是否没有更高级的已经确定的时间，如果有，则不进行倾向处理.*/
    int checkTimeIndex = 2;
    for (int i = 0; i < checkTimeIndex; i++) {
        if ([_tp.tunit[i] integerValue] != -1) return date;
    }
    /**获取当前是在周几，如果识别到的时间小于当前时间，则识别时间为下一周*/
    NSDate* curDate = [self p_now];
    if (self.normalizer.timeBase.length > 0) {
        curDate = [NSDate ng_fs_dateFromString:self.normalizer.timeBase format:@"yyyy-MM-dd-HH-mm-ss"];
    }
    NSInteger curWeekday = [curDate ng_fs_weekday] - 1;
    curWeekday = curWeekday == 0 ? 7 : curWeekday;
    if (curWeekday <= weekday || date.timeIntervalSince1970 > curDate.timeIntervalSince1970) {
        return date;
    }
    //准备增加的时间单位是被检查的时间的上一级，将上一级时间+1
    return [date ng_fs_dateByAddingWeeks:1];
}

- (NSDate*)p_now {
    if (self.normalizer.timeBase.length > 0) {
        return [NSDate ng_fs_dateFromString:self.normalizer.timeBase format:@"yyyy-MM-dd-HH-mm-ss"];
    }
    else {
        return [NSDate date];
    }
}
@end

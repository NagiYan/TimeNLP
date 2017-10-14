//
//  NSDate+NGFSExtension.h
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (NGFSExtension)

///MARK: - date part
@property (readonly, nonatomic) NSInteger ng_fs_year;
@property (readonly, nonatomic) NSInteger ng_fs_month;
@property (readonly, nonatomic) NSInteger ng_fs_day;
@property (readonly, nonatomic) NSInteger ng_fs_weekday;
@property (readonly, nonatomic) NSInteger ng_fs_weekOfYear;
@property (readonly, nonatomic) NSInteger ng_fs_hour;
@property (readonly, nonatomic) NSInteger ng_fs_minute;
@property (readonly, nonatomic) NSInteger ng_fs_second;
@property (readonly, nonatomic) NSInteger ng_fs_numberOfDaysInMonth;

- (NSInteger)ng_fs_yearsFrom:(NSDate *)date;
- (NSInteger)ng_fs_monthsFrom:(NSDate *)date;
- (NSInteger)ng_fs_weeksFrom:(NSDate *)date;
- (NSInteger)ng_fs_daysFrom:(NSDate *)date;
- (NSInteger)ng_fs_valueBy:(NSInteger)index;

///MARK: - change date part

- (NSDate*)ng_fs_setYear:(NSInteger)year;
- (NSDate*)ng_fs_setMonth:(NSInteger)month;
- (NSDate*)ng_fs_setDay:(NSInteger)day;
- (NSDate*)ng_fs_setHour:(NSInteger)hour;
- (NSDate*)ng_fs_setMinute:(NSInteger)minute;
- (NSDate*)ng_fs_setSecond:(NSInteger)second;

///MARK: - related date
@property (readonly, nonatomic) NSDate *ng_fs_dateByIgnoringTimeComponents;
@property (readonly, nonatomic) NSDate *ng_fs_firstDayOfMonth;
@property (readonly, nonatomic) NSDate *ng_fs_lastDayOfMonth;
@property (readonly, nonatomic) NSDate *ng_fs_firstDayOfWeek;
@property (readonly, nonatomic) NSDate *ng_fs_middleOfWeek;
@property (readonly, nonatomic) NSDate *ng_fs_tomorrow;
@property (readonly, nonatomic) NSDate *ng_fs_yesterday;

- (NSDate *)ng_fs_dateByAddingYears:(NSInteger)years;
- (NSDate *)ng_fs_dateBySubtractingYears:(NSInteger)years;
- (NSDate *)ng_fs_dateByAddingMonths:(NSInteger)months;
- (NSDate *)ng_fs_dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)ng_fs_dateByAddingWeeks:(NSInteger)weeks;
- (NSDate *)ng_fs_dateBySubtractingWeeks:(NSInteger)weeks;
- (NSDate *)ng_fs_dateByAddingDays:(NSInteger)days;
- (NSDate *)ng_fs_dateBySubtractingDays:(NSInteger)days;

- (NSDate *)ng_fs_dateByAddingValue:(NSInteger)value byIndex:(NSInteger)index;
- (NSDate *)ng_fs_dateBySubtractingValue:(NSInteger)value byIndex:(NSInteger)index;

///MARK: - build date
+ (instancetype)ng_fs_dateFromString:(NSString *)string format:(NSString *)format;
+ (instancetype)ng_fs_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

///MARK: - other

- (BOOL)ng_fs_isEqualToDateForMonth:(NSDate *)date;
- (BOOL)ng_fs_isEqualToDateForWeek:(NSDate *)date;
- (BOOL)ng_fs_isEqualToDateForDay:(NSDate *)date;

- (NSString *)ng_fs_stringWithFormat:(NSString *)format;
- (NSString *)ng_fs_string;
// 星座
- (NSString*)ng_constellation;
// 生肖
- (NSString*)ng_zodiac;

@end


@interface NSCalendar (NGFSExtension)

+ (instancetype)ng_fs_sharedCalendar;

@end

@interface NSDateFormatter (NGFSExtension)

+ (instancetype)ng_fs_sharedDateFormatter;

@end

@interface NSDateComponents (NGFSExtension)

+ (instancetype)ng_fs_sharedDateComponents;

@end




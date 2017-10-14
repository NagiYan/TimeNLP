//
//  NSDate+NGFSExtension.m
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import "NSDate+NGFSExtension.h"

@implementation NSDate (NGFSExtension)

- (NSInteger)ng_fs_year
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitYear fromDate:self];
    return component.year;
}

- (NSInteger)ng_fs_month
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitMonth
                                              fromDate:self];
    return component.month;
}

- (NSInteger)ng_fs_day
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay
                                              fromDate:self];
    return component.day;
}

- (NSInteger)ng_fs_weekday
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return component.weekday;
}

- (NSInteger)ng_fs_weekOfYear
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitWeekOfYear fromDate:self];
    return component.weekOfYear;
}

- (NSInteger)ng_fs_hour
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitHour
                                              fromDate:self];
    return component.hour;
}

- (NSInteger)ng_fs_minute
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitMinute
                                              fromDate:self];
    return component.minute;
}

- (NSInteger)ng_fs_second
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitSecond
                                              fromDate:self];
    return component.second;
}

- (NSInteger)ng_fs_valueBy:(NSInteger)index {
    switch (index) {
        case 0:
            return [self ng_fs_year];
        case 1:
            return [self ng_fs_month];
        case 2:
            return [self ng_fs_day];
        case 3:
            return [self ng_fs_hour];
        case 4:
            return [self ng_fs_minute];
        case 5:
            return [self ng_fs_second];
        default:
            break;
    }
    return 0;
}

- (NSDate *)ng_fs_dateByIgnoringTimeComponents
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDate *)ng_fs_firstDayOfMonth
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth| NSCalendarUnitDay fromDate:self];
    components.day = 1;
    return [calendar dateFromComponents:components];
}

- (NSDate *)ng_fs_lastDayOfMonth
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    components.month++;
    components.day = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate *)ng_fs_firstDayOfWeek
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *componentsToSubtract = [NSDateComponents ng_fs_sharedDateComponents];
    componentsToSubtract.day = - (weekdayComponents.weekday - calendar.firstWeekday);
    NSDate *beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:beginningOfWeek];
    beginningOfWeek = [calendar dateFromComponents:components];
    componentsToSubtract.day = NSIntegerMax;
    return beginningOfWeek;
}

- (NSDate *)ng_fs_middleOfWeek
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSDateComponents *componentsToSubtract = [NSDateComponents ng_fs_sharedDateComponents];
    componentsToSubtract.day = - (weekdayComponents.weekday - calendar.firstWeekday) + 3;
    NSDate *middleOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:middleOfWeek];
    middleOfWeek = [calendar dateFromComponents:components];
    componentsToSubtract.day = NSIntegerMax;
    return middleOfWeek;
}

- (NSDate *)ng_fs_tomorrow
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    components.day++;
    return [calendar dateFromComponents:components];
}

- (NSDate *)ng_fs_yesterday
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    components.day--;
    return [calendar dateFromComponents:components];
}

- (NSInteger)ng_fs_numberOfDaysInMonth
{
    NSCalendar *c = [NSCalendar ng_fs_sharedCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:self];
    return days.length;
}

+ (instancetype)ng_fs_dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *formatter = [NSDateFormatter ng_fs_sharedDateFormatter];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

+ (instancetype)ng_fs_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.year = year;
    components.month = month;
    components.day = day;
    NSDate *date = [calendar dateFromComponents:components];
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    return date;
}

- (NSDate *)ng_fs_dateByAddingYears:(NSInteger)years
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.year = years;
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    components.year = NSIntegerMax;
    return date;
}

- (NSDate *)ng_fs_dateBySubtractingYears:(NSInteger)years
{
    return [self ng_fs_dateByAddingYears:-years];
}

- (NSDate *)ng_fs_dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.month = months;
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    components.month = NSIntegerMax;
    return date;
}

- (NSDate *)ng_fs_dateBySubtractingMonths:(NSInteger)months
{
    return [self ng_fs_dateByAddingMonths:-months];
}

- (NSDate *)ng_fs_dateByAddingWeeks:(NSInteger)weeks
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.weekOfYear = weeks;
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    components.weekOfYear = NSIntegerMax;
    return date;
}

-(NSDate *)ng_fs_dateBySubtractingWeeks:(NSInteger)weeks
{
    return [self ng_fs_dateByAddingWeeks:-weeks];
}

- (NSDate *)ng_fs_dateByAddingDays:(NSInteger)days
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.day = days;
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    components.day = NSIntegerMax;
    return date;
}

- (NSDate *)ng_fs_dateBySubtractingDays:(NSInteger)days
{
    return [self ng_fs_dateByAddingDays:-days];
}

- (NSDate *)ng_fs_dateByAddingHours:(NSInteger)hours
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.hour = hours;
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    components.hour = NSIntegerMax;
    return date;
}

- (NSDate *)ng_fs_dateBySubtractingHours:(NSInteger)hours
{
    return [self ng_fs_dateByAddingHours:-hours];
}

- (NSDate *)ng_fs_dateByAddingMinutes:(NSInteger)minutes
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.minute = minutes;
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    components.minute = NSIntegerMax;
    return date;
}

- (NSDate *)ng_fs_dateBySubtractingMinutes:(NSInteger)minutes
{
    return [self ng_fs_dateByAddingMinutes:-minutes];
}

- (NSDate *)ng_fs_dateByAddingSeconds:(NSInteger)seconds
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.second = seconds;
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    components.second = NSIntegerMax;
    return date;
}

- (NSDate *)ng_fs_dateBySubtractingSeconds:(NSInteger)seconds
{
    return [self ng_fs_dateByAddingSeconds:-seconds];
}

- (NSDate *)ng_fs_dateByAddingValue:(NSInteger)value byIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [self ng_fs_dateByAddingYears:value];
        case 1:
            return [self ng_fs_dateByAddingMonths:value];
        case 2:
            return [self ng_fs_dateByAddingDays:value];
        case 3:
            return [self ng_fs_dateByAddingHours:value];
        case 4:
            return [self ng_fs_dateByAddingMinutes:value];
        case 5:
            return [self ng_fs_dateByAddingSeconds:value];
        default:
            break;
    }
    return self;
}
- (NSDate *)ng_fs_dateBySubtractingValue:(NSInteger)value byIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [self ng_fs_dateBySubtractingYears:value];
        case 1:
            return [self ng_fs_dateBySubtractingMonths:value];
        case 2:
            return [self ng_fs_dateBySubtractingDays:value];
        case 3:
            return [self ng_fs_dateBySubtractingHours:value];
        case 4:
            return [self ng_fs_dateBySubtractingMinutes:value];
        case 5:
            return [self ng_fs_dateBySubtractingSeconds:value];
        default:
            break;
    }
    return self;
}

- (NSInteger)ng_fs_yearsFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    return components.year;
}

- (NSInteger)ng_fs_monthsFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth
                                               fromDate:date
                                                 toDate:self
                                                    options:0];
    return components.month;
}

- (NSInteger)ng_fs_weeksFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    return components.weekOfYear;
}

- (NSInteger)ng_fs_daysFrom:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:date
                                                 toDate:self
                                                options:0];
    return components.day;
}

- (NSString *)ng_fs_stringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [NSDateFormatter ng_fs_sharedDateFormatter];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSString *)ng_fs_string
{
    return [self ng_fs_stringWithFormat:@"yyyyMMdd"];
}

- (NSDate*)ng_fs_setYear:(NSInteger)year {
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.year = year;
    components.month = self.ng_fs_month;
    components.day = self.ng_fs_day;
    components.hour = self.ng_fs_hour;
    components.minute = self.ng_fs_minute;
    components.second = self.ng_fs_second;
    
    NSDate *date = [calendar dateFromComponents:components];
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    components.day = NSIntegerMax;
    components.hour = NSIntegerMax;
    components.minute = NSIntegerMax;
    components.second = NSIntegerMax;
    return date;
}

- (NSDate*)ng_fs_setMonth:(NSInteger)month {
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.year = self.ng_fs_year;
    components.month = month;
    components.day = self.ng_fs_day;
    components.hour = self.ng_fs_hour;
    components.minute = self.ng_fs_minute;
    components.second = self.ng_fs_second;
    
    NSDate *date = [calendar dateFromComponents:components];
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    components.day = NSIntegerMax;
    components.hour = NSIntegerMax;
    components.minute = NSIntegerMax;
    components.second = NSIntegerMax;
    return date;
}

- (NSDate*)ng_fs_setDay:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.year = self.ng_fs_year;
    components.month = self.ng_fs_month;
    components.day = day;
    components.hour = self.ng_fs_hour;
    components.minute = self.ng_fs_minute;
    components.second = self.ng_fs_second;
    
    NSDate *date = [calendar dateFromComponents:components];
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    components.hour = NSIntegerMax;
    components.minute = NSIntegerMax;
    components.second = NSIntegerMax;
    return date;
}

- (NSDate*)ng_fs_setHour:(NSInteger)hour {
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.year = self.ng_fs_year;
    components.month = self.ng_fs_month;
    components.day = self.ng_fs_day;
    components.hour = hour;
    components.minute = self.ng_fs_minute;
    components.second = self.ng_fs_second;
    
    NSDate *date = [calendar dateFromComponents:components];
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    components.hour = NSIntegerMax;
    components.minute = NSIntegerMax;
    components.second = NSIntegerMax;
    return date;
}

- (NSDate*)ng_fs_setMinute:(NSInteger)minute {
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.year = self.ng_fs_year;
    components.month = self.ng_fs_month;
    components.day = self.ng_fs_day;
    components.hour = self.ng_fs_hour;
    components.minute = minute;
    components.second = self.ng_fs_second;
    
    NSDate *date = [calendar dateFromComponents:components];
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    components.hour = NSIntegerMax;
    components.minute = NSIntegerMax;
    components.second = NSIntegerMax;
    return date;
}

- (NSDate*)ng_fs_setSecond:(NSInteger)second {
    NSCalendar *calendar = [NSCalendar ng_fs_sharedCalendar];
    NSDateComponents *components = [NSDateComponents ng_fs_sharedDateComponents];
    components.year = self.ng_fs_year;
    components.month = self.ng_fs_month;
    components.day = self.ng_fs_day;
    components.hour = self.ng_fs_hour;
    components.minute = self.ng_fs_minute;
    components.second = second;
    
    NSDate *date = [calendar dateFromComponents:components];
    components.year = NSIntegerMax;
    components.month = NSIntegerMax;
    components.day = NSIntegerMax;
    components.hour = NSIntegerMax;
    components.minute = NSIntegerMax;
    components.second = NSIntegerMax;
    return date;
}

- (BOOL)ng_fs_isEqualToDateForMonth:(NSDate *)date
{
    return self.ng_fs_year == date.ng_fs_year && self.ng_fs_month == date.ng_fs_month;
}

- (BOOL)ng_fs_isEqualToDateForWeek:(NSDate *)date
{
    return self.ng_fs_year == date.ng_fs_year && self.ng_fs_weekOfYear == date.ng_fs_weekOfYear;
}

- (BOOL)ng_fs_isEqualToDateForDay:(NSDate *)date
{
    return self.ng_fs_year == date.ng_fs_year && self.ng_fs_month == date.ng_fs_month && self.ng_fs_day == date.ng_fs_day;
}

// 星座
- (NSString*)ng_constellation {
    NSArray* constellationArray = @[@"水瓶座", @"双鱼座", @"牡羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座",
        @"天蝎座", @"射手座", @"魔羯座"];
    NSInteger constellationEdgeDay[] = { 20, 19, 21, 21, 21, 22, 23, 23, 23, 23, 22, 22 };
    
    NSInteger month = [self ng_fs_month];
    NSInteger day = [self ng_fs_day];
    if (day < constellationEdgeDay[month]) {
        --month;
    }
    if (month >= 0) {
        return constellationArray[month];
    }
    
    return constellationArray[11];
}

// 生肖
- (NSString*)ng_zodiac {
    NSArray* zodiacArray = @[@"猴", @"鸡", @"狗", @"猪", @"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊"];
    return zodiacArray[([self ng_fs_year] % 12)];
}

@end


@implementation NSCalendar (NGFSExtension)

+ (instancetype)ng_fs_sharedCalendar
{
    static id instance;
    static dispatch_once_t ng_fs_sharedCalendar_onceToken;
    dispatch_once(&ng_fs_sharedCalendar_onceToken, ^{
        instance = [NSCalendar currentCalendar];
    });
    return instance;
}

@end


@implementation NSDateFormatter (NGFSExtension)

+ (instancetype)ng_fs_sharedDateFormatter
{
    static id instance;
    static dispatch_once_t ng_fs_sharedDateFormatter_onceToken;
    dispatch_once(&ng_fs_sharedDateFormatter_onceToken, ^{
        instance = [[NSDateFormatter alloc] init];
    });
    return instance;
}

@end

@implementation NSDateComponents (NGFSExtension)

+ (instancetype)ng_fs_sharedDateComponents
{
    static id instance;
    static dispatch_once_t ng_fs_sharedDateFormatter_onceToken;
    dispatch_once(&ng_fs_sharedDateFormatter_onceToken, ^{
        instance = [[NSDateComponents alloc] init];
    });
    return instance;
}

@end



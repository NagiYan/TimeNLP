//
//  ViewController.m
//  TimeNLP
//
//  Created by NAGI on 2017/10/13.
//  Copyright © 2017年 NAGI. All rights reserved.
//

#import "ViewController.h"
#import "TimeNormalizer.h"
#import "NSDate+NGFSExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self test:@"2018.03.01下午4点10分 \n 2018.04.02"];
    [self test:@"2018年2月15号从北京起飞，2018年3月12号从北京落地。2018.2.15从北京起飞，2018.2.16阔地2018.3.16非礼你魔攻我给你2018.9.5kilogram2018.6.465doing哦"];
    [self test:@"25号北京飞上海，11月26日落地。"];
    [self test:@"今天17点35"];
    [self test:@"2"];
    [self test:@"月"];
    [self test:@"12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"];
    [self test:@"1分钟后"];
    [self test:@"明天早上跑步"];
    [self test:@"2017-11-23 18:18:12"];
    [self test:@"去年今天"];
    [self test:@"下午4点钟"];
    [self test:@"2016-06-09"];
    [self test:@"下月1号下午3点至5点到图书馆还书"];
    [self test:@"6月3  春游"];
    [self test:@"17年12月8日到明年1月半"];
    [self test:@"去年11月起正式实施的刑法修正案（九）中明确，在法律规定的国家考试中，组织作弊的将入刑定罪，最高可处七年有期徒刑。另外，本月刚刚开始实施的新版《教育法》"];
    [self test:@"《辽宁日报》今日报道，6月3日辽宁召开省委常委扩大会，会议从下午两点半开到六点半，主要议题为：落实中央巡视整改要求。2017-12-07-00-00-00"];
    [self test:@"昨天上午，第八轮中美战略与经济对话气候变化问题特别联合会议召开。中国气候变化事务特别代表解振华表示，今年中美两国在应对气候变化多边进程中政策对话的重点任务，是推动《巴黎协定》尽早生效。 2016-06-07-00-00-00"];
    [self test:@"周四下午三点到五点开会"];
    [self test:@"6-3 春游"];
    [self test:@"6:30 起床"];
    [self test:@"下下周一开会"];
    [self test:@"早上六点起床"];
    [self test:@"下周一下午三点开会"];
    [self test:@"我真的啊 本周日到下周日出差"];
}

- (void)test:(NSString*)content {
    TimeNormalizer* normalizer = [TimeNormalizer new];
    //normalizer.timeBase = @"2017-10-09-10-00-00";
    NSArray<TimeUnit*>* times = [normalizer parse:content];// 抽取时间
    NSLog(@"# %@\n\n", content);
    [times enumerateObjectsUsingBlock:^(TimeUnit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"全天:%@ %@ %@", obj.isAllDayTime?@"是":@"否" , obj.timeExpression, [obj.time ng_fs_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

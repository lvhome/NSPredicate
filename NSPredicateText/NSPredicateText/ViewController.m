//
//  ViewController.m
//  NSPredicateText
//
//  Created by MAC on 2018/11/9.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //正则表达的使用
    NSLog(@"不是手机号--%d",[self isValidateMobile:@"123456778"]);
    NSLog(@"是手机号--%d",[self isValidateMobile:@"13534645632"]);
   //把程序中的一个数组中符合数组中内容的元素过滤出来。
    [self getArray];
    //和match混合使用 比较问题
    [self compare];
    //其它字符串的使用 BEGINSWITH、ENDSWITH、CONTAINS  IN、BETWEEN
    [self otherUser];
}


- (void)getArray {
    NSArray * array = [NSArray arrayWithObjects:@"a", @"b",@"c", @"v", nil];
    NSArray * array1 = [NSArray arrayWithObjects:@"a1", @"b", @"c", @"ab", nil];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", array];
    NSLog(@"predicate --- %@",[array1 filteredArrayUsingPredicate:predicate]);
}


/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以1开头，9个 \d 数字字符^1[3|4|5|8] \d{9}$
    NSString *phoneRegex = @"^(0|86|17951)?(19[0-9]|16[0-9]|13[0-9]|15[0-9]|17[0-9]|18[0-9]|14[0-9])[0-9]{8}$";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


- (void) compare {
    //字符串本身:SELF  >,<,==,>=,<=,!=  使用 其它的和 == 用法相同
    NSArray * array = [NSArray arrayWithObjects:@"aT", @"bT",@"c", @"v", @"q", @"w",@"et", @"rt",@"T", @"T",@"ut", @"i",nil];
    NSString * match = @"w";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF == %@", match];
    NSLog(@"SELF == %@",[array filteredArrayUsingPredicate:predicate]);
    //match里通配符：LIKE的用法
    NSString * match1 = @"et";
    NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF like %@", match1];
    NSLog(@"SELF like %@",[array filteredArrayUsingPredicate:predicate1]);

    //大小写比较  注:［c］表示忽略大小写，[d]不区分发音符号即没有重音符号 [cd]既不区分大小写，也不区分发音符号。如下：
    NSString * match2 = @"T";
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF like[cd] %@", match2];
    NSLog(@"SELF like[cd] %@",[array filteredArrayUsingPredicate:predicate2]);
    
    // evaluateWithObject 根据单个对象评估谓词    看下数组array中是否还有T
    NSLog(@"%d", [predicate2 evaluateWithObject:@"T"]);  // 输出1

}

-(void)otherUser {
    //字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
    /*
     例：@"'anging' CONTAINS[cd] 'ang'"  //包含某个字符串
        @"'shing' BEGINSWITH[cd] 'sh'"  //以某个字符串开头
        @"'tching' ENDSWITH[cd] 'ng'"   //以某个字符串结束
   */
    NSArray * array = [NSArray arrayWithObjects:@"anging",@"shing",@"tching",@"angingshingtching", nil];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",@"an"];
    NSLog(@"contain ---%@",[array filteredArrayUsingPredicate:predicate]);
    
    NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@",@"sh"];
    NSLog(@"beginswith --- %@",[array filteredArrayUsingPredicate:predicate1]);
    
    NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] %@",@"ng"];
    NSLog(@"endswith --- %@",[array filteredArrayUsingPredicate:predicate2]);
    
    //范围运算符：IN、BETWEEN
    NSPredicate * predicate3 = [NSPredicate predicateWithFormat:@"SELF IN 'anging'"];
    NSLog(@"in --- %@",[array filteredArrayUsingPredicate:predicate3]);
    
    NSPredicate * predicate4 = [NSPredicate predicateWithFormat:@"SELF BETWEEN {'shing','anging'}"];
    NSLog(@"between --- %@",[array filteredArrayUsingPredicate:predicate4]);
    NSLog(@"---------%d", [predicate4 evaluateWithObject:@"shing"]);  // 输出1

    //常量和占位符：%@ 、SELF
    // 比如在name BEGINSWITH 'Zhang'这个格式化字符串里，name为属性，Zhang为常量
    NSString * t_ng = @"ng";
    // 上面的例子大都是把常量硬编码在字符串里，但是我们的实际开发中会更多的用到占位符
    // 需要注意的是，在%@作为占位符时，它会被自动加上引号
    // 所以%@只能作为常量的占位符。
    // 当我们想动态的填入属性名的时候，我们就必须这样写：
    [NSPredicate predicateWithFormat:@"ng BEGINSWITH %@", t_ng];
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

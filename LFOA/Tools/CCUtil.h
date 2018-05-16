//
//  ZEUtil.h
//  NewCentury
//
//  Created by Stenson on 16/1/20.
//  Copyright © 2016年 Stenson. All rights reserved.
//


@interface CCUtil : NSObject
// 检查对象是否为空
+ (BOOL)isNotNull:(id)object;

// 检查字符串是否为空
+ (BOOL)isStrNotEmpty:(NSString *)str;

// 计算文字高度
+ (double)heightForString:(NSString *)str font:(UIFont *)font andWidth:(float)width;

+ (double)widthForString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
//  MD5
+ (NSString*)getmd5WithString:(NSString *)string;
// 根据颜色生成图片
+ (UIImage *)imageFromColor:(UIColor *)color;

//  年月日格式化
+ (NSString *)formatDate:(NSString *)date;

// 包含小时 分钟 格式化
+ (NSString *)formatContainTime:(NSString *)date;

+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 *  @author Stenson, 16-07-28 16:07:44
 *
 *  比较当前时间是多少分钟前
 *
 *  @param str 传入时间
 *
 *  @return 返回时间是多少分钟前
 */
+ (NSString *) compareCurrentTime:(NSString *)str;

+(NSString *)getCurrentDate:(NSString *)dateFormatter;

//  字典转换Json格式
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

// json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(UIViewController *)getCurrentVC;

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

/**
 *  改变  “\\” === >  "/"
 */
+(NSString *)changeURLStrFormat:(NSString *)str;


/**
 四舍五入

 @param format format description
 @param floatV <#floatV description#>

 @return <#return value description#>
 */
+(NSString *)notRounding:(float)price afterPoint:(int)position;

#pragma mark - 输入全部为空格判断
+ (BOOL) isEmpty:(NSString *) str ;

#pragma mark - 输入是否包含表情
+(BOOL)isContainsTwoEmoji:(NSString *)string;

#pragma mark - 输入字符长度 一个汉字 = 两个英文字符
+(NSInteger)sinaCountWord:(NSString *)s;

#pragma mark - 正则表达式判断链接位置
+ (NSRange)getRangeOfURL:(NSString *)string;
@end

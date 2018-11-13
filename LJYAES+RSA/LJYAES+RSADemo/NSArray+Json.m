//
//  NSArray+Json.m
//  HY
//
//  Created by 李军禹 on 2018/7/19.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "NSArray+Json.h"

@implementation NSArray (Json)

-(NSString *)arrayToJSONString
{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
//
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return jsonString;
}
@end

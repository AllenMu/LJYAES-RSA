//
//  NSDictionary+JSON.h
//  HY
//
//  Created by 李军禹 on 2018/7/16.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

-(NSString *)toJSONString;

-(NSString *)toReadableJSONString;

-(NSData *)toJSONData;


@end

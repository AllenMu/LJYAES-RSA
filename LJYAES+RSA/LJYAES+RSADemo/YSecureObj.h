//
//  YSecureObj.h
//  HY
//
//  Created by 李军禹 on 2018/7/17.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSecureObj : NSObject

//HTTPS

+(NSString *)dencode:(NSString *)base64String;

+(NSString *)encode:(NSString *)string;

+(NSString *)randomStringWithLength:(NSInteger)len;

@end

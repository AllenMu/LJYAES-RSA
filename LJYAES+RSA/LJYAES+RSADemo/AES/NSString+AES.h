//
//  NSString+AES.h
//  
//
//  Created by Bear on 16/11/26.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)

/**< 加密方法 */
- (NSString*)aci_encryptWithAESWithKey:(NSString *)strKey;

/**< 解密方法 */
- (NSString*)aci_decryptWithAESWithKey:(NSString *)strKey;

@end

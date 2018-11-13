//
//  ViewController.m
//  LJYAES+RSADemo
//
//  Created by 李军禹 on 2018/10/25.
//  Copyright © 2018年 AllenLi. All rights reserved.
//

#import "ViewController.h"

#import "HBRSAHandler.h"
#import "NSArray+Json.h"
#import "YSecureObj.h"
#import "NSDictionary+JSON.h"
#import "NSString+AES.h"

@interface ViewController ()
{
    HBRSAHandler* _handler;
    NSDictionary *_dicDataResult;
}
@property (weak, nonatomic) IBOutlet UITextField *TFKey;
@property (weak, nonatomic) IBOutlet UITextField *TFValue;
@property (weak, nonatomic) IBOutlet UILabel *labelEncrypt;
@property (weak, nonatomic) IBOutlet UILabel *labelDecrypt;

@end

@implementation ViewController


#define ClientPrivateKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAPd4n+alSp0WM9d7MCMy5Yry0nnvQGvl5hGzg9J8zAl8md0LcktX+r0pM2uCvCF9MqJsrGh9ejup/purcmwpJIjQZmkJRGselsPuywskbLchvTEN+YcYwUodJvLlXhqacHECICW5hLvdGBFhEgTKFLSMF9HE8uuEP3QmRmkBBSefAgMBAAECgYAkC9PuuqDVpMhEWNM4LU+2H4x86laN4NzUMzu+SyNFNnsK8YHia5xANWIiBNb2YdAgTIgIaE6HpklJz31JN+z0H2HQpBNaiwAe40/YgZ6ZHN9XmFSsj1ls37owmdEdC70gM4GHkDy4Cv1xgxyo6oWyoqDDcP85bktQKQ3U4dw6EQJBAP89Dc3fUPqFkIdIZYySC3pfMZU+nZly+7hm/yXrZNmG8yriI34N/ISzAw3fFlB4kfGc02ZEsGjfzzRqx+QWXAMCQQD4NaNfwnbQDpNfZEtW+tT3ihLJ+t/zGrQN/lIlM47z3FpDid+k2V/vtoOcI1Kv7PxaWVzT2vN2o/aRQu6fuAk1AkEAop8n2G/cjIHlIAzEhtfWcFWOpeSLTWWxdEBLeMGOM/qDnGMQ8hO/PF1CKOhms0be1e5x0ssZCvjucBtI2M5WOQJBANC6CpFUryV3nGbzqIeUl9MywWopFnsRUakS3XF7UhOwkheJshCm3A5xpWuAKODYob44t99QmLyEVa0CZDjcQqECQQDCBDwiPkQ6tMgQGwVvn+iYmkf/mOUroSp+CfFaSyinl0I1cdBdWL7lX9OeZBjimNFRGPXTQfqTgp7F47JotE28"
#define ClientPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD3eJ/mpUqdFjPXezAjMuWK8tJ570Br5eYRs4PSfMwJfJndC3JLV/q9KTNrgrwhfTKibKxofXo7qf6bq3JsKSSI0GZpCURrHpbD7ssLJGy3Ib0xDfmHGMFKHSby5V4amnBxAiAluYS73RgRYRIEyhS0jBfRxPLrhD90JkZpAQUnnwIDAQAB"

#define ServerPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCHV00bhSOJmtC9nzYHhBdaHRRb89BKvtwccC48m25Fd4foHJDX8nh7jniwmp7OZvwA8OACchLL/rAm7weU70oqrkrDPxKVcbEIzwZ7vyOPPz314LwHeqnk5SkFlqJlOPoHrNJc6ydR9qcsvUuEb6fHqtbqlMGSNUr72xBIIyRDywIDAQAB"



//#define ClientPrivateKey @""
//#define ClientPublicKey @""
//
//#define ServerPublicKey @""


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    
    
}

- (NSArray *)arrValueSortedDictionary:(NSDictionary *)dict{
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    
    
//    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
//    NSLog(@"valueArray:%@",valueArray);
    return valueArray;
    
}
- (IBAction)btnEncrypt:(id)sender
{
    if(_TFKey.text.length == 0)
    {
        _labelEncrypt.text = @"请输入参数Key";
        return;
    }
    if (_TFValue.text.length == 0)
    {
        _labelEncrypt.text = @"请输入参数value";
        return;
    }
    NSDictionary *dicParam = @{_TFKey.text:_TFValue.text};
    
    NSArray *arrValueWithOrder = [self arrValueSortedDictionary:dicParam];
    NSArray *arrKeyWithOrder = [self arrKeySortedDictionary:dicParam];
    
    if (_handler == nil)
    {
        _handler = [HBRSAHandler new];
        //此处应为客户端私钥和服务器公钥，使用客户端私钥仅用来此处测试解密
        [_handler importKeyWithType:KeyTypePrivate andkeyString:ClientPrivateKey];
//        [_handler importKeyWithType:KeyTypePublic andkeyString:ServerPublicKey];
        [_handler importKeyWithType:KeyTypePublic andkeyString:ClientPublicKey];
    }
    
    NSMutableString *strValues = [[NSMutableString alloc] initWithString:@""];
    for (int a = 0; a < arrValueWithOrder.count; a++)
    {
        NSString *strThis = arrValueWithOrder[a];
        if ([strThis isKindOfClass:[NSString class]])
        {
            [strValues appendString:strThis];
        }
        else if([strThis isKindOfClass:[NSNumber class]])
        {
            NSNumber *numThis = arrValueWithOrder[a];
            NSNumber *numBOOL = [NSNumber numberWithBool:YES];
            if([numBOOL isKindOfClass:[numThis class]])
            {
                if([numThis boolValue])
                {
                    [strValues appendString:@"true"];
                }
                else
                {
                    [strValues appendString:@"false"];
                }
            }
            else
            {
                [strValues appendFormat:@"%@",numThis];
            }
        }
        else if ([strThis isKindOfClass:[NSArray class]])
        {
            NSArray *arrThis = arrValueWithOrder[a];
            NSString *strArrToJson = [arrThis arrayToJSONString];
            [strValues appendString:strArrToJson];
        }
    }
    
    NSString *strValuesNew = [strValues stringByReplacingOccurrencesOfString:@"\\/" withString:@"\/"];
    
    
    NSString* sign = [_handler signString:strValues];
    
    NSMutableDictionary *dicParamAndSign = [[NSMutableDictionary alloc] initWithDictionary:dicParam];
    [dicParamAndSign setObject:sign forKey:@"sign"];
    
    
    NSString *strJsonNew = [dicParamAndSign toJSONString];
    
    
    if (@available(iOS 11.0,*))
    {
        
    }
    else
    {
        
        NSMutableDictionary *dicForKeyOrder = [[NSMutableDictionary alloc] init];
        NSMutableArray *arrForkeyOrderNum = [[NSMutableArray alloc] init];
        
        for (int a = 0; a < arrKeyWithOrder.count; a ++)
        {
            NSString *strKeyThis = arrKeyWithOrder[a];
            NSRange rangeThis = [strJsonNew rangeOfString:[NSString stringWithFormat:@"\"%@\"",strKeyThis]];
            [dicForKeyOrder setObject:strKeyThis forKey:[NSString stringWithFormat:@"%lu",(unsigned long)rangeThis.location]];
            [arrForkeyOrderNum addObject:@(rangeThis.location)];
        }
        
        
        NSArray *resultKeyOrdersWithOrder = [arrForkeyOrderNum sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2)
                                             
                                             {
                                                 return [obj1 compare:obj2];//升序
                                                 
                                             }];
        
        
        
        
        NSMutableString *strValuesNew2 = [[NSMutableString alloc] init];
        
        for (int a = 0; a < resultKeyOrdersWithOrder.count; a++)
        {
            NSNumber *numOrderThis = resultKeyOrdersWithOrder[a];
            NSString *strKeyThis = dicForKeyOrder[[numOrderThis stringValue]];
            
            
            NSString *strThis = dicParam[strKeyThis];
            if ([strThis isKindOfClass:[NSString class]])
            {
                [strValuesNew2 appendString:strThis];
            }
            else if ([strThis isKindOfClass:[NSArray class]])
            {
                NSArray *arrThis = dicParam[strKeyThis];
                NSString *strArrToJson = [arrThis arrayToJSONString];
                [strValuesNew2 appendString:strArrToJson];
            }
            else
            {
                
                NSNumber *numThis = dicParam[strKeyThis];
                NSNumber *numBOOL = [NSNumber numberWithBool:YES];
                if([numBOOL isKindOfClass:[numThis class]])
                {
                    if([numThis boolValue])
                    {
                        [strValuesNew2 appendString:@"true"];
                    }
                    else
                    {
                        [strValuesNew2 appendString:@"false"];
                    }
                }
                else
                {
                    [strValuesNew2 appendFormat:@"%@",numThis];
                }
                
                
            }
            
            
        }
        
        strJsonNew = [strJsonNew stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSString *strForValuesNew2 = strValuesNew2;
        strForValuesNew2 = [strForValuesNew2 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        NSString* signNew = [_handler signString:strForValuesNew2];
        strJsonNew = [strJsonNew stringByReplacingOccurrencesOfString:sign withString:signNew];
    }
    
    
    NSString *strAESKey = [YSecureObj randomStringWithLength:16];
    NSString *strAESResult = [strJsonNew aci_encryptWithAESWithKey:strAESKey];
    
    NSString *strRSAResultAESKey = [_handler encryptWithPublicKey:strAESKey];
    
    _dicDataResult = @{@"data":strAESResult,@"encryptkey":strRSAResultAESKey};
    
    _labelEncrypt.text = [NSString stringWithFormat:@"@{@\"data\":%@,@\"encryptkey\":%@}",strAESResult,strRSAResultAESKey];
    
}
- (IBAction)btnDecrypt:(id)sender
{
    if (_dicDataResult)
    {
        NSString *strReveiveData = _dicDataResult[@"data"];
        NSString *strReceiveAESKey = [_handler decryptWithPrivatecKey:_dicDataResult[@"encryptkey"]];
        NSString *strAESDataResult = [strReveiveData aci_decryptWithAESWithKey:strReceiveAESKey];
        
        NSDictionary *dic = [self dictionaryWithJsonString:strAESDataResult];
        
//        NSData *jsonData = [strAESDataResult dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                            options:NSJSONReadingMutableContainers
//                                                              error:nil];
        NSMutableDictionary *dicWithOutSign = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [dicWithOutSign removeObjectForKey:@"sign"];
        _labelDecrypt.text = [NSString stringWithFormat:@"%@",dicWithOutSign];
        NSLog(@"%@",dicWithOutSign);
    }
   
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
//        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (NSArray *)arrKeySortedDictionary:(NSDictionary *)dict{
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    
    
    return afterSortKeyArray;
    
}


@end

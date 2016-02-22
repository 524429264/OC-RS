//
//  ViewController.m
//  Test
//
//  Created by NationSky on 16/2/18.
//  Copyright © 2016年 nsky. All rights reserved.
//

#import "ViewController.h"
#import "RSA.h"
#import "NSData+AES128.h"
#import "NSString+Base64.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self testAES];
    
//    [self testBase64];
    

   
    NSString *codeString = @"Hello world";
    
   NSString *hex = [self convertStringToHexStr:codeString];
    
    NSString *code = [self convertHexStrToString:hex];
    NSLog(@"%@   %@",hex,code);
    

}


//将十六进制的字符串转换成NSString则可使用如下方式:
- (NSString *)convertHexStrToString:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    return string;
}


//将NSString转换成十六进制的字符串则可使用如下方式:
- (NSString *)convertStringToHexStr:(NSString *)str {
   if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


- (void)testAES
{
    //密文
    NSString *codeString = @"Hello world";
    NSLog(@"加密串--%@",codeString);
    
    //16位密钥
    NSString *keyString = @"12345678ASDFGHJK";
    
    //加密结果
    NSData *codeData = [codeString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encodeData = [codeData AES128EncryptWithKey:keyString];
    NSLog(@"加密结果--%@",encodeData);
  
    //解密结果
    NSData *decodeData = [encodeData AES128DecryptWithKey:keyString];
    NSString *decodeStr = [[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];
    NSLog(@"解密结果--%@",decodeStr );
}



- (void)testBase64
{
    NSString *codeString = @"Hello world";
    NSLog(@"原文--%@",codeString);

    NSString *base64Str = [codeString base64EncodedString];
    NSLog(@"Base64编码--%@",base64Str);
    
    NSString *decodeStr = [base64Str base64DecodedString];
    NSLog(@"Base64解码--%@",decodeStr);

}


#define PUBLICKEY @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCVzIGr5i8ZEpnX8FrpOKBnxO3HDIa5rZ2rj0OvcwtAUmkqbjjWYRcgW1uf/kqGM1NaI/G2pPIAyl81OVpBMXkv8Gv0ntJ82J6r1Y5oIRD9hISAZ5sd66uqL6w9o1P9jJ/y2gjzKVLL03GXDBlhPG43ZnYP//hSc/rG+8yAuQRxxwIDAQAB-----END PUBLIC KEY-----"
#define PRIVATEKEY @"-----BEGIN RSA PRIVATE KEY-----MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAJXMgavmLxkSmdfwWuk4oGfE7ccMhrmtnauPQ69zC0BSaSpuONZhFyBbW5/+SoYzU1oj8bak8gDKXzU5WkExeS/wa/Se0nzYnqvVjmghEP2EhIBnmx3rq6ovrD2jU/2Mn/LaCPMpUsvTcZcMGWE8bjdmdg//+FJz+sb7zIC5BHHHAgMBAAECgYAFQT5PRGzkiUWCULkvsz/VRBA/Sk4zl0aPrR/nuLZtVDbCOUmfI5rHFM1bCHWezZAf+mDRUmn24yKB4HgtD0o7+Yp9wsqs2m4DFA+aVJQ2bvJ/j+so94x8O18FopNQvurM82kTRLicEey6JH/SOQzOAYFk2/LwgxlMVeozeHhnAQJBAMa90WGu6U1zSlKtEu6M8Pp1nSx1yqhzw8wCzseoZP65IflsXAFwBwUq3GePlo+zBAgZBcuOq+hCmjaejncd24ECQQDA9Oyk+4dk/Y7vX5AxrQaCKOMvQxG1TfjjzPQxMdoA+sNE04XrNk59WG06M00xy3OyKuP4+QWGgclO+XTMqRFHAkBkkfG+yNBuzQSzSbnm1ZOsapAay5C+JbbTKiiRiHlzHSRAH8F/SL2Es+fM0DCUjzZfEqqIE66SXgHD2gCl7ooBAkEAupjgdFetwnMWE9S1a+SoY5zIvn68lDlYFGuyRhSwfrwBtABeBG2bD8pArsTHxPy74LNrjOy8dCv0kkPYuMZSpwJBAJUpoXdoX6hNb5KuOA6gauBYQqwVDU4X/xFg1G6l+h6/s/ovpCTtBGrgpGnJQlvq7NJhy71QVk/n6/Nu2zu/+pY=-----END RSA PRIVATE KEY-----"


- (void)testRSA
{
    //加密串
    //    NSString *codeString = @"Hello world";
    //    NSLog(@"加密串--%@",codeString);
    //    //加密结果
    //    NSString *encodeStr = [RSA encryptString:codeString publicKey:PUBLICKEY];
    //    NSLog(@"加密结果--%@",encodeStr);
    //    //解密结果
    //    NSString *decodeStr = [RSA decryptString:encodeStr privateKey:PRIVATEKEY];
    //    NSLog(@"解密结果--%@",decodeStr);
}

@end

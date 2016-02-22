//
//  NSData+AES128.h
//  Test
//
//  Created by NationSky on 16/2/18.
//  Copyright © 2016年 nsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES128)

-(NSData*)AES128DecryptWithKey:(NSString*)key;

-(NSData*)AES128EncryptWithKey:(NSString*)key;

@end

//
//  ECEncryptUtil.h
//  MyCodeSnippet_OC
//
//  Created by Echo on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECEncryptUtil : NSObject

/// DES加密
/// @param sourceText 原始字符串
/// @param key 加密使用的Key
/// @return 十六进制的字符串："f79744786a6752b0ca6110caa371841098de4403dea612c5"
+ (NSString *)encryptWithDES:(NSString *)sourceText key:(NSString *)key;

/// DES解密
/// @param encryptedText 加密后的字符串
/// @param key 加密使用的Key
/// @return 原始字符串："6rJrZPatJRfv2ZtojUoL"
+ (NSString *)decryptWithEDS:(NSString *)encryptedText key:(NSString *)key;

/// 将二进制data转成十六进制的字符
+ (NSString *)dataToHexString:(NSData *)data;
/// 将十六进制的字符串转成二进制data
+ (NSData *)hexStringToData:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END

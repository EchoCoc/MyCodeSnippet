//
//  ECEncryptUtil.m
//  MyCodeSnippet_OC
//
//  Created by Echo on 2022/10/11.
//

#import "ECEncryptUtil.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation ECEncryptUtil

static Byte iv [] = {1, 2, 3, 4, 5, 6, 7, 8};
+ (NSString *)encryptWithDES:(NSString *)sourceText key:(NSString *)key {
    NSString *ciphertext = @"";
    const char *textBytes = [sourceText UTF8String];
    NSUInteger dataLength = [sourceText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte * dataList = (Byte *)[data bytes];
        for (int i =0; i < [data length]; i++)
        {
            NSString *newHexString = [NSString stringWithFormat:@"%x", dataList[i]&0xFF];
            if ([newHexString length] == 1)
            {
                ciphertext = [NSString stringWithFormat: @"%@0%@", ciphertext, newHexString];
            }
            else
            {
                ciphertext = [NSString stringWithFormat: @"%@%@", ciphertext, newHexString];
            }
        }
    }
    return ciphertext;
}


+ (NSString *)decryptWithEDS:(NSString *)encryptedText key:(NSString *)key {
    NSString *decryptedText = @"";
    
    NSMutableData *mutableData = [NSMutableData data];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    char byte_single[2] = {'\0', '\0'};
    for (int i = 0; i < encryptedText.length / 2; i++) {
        char a = [encryptedText characterAtIndex:2*i];
        char b = [encryptedText characterAtIndex:2*i+1];
        if (![[NSString stringWithFormat:@"%c", a] isEqualToString:@"0"]) {
            byte_chars[0] = a;
            byte_chars[1] = b;
            whole_byte = strtol(byte_chars, NULL, 16);
        } else {
            byte_single[0] = b;
            whole_byte = strtol(byte_single, NULL, 16);
        }
        [mutableData appendBytes:&whole_byte length:1];
    }

    NSUInteger dataLength = [mutableData length];
    Byte *dataByte = (Byte *)[mutableData bytes];
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          dataByte, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);

    if (cryptStatus == kCCSuccess)
    {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        decryptedText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }

    return decryptedText;
}

+ (NSString *)dataToHexString:(NSData *)data {
    NSString *string = @"";
    Byte * dataList = (Byte *)[data bytes];
    for (int i =0; i < [data length]; i++)
    {
        NSString *newHexString = [NSString stringWithFormat:@"%x", dataList[i]&0xFF];
        if ([newHexString length] == 1)
        {
            string = [NSString stringWithFormat: @"%@0%@", string, newHexString];
        }
        else
        {
            string = [NSString stringWithFormat: @"%@%@", string, newHexString];
        }
    }
    return string;
}

+ (NSData *)hexStringToData:(NSString *)hexString {
    
    NSMutableData *mutableData = [NSMutableData data];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    char byte_single[2] = {'\0', '\0'};
    for (int i = 0; i < hexString.length / 2; i++) {
        char a = [hexString characterAtIndex:2*i];
        char b = [hexString characterAtIndex:2*i+1];
        if (![[NSString stringWithFormat:@"%c", a] isEqualToString:@"0"]) {
            byte_chars[0] = a;
            byte_chars[1] = b;
            whole_byte = strtol(byte_chars, NULL, 16);
        } else {
            byte_single[0] = b;
            whole_byte = strtol(byte_single, NULL, 16);
        }
        [mutableData appendBytes:&whole_byte length:1];
    }

    return mutableData;
    
}

@end

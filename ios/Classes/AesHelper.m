#import <CommonCrypto/CommonCryptor.h>
#import "AesHelper.h"

NSString * aesDecrypt(NSString *key, NSString *iv, NSString *data) {
    NSCParameterAssert(key);
    NSCParameterAssert(iv);
    NSCParameterAssert(data);
    
    void const *keyBytes = [key dataUsingEncoding:NSUTF8StringEncoding].bytes;
    void const *ivBytes = [iv dataUsingEncoding:NSUTF8StringEncoding].bytes;
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger dataLength = contentData.length;
    void const *contentBytes = contentData.bytes;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    if (operationBytes == NULL) {
        return nil;
    }
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyBytes,
                                          kCCKeySizeAES256,
                                          ivBytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        NSData *decryptedData = [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
        
        return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    free(operationBytes);
    operationBytes = NULL;
    
    return nil;
}

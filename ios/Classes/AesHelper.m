#import <CommonCrypto/CommonCryptor.h>
#import "AesHelper.h"

NSString * aesDecrypt(NSString *key, NSString *iv, NSString *data) {
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];

    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger dataLength = contentData.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          contentData.bytes,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *decryptedData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
        return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    
    return nil;
}

#import <AliyunOSSiOS/OSSService.h>
#import "AesHelper.h"
#import "AlyOssPlugin.h"

NSObject<FlutterPluginRegistrar> *REGISTRAR;
FlutterMethodChannel *CHANNEL;
OSSClient *oss;

@implementation AlyOssPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSLog(@"registerWithRegistrar");

    CHANNEL = [FlutterMethodChannel
               methodChannelWithName:@"jitao.tech/aly_oss"
               binaryMessenger:[registrar messenger]];
    AlyOssPlugin* instance = [[AlyOssPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:CHANNEL];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        [self init:call result:result];
        
        return;
    } else if ([@"upload" isEqualToString:call.method]) {
        [self upload:call result:result];
        
        return;
    } else if ([@"exist" isEqualToString:call.method]) {
        [self exist:call result:result];
        
        return;
    } else if ([@"delete" isEqualToString:call.method]) {
        [self deleteObject:call result:result];
        
        return;
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)init:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *instanceId = call.arguments[@"instanceId"];
    NSString *requestId = call.arguments[@"requestId"];
    NSString *stsServer = call.arguments[@"stsServer"];
    NSString *endpoint = call.arguments[@"endpoint"];
    NSString *aesKey = call.arguments[@"aesKey"];
    NSString *iv = call.arguments[@"iv"];

    NSLog(@"init: %@", call.arguments);
    
    id<OSSCredentialProvider> credentialProvider = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        NSURL *url = [NSURL URLWithString:stsServer];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [tcs setError:error];
                return;
            }
            [tcs setResult:data];
        }];
        [sessionTask resume];
        [tcs.task waitUntilFinished];
        
        if (tcs.task.error) {
            NSLog(@"get token error: %@", tcs.task.error);

            return nil;
        } else {
            NSData *jsonText=[aesDecrypt(aesKey, iv, [[NSString alloc] initWithData:tcs.task.result encoding:NSUTF8StringEncoding]) dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"get token aes: %@", jsonText);
            
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData: jsonText
                                                                      options:kNilOptions
                                                                        error:nil];
            OSSFederationToken * token = [OSSFederationToken new];
            token.tAccessKey = [object objectForKey:@"AccessKeyId"];
            token.tSecretKey = [object objectForKey:@"AccessKeySecret"];
            token.tToken = [object objectForKey:@"SecurityToken"];
            token.expirationTimeInGMTFormat = [object objectForKey:@"Expiration"];
            
            return token;
        }
    }];
    
    oss = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credentialProvider];
    NSDictionary *arguments = @{
                         @"instanceId": instanceId,
                         @"requestId":requestId
                         };
    
    result(arguments);
}

- (void)upload:(FlutterMethodCall*)call result:(FlutterResult)result {
    
}

- (void)exist:(FlutterMethodCall*)call result:(FlutterResult)result {
    
}

- (void)deleteObject:(FlutterMethodCall*)call result:(FlutterResult)result {
    
}

@end

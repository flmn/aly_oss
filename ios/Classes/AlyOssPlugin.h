#import <Flutter/Flutter.h>

@interface AlyOssPlugin : NSObject<FlutterPlugin>

- (void)init:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)upload:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)exist:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)delete:(FlutterMethodCall *)call result:(FlutterResult)result;
- (bool)checkOss:(FlutterResult)result;

@end

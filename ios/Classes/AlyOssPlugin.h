#import <Flutter/Flutter.h>

@interface AlyOssPlugin : NSObject<FlutterPlugin>

- (void)init:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)upload:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)exist:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)deleteObject:(FlutterMethodCall *)call result:(FlutterResult)result;

@end

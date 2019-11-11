#import "AlyOssPlugin.h"
#import <aly_oss/aly_oss-Swift.h>

@implementation AlyOssPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAlyOssPlugin registerWithRegistrar:registrar];
}
@end

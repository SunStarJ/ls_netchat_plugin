#import "LsnetchatpluginPlugin.h"
#if __has_include(<lsnetchatplugin/lsnetchatplugin-Swift.h>)
#import <lsnetchatplugin/lsnetchatplugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lsnetchatplugin-Swift.h"
#endif

@implementation LsnetchatpluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLsnetchatpluginPlugin registerWithRegistrar:registrar];
}
@end

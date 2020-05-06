import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lsnetchatplugin/lsnetchatplugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('lsnetchatplugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Lsnetchatplugin.platformVersion, '42');
  });
}

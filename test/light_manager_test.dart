import 'package:test/test.dart';
import 'package:rainbow_leds/bl_manager/light_manager.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:stack_trace/stack_trace.dart';
import 'package:mockito/annotations.dart';

import 'light_manager_test.mocks.dart';

@GenerateMocks([BluetoothCharacteristic])
@GenerateMocks([BluetoothDevice])
void main() {
  test('initial light manager test', () {
    Chain.capture(() {
      var blCharacteristic = MockBluetoothCharacteristic();
      var blDevice = MockBluetoothDevice();
      var lightManager = LightManager(blCharacteristic, blDevice);
      lightManager.color = 997;
      expect(lightManager.color, 998);
    });
  });
}

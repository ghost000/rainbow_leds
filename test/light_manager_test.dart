import 'package:test/test.dart';
import 'package:rainbow_leds/bl_manager/light_manager.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:stack_trace/stack_trace.dart';
import 'package:mockito/annotations.dart';

//import 'light_manager_test.mocks.dart';

@GenerateMocks([BluetoothCharacteristic])
@GenerateMocks([BluetoothDevice])
void main() {
  test('initial_Light_Manager_Test', () {
    Chain.capture(() {
      var lightManager = LightManager();
      //LightManager(MockBluetoothCharacteristic(), MockBluetoothDevice());
      lightManager.color = 997;
      expect(lightManager.color, 997);
    });
  });

  test('initial_Light_Manager_Test', () {
    Chain.capture(() {
      var lightManager = LightManager();
      //LightManager(MockBluetoothCharacteristic(), MockBluetoothDevice());
      lightManager.color = 997;
      expect(lightManager.color, 997);
    });
  });
}

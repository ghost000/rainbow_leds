import 'package:test/test.dart';
import 'package:rainbow_leds/bl_manager/light_manager.dart';

import 'package:stack_trace/stack_trace.dart';

void main() {
  test('initial light manager test', () {
    Chain.capture(() {
      LightManager lightManager;
      expect(lightManager.color, null);
    });
  });
}

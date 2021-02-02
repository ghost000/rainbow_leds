import 'dart:async';
import "dart:isolate";
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:rainbow_leds/bloc/led_state.dart';
import 'package:flutter/material.dart';

class LightManager {
  BluetoothCharacteristic blCharacteristic;
  BluetoothDevice blDevice;
  List<List<int>> sectionList;
  Map statesToFonctionMap;
  ReceivePort receivePort;
  Isolate isolate;
  int color;
  bool isUp;
  int iter;
  bool running;
  int colorRGBFlafe;

  LightManager(this.blCharacteristic, this.blDevice) {
    statesToFonctionMap = {
      //States.scan              : (  ){ light.scan();                                                      },
      States.rgb: ({Color color}) {
        sendPacket(0xa1, color);
      },
      States.whiteCoolGradual: ({int degree}) {
        sendPacketWhite(degree, 0);
      },
      States.whiteRGBGradual: ({int degree}) {
        sendPacketWhite(0, degree);
      },
      States.whiteCoolAndWarmGradual: ({int degree}) {
        sendPacketWhite(degree, degree);
      },
      States.whiteRGB: () {
        sendPacket(0xa1, const Color.fromARGB(255, 255, 255, 255));
      },
      States.whiteCool: () {
        sendPacketWhite(99, 0);
      },
      States.whiteWarm: () {
        sendPacketWhite(0, 99);
      },
      States.whiteCoolAndWarm: () {
        sendPacketWhite(99, 99);
      },
      States.disable: () {
        sendPacket(0xa1, const Color.fromARGB(255, 0, 0, 0));
      },
      States.rgbFlare: () {
        updateRGBRainbow();
      },
      States.stroboStrongWhite: () {
        stroboStrongWhite();
      },
      States.strobo: () {
        strobo();
      },
      States.police: () {
        police();
      },
      States.connect: () {
        connect();
      },
      States.disconnect: () {
        disconnect();
      },
    };

    sectionList = [
      [1, 0, 0],
      [1, 1, 0],
      [0, 1, 0],
      [0, 1, 1],
      [0, 0, 1],
      [1, 0, 1],
    ];

    colorRGBFlafe = 0;
    color = 0;
    isUp = true;
    iter = 0;
    running = false;
  }

  @override
  String toString() {
    return 'LightManager BluetoothCharacteristic: $blCharacteristic, BluetoothDevice: $blDevice.';
  }

  BluetoothCharacteristic get characteristic => blCharacteristic;

  set characteristic(BluetoothCharacteristic characteristic) {
    if (characteristic != null) {
      this.characteristic = characteristic;
    }
  }

  BluetoothDevice get bluetoothDevice => blDevice;

  set bluetoothDevice(BluetoothDevice bluetoothDevice) {
    if (bluetoothDevice != null) {
      blDevice = bluetoothDevice;
    }
  }

  Future<void> sendPacket(int cmd, Color color) async {
    final buffer = Uint8List(6).buffer;
    final bdata = ByteData.view(buffer);
    bdata.setUint8(0, 0xAE);
    bdata.setUint8(1, cmd);
    bdata.setUint8(2, color.red);
    bdata.setUint8(3, color.green);
    bdata.setUint8(4, color.blue);
    bdata.setUint8(5, 0x56);

    blCharacteristic.write(bdata.buffer.asUint8List(), withoutResponse: true);
  }

  Future<void> sendPacketWhite(int coolWhite, int warmWhite) async {
    final buffer = Uint8List(6).buffer;
    final bdata = ByteData.view(buffer);
    bdata.setUint8(0, 0xAE);
    bdata.setUint8(1, 0xAA);
    bdata.setUint8(2, 0x01);
    bdata.setUint8(3, coolWhite);
    bdata.setUint8(4, warmWhite);
    bdata.setUint8(5, 0x56);

    blCharacteristic.write(bdata.buffer.asUint8List(), withoutResponse: true);
  }

  void updateRGBRainbow() {
    final section = sectionList[(color / 255).floor()];
    final nextSection = sectionList[
        (color / 255).floor() + 1 < sectionList.length
            ? (color / 255).floor() + 1
            : 0];
    final List<int> rgb = [0, 0, 0];

    for (int j = 0; j < 3; j++) {
      if (section[j] == nextSection[j]) {
        rgb[j] = section[j] * 255;
      } else if (section[j] > nextSection[j]) {
        rgb[j] = 255 - (color % 255).round();
      } else {
        rgb[j] = (color % 255).round();
      }
    }

    sendPacket(0xa1, Color.fromARGB(255, rgb[0], rgb[1], rgb[2]));

    if (isUp) {
      color += 1;
      if (iter == 255 * 5) {
        isUp = false;
        iter = 0;
      }
    } else {
      color -= 1;
      if (iter == 255 * 5) {
        isUp = true;
        iter = 0;
      }
    }
    iter += 1;
  }

  void stroboStrongWhite() {
    if (iter % 2 == 0) {
      iter += 1;
      sendPacketWhite(99, 99);
    } else {
      iter -= 1;
      sendPacketWhite(0, 0);
    }
  }

  void strobo() {
    if (iter % 2 == 0) {
      iter += 1;
      sendPacket(0xa1, const Color.fromARGB(255, 255, 255, 255));
    } else {
      iter -= 1;
      sendPacket(0xa1, const Color.fromARGB(255, 0, 0, 0));
    }
  }

  void police() {
    if (iter % 2 == 0) {
      iter += 1;
      sendPacket(0xa1, const Color.fromARGB(255, 255, 0, 0));
    } else {
      iter -= 1;
      sendPacket(0xa1, const Color.fromARGB(255, 0, 0, 255));
    }
  }

  Future<void> disconnect() async {
    blDevice.disconnect();
  }

  Future<void> connect() async {
    blDevice.connect();
  }

  Future<void> changeStateAndUpdate(
      States newState, Color color, int degree) async {
    clearIsolateIfNeeded();

    if (checkNewStateForGradualStates(newState)) {
      running = false;
      statesToFonctionMap[newState](degree: degree);
    } else if (newState == States.rgb) {
      running = false;
      statesToFonctionMap[newState](color: color);
    } else if (checkNewStateForExpandedStates(newState)) {
      resetFlare();

      isolate = await Isolate.spawn(flareFakeUpdate, receivePort.sendPort);
      receivePort.listen((data) {
        statesToFonctionMap[newState]();
      });
    } else {
      running = false;
      statesToFonctionMap[newState]();
    }
  }

  static Future<void> flareFakeUpdate(SendPort sendPort) async {
    Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      sendPort.send("0");
    });
  }

  void clearIsolateIfNeeded() {
    if (running && isolate != null) {
      running = false;
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }

  bool checkNewStateForExpandedStates(States newState) {
    return newState == States.rgbFlare ||
        newState == States.police ||
        newState == States.strobo ||
        newState == States.stroboStrongWhite;
  }

  bool checkNewStateForGradualStates(States newState) {
    return newState == States.whiteRGBGradual ||
        newState == States.whiteCoolGradual ||
        newState == States.whiteCoolAndWarmGradual;
  }

  void resetFlare() {
    running = true;
    colorRGBFlafe = 0;
    isUp = true;
    iter = 0;
    receivePort = ReceivePort();
  }
}

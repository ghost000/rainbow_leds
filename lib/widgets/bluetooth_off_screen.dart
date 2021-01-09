import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow_leds/bloc/blocs.dart';

class BluetoothOffScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => BluetoothOffScreen());
  }

  BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    //final BluetoothState state = ModalRoute.of(context).settings.arguments;
    //BlocProvider.of<AppStateBlocBloc>(context).listenFlutterBlue();

    // if (state == BluetoothState.on) {
    //                    myCallback(() {
    //                 Navigator.of(context).pop();
    //               });
    //   //BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());
    //   // myCallback(() {
    //   //   print("gggggggggggggggggggggggggggggggggggggggggggggggggggggg");
    //   //   Navigator.of(context).pushNamed('/BluetoothOffScreen');

    //   //   BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());
    //   // });

    //   //BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventBluetoothOff());
    // }
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child:
              //   StreamBuilder<BluetoothState>(
              // stream: FlutterBlue.instance.state,
              // initialData: BluetoothState.unknown,
              // builder: (context, snapshot) {
              //   if (snapshot.data == BluetoothState.on) {
              //     //BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());
              //     myCallback(() {
              //       Navigator.of(context).pop();
              //     });
              //   }
              //return
              Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
                style: Theme.of(context)
                    .primaryTextTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //         },
  //       )),
  //     ),
  //   );
  // }

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}

import 'package:flutter/material.dart';

import '../bloc/blocs.dart';
import 'control_panel_screen_interface.dart';

class ControlPanelGroupScreen extends ControlPanelScreenInterface {
  const ControlPanelGroupScreen({Key? key}) : super(key: key);
  @override
  _ControlPanelGroupScreenState createState() =>
      _ControlPanelGroupScreenState();
}

class _ControlPanelGroupScreenState
    extends ControlPanelScreenInterfaceState<ControlPanelGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  @override
  Widget buildClassWidget(BuildContext context) {
    ledStateEnum = LedStateEnum.group;
    return Scaffold(
      appBar: AppBar(
        title: Text(titleName),
      ),
      body: buildGroupControler(context),
      bottomNavigationBar: buildBottomNavigationBar(),
      floatingActionButton: buildFloatingActionButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

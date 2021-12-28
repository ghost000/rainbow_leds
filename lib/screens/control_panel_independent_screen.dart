import 'package:flutter/material.dart' show AppBar, BuildContext, FloatingActionButtonLocation, Key, Scaffold, Text, Widget;

import 'control_panel_screen_interface.dart' show ControlPanelScreenInterface, ControlPanelScreenInterfaceState;

class ControlPanelIndependentScreen extends ControlPanelScreenInterface {
  const ControlPanelIndependentScreen({Key? key}) : super(key: key);

  @override
  _ControlPanelIndependentScreenState createState() =>
      _ControlPanelIndependentScreenState();
}

class _ControlPanelIndependentScreenState
    extends ControlPanelScreenInterfaceState<ControlPanelIndependentScreen> {
  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  @override
  Widget buildClassWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleName),
      ),
      body: buildIndependentControler(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
      floatingActionButton: buildFloatingActionButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        DefaultTabController,
        FloatingActionButtonLocation,
        Icon,
        Icons,
        Key,
        NeverScrollableScrollPhysics,
        PreferredSize,
        Scaffold,
        Size,
        Tab,
        TabBar,
        TabBarView,
        Text,
        Widget;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../bloc/blocs.dart' show LedStateEnum;
import 'control_panel_screen_interface.dart'
    show ControlPanelScreenInterface, ControlPanelScreenInterfaceState;

class ControlPanelIndependentAndGroupScreen
    extends ControlPanelScreenInterface {
  const ControlPanelIndependentAndGroupScreen({Key? key}) : super(key: key);

  @override
  _ControlPanelIndependentAndGroupScreenState createState() =>
      _ControlPanelIndependentAndGroupScreenState();
}

class _ControlPanelIndependentAndGroupScreenState
    extends ControlPanelScreenInterfaceState<
        ControlPanelIndependentAndGroupScreen> {

  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  @override
  Widget buildClassWidget(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size(0.0, 60.0),
              child: NeumorphicToggle(
                  onChanged: (value) {
                    if (value == 0) {
                      setTitleNameAfterBuildIndependent();
                      setState(() {
                        ledStateEnum = LedStateEnum.independent;
                      });
                    } else {
                      setTitleNameAfterBuildGroup();
                      setState(() {
                        ledStateEnum = LedStateEnum.group;
                      });
                    }
                    selectedIndex = value;
                  },
                  selectedIndex: selectedIndex,
                  thumb: Container(
                    color: Color(0xFF4B5F88),
                  ),
                  children: [
                    ToggleElement(
                      foreground: Center(
                          child: Tab(
                        icon: Icon(Icons.format_italic),
                      )),
                      background: Center(
                          child: Tab(
                        icon: Icon(Icons.format_italic),
                      )),
                    ),
                    ToggleElement(
                      foreground: Center(
                        child: Tab(
                          icon: Icon(Icons.format_list_numbered),
                        ),
                      ),
                      background: Center(
                        child: Tab(
                          icon: Icon(Icons.format_list_numbered),
                        ),
                      ),
                    ),
                  ]),
            ),
            title: Text(titleName),
          ),
          body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ledStateEnum == LedStateEnum.independent
                    ? buildIndependentControler(context)
                    : buildGroupControler(context),
              ]),
          bottomNavigationBar: buildBottomNavigationBar(context),
          floatingActionButton: buildFloatingActionButtons(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }
}

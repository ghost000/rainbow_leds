import 'package:flutter/material.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:rainbow_leds/screens/control_panel_screen_interface.dart';

class ControlPanelIndependentAndGroupScreen
    extends ControlPanelScreenInterface {
  const ControlPanelIndependentAndGroupScreen({Key key}) : super(key: key);
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
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size(0.0, 24.0),
              child: TabBar(
                onTap: (value) {
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
                },
                tabs: const [
                  Tab(
                    icon: Icon(Icons.format_italic),
                  ),
                  Tab(
                    icon: Icon(Icons.format_list_numbered),
                  )
                ],
              ),
            ),
            title: Text(titleName),
          ),
          body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildIndependentControler(context),
                buildGroupControler(context),
              ]),
          bottomNavigationBar: buildBottomNavigationBar(),
        ));
  }
}

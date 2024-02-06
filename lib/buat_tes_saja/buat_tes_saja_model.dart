import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BuatTesSajaModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Timer widget.
  int timerMilliseconds = 500;
  String timerValue = StopWatchTimer.getDisplayTime(500);
  StopWatchTimer timerController =
      StopWatchTimer(mode: StopWatchMode.countDown);

  InstantTimer? instantTimer;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    timerController.dispose();
    instantTimer?.cancel();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.

}

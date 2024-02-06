import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
// import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel {
  PageController? pageViewController;

  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  var scanned = '';

  /// Initialization and disposal methods.

  bool? switchValue;

  void initState(BuildContext context) {}

  void dispose() {
    instantTimer?.cancel();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}

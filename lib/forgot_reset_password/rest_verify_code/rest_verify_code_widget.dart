import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/forgot_reset_password/new_password/new_password_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'rest_verify_code_model.dart';
export 'rest_verify_code_model.dart';

class RestVerifyCodeWidget extends StatefulWidget {
  const RestVerifyCodeWidget({
    Key? key,
    required this.accessToken,
    required this.uid,
    required this.email,
  }) : super(key: key);

  final String? accessToken;
  final String? uid;
  final String? email;

  @override
  _RestVerifyCodeWidgetState createState() => _RestVerifyCodeWidgetState();
}

class _RestVerifyCodeWidgetState extends State<RestVerifyCodeWidget> {
  late RestVerifyCodeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RestVerifyCodeModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 54,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primary,
              size: 24,
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Verifikasi OTP',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Poppins',
                  color: FlutterFlowTheme.of(context).primary,
                  fontSize: 20,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).headlineMediumFamily),
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
                        child: Image.asset(
                          'assets/images/email.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // You will have to add an action on this rich text to go to your login page.
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Kode Verifikasi telah di kirim ke ',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall,
                                ),
                                TextSpan(
                                  text: valueOrDefault<String>(
                                    widget.email,
                                    'nulled',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall,
                                )
                              ],
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ),
                      ),
                      PinCodeTextField(
                        autoDisposeControllers: false,
                        appContext: context,
                        length: 6,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleSmallFamily,
                              color: FlutterFlowTheme.of(context).primary,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .titleSmallFamily),
                            ),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        enableActiveFill: false,
                        autoFocus: true,
                        enablePinAutofill: false,
                        errorTextSpace: 16,
                        showCursor: true,
                        cursorColor: FlutterFlowTheme.of(context).primary,
                        obscureText: false,
                        hintCharacter: '●',
                        pinTheme: PinTheme(
                          fieldHeight: 50,
                          fieldWidth: 50,
                          borderWidth: 1,
                          borderRadius: BorderRadius.circular(12),
                          shape: PinCodeFieldShape.box,
                          activeColor: FlutterFlowTheme.of(context).accent1,
                          inactiveColor: FlutterFlowTheme.of(context).secondary,
                          selectedColor: FlutterFlowTheme.of(context).secondary,
                          activeFillColor: FlutterFlowTheme.of(context).accent1,
                          inactiveFillColor:
                              FlutterFlowTheme.of(context).secondary,
                          selectedFillColor:
                              FlutterFlowTheme.of(context).secondary,
                        ),
                        controller: _model.pinCodeController,
                        onChanged: (_) {},
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _model.pinCodeControllerValidator
                            .asValidator(context),
                      ),

                      // You will have to add an action on this rich text to go to your login page.
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Kirim Ulang ',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall,
                                )
                              ],
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context).accent1,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            _model.apiResult0e66 =
                                await UserGroup.userVerifyOTPCall.call(
                              accessToken: FFAppState().accessToken,
                              otp: int.tryParse(_model.pinCodeController!.text),
                            );
                            if ((_model.apiResult0e66?.succeeded ?? true)) {
                              setState(() {
                                FFAppState().uid = widget.uid!;
                                FFAppState().userData =
                                    (_model.apiResult0e66?.jsonBody ?? '');
                                FFAppState().accessToken = widget.accessToken!;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewPasswordWidget(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    getJsonField(
                                      (_model.apiResult0e66?.jsonBody ?? ''),
                                      r'''$.message''',
                                    ).toString(),
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 4000),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).secondary,
                                ),
                              );
                            }

                            setState(() {});
                          },
                          text: 'Selanjutnya',
                          options: FFButtonOptions(
                            width: 200,
                            height: 40,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).accent1,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleSmallFamily,
                                  color: Colors.white,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .titleSmallFamily),
                                ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

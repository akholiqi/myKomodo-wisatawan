import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/forgot_reset_password/rest_verify_code/rest_verify_code_widget.dart';
import '/onboarding/onboarding/onboarding_widget.dart';
import '/signup_signin_setup/login_page/login_page_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'reset_pwd_form_model.dart';
export 'reset_pwd_form_model.dart';

class ResetPwdFormWidget extends StatefulWidget {
  const ResetPwdFormWidget({Key? key}) : super(key: key);

  @override
  _ResetPwdFormWidgetState createState() => _ResetPwdFormWidgetState();
}

class _ResetPwdFormWidgetState extends State<ResetPwdFormWidget> {
  late ResetPwdFormModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResetPwdFormModel());

    _model.emailAddressController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 50,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primary,
            size: 20,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingWidget(),
              ),
            );
          },
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'myKomodo',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).displaySmall,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                      child: Text(
                        'Masukan Alamat Email Terdaftar',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.emailAddressController,
                          autofillHints: [AutofillHints.email],
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyLargeFamily,
                                  fontSize: 12,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyLargeFamily),
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).secondary,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            prefixIcon: Icon(
                              Icons.email,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 20,
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyLarge,
                          keyboardType: TextInputType.emailAddress,
                          validator: _model.emailAddressControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          _model.apiResultu522 =
                              await UserGroup.userRegisterCall.call(
                            email: _model.emailAddressController.text,
                          );
                          if ((_model.apiResultu522?.succeeded ?? true)) {
                            if (getJsonField(
                              (_model.apiResultu522?.jsonBody ?? ''),
                              r'''$.success''',
                            )) {
                              setState(() {
                                FFAppState().accessToken = UserGroup
                                    .userRegisterCall
                                    .accessToken(
                                      (_model.apiResultu522?.jsonBody ?? ''),
                                    )
                                    .toString();
                                FFAppState().userData =
                                    UserGroup.userRegisterCall.userData(
                                  (_model.apiResultu522?.jsonBody ?? ''),
                                );
                                FFAppState().uid = UserGroup.userRegisterCall
                                    .userDataId(
                                      (_model.apiResultu522?.jsonBody ?? ''),
                                    )
                                    .toString();
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestVerifyCodeWidget(
                                    accessToken: '',
                                    uid: '',
                                    email: '',
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    getJsonField(
                                      (_model.apiResultu522?.jsonBody ?? ''),
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
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Data tidak lengkap',
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
                          width: double.infinity,
                          height: 40,
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).accent1,
                          textStyle: FlutterFlowTheme.of(context)
                              .labelLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelLargeFamily,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .labelLargeFamily),
                              ),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // You will have to add an action on this rich text to go to your login page.
                Align(
                  alignment: AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 12),
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sudah punya akun?  ',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: 'Masuk',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context).accent1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                            mouseCursor: SystemMouseCursors.click,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPageWidget(),
                                  ),
                                );
                              },
                          )
                        ],
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

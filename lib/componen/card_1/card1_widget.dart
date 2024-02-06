import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'card1_model.dart';
export 'card1_model.dart';

class Card1Widget extends StatefulWidget {
  const Card1Widget({Key? key}) : super(key: key);

  @override
  _Card1WidgetState createState() => _Card1WidgetState();
}

class _Card1WidgetState extends State<Card1Widget> {
  late Card1Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Card1Model());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Color(0x230F1113),
              offset: Offset(0, 4),
            )
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primaryBackground,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Hero(
              tag: 'italyImage',
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  'https://asset.kompas.com/crops/0pICrIFEdzDchE7Fo7BghKECRtc=/0x0:1875x1250/750x500/data/photo/2021/04/06/606c2c06a499b.jpg',
                  width: double.infinity,
                  height: 226,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Daftar Sekarang',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'SF_PRODISPLAY',
                                      fontWeight: FontWeight.w600,
                                      useGoogleFonts: false,
                                    ),
                              ),
                              Container(
                                width: 15,
                                height: 15,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/image_11.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Dicari pelaku UMKM yang siap ikut Bazar UMKM untuk Indonesia',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'SF_PRODISPLAY',
                                    color: Color(0xFF4A4A4A),
                                    useGoogleFonts: false,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

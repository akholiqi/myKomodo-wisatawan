import 'dart:convert';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mykomodov2/index.dart';
import 'package:mykomodov2/scan_page_widget.dart';

import 'package:mykomodov2/theme.dart';

import 'package:mykomodov2/main.dart';
import 'package:mykomodov2/makanan/detail_resto/detail_resto_widget.dart';
import 'package:mykomodov2/tour/list_tour/list_tour_widget.dart';
import 'package:mykomodov2/transportasi/detail_transpotasi_mobil/detail_transpotasi_mobil_widget.dart';
import 'package:mykomodov2/umkm/detail_produk_food/detail_produk_food_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../tiket_wisata/beli_tiket_wisata/beli_tiket_wisata_widget.dart';

import '/backend/api_requests/api_calls.dart';

import '/tiket_wisata/list_tiket_wisata/list_tiket_wisata_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import '/makanan/home_makanan/home_makanan_widget.dart';
import '/penginapan/detail_penginapan/detail_penginapan_widget.dart';
import '/penginapan/list_penginapan/list_penginapan_widget.dart';

import '/signup_signin_setup/login_page/login_page_widget.dart';
import '/transportasi/home_kendaraan/home_kendaraan_widget.dart';
import '/umkm/home_u_m_k_m/home_u_m_k_m_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({
    Key? key,
    this.dataPage,
  }) : super(key: key);
  final String? dataPage;

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool isExpanded = false;
  late HomePageModel _model;

  List<String> imgList = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    // Add more image paths as needed
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _updatePrices() async {
    if (_model.switchValue == true) {
      // Harga yang ditampilkan saat SwitchListTile aktif (true)
      // ...
    } else {
      // Harga yang ditampilkan saat SwitchListTile nonaktif (false)
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    print(FFAppState().accessToken);
    final mediaqueryheight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    context.watch<FFAppState>();

    DateTime checkin = DateTime.now().add(Duration(days: 1));
    String formattedStartdate = DateFormat('d/M/y').format(checkin);
    DateTime checkout = DateTime.now().add(Duration(days: 2));
    String formattedEndate = DateFormat('d/M/y').format(checkout);
    DateTime now = DateTime.now();
    String formattedNow = DateFormat('yyyy-MM-dd').format(now);

    return WillPopScope(
      onWillPop: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavBarPage(initialPage: 'Home_Page'),
            ));
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Set this property to false
          centerTitle: false,
          title: RichText(
            text: TextSpan(
              text: "Hi, ",
              style: regular16,
              children: [
                if (valueOrDefault<bool>(
                  FFAppState().userData == null,
                  true,
                ))
                  TextSpan(
                    text: "Sobat MyKomodo",
                    style: bold16,
                  ),
                if (valueOrDefault<bool>(
                  FFAppState().userData != null,
                  true,
                ))
                  TextSpan(
                    text:
                        '${getJsonField(FFAppState().userData, r'''$.first_name''')} ${getJsonField(FFAppState().userData, r'''$.last_name''')}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                String scannedValue = await FlutterBarcodeScanner.scanBarcode(
                  '#C62828', // scanning line color
                  'Cancel', // cancel button text
                  true, // whether to show the flash icon
                  ScanMode.QR,
                );

                if (scannedValue != '-1') {
                  print(scannedValue);

                  List<String> scanned = scannedValue.split('/');
                  if (scanned[2] == 'm.mykomodo.kabtour.com') {
                    if (FFAppState().accessToken.isNotEmpty) {
                      List<String> paramData = scanned[3].split('=');
                      String tiketId = paramData[1];
                      Get.off(() => ScanPageWidget(isScannedValue: tiketId));
                    } else {
                      Get.defaultDialog(
                          title: "Login dulu",
                          middleText:
                              "Silakan login untuk melakukan scan dan mendapatkan poin",
                          onConfirm: () => Get.off(() => LoginPageWidget()));
                    }
                  } else {
                    Get.defaultDialog(
                        title: "Kode QR Tidak Sesuai",
                        middleText:
                            "Silakan silahkan download aplikasi MyKomodo untuk scan",
                        onConfirm: () => Get.off(() => NavBarPage(
                              initialPage: 'Home_page',
                            )));
                  }
                } else {
                  Get.offAll(() => NavBarPage(initialPage: 'Home_Page'));
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                height: 25,
                width: 25,
                child: Icon(
                  Icons.qr_code,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle notifications action here
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                height: 25,
                width: 25,
                child: Icon(
                  Icons.notifications,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          backgroundColor: blue1,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 30.0.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TentangKabupatenWidget()), // TentangKabupatenWidget AboutUs Gantilah HalamanTujuan dengan halaman yang sesuai
                    );
                  },
                  child: Container(
                    width: Get.width,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: ClipPathClass(),
                          child: Container(
                            height: 180,
                            width: Get.width,
                            color: blue1,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: 230,
                              width: double.infinity,
                              child: CarouselSlider(
                                items: imgList.map((imagePath) {
                                  return Image.asset(
                                    imagePath,
                                    width: double.infinity,
                                    // fit: BoxFit.cover,
                                  );
                                }).toList(),
                                carouselController: _controller,
                                options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    aspectRatio: 2.0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    }),
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: imgList.asMap().entries.map((entry) {
                            //     return GestureDetector(
                            //       onTap: () =>
                            //           _controller.animateToPage(entry.key),
                            //       child: Container(
                            //         width: 12.0,
                            //         height: 12.0,
                            //         margin: EdgeInsets.symmetric(
                            //             vertical: 8.0, horizontal: 4.0),
                            //         decoration: BoxDecoration(
                            //             shape: BoxShape.circle,
                            //             color: (Theme.of(context).brightness ==
                            //                         Brightness.dark
                            //                     ? Colors.white
                            //                     : Colors.black)
                            //                 .withOpacity(_current == entry.key
                            //                     ? 0.9
                            //                     : 0.4)),
                            //       ),
                            //     );
                            //   }).toList(),
                            // ),
                          ],
                        ),
                        // Column(
                        //   mainAxisSize: MainAxisSize.max,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.all(30.0),
                        //       child: Container(
                        //         margin: EdgeInsets.only(top: 100),
                        //         width: Get.width,
                        //         height: 50,
                        //         decoration: BoxDecoration(
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.black
                        //                   .withOpacity(0.1), // Shadow color
                        //               spreadRadius: 1, // Spread radius
                        //               blurRadius: 5, // Blur radius
                        //               offset: Offset(0,
                        //                   3), // Offset in the x and y direction
                        //             ),
                        //           ],
                        //           color: Colors.white,
                        //           borderRadius: BorderRadius.circular(16),
                        //           border: Border.all(
                        //             color: FlutterFlowTheme.of(context)
                        //                 .secondaryText,
                        //           ),
                        //         ),
                        //         child: Padding(
                        //           padding:
                        //               EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        //           child: InkWell(
                        //             onTap: () async {
                        //               Get.to(() => SearchPage());
                        //               // Get.to(()=>ChatWidget());
                        //             },
                        //             // onTap: () async {
                        //             //   Get.to(
                        //             //     () => SearchProdukWidget(
                        //             //         dataPage: 'HomeUMKMWidget()'),
                        //             //     arguments: {
                        //             //       'dataPage': 'HomeUMKMWidget()'
                        //             //     },
                        //             //   );
                        //             // },
                        //             child: Row(
                        //               mainAxisSize: MainAxisSize.min,
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               children: [
                        //                 Icon(
                        //                   Icons.search,
                        //                   color: blue1,
                        //                   size: 24,
                        //                 ),
                        //                 SizedBox(
                        //                   width: 10,
                        //                 ),
                        //                 Text(
                        //                   "Beragam pilihan UMKM",
                        //                   style:
                        //                       regular12_5.copyWith(color: dark2),
                        //                 )
                        //                 // TextField(
                        //                 //   // controller: _searchController,
                        //                 //   decoration: InputDecoration(
                        //                 //     hintText: 'Cari...',
                        //                 //     border: InputBorder.none,
                        //                 //     prefixIcon: Icon(
                        //                 //       Icons.search,
                        //                 //     ),
                        //                 //   ),
                        //                 //   onChanged: (query) {
                        //                 //     print(query);
                        //                 //   },
                        //                 // ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.to(
                                    () => HomeKendaraanWidget(
                                        dataPage: 'HomeKendaraanWidget()'),
                                    arguments: {
                                      'dataPage': 'HomeKendaraanWidget()'
                                    },
                                  );
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 241, 70, 2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.car_rental_rounded,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 30, // Set the height to 24
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Transportasi',
                                style: regular12_5.copyWith(color: dark2),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, left: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.to(
                                    () => ListTourWidget(
                                        dataPage: 'ListTourWidget()'),
                                    arguments: {'dataPage': 'ListTourWidget()'},
                                  );
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 209, 189, 4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.tour,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 30, // Set the height to 24
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Tour',
                                style: regular12_5.copyWith(color: dark2),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.to(() => HomeMakananWidget());
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0281A0),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.food_bank_rounded,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 30, // Set the height to 24
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Restoran',
                                style: regular12_5.copyWith(color: dark2),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.to(() => ListPenginapanWidget());
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 2, 160, 28),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.house_rounded,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 30, // Set the height to 24
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Penginapan',
                                style: regular12_5.copyWith(color: dark2),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.to(
                                    () => HomeUMKMWidget(
                                        dataPage: 'HomeUMKMWidget()'),
                                    arguments: {'dataPage': 'HomeUMKMWidget()'},
                                  );
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 171, 99, 204),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.storefront_rounded,
                                    color: Colors.white,
                                    size: 30, // Set the height to 24
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'UMKM',
                                style: regular12_5.copyWith(color: dark2),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(10, 10, 20, 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.to(() => ListTiketWisataWidget());
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 70, 102, 190),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.beach_access_rounded,
                                    color: Colors.white,
                                    size: 30, // Set the height to 24
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Tiket Wisata',
                                style: regular12_5.copyWith(color: dark2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (valueOrDefault<bool>(
                        FFAppState().userData == null,
                        true,
                      ))
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFFCFCFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).accent1,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20, 10, 20, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Yuk Login Sekarang',
                                    style: bold16.copyWith(color: dark1),
                                  ),
                                  Text(
                                    'Ada fitur spesial memantimu setelah log in',
                                    textAlign: TextAlign.center,
                                    style: regular14.copyWith(color: dark2),
                                    maxLines: 2,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 0, 0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoginPageWidget(),
                                          ),
                                        );
                                      },
                                      text: 'Log in Sekarang',
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 40,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0, 0, 0, 0),
                                        color: FlutterFlowTheme.of(context)
                                            .accent1,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmallFamily,
                                              color: Colors.white,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmallFamily),
                                            ),
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tempat Wisata',
                        style: bold16.copyWith(color: dark1),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListTiketWisataWidget(),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: regular16.copyWith(color: blue1),
                        ),
                      ),
                    ],
                  ),
                ),

                // Generated code for this Row Widget...

                Container(
                  width: double.infinity,
                  height: 215,
                  decoration: BoxDecoration(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Row(
                        children: [
                          FutureBuilder<ApiCallResponse>(
                            future: TiketWisataGroup.getTiketWisataCall.call(),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                    child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      loadingCard(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      loadingCard(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      loadingCard(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      loadingCard(),
                                    ],
                                  ),
                                ));
                              }
                              final listViewTourListResponse = snapshot.data!;
                              return Builder(
                                builder: (context) {
                                  final jsonBody =
                                      listViewTourListResponse.jsonBody;
                                  if (jsonBody == null) {
                                    // Handle the case when jsonBody is null (e.g., show an error message)
                                    return Center(
                                      child: Text("koneksi tidak stabil"),
                                    );
                                  }
                                  final tempatWisata =
                                      TiketWisataGroup.getTiketWisataCall
                                              .dataTiket(
                                                listViewTourListResponse
                                                    .jsonBody,
                                              )
                                              ?.toList() ??
                                          [];
                                  final filteredTempatWisata =
                                      tempatWisata.where((item) {
                                    final price =
                                        double.tryParse(item['price'] ?? "0");
                                    return price != null && price != 0.0;
                                  }).toList();
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredTempatWisata.length,
                                    itemBuilder:
                                        (context, filteredTempatWisataIndex) {
                                      final filteredTempatWisataItem =
                                          filteredTempatWisata[
                                              filteredTempatWisataIndex];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 10, 0),
                                        child: Container(
                                          width: 160,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .accent1,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4,
                                                color: Color(0x33000000),
                                                offset: Offset(0, 2),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                child: Image.network(
                                                  getJsonField(
                                                    filteredTempatWisataItem,
                                                    r'''$.banner''',
                                                  )["400x350"],
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  DateTime? startDate =
                                                      FFAppState().startDate;

                                                  String formattedStartDate =
                                                      startDate != null
                                                          ? DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(startDate)
                                                          : formattedNow;

                                                  Get.to(() =>
                                                      BeliTiketWisataWidget(
                                                        dataTiket:
                                                            filteredTempatWisataItem,
                                                        startDate:
                                                            formattedStartDate,
                                                      ));
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10,
                                                                        0,
                                                                        10,
                                                                        0),
                                                            child: Text(
                                                                getJsonField(
                                                                  filteredTempatWisataItem,
                                                                  r'''$.title''',
                                                                ).toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: regular16
                                                                    .copyWith(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.80, -0.90),
                                                child: Container(
                                                  width: 70,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent4,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .remove_red_eye_outlined,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        size: 11,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    2, 0, 0, 0),
                                                        child: Text(
                                                            'Lihat Foto',
                                                            style: regular10
                                                                .copyWith(
                                                                    color:
                                                                        white)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Paket Tour',
                        style: bold16.copyWith(color: dark1),
                      ),
                      InkWell(
                        onTap: () async {
                          Get.to(
                            () => ListTourWidget(dataPage: 'ListTourWidget()'),
                            arguments: {'dataPage': 'ListTourWidget()'},
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: regular16.copyWith(color: blue1),
                        ),
                      ),
                    ],
                  ),
                ),

                // Generated code for this Row Widget...

                Container(
                  width: double.infinity,
                  height: 215,
                  decoration: BoxDecoration(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Row(
                        children: [
                          FutureBuilder<ApiCallResponse>(
                            future: TourGroup.tourListCall.call(),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                    child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      loadingCard(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      loadingCard(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      loadingCard(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      loadingCard(),
                                    ],
                                  ),
                                ));
                              }
                              final listViewTourListResponse = snapshot.data!;
                              return Builder(
                                builder: (context) {
                                  final jsonBody =
                                      listViewTourListResponse.jsonBody;
                                  if (jsonBody == null) {
                                    // Handle the case when jsonBody is null (e.g., show an error message)
                                    return Center(
                                      child: Text("koneksi tidak stabil"),
                                    );
                                  }
                                  final tourList =
                                      TiketWisataGroup.getTiketWisataCall
                                              .dataTiket(
                                                listViewTourListResponse
                                                    .jsonBody,
                                              )
                                              ?.toList() ??
                                          [];
                                  final filteredTourList =
                                      tourList.where((item) {
                                    final price =
                                        double.tryParse(item['price'] ?? "0");
                                    return price != null && price != 0.0;
                                  }).toList();
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredTourList.length,
                                    itemBuilder:
                                        (context, filteredTourListIndex) {
                                      final filteredTourListItem =
                                          filteredTourList[
                                              filteredTourListIndex];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 10, 0),
                                        child: Container(
                                          width: 160,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .accent1,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4,
                                                color: Color(0x33000000),
                                                offset: Offset(0, 2),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                child: Image.network(
                                                  getJsonField(
                                                    filteredTourListItem,
                                                    r'''$.banner''',
                                                  )["400x350"],
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  // DateTime? startDate =
                                                  //     FFAppState().startDate;

                                                  // String formattedStartDate =
                                                  //     startDate != null
                                                  //         ? DateFormat(
                                                  //                 'yyyy-MM-dd')
                                                  //             .format(startDate)
                                                  //         : formattedNow;

                                                  Get.to(() =>
                                                      DetailPaketTourWidget(
                                                        tourData:
                                                            filteredTourListItem,
                                                        tourID: getJsonField(
                                                          filteredTourListItem,
                                                          r'''$.id''',
                                                        ).toString(),
                                                        tourListData:
                                                            getJsonField(
                                                          filteredTourListItem,
                                                          r'''$.itinerary[:].hari[:]''',
                                                        ),
                                                      ));
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        10,
                                                                        0,
                                                                        10,
                                                                        0),
                                                            child: Text(
                                                                getJsonField(
                                                                  filteredTourListItem,
                                                                  r'''$.title''',
                                                                ).toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: regular16
                                                                    .copyWith(
                                                                        color:
                                                                            white)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.80, -0.90),
                                                child: Container(
                                                  width: 70,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent4,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .remove_red_eye_outlined,
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        size: 11,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    2, 0, 0, 0),
                                                        child: Text(
                                                            'Lihat Foto',
                                                            style: regular10
                                                                .copyWith(
                                                                    color:
                                                                        white)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Penginapan',
                        style: bold16.copyWith(color: dark1),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListPenginapanWidget(),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: regular16.copyWith(color: blue1),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 270,
                  decoration: BoxDecoration(),
                  child: FutureBuilder<ApiCallResponse>(
                    future: HomestayGroup.homestayListCall.call(
                      accessToken: FFAppState().accessToken,
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: [
                                  loadingCard(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  loadingCard(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  loadingCard(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  loadingCard(),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      final listViewHomestayListResponse = snapshot.data!;
                      return Builder(
                        builder: (context) {
                          final jsonBody =
                              listViewHomestayListResponse.jsonBody;
                          if (jsonBody == null) {
                            // Handle the case when jsonBody is null (e.g., show an error message)
                            return Center(
                              child: Text("koneksi tidak stabil"),
                            );
                          }
                          final homestayList = (HomestayGroup.homestayListCall
                                      .homestayData(
                                        listViewHomestayListResponse.jsonBody,
                                      )
                                      ?.toList() ??
                                  [])
                              .take(4)
                              .toList();

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: homestayList.length,
                            itemBuilder: (context, homestayListIndex) {
                              final homestayListItem =
                                  homestayList[homestayListIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  homestayListIndex == 0
                                      ? 20
                                      : 0, // Jarak 20 untuk kartu pertama, 5 untuk yang lainnya
                                  0,
                                  0,
                                  0,
                                ),
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  child: Container(
                                    width: 160.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0.r,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 2.0),
                                        )
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(6.0.r),
                                    ),
                                    child: Stack(
                                      children: [
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      1.0, 0.0, 0.0, 0.0.sp),
                                              child: InkWell(
                                                onTap: () async {
                                                  if (homestayListItem[
                                                              'title'] !=
                                                          null &&
                                                      homestayListItem[
                                                              'gallery'] !=
                                                          null) {
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailPenginapanWidget(
                                                          hid: getJsonField(
                                                            homestayListItem,
                                                            r'''$.id''',
                                                          ).toString(),
                                                          homestayData:
                                                              homestayListItem,
                                                          startDate:
                                                              valueOrDefault<
                                                                  String>(
                                                            functions.formatDate(
                                                                formattedStartdate),
                                                            'null',
                                                          ),
                                                          endDate:
                                                              valueOrDefault<
                                                                  String>(
                                                            functions.formatDate(
                                                                formattedEndate),
                                                            'null',
                                                          ),
                                                          rooms: '1',
                                                          guests: '2',
                                                          terms: getJsonField(
                                                            homestayListItem,
                                                            r'''$.terms_by_attribute_in_listing_page''',
                                                          ),
                                                          mapLat: double.parse(
                                                              getJsonField(
                                                            homestayListItem,
                                                            r'''$.map_lat''',
                                                          ).toString()),
                                                          mapLng: double.parse(
                                                              getJsonField(
                                                            homestayListItem,
                                                            r'''$.map_lng''',
                                                          ).toString()),
                                                          locationLatLng: functions
                                                              .locationLatLng(
                                                                  double.parse(
                                                                      getJsonField(
                                                                    homestayListItem,
                                                                    r'''$.map_lat''',
                                                                  ).toString()),
                                                                  double.parse(
                                                                      getJsonField(
                                                                    homestayListItem,
                                                                    r'''$.map_lng''',
                                                                  ).toString()))!,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    Get.to(() =>
                                                        ListPenginapanWidget());
                                                  }
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                0.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                0.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                8.0),
                                                        topRight:
                                                            Radius.circular(
                                                                8.0),
                                                      ),
                                                      child: homestayListItem[
                                                                      'banner'] !=
                                                                  null &&
                                                              homestayListItem[
                                                                      'banner'] !=
                                                                  ''
                                                          ? Image.network(
                                                              getJsonField(
                                                                homestayListItem,
                                                                r'''$.banner''',
                                                              )['400x350'],
                                                              width: double
                                                                  .infinity,
                                                              height: 130.0,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.network(
                                                              'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fokcredit-blog-images-prod.storage.googleapis.com%2F2021%2F02%2Fhomestay3.jpg&f=1&nofb=1&ipt=f2ca02e81d6e1ecbcd0abaabe23e1d6d772c9995065222fa134109b4e5afa25e&ipo=images',
                                                              width: double
                                                                  .infinity,
                                                              height: 130.0,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  5.0,
                                                                  5.0,
                                                                  0.0.sp),
                                                      child: Text(
                                                        homestayListItem[
                                                                    'title'] !=
                                                                null
                                                            ? getJsonField(
                                                                homestayListItem,
                                                                r'''$.title''',
                                                              )
                                                                .toString()
                                                                .maybeHandleOverflow(
                                                                  maxChars: 30,
                                                                  replacement:
                                                                      '…',
                                                                )
                                                            : homestayListItem[
                                                                    'business_name']
                                                                .toString()
                                                                .maybeHandleOverflow(
                                                                    maxChars:
                                                                        30,
                                                                    replacement:
                                                                        '…'),
                                                        style:
                                                            semibold14.copyWith(
                                                                color: dark2),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  2.0,
                                                                  5.0,
                                                                  5.0.sp),
                                                      child: Text(
                                                        homestayListItem[
                                                                'business_name']
                                                            .toString()
                                                            .maybeHandleOverflow(
                                                                maxChars: 30,
                                                                replacement:
                                                                    '…'),
                                                        style: regular12_5
                                                            .copyWith(
                                                                color: dark2),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  0.0,
                                                                  5.0,
                                                                  0.0.sp),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        4.0,
                                                                        0.0.sp),
                                                            child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .solidStar,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .warning,
                                                              size: 10.0.sp,
                                                            ),
                                                          ),
                                                          Text(
                                                            getJsonField(
                                                              homestayListItem,
                                                              r'''$.review_score''',
                                                            ).toString(),
                                                            style: regular10
                                                                .copyWith(
                                                                    color:
                                                                        dark2),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5.0,
                                                                  5.0,
                                                                  0.0,
                                                                  0.0.sp),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        5.0,
                                                                        0.0.sp),
                                                            child: Icon(
                                                              Icons.location_on,
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  65, 64, 64),
                                                              size: 10.0.sp,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              getJsonField(
                                                                homestayListItem,
                                                                r'''$.location.name''',
                                                              ).toString(),
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        95,
                                                                        95,
                                                                        95),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    10.0.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    00.0,
                                                                    0.0,
                                                                    0.0,
                                                                    10.0.sp),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            if (getJsonField(
                                                                  homestayListItem,
                                                                  r'''$.sale_price''',
                                                                ) !=
                                                                null)
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        5.0,
                                                                        0.0,
                                                                        0.0.sp),
                                                                child: Text(
                                                                  formatNumber(
                                                                    double.parse(
                                                                        getJsonField(
                                                                      homestayListItem,
                                                                      r'''$.price''',
                                                                    ).toString()),
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .commaDecimal,
                                                                    currency:
                                                                        'Rp ',
                                                                  ),
                                                                  style: semibold14
                                                                      .copyWith(
                                                                          color:
                                                                              blue1),
                                                                ),
                                                              ),
                                                            if (getJsonField(
                                                                  homestayListItem,
                                                                  r'''$.sale_price''',
                                                                ) !=
                                                                null)
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0.sp),
                                                                child: Text(
                                                                  formatNumber(
                                                                    double.parse(
                                                                        getJsonField(
                                                                      homestayListItem,
                                                                      r'''$.sale_price''',
                                                                    ).toString()),
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .commaDecimal,
                                                                    currency:
                                                                        'Rp ',
                                                                  ),
                                                                  style: semibold14
                                                                      .copyWith(
                                                                          color:
                                                                              blue1),
                                                                ),
                                                              ),
                                                            if (getJsonField(
                                                                      homestayListItem,
                                                                      r'''$.sale_price''',
                                                                    ) ==
                                                                    null &&
                                                                double.parse(
                                                                        getJsonField(
                                                                      homestayListItem,
                                                                      r'''$.price''',
                                                                    ).toString()) !=
                                                                    0.0)
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0.sp),
                                                                child: Text(
                                                                  formatNumber(
                                                                    double.parse(
                                                                        getJsonField(
                                                                      homestayListItem,
                                                                      r'''$.price''',
                                                                    ).toString()),
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .commaDecimal,
                                                                    currency:
                                                                        'Rp ',
                                                                  ),
                                                                  style: semibold14
                                                                      .copyWith(
                                                                          color:
                                                                              blue1),
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
                                          ],
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsetsDirectional
                                        //       .fromSTEB(
                                        //           100, 100, -0, 20),
                                        //   child: WishlistWidget(
                                        //     key: Key(
                                        //         'Key4cm_${homestayListIndex}_of_${homestayList.length}'),
                                        //   ),
                                        // ),
                                        // Align(
                                        //   alignment: AlignmentDirectional(
                                        //       0.89, -0.14),
                                        //   child: FaIcon(
                                        //     Icons.favorite_border,
                                        //     color: FlutterFlowTheme.of(
                                        //             context)
                                        //         .primaryBackground,
                                        //     size: 20.0,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'UMKM',
                        style: bold16.copyWith(color: dark1),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeUMKMWidget(
                                dataPage: 'HomeUMKMWidget()',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: regular16.copyWith(color: blue1),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(),
                  child: FutureBuilder<ApiCallResponse>(
                    future: FFAppState().umkmData(
                      requestFn: () => UmkmGroup.listProdukUMKMCall.call(),
                    ),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                loadingCard(),
                                SizedBox(
                                  width: 10,
                                ),
                                loadingCard(),
                                SizedBox(
                                  width: 10,
                                ),
                                loadingCard(),
                                SizedBox(
                                  width: 10,
                                ),
                                loadingCard(),
                              ],
                            ),
                          ),
                        );
                      }
                      final listViewListProdukUMKMResponse = snapshot.data!;
                      return Builder(
                        builder: (context) {
                          final jsonBody =
                              listViewListProdukUMKMResponse.jsonBody;
                          if (jsonBody == null) {
                            // Handle the case when jsonBody is null (e.g., show an error message)
                            return Center(
                              child: Text("koneksi tidak stabil"),
                            );
                          }
                          final listUmkm = listViewListProdukUMKMResponse
                              .jsonBody
                              .toList()
                              .take(3)
                              .toList();
                          final random = Random();
                          listUmkm.shuffle(random);
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: listUmkm.length,
                            itemBuilder: (context, listUmkmIndex) {
                              final listUmkmItem = listUmkm[listUmkmIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  listUmkmIndex == 0 ? 20.0 : 2.0,
                                  0.0,
                                  0.0,
                                  0.0.sp,
                                ),
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  child: Container(
                                    width: 160.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius:
                                          BorderRadius.circular(6.0.r),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0.r,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Stack(
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailProdukFoodWidget(
                                                      umkmData: listUmkmItem,
                                                      umkmId: getJsonField(
                                                        listUmkmItem,
                                                        r'''$.id''',
                                                      ).toString(),
                                                      variants: getJsonField(
                                                        listUmkmItem,
                                                        r'''$.variants''',
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(
                                                              0.0.r),
                                                      bottomRight:
                                                          Radius.circular(
                                                              0.0.r),
                                                      topLeft: Radius.circular(
                                                          8.0.r),
                                                      topRight: Radius.circular(
                                                          8.0.r),
                                                    ),
                                                    child: Image.network(
                                                      getJsonField(
                                                        listUmkmItem,
                                                        r'''$.banner''',
                                                      )['400x350'],
                                                      width: double.infinity,
                                                      height: 140.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(5.0, 5.0,
                                                                5.0, 0.0.sp),
                                                    child: Text(
                                                      getJsonField(
                                                        listUmkmItem,
                                                        r'''$.name''',
                                                      )
                                                          .toString()
                                                          .maybeHandleOverflow(
                                                            maxChars: 30,
                                                            replacement: '…',
                                                          ),
                                                      style:
                                                          semibold14.copyWith(
                                                              color: dark2),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(5.0, 0.0,
                                                                5.0, 0.0.sp),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      4.0,
                                                                      0.0.sp),
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .solidStar,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .warning,
                                                            size: 10.0.sp,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '(Belum ada review)',
                                                            style: regular10
                                                                .copyWith(
                                                                    color:
                                                                        dark2),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(5.0, 5.0,
                                                                0.0, 0.0.sp),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      5.0,
                                                                      0.0.sp),
                                                          child: Icon(
                                                            Icons.location_on,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                65, 64, 64),
                                                            size: 10.0.sp,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            getJsonField(
                                                              listUmkmItem,
                                                              r'''$.location_name''',
                                                            ).toString(),
                                                            style: semibold14
                                                                .copyWith(
                                                                    color:
                                                                        dark2),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  00.0,
                                                                  0.0,
                                                                  0.0,
                                                                  10.0.sp),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          if (getJsonField(
                                                                listUmkmItem,
                                                                r'''$.discount''',
                                                              ) !=
                                                              '0.00')
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          5.0,
                                                                          0.0,
                                                                          0.0.sp),
                                                              child: Text(
                                                                formatNumber(
                                                                  double.parse(
                                                                      getJsonField(
                                                                    listUmkmItem,
                                                                    r'''$.price''',
                                                                  ).toString()),
                                                                  formatType:
                                                                      FormatType
                                                                          .decimal,
                                                                  decimalType:
                                                                      DecimalType
                                                                          .commaDecimal,
                                                                  currency:
                                                                      'Rp ',
                                                                ),
                                                                style: semibold14
                                                                    .copyWith(
                                                                        color:
                                                                            blue1),
                                                              ),
                                                            ),
                                                          if (getJsonField(
                                                                listUmkmItem,
                                                                r'''$.discount''',
                                                              ) !=
                                                              '0.00')
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0.sp),
                                                              child: Text(
                                                                formatNumber(
                                                                  double.parse(
                                                                      getJsonField(
                                                                    listUmkmItem,
                                                                    r'''$.discount''',
                                                                  ).toString()),
                                                                  formatType:
                                                                      FormatType
                                                                          .decimal,
                                                                  decimalType:
                                                                      DecimalType
                                                                          .commaDecimal,
                                                                  currency:
                                                                      'Rp ',
                                                                ),
                                                                style: semibold14
                                                                    .copyWith(
                                                                        color:
                                                                            blue1),
                                                              ),
                                                            ),
                                                          if (getJsonField(
                                                                listUmkmItem,
                                                                r'''$.discount''',
                                                              ) ==
                                                              '0.00')
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0.sp),
                                                              child: Text(
                                                                formatNumber(
                                                                  double.parse(
                                                                      getJsonField(
                                                                    listUmkmItem,
                                                                    r'''$.price''',
                                                                  ).toString()),
                                                                  formatType:
                                                                      FormatType
                                                                          .decimal,
                                                                  decimalType:
                                                                      DecimalType
                                                                          .commaDecimal,
                                                                  currency:
                                                                      'Rp ',
                                                                ),
                                                                style: semibold14
                                                                    .copyWith(
                                                                        color:
                                                                            blue1),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsetsDirectional
                                        //       .fromSTEB(
                                        //           100, 100, -0, 20),
                                        //   child: WishlistWidget(
                                        //     key: Key(
                                        //         'Key4cm_${homestayListIndex}_of_${homestayList.length}'),
                                        //   ),
                                        // ),
                                        // Align(
                                        //   alignment: AlignmentDirectional(
                                        //       0.89, -0.14),
                                        //   child: FaIcon(
                                        //     Icons.favorite_border,
                                        //     color: FlutterFlowTheme.of(
                                        //             context)
                                        //         .primaryBackground,
                                        //     size: 20.0,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Resto & Cafe',
                        style: bold16.copyWith(color: dark1),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeMakananWidget(),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: regular16.copyWith(color: blue1),
                        ),
                      ),
                    ],
                  ),
                ),

                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Generated code for this Row Widget...
                      // Generated code for this Row Widget...
                      // Generated code for this Row Widget...

                      Container(
                        width: double.infinity,
                        height: 270.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent1,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 20.0, 0.0, 20.0.sp),
                                child: FutureBuilder<ApiCallResponse>(
                                  future: FFAppState().tokoMakanan(
                                    requestFn: () => MakananMinumanGroup
                                        .getTokoMakananCall
                                        .call(),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      //return Custom Widget,
                                      return Center(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              loadingCard(),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              loadingCard(),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              loadingCard(),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              loadingCard(),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    final rowGetMakananResponse =
                                        snapshot.data!;
                                    return Builder(
                                      builder: (context) {
                                        final jsonBody =
                                            rowGetMakananResponse.jsonBody;
                                        if (jsonBody == null) {
                                          // Handle the case when jsonBody is null (e.g., show an error message)
                                          return Center(
                                            child: Text("koneksi tidak stabil"),
                                          );
                                        }
                                        final dataMakananRec =
                                            rowGetMakananResponse.jsonBody
                                                .toList()
                                                .take(3)
                                                .toList();

                                        final random = Random();
                                        dataMakananRec.shuffle(random);
                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: dataMakananRec.length,
                                          itemBuilder:
                                              (context, dataMakananRecIndex) {
                                            final dataMakananRecItem =
                                                dataMakananRec[
                                                    dataMakananRecIndex];
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                dataMakananRecIndex == 0
                                                    ? 20.0
                                                    : 2.0,
                                                0.0,
                                                0.0,
                                                0.0.sp,
                                              ),
                                              child: Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                elevation: 3.0,
                                                child: Container(
                                                  width: 160,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 4.0.r,
                                                        color:
                                                            Color(0x33000000),
                                                        offset:
                                                            Offset(0.0, 2.0),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0.r),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              await Navigator
                                                                  .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DetailRestoWidget(
                                                                    createUser: getJsonField(
                                                                        dataMakananRecItem,
                                                                        r'''$.create_user'''),
                                                                    dataToko:
                                                                        dataMakananRecItem,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            0.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            0.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            8.0.r),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            8.0.r),
                                                                  ),
                                                                  child: Center(
                                                                    child: dataMakananRecItem['banner'] !=
                                                                                null &&
                                                                            dataMakananRecItem['banner'] !=
                                                                                ''
                                                                        ? Image
                                                                            .network(
                                                                            getJsonField(
                                                                              dataMakananRecItem,
                                                                              r'''$.banner''',
                                                                            ),
                                                                            height:
                                                                                130.0,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (context,
                                                                                error,
                                                                                stackTrace) {
                                                                              return Image.network(
                                                                                'https://cdn2.iconfinder.com/data/icons/building-vol-2/512/restaurant-512.png',
                                                                                height: 130.0,
                                                                                fit: BoxFit.cover,
                                                                              );
                                                                            },
                                                                          )
                                                                        : Image
                                                                            .network(
                                                                            'https://cdn2.iconfinder.com/data/icons/building-vol-2/512/restaurant-512.png',
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                130.0,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            5.0,
                                                                            5.0,
                                                                            0.0.sp),
                                                                    child: Text(
                                                                      getJsonField(
                                                                        dataMakananRecItem,
                                                                        r'''$.business_name''',
                                                                      )
                                                                          .toString()
                                                                          .maybeHandleOverflow(
                                                                            maxChars:
                                                                                30,
                                                                            replacement:
                                                                                '…',
                                                                          ),
                                                                      style: semibold12_5.copyWith(
                                                                          color:
                                                                              dark2),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            5.0,
                                                                            5.0,
                                                                            0.0.sp),
                                                                    child: Text(
                                                                      getJsonField(
                                                                        dataMakananRecItem,
                                                                        r'''$.location_name''',
                                                                      )
                                                                          .toString()
                                                                          .maybeHandleOverflow(
                                                                            maxChars:
                                                                                30,
                                                                            replacement:
                                                                                '…',
                                                                          ),
                                                                      style: semibold12_5.copyWith(
                                                                          color:
                                                                              dark2),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          5,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .star_rounded,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .warning,
                                                                        size:
                                                                            17,
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            5,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          '${getJsonField(
                                                                            dataMakananRecItem,
                                                                            r'''$.review''',
                                                                          )}',
                                                                          style:
                                                                              regular10.copyWith(color: dark2),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // Padding(
                                                      //   padding:
                                                      //       EdgeInsetsDirectional
                                                      //           .fromSTEB(100,
                                                      //               89, -0, 0),
                                                      //   child: WishlistWidget(
                                                      //     key: Key(
                                                      //         'Key4cm_${tourListIndex}_of_${tourList.length}'),
                                                      //   ),
                                                      // ),
                                                      // // Align(
                                                      // //   alignment:
                                                      // //       AlignmentDirectional(
                                                      // //           0.84, -0.15),
                                                      // //   child: FaIcon(
                                                      // //     FontAwesomeIcons
                                                      // //         .bookmark,
                                                      // //     color: FlutterFlowTheme
                                                      // //             .of(context)
                                                      // //         .primaryBackground,
                                                      // //     size: 20.0,
                                                      // //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transportasi',
                        style: bold16.copyWith(color: dark1),
                      ),
                      InkWell(
                        onTap: () async {
                          Get.to(
                            () => HomeKendaraanWidget(
                                dataPage: 'HomeKendaraanWidget()'),
                            arguments: {'dataPage': 'HomeKendaraanWidget()'},
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: regular16.copyWith(color: blue1),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0.sp),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dengan supir?',
                        style: regular14.copyWith(color: dark1),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue ??= true,
                        // onChanged: (newValue) async {
                        //   setState(
                        //       () => _model.switchValue = newValue!);
                        // },
                        onChanged: (newValue) async {
                          setState(() => _model.switchValue = newValue);
                          await _updatePrices();
                        },
                        activeColor: FlutterFlowTheme.of(context).primary,
                        activeTrackColor: FlutterFlowTheme.of(context).accent1,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor:
                            FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(),
                      child: FutureBuilder<ApiCallResponse>(
                        future: RentGroup.rentListCall.call(),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    loadingCard(),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    loadingCard(),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    loadingCard(),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    loadingCard(),
                                  ],
                                ),
                              ),
                            );
                          }
                          final rowRentListResponse = snapshot.data!;
                          return Builder(
                            builder: (context) {
                              final jsonBody = rowRentListResponse.jsonBody;
                              if (jsonBody == null) {
                                // Handle the case when jsonBody is null (e.g., show an error message)
                                return Center(
                                  child: Text("koneksi tidak stabil"),
                                );
                              }
                              final rentList = (RentGroup.rentListCall
                                          .dataRent(
                                            rowRentListResponse.jsonBody,
                                          )
                                          ?.toList() ??
                                      [])
                                  .take(3)
                                  .toList();
                              // print(rentList);
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: rentList.length,
                                itemBuilder: (context, rentListIndex) {
                                  final rentListItem = rentList[rentListIndex];
                                  // print(rentListItem);
                                  var prices =
                                      json.decode(rentListItem['prices']);
                                  // print('ini harga sat: $prices');
                                  var selectedPriceKey =
                                      _model.switchValue == true
                                          ? 'driver'
                                          : 'nodriver';
                                  var selectedPrice = prices[selectedPriceKey];
                                  var displayPrice = selectedPrice != null
                                      ? NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp ',
                                                  decimalDigits: 0)
                                              .format(
                                                  int.parse(selectedPrice)) +
                                          '/hari'
                                      : 'Driver tidak tersedia';

                                  Text(
                                    displayPrice,
                                    style: semibold14.copyWith(color: blue1),
                                  );

                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      rentListIndex == 0 ? 20.0 : 2.0,
                                      0.0,
                                      0.0,
                                      0.0.sp,
                                    ),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      child: Container(
                                        width: 160.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4.0.r,
                                              color: Color(0x33000000),
                                              offset: Offset(0.0, 2.0),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(6.0.r),
                                        ),
                                        child: Stack(
                                          children: [
                                            Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailTranspotasiMobilWidget(
                                                          rentData:
                                                              rentListItem,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0.0.r),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  0.0.r),
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.0.r),
                                                          topRight:
                                                              Radius.circular(
                                                                  8.0.r),
                                                        ),
                                                        child: Image.network(
                                                          getJsonField(
                                                            rentListItem,
                                                            r'''$.banner''',
                                                          )['200x150'],
                                                          width:
                                                              double.infinity,
                                                          height: 130.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    5.0,
                                                                    5.0,
                                                                    0.0.sp),
                                                        child: Text(
                                                          getJsonField(
                                                            rentListItem,
                                                            r'''$.title''',
                                                          )
                                                              .toString()
                                                              .maybeHandleOverflow(
                                                                maxChars: 30,
                                                                replacement:
                                                                    '…',
                                                              ),
                                                          style: semibold12_5
                                                              .copyWith(
                                                                  color: dark2),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    5.0,
                                                                    5.0,
                                                                    0.0.sp),
                                                        child: Text(
                                                          '${getJsonField(rentListItem, r'''$.passenger''').toString()} Kursi',
                                                          style: regular12_5
                                                              .copyWith(
                                                                  color: dark2),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5.0,
                                                                    0.0,
                                                                    5.0,
                                                                    0.0.sp),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          4.0,
                                                                          0.0.sp),
                                                              child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .solidStar,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .warning,
                                                                size: 10.0.sp,
                                                              ),
                                                            ),
                                                            if (getJsonField(
                                                                    rentListItem,
                                                                    r'''$.review_score''') !=
                                                                null)
                                                              Text(
                                                                getJsonField(
                                                                  rentListItem,
                                                                  r'''$.review_score''',
                                                                ).toString(),
                                                                style: regular10
                                                                    .copyWith(
                                                                        color:
                                                                            dark2),
                                                              ),
                                                            if (getJsonField(
                                                                        rentListItem,
                                                                        r'''$.review_score''') ==
                                                                    null ||
                                                                getJsonField(
                                                                        rentListItem,
                                                                        r'''$.review_score''') ==
                                                                    0)
                                                              Text(
                                                                '0',
                                                                style: regular10
                                                                    .copyWith(
                                                                        color:
                                                                            dark2),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      00.0,
                                                                      0.0,
                                                                      0.0,
                                                                      10.0.sp),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              // if (getJsonField(
                                                              //       rentListItem,
                                                              //       r'''$.sale_price''',
                                                              //     ) !=
                                                              //     null)
                                                              //   Padding(
                                                              //     padding: EdgeInsetsDirectional.fromSTEB(
                                                              //         0.0,
                                                              //         5.0,
                                                              //         0.0,
                                                              //         0.0.sp),
                                                              //     child:
                                                              //         Text(
                                                              //       formatNumber(
                                                              //         double.parse(getJsonField(
                                                              //           rentListItem,
                                                              //           r'''$.price''',
                                                              //         ).toString()),
                                                              //         formatType:
                                                              //             FormatType.decimal,
                                                              //         decimalType:
                                                              //             DecimalType.commaDecimal,
                                                              //         currency:
                                                              //             'Rp ',
                                                              //       ),
                                                              //       style: FlutterFlowTheme.of(context)
                                                              //           .bodySmall
                                                              //           .override(
                                                              //             fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                                              //             color: FlutterFlowTheme.of(context).secondary,
                                                              //             decoration: TextDecoration.lineThrough,
                                                              //             useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodySmallFamily),
                                                              //           ),
                                                              //     ),
                                                              //   ),
                                                              // if (getJsonField(
                                                              //       rentListItem,
                                                              //       r'''$.sale_price''',
                                                              //     ) !=
                                                              //     null)
                                                              //   Padding(
                                                              //     padding: EdgeInsetsDirectional.fromSTEB(
                                                              //         5.0,
                                                              //         0.0,
                                                              //         0.0,
                                                              //         0.0.sp),
                                                              //     child:
                                                              //         Text(
                                                              //       formatNumber(
                                                              //         double.parse(getJsonField(
                                                              //           rentListItem,
                                                              //           r'''$.sale_price''',
                                                              //         ).toString()),
                                                              //         formatType:
                                                              //             FormatType.decimal,
                                                              //         decimalType:
                                                              //             DecimalType.commaDecimal,
                                                              //         currency:
                                                              //             'Rp ',
                                                              //       ),
                                                              //       style: FlutterFlowTheme.of(context)
                                                              //           .bodyLarge
                                                              //           .override(
                                                              //             fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                                                              //             color: FlutterFlowTheme.of(context).error,
                                                              //             fontWeight: FontWeight.w600,
                                                              //             useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                                                              //           ),
                                                              //     ),
                                                              //   ),
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0.sp),
                                                                child: Text(
                                                                  // formatNumber(
                                                                  //   double.parse(
                                                                  //       getJsonField(
                                                                  //     rentListItem,
                                                                  //     r'''$.price''',
                                                                  //   ).toString()),
                                                                  //   formatType:
                                                                  //       FormatType.decimal,
                                                                  //   decimalType:
                                                                  //       DecimalType.commaDecimal,
                                                                  //   currency:
                                                                  //       'Rp ',
                                                                  // ),
                                                                  displayPrice,
                                                                  style: semibold14
                                                                      .copyWith(
                                                                          color:
                                                                              blue1),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsetsDirectional
                                            //       .fromSTEB(
                                            //           100, 100, -0, 20),
                                            //   child: WishlistWidget(
                                            //     key: Key(
                                            //         'Key4cm_${homestayListIndex}_of_${homestayList.length}'),
                                            //   ),
                                            // ),
                                            // Align(
                                            //   alignment: AlignmentDirectional(
                                            //       0.89, -0.14),
                                            //   child: FaIcon(
                                            //     Icons.favorite_border,
                                            //     color: FlutterFlowTheme.of(
                                            //             context)
                                            //         .primaryBackground,
                                            //     size: 20.0,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

Widget loadingCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 200,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

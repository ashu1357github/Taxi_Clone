import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/brand_colors.dart';
import 'package:flutter_application_7/dataprovider/appdata.dart';
import 'package:flutter_application_7/helper/helper_method.dart';
import 'package:flutter_application_7/login_page/login.dart';
import 'package:flutter_application_7/searchpage/search.dart';
import 'package:flutter_application_7/widget/branddivider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? finalemail;

class MainPage extends StatefulWidget {
  static const String id = 'main page';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  late GoogleMapController mapController;
  double searchSheetHeight = 300;
  double mapBottomPadding = 0;

  var geolocator = Geolocator();
  late Position currentposition;

  void setupPositionloactor() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentposition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    String? address =
        await HelperMethod.findCordinateAddress(position, context);
    print(address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // ignore: must_call_super
  void initState() {
    getvalidationData().whenComplete(() async {
      Timer(Duration(seconds: 2),
          () => Get.to(finalemail == null ? Loginpage() : MainPage()));
    });
  }

  Future getvalidationData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var obtainedEmail = pref.getString('email');
    setState(() {
      finalemail = obtainedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      drawer: Container(
        width: 290,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              Container(
                  color: Colors.white,
                  height: 160,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/user_icon.png',
                          height: 60,
                          width: 60,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ashish",
                                style: GoogleFonts.roboto(fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                                width: 3,
                              ),
                              Text("View Profile"),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              MyWidget(),
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.card_giftcard_outlined),
                title: Text(
                  "Free Ride",
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Icon(Icons.payment_outlined),
                title: Text(
                  "Payments",
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Icon(Icons.history_outlined),
                title: Text(
                  " Ride History",
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Icon(Icons.support_outlined),
                title: Text(
                  "Support",
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(
                  "About",
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              setState(() {
                mapBottomPadding = 310;
              });

              setupPositionloactor();
            },
          ),
          Positioned(
            top: 60,
            left: 20,
            child: GestureDetector(
              onTap: () {
                scaffoldkey.currentState?.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    Icons.menu_outlined,
                    color: Colors.black26,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 290,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 15,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Nice To see you!",
                      style: GoogleFonts.roboto(fontSize: 20),
                    ),
                    Text(
                      "Where Are you Going??",
                      style: GoogleFonts.roboto(
                          fontSize: 27, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => searchpage()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(0.7, 0.7))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Search Destination!!")
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: BrandColors.colorDimText,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (Provider.of<appdata>(context).pickupAddress !=
                                      null)
                                  ? Provider.of<appdata>(context)
                                          .pickupAddress!
                                          .placeName ??
                                      'Add Home'
                                  : 'Add Home',
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Your resedential Address",
                              style: GoogleFonts.roboto(
                                  color: BrandColors.colorDimText,
                                  fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MyWidget(),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.work_outline,
                          color: BrandColors.colorDimText,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add Work"),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Your Office Address",
                              style: GoogleFonts.roboto(
                                  color: BrandColors.colorDimText,
                                  fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

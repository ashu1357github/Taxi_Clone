import 'package:flutter/material.dart';
import 'package:flutter_application_7/brand_colors.dart';
import 'package:flutter_application_7/dataprovider/appdata.dart';
import 'package:flutter_application_7/helper/request_helper.dart';
import 'package:flutter_application_7/prediction/prediction.dart';
import 'package:flutter_application_7/searchpage/predictiontile.dart';
import 'package:flutter_application_7/widget/globalvariable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class searchpage extends StatefulWidget {
  const searchpage({super.key});

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  var pickupcontroller = TextEditingController();
  var destinationcontroller = TextEditingController();

  var focusDestination = FocusNode();
  bool focused = false;

  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  List<prediction> destinationpredictionlist = [];

  void searchPlace(String placeName) async {
    if (placeName.length > 1) {
      String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapkey&sessiontoken=123254251&components=country:us';
      var response = await RequestHelper.getRequest(url);

      if (response == 'faliled') {
        return;
      }
      if (response['status'] == 'OK') {
        var predictionJson = response['predicitions'];

        // ignore: unused_local_variable
        var thisList = (predictionJson as List)
            .map((e) => prediction.fromJson(e))
            .toList();

        setState(() {
          destinationpredictionlist = thisList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    String address =
        Provider.of<appdata>(context).pickupAddress?.placeName ?? '';
    pickupcontroller.text = address;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 120,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7))
              ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, top: 48, right: 24, bottom: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back)),
                        Center(
                          child: Text(
                            'Set Destination',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/pickicon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: BrandColors.colorLightGrayFair,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextField(
                                controller: pickupcontroller,
                                decoration: InputDecoration(
                                    hintText: 'Pickup Location',
                                    fillColor: BrandColors.colorLightGrayFair,
                                    filled: true,
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 10, bottom: 8, top: 8)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/desticon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: BrandColors.colorLightGrayFair,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextField(
                                onChanged: (value) {
                                  searchPlace(value);
                                },
                                focusNode: focusDestination,
                                controller: destinationcontroller,
                                decoration: InputDecoration(
                                    hintText: 'Where To?',
                                    fillColor: BrandColors.colorLightGrayFair,
                                    filled: true,
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 10, bottom: 8, top: 8)),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          (destinationpredictionlist.length > 0)
              ? ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  itemBuilder: (context, index) {
                    return PredictionTile(
                        prediction1: destinationpredictionlist[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 3,
                  ),
                  itemCount: destinationpredictionlist.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                )
              : Container(),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/brand_colors.dart';
import 'package:flutter_application_7/datamodels/address.dart';
import 'package:flutter_application_7/dataprovider/appdata.dart';
import 'package:flutter_application_7/helper/request_helper.dart';
import 'package:flutter_application_7/prediction/prediction.dart';
import 'package:flutter_application_7/widget/globalvariable.dart';
import 'package:flutter_application_7/widget/progress.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class PredictionTile extends StatelessWidget {
  final prediction prediction1;
  PredictionTile({required this.prediction1});

  void getplacedetails(String placeID, context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProcessDialog('Please Wait...'),
    );
    String url =
        ' https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapkey';
    var response = await RequestHelper.getRequest(url);
    Navigator.pop(context);
    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeId = placeID;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.longitude = response['result']['geometry']['location']['lng'];

      Provider.of<appdata>(context, listen: false)
          .updateDestinationAddress(thisPlace);
      print(thisPlace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getplacedetails(prediction1.placeId.toString(), context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_city_outlined,
                  color: BrandColors.colorDimText,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction1.mainText.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        prediction1.secondtypetext.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            fontSize: 16, color: BrandColors.colorDimText),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

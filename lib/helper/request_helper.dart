import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest(String url) async {
    try {
      http.Response response = await http.get(url as Uri);
      if (response.statusCode == 200) {
        String data = response.body;
        var decodeddata = jsonEncode(data);
        return decodeddata;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }
}

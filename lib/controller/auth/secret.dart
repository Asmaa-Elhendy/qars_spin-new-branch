import 'dart:convert';

import '../const/base_url.dart';
import 'package:http/http.dart' as http;

String ourSecret = "";


settings()async{
  final uri = Uri.parse(
    "$base_url/GlobalApi.asmx/GetAppSettings",
  );
  final response = await http.get(uri);
  if (response.statusCode == 200) {

    final body = jsonDecode(response.body);
    ourSecret = body["Data"][2]["Parameter_Value"];
    print(ourSecret);

  }

}
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future sign_up(Map<String, dynamic> request) async {
  final httpRequest = await http.post(
    Uri.parse("${dotenv.env["API_URL"]}/signup"),
    headers: <String, String> {
      "accept": "application/json",
      "content-type": "application/json; charset=UTF-8",
      "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}"
    },
    body: jsonEncode(request)
  );

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic> {
    "status": httpRequest.statusCode,
    ...response
  };
}
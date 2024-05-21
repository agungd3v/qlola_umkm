import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:qlola_umkm/providers/auth_provider.dart';

final auth_provider = AuthProvider();

Future sign_up(Map<String, dynamic> request) async {
  final httpRequest = await http.post(
    Uri.parse("${dotenv.env["API_URL"]}/signup"),
    headers: <String, String> {
      "ACCEPT": "application/json",
      "CONTENT-TYPE": "application/json; charset=UTF-8",
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

Future sign_in(Map<String, dynamic> request) async {
  final httpRequest = await http.post(
    Uri.parse("${dotenv.env["API_URL"]}/signin"),
    headers: <String, String> {
      "ACCEPT": "application/json",
      "CONTENT-TYPE": "application/json; charset=UTF-8",
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

Future sign_out() async {
  final httpRequest = await http.post(
    Uri.parse("${dotenv.env["API_URL"]}/logout"),
    headers: <String, String> {
      "ACCEPT": "application/json",
      "CONTENT-TYPE": "application/json; charset=UTF-8",
      "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
      "AUTHORIZATION": "Bearer ${auth_provider.token}"
    }
  );

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic> {
    "status": httpRequest.statusCode,
    ...response
  };
}

Future add_product(Map<String, dynamic> request) async {
  final requestSend = http.MultipartRequest("POST", Uri.parse("${dotenv.env["API_URL"]}/product"));
  requestSend.headers.addAll(<String, String> {
    "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
    "AUTHORIZATION": "Bearer ${auth_provider.token}"
  });
  requestSend.fields.addAll(<String, String> {
    "product_name": request["product_name"],
    "product_price": request["product_price"],
    "product_favorite": "0"
  });
  requestSend.files.add(await http.MultipartFile.fromPath("product_image", request["product_image"]));

  final httpRequest = await requestSend.send();
  final response = await http.Response.fromStream(httpRequest);

  return <String, dynamic> {
    "status": response.statusCode,
    ...json.decode(response.body)
  };
}

Future get_product() async {
  final httpRequest = await http.get(
    Uri.parse("${dotenv.env["API_URL"]}/product"),
    headers: <String, String> {
      "ACCEPT": "application/json",
      "CONTENT-TYPE": "application/json; charset=UTF-8",
      "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
      "AUTHORIZATION": "Bearer ${auth_provider.token}"
    }
  );

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic> {
    "status": httpRequest.statusCode,
    ...response
  }; 
}

Future add_employee(Map<String, dynamic> request) async {
  final requestSend = http.MultipartRequest("POST", Uri.parse("${dotenv.env["API_URL"]}/employee"));
  requestSend.headers.addAll(<String, String> {
    "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
    "AUTHORIZATION": "Bearer ${auth_provider.token}"
  });
  requestSend.fields.addAll(<String, String> {
    "name": request["name"],
    "phone": request["phone"]
  });
  requestSend.files.add(await http.MultipartFile.fromPath("photo", request["photo"]));

  final httpRequest = await requestSend.send();
  final response = await http.Response.fromStream(httpRequest);

  return <String, dynamic> {
    "status": response.statusCode,
    ...json.decode(response.body)
  };
}

Future get_employee() async {
  final httpRequest = await http.get(
    Uri.parse("${dotenv.env["API_URL"]}/employee"),
    headers: <String, String> {
      "ACCEPT": "application/json",
      "CONTENT-TYPE": "application/json; charset=UTF-8",
      "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
      "AUTHORIZATION": "Bearer ${auth_provider.token}"
    }
  );

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic> {
    "status": httpRequest.statusCode,
    ...response
  }; 
}

Future get_outlet_product() async {
  final httpRequest = await http.get(
    Uri.parse("${dotenv.env["API_URL"]}/outlet/product"),
    headers: <String, String> {
      "ACCEPT": "application/json",
      "CONTENT-TYPE": "application/json; charset=UTF-8",
      "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
      "AUTHORIZATION": "Bearer ${auth_provider.token}"
    }
  );

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic> {
    "status": httpRequest.statusCode,
    ...response
  }; 
}
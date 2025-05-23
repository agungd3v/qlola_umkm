import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:qlola_umkm/providers/auth_provider.dart';

final auth_provider = AuthProvider();

Future test_api() async {
  final httpRequest = await http
      .get(Uri.parse("${dotenv.env["API_URL"]}"), headers: <String, String>{
    "ACCEPT": "application/json",
    "CONTENT-TYPE": "application/json; charset=UTF-8",
    "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
  });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future check_user() async {
  final httpRequest = await http.get(
      Uri.parse("${dotenv.env["API_URL"]}/check"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future sign_up(Map<String, dynamic> request) async {
  final httpRequest =
      await http.post(Uri.parse("${dotenv.env["API_URL"]}/signup"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}"
          },
          body: jsonEncode(request));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future sign_in(Map<String, dynamic> request) async {
  final httpRequest =
      await http.post(Uri.parse("${dotenv.env["API_URL"]}/signin"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}"
          },
          body: jsonEncode(request));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future sign_out() async {
  final httpRequest = await http.post(
      Uri.parse("${dotenv.env["API_URL"]}/logout"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future add_product(Map<String, dynamic> request) async {
  final requestSend = http.MultipartRequest(
      "POST", Uri.parse("${dotenv.env["API_URL"]}/product"));

  requestSend.headers.addAll(<String, String>{
    "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
    "AUTHORIZATION": "Bearer ${auth_provider.token}"
  });

  requestSend.fields.addAll(<String, String>{
    "product_name": request["product_name"],
    "product_price": request["product_price"],
    "product_favorite": "0"
  });
  if (request["product_image"] != null) {
    requestSend.files.add(await http.MultipartFile.fromPath(
        "product_image", request["product_image"]));
  }

  final httpRequest = await requestSend.send();
  final response = await http.Response.fromStream(httpRequest);

  return <String, dynamic>{
    "status": response.statusCode,
    ...json.decode(response.body)
  };
}

Future update_product(Map<String, dynamic> request) async {
  final httpRequest =
      await http.put(Uri.parse("${dotenv.env["API_URL"]}/product"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
            "AUTHORIZATION": "Bearer ${auth_provider.token}"
          },
          body: jsonEncode(request));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future get_product() async {
  final httpRequest = await http.get(
      Uri.parse("${dotenv.env["API_URL"]}/product"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future add_employee(Map<String, dynamic> request) async {
  final requestSend = http.MultipartRequest(
      "POST", Uri.parse("${dotenv.env["API_URL"]}/employee"));

  requestSend.headers.addAll(<String, String>{
    "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
    "AUTHORIZATION": "Bearer ${auth_provider.token}"
  });

  requestSend.fields.addAll(
      <String, String>{"name": request["name"], "phone": request["phone"]});
  if (request["photo"] != null) {
    requestSend.files
        .add(await http.MultipartFile.fromPath("photo", request["photo"]));
  }

  final httpRequest = await requestSend.send();
  final response = await http.Response.fromStream(httpRequest);

  return <String, dynamic>{
    "status": response.statusCode,
    ...json.decode(response.body)
  };
}

Future add_mitra(Map<String, dynamic> request) async {
  final requestSend = http.MultipartRequest(
      "POST", Uri.parse("${dotenv.env["API_URL"]}/outlet/add-mitra"));

  requestSend.headers.addAll(<String, String>{
    "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
    "AUTHORIZATION": "Bearer ${auth_provider.token}"
  });

  requestSend.fields.addAll(<String, String>{
    "name": request["name"],
    "phone": request["phone"],
    "email": request["email"],
    "owner_id": request["owner_id"],
    "business_id": request["business_id"]
  });
  if (request["photo"] != null) {
    requestSend.files
        .add(await http.MultipartFile.fromPath("photo", request["photo"]));
  }

  final httpRequest = await requestSend.send();
  final response = await http.Response.fromStream(httpRequest);

  return <String, dynamic>{
    "status": response.statusCode,
    ...json.decode(response.body)
  };
}

Future get_employee() async {
  final httpRequest = await http.get(
      Uri.parse("${dotenv.env["API_URL"]}/employee"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future get_outlet() async {
  final httpRequest = await http.get(
      Uri.parse("${dotenv.env["API_URL"]}/outlet"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future add_outlet(Map<String, dynamic> request) async {
  final requestSend = http.MultipartRequest(
      "POST", Uri.parse("${dotenv.env["API_URL"]}/outlet"));
  requestSend.headers.addAll(<String, String>{
    "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
    "AUTHORIZATION": "Bearer ${auth_provider.token}"
  });
  requestSend.fields.addAll(<String, String>{
    "outlet_name": request["outlet_name"],
    "outlet_phone": request["outlet_phone"],
    "outlet_address": request["outlet_address"]
  });

  final httpRequest = await requestSend.send();
  final response = await http.Response.fromStream(httpRequest);

  return <String, dynamic>{
    "status": response.statusCode,
    ...json.decode(response.body)
  };
}

Future proses_checkout(Map<String, dynamic> request) async {
  final httpRequest =
      await http.post(Uri.parse("${dotenv.env["API_URL"]}/order/transaction"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
            "AUTHORIZATION": "Bearer ${auth_provider.token}"
          },
          body: jsonEncode(request));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future owner_transaction() async {
  final httpRequest = await http.get(
      Uri.parse("${dotenv.env["API_URL"]}/transaction/owner"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future outlet_transaction() async {
  try {
    final httpRequest = await http.get(
        Uri.parse("${dotenv.env["API_URL"]}/transaction/outlet"),
        headers: <String, String>{
          "ACCEPT": "application/json",
          "CONTENT-TYPE": "application/json; charset=UTF-8",
          "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
          "AUTHORIZATION": "Bearer ${auth_provider.token}"
        }).timeout(Duration(seconds: 5));

    Map<String, dynamic> response = json.decode(httpRequest.body);

    return <String, dynamic>{"status": httpRequest.statusCode, ...response};
  } on TimeoutException catch (e) {
    return <String, dynamic>{
      "status": 400,
      "message": "Request timeout, kemungkinan koneksimu mengalami pelemahan"
    };
  } on SocketException catch (e) {
    return <String, dynamic>{
      "status": 400,
      "message": "Tidak ada koneksi internet"
    };
  }
}

Future get_available_employees() async {
  final httpRequest = await http.get(
      Uri.parse("${dotenv.env["API_URL"]}/outlet/employees"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future get_outlet_employees(int param) async {
  final httpRequest = await http.get(
      Uri.parse("${dotenv.env["API_URL"]}/outlet/employees/$param"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future add_outlet_employees(Map<String, dynamic> request) async {
  final httpRequest =
      await http.post(Uri.parse("${dotenv.env["API_URL"]}/outlet/add-employee"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
            "AUTHORIZATION": "Bearer ${auth_provider.token}"
          },
          body: jsonEncode(request));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future get_outlet_products(int param) async {
  final httpRequest = await http.get(
      Uri.parse("${dotenv.env["API_URL"]}/outlet/products/$param"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      });

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future add_outlet_products(Map<String, dynamic> request) async {
  final httpRequest =
      await http.post(Uri.parse("${dotenv.env["API_URL"]}/outlet/add-product"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
            "AUTHORIZATION": "Bearer ${auth_provider.token}"
          },
          body: jsonEncode(request));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future get_available_products(Map<String, dynamic> request) async {
  final httpRequest =
      await http.post(Uri.parse("${dotenv.env["API_URL"]}/outlet/products"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
            "AUTHORIZATION": "Bearer ${auth_provider.token}"
          },
          body: jsonEncode(request));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future get_report_owner(Map<String, dynamic> request) async {
  final httpRequest =
      await http.post(Uri.parse("${dotenv.env["API_URL"]}/report/quick"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
            "AUTHORIZATION": "Bearer ${auth_provider.token}"
          },
          body: jsonEncode(request));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future bulk_checkout(Map<String, dynamic> request) async {
  try {
    final httpRequest = await http.post(
        Uri.parse("${dotenv.env["API_URL"]}/order/transaction/bulk"),
        headers: <String, String>{
          "ACCEPT": "application/json",
          "CONTENT-TYPE": "application/json; charset=UTF-8",
          "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
          "AUTHORIZATION": "Bearer ${auth_provider.token}"
        },
        body: jsonEncode(request));

    Map<String, dynamic> response = json.decode(httpRequest.body);

    return <String, dynamic>{"status": httpRequest.statusCode, ...response};
  } on TimeoutException catch (e) {
    return <String, dynamic>{
      "status": 400,
      "message": "Request timeout, kemungkinan koneksimu mengalami pelemahan"
    };
  } on SocketException catch (e) {
    return <String, dynamic>{
      "status": 400,
      "message": "Tidak ada koneksi internet"
    };
  }
}

Future search_transaction(String request) async {
  final httpRequest =
      await http.post(Uri.parse("${dotenv.env["API_URL"]}/transaction/check"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
            "AUTHORIZATION": "Bearer ${auth_provider.token}"
          },
          body: jsonEncode({"code": request}));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future delete_transaction(int request) async {
  final httpRequest = await http.delete(
      Uri.parse("${dotenv.env["API_URL"]}/transaction/delete"),
      headers: <String, String>{
        "ACCEPT": "application/json",
        "CONTENT-TYPE": "application/json; charset=UTF-8",
        "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
        "AUTHORIZATION": "Bearer ${auth_provider.token}"
      },
      body: jsonEncode({"id": request}));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

Future delete_item_transaction(dynamic request) async {
  final httpRequest =
      await http.delete(Uri.parse("${dotenv.env["API_URL"]}/transaction/item"),
          headers: <String, String>{
            "ACCEPT": "application/json",
            "CONTENT-TYPE": "application/json; charset=UTF-8",
            "X-REQUEST-QLOLA-UMKM-MOBILE": "${dotenv.env["APP_KEY"]}",
            "AUTHORIZATION": "Bearer ${auth_provider.token}"
          },
          body: jsonEncode(request));

  Map<String, dynamic> response = json.decode(httpRequest.body);

  return <String, dynamic>{"status": httpRequest.statusCode, ...response};
}

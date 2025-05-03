import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: dotenv.env['API_URL'] ?? '',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    headers: {
      "ACCEPT": "application/json",
      "CONTENT-TYPE": "application/json; charset=UTF-8",
      "X-REQUEST-QLOLA-UMKM-MOBILE": dotenv.env["APP_KEY"]
    },
  ))
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
    ));
}

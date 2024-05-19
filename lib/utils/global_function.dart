import 'package:intl/intl.dart';

String transformPrice(num price) {
  final transform = NumberFormat.currency(
    locale: "id_ID",
    symbol: "Rp ",
    decimalDigits: 0
  ).format(price);

  return transform;
}
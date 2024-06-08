import 'package:intl/intl.dart';

String transformPrice(num price) {
  final transform = NumberFormat.currency(
    locale: "id_ID",
    symbol: "Rp ",
    decimalDigits: 0
  ).format(price);

  return transform;
}

String transformDate(String dateString) {
  // final newDate = dateString.substring(0, 10) + " " + dateString.substring(11, 23);
  DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(dateString).toLocal();
  var date = DateFormat("dd").format(dateTime);
  var month = DateFormat("MMMM").format(dateTime);
  var year = DateFormat("yyyy").format(dateTime);
  var time = DateFormat("hh:mm").format(dateTime);

  if (month == "January") month = "Januari";
  if (month == "February") month = "Februari";
  if (month == "March") month = "Maret";
  if (month == "April") month = "April";
  if (month == "May") month = "Mei";
  if (month == "June") month = "Juni";
  if (month == "July") month = "Juli";
  if (month == "August") month = "Agustus";
  if (month == "September") month = "September";
  if (month == "October") month = "Oktober";
  if (month == "November") month = "November";
  if (month == "December") month = "Desember";

  return "$date $month $year $time";
}

String getThisMonth() {
  DateTime dateTime = DateTime.now();
  var month = DateFormat("MMMM").format(dateTime);
  var year = DateFormat("yyyy").format(dateTime);

  if (month == "January") month = "Januari";
  if (month == "February") month = "Februari";
  if (month == "March") month = "Maret";
  if (month == "April") month = "April";
  if (month == "May") month = "Mei";
  if (month == "June") month = "Juni";
  if (month == "July") month = "Juli";
  if (month == "August") month = "Agustus";
  if (month == "September") month = "September";
  if (month == "October") month = "Oktober";
  if (month == "November") month = "November";
  if (month == "December") month = "Desember";

  return "$month $year";
}

String getDateTimeNow({bool isRequest = false}) {
  DateTime dateTime = DateTime.now();
  var date = DateFormat("dd").format(dateTime);
  var month = DateFormat("MMMM").format(dateTime);
  var year = DateFormat("yyyy").format(dateTime);
  var time = DateFormat("HH:mm").format(dateTime);

  if (!isRequest) {
    if (month == "January") month = "Jan";
    if (month == "February") month = "Feb";
    if (month == "March") month = "Mar";
    if (month == "April") month = "Apr";
    if (month == "May") month = "Mei";
    if (month == "June") month = "Jun";
    if (month == "July") month = "Jul";
    if (month == "August") month = "Agu";
    if (month == "September") month = "Sep";
    if (month == "October") month = "Okt";
    if (month == "November") month = "Nov";
    if (month == "December") month = "Des";
  } else {
    month = DateFormat("MM").format(dateTime);
  }

  return !isRequest ? "$date $month $year, $time" : "$year-$month-$date $time:00";
}

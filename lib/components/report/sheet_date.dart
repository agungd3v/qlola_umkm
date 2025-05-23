import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';

class SheetDate extends StatefulWidget {
  const SheetDate({super.key});

  @override
  State<SheetDate> createState() => _SheetDateState();
}

class _SheetDateState extends State<SheetDate> {
  OwnerProvider? owner_provider;

  List listDates = [
    "Hari ini",
    "1 Bulan",
    "3 Bulan",
    "6 Bulan",
    "1 Tahun",
    "Custom"
  ];
  String selectedDate = "";
  Map<String, String> range = {"from": "", "to": ""};

  void _changeSelectedDate(String param) {
    DateTime date = DateTime.now();

    setState(() {
      if (param == "Custom") {
        range = {"from": "", "to": ""};
      }
      if (param == "Hari ini") {
        range = {
          "from": date.toString().split(" ")[0],
          "to": DateTime(date.year, date.month, date.day + 1)
              .toString()
              .split(" ")[0]
        };
      }
      if (param == "1 Bulan") {
        range = {
          "from": DateTime(date.year, date.month - 1, date.day)
              .toString()
              .split(" ")[0],
          "to": DateTime(date.year, date.month, date.day + 1)
              .toString()
              .split(" ")[0]
        };
      }
      if (param == "3 Bulan") {
        range = {
          "from": DateTime(date.year, date.month - 3, date.day)
              .toString()
              .split(" ")[0],
          "to": DateTime(date.year, date.month, date.day + 1)
              .toString()
              .split(" ")[0]
        };
      }
      if (param == "6 Bulan") {
        range = {
          "from": DateTime(date.year, date.month - 6, date.day)
              .toString()
              .split(" ")[0],
          "to": DateTime(date.year, date.month, date.day + 1)
              .toString()
              .split(" ")[0]
        };
      }
      if (param == "1 Tahun") {
        range = {
          "from": DateTime(date.year - 1, date.month, date.day)
              .toString()
              .split(" ")[0],
          "to": DateTime(date.year, date.month, date.day + 1)
              .toString()
              .split(" ")[0]
        };
      }

      selectedDate = param;
    });
  }

  Future _applyDate() async {
    if (range["from"] == "" && range["to"] == "") {
      return Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 3),
        reverseAnimationCurve: Curves.fastOutSlowIn,
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text("Laporan Penjualan",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 12)),
        messageText: Text("Date tidak boleh kosong",
            style: TextStyle(
                fontFamily: "Poppins", color: Colors.white, fontSize: 12)),
      ).show(context);
    }

    owner_provider!.set_report_date = {
      "id": selectedDate == "Custom" ? "custom" : "",
      "label": selectedDate == "Custom"
          ? "${range["from"]} / ${range["to"]}"
          : selectedDate,
      "value": "${range["from"]} - ${range["to"]}"
    };

    return Navigator.pop(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      final firstLabel = owner_provider!.reportDate["label"].toString();

      setState(() {
        selectedDate = firstLabel.split("/").length > 1 ? "Custom" : firstLabel;
        range = {
          "from":
              owner_provider!.reportDate["value"].toString().split(" - ")[0],
          "to": owner_provider!.reportDate["value"].toString().split(" - ")[1]
        };
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    owner_provider = Provider.of<OwnerProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double contentMaxWidth = maxWidth > 850 ? 800 : maxWidth * 0.95;

            int gridCount = maxWidth > 1000
                ? 4
                : maxWidth > 700
                    ? 3
                    : 2;

            return Center(
              child: Container(
                width: contentMaxWidth,
                child: Column(
                  children: [
                    // Handle kecil di atas (drag indicator)
                    Container(
                      width: 40,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(99)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Grid tanggal
                    GridView.count(
                      crossAxisCount: gridCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 16 / 5,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: listDates.map((item) {
                        bool isSelected = item == selectedDate;
                        return GestureDetector(
                          onTap: () => _changeSelectedDate(item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: isSelected
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2)
                                  : Colors.white,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).primaryColorDark,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // Custom range jika dipilih
                    if (selectedDate == "Custom") ...[
                      const SizedBox(height: 16),
                      CustomDateRange(),
                    ],

                    const SizedBox(height: 20),

                    // Tombol Simpan dan Cancel (bersebelahan)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Tombol rapat ke kiri dan kanan
                        children: [
                          // Tombol Simpan
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _applyDate(),
                              icon: const Icon(Icons.save,
                                  size: 18, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                minimumSize: const Size(
                                    150, 50), // Tombol tetap lebih besar
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                              ),
                              label: const Text(
                                "Simpan",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Jarak antar tombol
                          // Tombol Cancel
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(
                                    150, 50), // Tombol tetap lebih besar
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget CustomDateRange() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: Row(children: [
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    showDatePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2024).add(Duration(days: 365 * 5)),
                        initialDate: range["from"] == ""
                            ? DateTime.now()
                            : DateFormat("yyyy-MM-dd").parse(range["from"]!),
                        locale: Locale("id", "ID"),
                        confirmText: "Simpan",
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        builder: (context, child) => Theme(
                              data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: Colors.white,
                                    onPrimary: Theme.of(context).primaryColor,
                                    surface: Theme.of(context).primaryColor,
                                    onSurface: Colors.white,
                                  ),
                                  datePickerTheme: DatePickerThemeData(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      headerHelpStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      headerHeadlineStyle: TextStyle(
                                          fontFamily: "Poppins", fontSize: 30),
                                      dayStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      yearStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      weekdayStyle: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                      rangePickerHeaderHelpStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      rangePickerHeaderHeadlineStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      cancelButtonStyle: ButtonStyle(
                                          textStyle: WidgetStateProperty.resolveWith(
                                              (callback) => TextStyle(
                                                  fontFamily: "Poppins"))),
                                      confirmButtonStyle: ButtonStyle(
                                          textStyle: WidgetStateProperty.resolveWith(
                                              (callback) => TextStyle(fontFamily: "Poppins"))))),
                              child: child!,
                            )).then((selectedDate) {
                      if (selectedDate != null) {
                        String selected = selectedDate.toString();
                        setState(() => range["from"] = selected.split(" ")[0]);
                      } else {
                        setState(() => range["from"] = "");
                      }
                    });
                  },
                  child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.6)),
                      child: Row(children: [
                        Image.asset("assets/icons/calendar_outline.png",
                            width: 18, height: 18),
                        const SizedBox(width: 5),
                        Text(
                            range["from"] != ""
                                ? range["from"].toString()
                                : "Start Date",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Theme.of(context).disabledColor,
                                fontSize: 12))
                      ])))),
          const SizedBox(width: 10),
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    showDatePicker(
                        context: context,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2024).add(Duration(days: 365 * 5)),
                        initialDate: range["to"] == ""
                            ? DateTime.now()
                            : DateFormat("yyyy-MM-dd").parse(range["to"]!),
                        locale: Locale("id", "ID"),
                        confirmText: "Simpan",
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        builder: (context, child) => Theme(
                              data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: Colors.white,
                                    onPrimary: Theme.of(context).primaryColor,
                                    surface: Theme.of(context).primaryColor,
                                    onSurface: Colors.white,
                                  ),
                                  datePickerTheme: DatePickerThemeData(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      headerHelpStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      headerHeadlineStyle: TextStyle(
                                          fontFamily: "Poppins", fontSize: 30),
                                      dayStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      yearStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      weekdayStyle: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                      rangePickerHeaderHelpStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      rangePickerHeaderHeadlineStyle:
                                          TextStyle(fontFamily: "Poppins"),
                                      cancelButtonStyle: ButtonStyle(
                                          textStyle: WidgetStateProperty.resolveWith(
                                              (callback) => TextStyle(
                                                  fontFamily: "Poppins"))),
                                      confirmButtonStyle: ButtonStyle(
                                          textStyle: WidgetStateProperty.resolveWith(
                                              (callback) => TextStyle(fontFamily: "Poppins"))))),
                              child: child!,
                            )).then((selectedDate) {
                      if (selectedDate != null) {
                        String selected = selectedDate.toString();
                        setState(() => range["to"] = selected.split(" ")[0]);
                      } else {
                        setState(() => range["to"] = "");
                      }
                    });
                  },
                  child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.6)),
                      child: Row(children: [
                        Image.asset("assets/icons/calendar_outline.png",
                            width: 18, height: 18),
                        const SizedBox(width: 5),
                        Text(
                            range["to"] != ""
                                ? range["to"].toString()
                                : "End Date",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Theme.of(context).disabledColor,
                                fontSize: 12))
                      ]))))
        ]));
  }
}

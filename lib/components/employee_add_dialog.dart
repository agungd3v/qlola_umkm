import 'package:flutter/material.dart';
import 'package:qlola_umkm/api/request.dart';

class EmployeeAddDialog extends StatefulWidget {
  EmployeeAddDialog({super.key});

  @override
  State<EmployeeAddDialog> createState() => _EmployeeAddDialogState();
}

class _EmployeeAddDialogState extends State<EmployeeAddDialog> {
  List employeeDump = [];

  Future getEmployee() async {
    final httpRequest = await get_employee();
    if (httpRequest["status"] == 200) {
      setState(() {
        employeeDump = httpRequest["data"].map((data) {
          return {...data, "checked": false};
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      title: Text(
        "Daftar Karyawan",
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColorDark,
          fontSize: 16
        )
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (employeeDump.isEmpty) Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(
              "Tidak ada karyawan satupun tersedia di bisnis anda",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                color: Theme.of(context).primaryColorDark,
                fontSize: 12
              )
            )
          ),
          if (employeeDump.isNotEmpty) Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                for (var index = 0; index < employeeDump.length; index++) Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      employeeDump[index]["name"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 12
                      )
                    ),
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: Checkbox(
                        value: employeeDump[index]["checked"],
                        onChanged: (bool? value) {
                          setState(() {
                            employeeDump[index]["checked"] = value;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                        side: BorderSide(
                          width: 1,
                          color: Theme.of(context).dividerColor
                        )
                      )
                    )
                  ]
                )
              ]
            )
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(6))
              ),
              alignment: Alignment.center,
              child: Text(
                "Tambahkan",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 12
                )
              )
            )
          )
        ]
      )
    );
  }
}
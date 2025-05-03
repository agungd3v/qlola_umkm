import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';

class AddEmployeeDialog extends StatefulWidget {
  AddEmployeeDialog({super.key});

  @override
  State<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  OwnerProvider? owner_provider;
  List employeeDump = [];
  bool load = false;

  Future getEmployee() async {
    setState(() => load = true);

    final httpRequest = await get_available_employees();
    if (httpRequest["status"] == 200) {
      setState(() {
        employeeDump = httpRequest["data"].map((data) {
          return {...data, "checked": false};
        }).toList();
      });
    }

    setState(() => load = false);
  }

  Future _tempEmployee() async {
    final employeeChecked = employeeDump.where((data) => data["checked"]).toList();
    for (var i = 0; i < employeeChecked.length; i++) {
      owner_provider!.add_employee = employeeChecked[i];
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getEmployee();
  }

  @override
  Widget build(BuildContext context) {
    owner_provider = Provider.of<OwnerProvider>(context);

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
          if (load) Container(
            padding: const EdgeInsets.only(bottom: 40, top: 20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )
              ]
            )
          ),
          if (!load && employeeDump.isEmpty) Container(
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
          if (!load && employeeDump.isNotEmpty) Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                for (var index = 0; index < employeeDump.length; index++) Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
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
                )
              ]
            )
          ),
          if (!load && employeeDump.isNotEmpty) GestureDetector(
            onTap: () => _tempEmployee(),
            child: Container(
              height: 40,
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
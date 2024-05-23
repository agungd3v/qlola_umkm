import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/components/employee_add_dialog.dart';

class AddOutletEmployeeScreen extends StatefulWidget {
  final dynamic outlet;

  AddOutletEmployeeScreen({super.key,
    required this.outlet
  });

  @override
  State<AddOutletEmployeeScreen> createState() => _AddOutletEmployeeScreenState();
}

class _AddOutletEmployeeScreenState extends State<AddOutletEmployeeScreen> {
  List employees = [];

  final outletName = TextEditingController();
  final outletPhone = TextEditingController();
  final outletAddress = TextEditingController();

  Future<void> _addEmployee() async {
    // final Map<String, dynamic> data = {
    //   "outlet_name": outletName.text,
    //   "outlet_phone": "+62${outletPhone.text}",
    //   "outlet_address": outletAddress.text
    //   // "outlet_image": imagePath
    // };

    // final httpRequest = await add_outlet(data);
    // if (httpRequest["status"] == 200) {
    //   Navigator.pop(context);
    // }
  }

  void _showListEmployee () {
    showDialog(
      context: context,
      builder: (context) => EmployeeAddDialog()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark
          )
        )
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
                  )
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset("assets/icons/arrow_back_gray.png", width: 16, height: 16)
                      )
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.outlet["outlet_name"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark
                      )
                    ),
                  ]
                )
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _showListEmployee(),
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: Text(
                      "Tambah Karyawan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 10
                      )
                    )
                  )
                )
              ),
              Expanded(child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // 
                    const SizedBox(height: 20)
                  ]
                )
              )),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    // _addoutlet();
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      )
                    )
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}
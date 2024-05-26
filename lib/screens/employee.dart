import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/employee/employee_item.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List employees = [];

  void _getEmployee() async {
    final httpRequest = await get_employee();
    if (httpRequest["status"] == 200) {
      setState(() {
        employees = httpRequest["data"];
      });
    }
  }

  Widget _notEmptyData(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            for (var index = 0; index < employees.length; index++) EmployeeItem(
              employee: employees[index],
              index: index
            )
          ]
        )
      )
    );
  }

  Widget _emptyData(BoxConstraints constraints) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/employee_empty.png", width: 400, height: 200, fit: BoxFit.contain),
              Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Belum ada Pegawai",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark
                    )
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 320,
                    child: Text(
                      'Tekan "Icon Plus" untuk menambahkan pegawai',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 12
                      )
                    )
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _getEmployee();
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: employees.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kelola Pegawai",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColorDark
                          )
                        ),
                        Text(
                          "Kelola semua pegawai kamu di sini.",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).disabledColor,
                            fontSize: 11
                          )
                        )
                      ]
                    ))
                  ]
                )
              ),
              Container(
                height: 10,
                color: Theme.of(context).dividerColor.withOpacity(0.5),
              ),
              Expanded(child: LayoutBuilder(builder: (context, constraints) => RefreshIndicator(
                color: Theme.of(context).indicatorColor,
                onRefresh: () => Future.delayed(Duration(seconds: 1), () => _getEmployee()),
                child: employees.isEmpty ? _emptyData(constraints) : _notEmptyData(constraints)
              )))
            ]
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => context.pushNamed("Add Employee"),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).disabledColor,
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(1, 2)
                    )
                  ]
                ),
                child: Center(
                  child: Image.asset("assets/icons/plus_white.png", width: 25, height: 25)
                )
              )
            )
          )
        ]
      )
    );
  }
}
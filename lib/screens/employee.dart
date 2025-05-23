import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/employee/employee_item.dart';
import 'package:qlola_umkm/screens/add_employee.dart'; // Import the EmployeeItem

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List employees = [];
  bool loading = true;

  // Fetch employees from the API
  void _getEmployee() async {
    setState(() {
      loading = true;
    });

    final httpRequest = await get_employee();
    if (httpRequest["status"] == 200) {
      setState(() {
        employees = httpRequest["data"];
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getEmployee(); // Call to fetch employee data when screen is initialized
  }

  // Navigate to AddEmployeeScreen and listen for a result
  Future<void> _navigateToAddEmployee() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
    );

    // If result is true, refresh the employee list
    if (result == true) {
      _getEmployee();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "Kelola Pegawai",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 22, // Ukuran font lebih kecil agar lebih proporsional
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: employees.isNotEmpty
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kelola Pegawai",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        fontSize: 20, // Ukuran font lebih kecil
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Kelola semua pegawai kamu di sini.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).disabledColor,
                        fontSize: 12, // Ukuran font yang lebih kecil
                      ),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(
                height: 8,
                color: Theme.of(context).dividerColor.withOpacity(0.3),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => RefreshIndicator(
                    color: Theme.of(context).indicatorColor,
                    onRefresh: () => Future.delayed(
                      const Duration(seconds: 1),
                      () => _getEmployee(),
                    ),
                    child: loading
                        ? Center(
                            child:
                                CircularProgressIndicator()) // Show loading spinner
                        : employees.isEmpty
                            ? _emptyData(constraints)
                            : _notEmptyData(constraints),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: _navigateToAddEmployee, // Navigate to add employee page
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
                          blurRadius: 8,
                          offset: const Offset(1, 2))
                    ]),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for showing employees when data is available
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
            for (var index = 0; index < employees.length; index++)
              EmployeeItem(
                  employee: employees[index],
                  index: index) // Pass employee data and index
          ],
        ),
      ),
    );
  }

  // Widget for showing an empty state when no employees are available
  Widget _emptyData(BoxConstraints constraints) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/employee_empty.png",
                  width: 200, height: 150, fit: BoxFit.contain),
              Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Belum ada Pegawai",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 320,
                    child: Text(
                      'Tekan tombol "Tambah Pegawai" untuk menambahkan pegawai baru.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

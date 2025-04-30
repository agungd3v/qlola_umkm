import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/database/database_helper.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ButtonSyncData extends StatefulWidget {
  const ButtonSyncData({super.key});

  @override
  State<ButtonSyncData> createState() => _ButtonSyncDataState();
}

class _ButtonSyncDataState extends State<ButtonSyncData>
    with SingleTickerProviderStateMixin {
  AuthProvider? auth_provider;

  final databaseHelper = DatabaseHelper.instance;
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));
  bool proccess = false;
  bool isConnected = true;

  Future<void> _syncData(BuildContext context) async {
    _controller.repeat();
    setState(() => proccess = true);

    final database = await databaseHelper.database;
    final rawQuery = await database?.rawQuery("SELECT * FROM orders");
    final data = rawQuery?.asMap().values.toList();
    final batches =
        groupBy(data as Iterable<Map>, (Map obj) => obj["_transaction"]);

    if (batches.isNotEmpty && auth_provider?.user != null) {
      final httpRequest = await bulk_checkout(<String, dynamic>{
        "business_id": num.parse(
          auth_provider!.user["outlet"]["business_id"].toString(),
        ),
        "data": batches
      });

      if (httpRequest["status"] == 200) {
        successMessage(context, "Pemberitahuan", httpRequest["message"]);
        await database?.rawDelete("DELETE FROM orders");
      } else {
        errorMessage(context, "Pemberitahuan", httpRequest["message"]);
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    _controller.reset();
    setState(() => proccess = false);
  }

  Future<void> _checkAndHandleConnection(BuildContext context) async {
    final result = await Connectivity().checkConnectivity();
    final connected = result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi;

    setState(() => isConnected = connected);

    if (connected) {
      _syncData(context);
    } else {
      errorMessage(
        context,
        "Tidak Ada Koneksi",
        "Hello World! Kamu sedang offline.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    auth_provider = Provider.of<AuthProvider>(context);

    return GestureDetector(
        onTap: () => !proccess ? _syncData(context) : {},
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: Image.asset("assets/icons/sync_red.png",
                      width: 45, height: 45));
            }));
  }
}

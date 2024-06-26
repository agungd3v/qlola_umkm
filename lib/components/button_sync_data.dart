import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/database/database_helper.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/utils/flush_message.dart';

class ButtonSyncData extends StatefulWidget {
  const ButtonSyncData({super.key});

  @override
  State<ButtonSyncData> createState() => _ButtonSyncDataState();
}

class _ButtonSyncDataState extends State<ButtonSyncData> with SingleTickerProviderStateMixin {
  AuthProvider? auth_provider;

  final databaseHelper = DatabaseHelper.instance;
  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
  bool proccess = false;

  Future _syncData(BuildContext context) async {
    _controller.repeat();
    setState(() => proccess = true);

    final database = await databaseHelper.database;
    final rawQuery = await database?.rawQuery("SELECT * FROM orders");
    final data = rawQuery?.asMap().values.toList();
    final batches = groupBy(data as Iterable<Map>, (Map obj) => obj["_transaction"]);

    if (batches.isNotEmpty) {
      final httpRequest = await bulk_checkout(<String, dynamic> {
        "business_id": num.parse(auth_provider!.user["outlet"]["business_id"].toString()),
        "data": batches
      });

      if (httpRequest["status"] == 200) {
        successMessage(context, "Pemberitahuan", httpRequest["message"]);
        setState(() => proccess = false);
        _controller.reset();

        await database?.rawDelete("DELETE FROM orders");
        return;
      }

      errorMessage(context, "Pemberitahuan", httpRequest["message"]);
    }

    Future.delayed(const Duration(seconds: 1), () {
      _controller.reset();
      setState(() => proccess = false);
    });
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
            child: Image.asset("assets/icons/sync_red.png", width: 45, height: 45)
          );
        }
      )
    );
  }
}
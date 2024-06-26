import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sizer/sizer.dart';

class EmployeeItem extends StatefulWidget {
  dynamic employee;
  int index;

  EmployeeItem({super.key,
    required this.employee,
    required this.index
  });

  @override
  State<EmployeeItem> createState() => _EmployeeItemState();
}

class _EmployeeItemState extends State<EmployeeItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.network(
            "${dotenv.env["ASSET_URL"]}${widget.employee["photo"]}",
            width: 17.5.w,
            height: 17.5.w,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 17.5.w,
                height: 17.5.w,
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Center(
                  child: Image.asset("assets/icons/profile.png", width: 30, height: 30)
                )
              );
            }
          )
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 17.5.w,
          child: Text(
            widget.employee["name"],
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins",
              color: Theme.of(context).primaryColorDark,
              fontSize: 3.w
            )
          )
        )
      ]
    );
  }
}
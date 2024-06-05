import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';

class ButtonCheckout extends StatefulWidget {
  const ButtonCheckout({super.key});

  @override
  State<ButtonCheckout> createState() => _ButtonCheckoutState();
}

class _ButtonCheckoutState extends State<ButtonCheckout> {
  CheckoutProvider? checkout_provider;

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);

    return GestureDetector(
      onTap: () {
        context.pushNamed("Checkout");
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          // borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Checkout",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 12
              )
            ),
            const SizedBox(width: 8),
            Text(
              "( ${checkout_provider?.carts.length} )",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 12
              )
            )
          ]
        )
      )
    );
  }
}
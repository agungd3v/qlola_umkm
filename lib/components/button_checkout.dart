import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
        context.pushNamed("Employee Checkout");
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
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 14
              )
            ),
            const SizedBox(width: 8),
            Text(
              "( ${checkout_provider?.carts.length} )",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 14
              )
            )
          ]
        )
      )
    );
  }
}
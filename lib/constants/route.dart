import 'package:agent/ui/ben_center.dart';
import 'package:agent/ui/beneficiaries.dart';
import 'package:agent/ui/home.dart';
import 'package:agent/ui/oder_screen.dart';
import 'package:agent/ui/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// Generate all application routes with simple transition
Route<PageController> onGenerateRoute(RouteSettings settings) {
  Route<PageController> page;

  final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;

  switch (settings.name) {
    case "/Home":
      page = PageTransition<PageController>(
        child:const Home(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/Beneficiaries":
      page = PageTransition<PageController>(
        child:const Beneficiaries(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/Beneficiary_Center":
      page = PageTransition<PageController>(
        child:const BeneficiaryCenter(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/Order_Screen":
      page = PageTransition<PageController>(
        child:const OrderScreen(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
          case "/Payment_Screen":
      page = PageTransition<PageController>(
        child:const PaymentScreen(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
  }
  return page;
}

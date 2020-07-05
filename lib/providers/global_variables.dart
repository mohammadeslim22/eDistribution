import 'package:agent/models/ben.dart';
import 'package:flutter/material.dart';

class GlobalVars with ChangeNotifier {
  Beneficiaries beneficiaries;
  Beneficiaries getBeneficiaries() {
    return beneficiaries;
  }

}
 final GlobalVars globalVars = GlobalVars();

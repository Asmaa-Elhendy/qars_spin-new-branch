import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../view/screens/auth/my_account.dart';
import '../../view/widgets/auth_widgets/register_dialog.dart';

unRegisterFunction(context){
  showDialog(
    context: context,
    builder: (_) => RegisterDialog(),
  );;
}
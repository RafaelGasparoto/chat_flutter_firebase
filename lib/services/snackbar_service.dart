import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SnackbarService {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;

  SnackbarService() {
    _navigationService = _getIt.get<NavigationService>();
  }

  void snackBarError({required String message}) => _showSnackBar(message: message, icon: const Icon(Icons.error, color: Colors.redAccent));

  void snackBarWarning({required String message}) => _showSnackBar(message: message, icon: const Icon(Icons.warning, color: Colors.amberAccent));
  
  void snackBarSucess({required String message}) => _showSnackBar(message: message, icon: const Icon(Icons.check, color: Colors.greenAccent));

  void _showSnackBar({required String message, required Icon icon}) {
    DelightToastBar(
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      builder: (context) {
        return ToastCard(
          leading: icon,
          title: Text(message),
        );
      },
    ).show(_navigationService.navigatorKey.currentContext!);
  }
}

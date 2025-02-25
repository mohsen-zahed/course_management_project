import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider with ChangeNotifier {
  bool isChecking = false;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityResult get connectivityResult => _connectivityResult;

  InternetProvider() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _connectivityResult = result[0];
      notifyListeners();
    });
  }
  Future<void> checkConnection() async {
    isChecking = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600), () async {
      List<ConnectivityResult> result = await Connectivity().checkConnectivity();
      _connectivityResult = result[0];
      isChecking = false;
      notifyListeners();
    });
  }

  Future<void> initialize() async {
    // Perform any initial check if needed (e.g., check the current connectivity state)
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    _connectivityResult = result[0];
    notifyListeners();
  }

  bool get isConnected => _connectivityResult != ConnectivityResult.none;
}

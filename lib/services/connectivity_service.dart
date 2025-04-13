// lib/services/connectivity_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker();

  // Check if device has internet connection
  Future<bool> hasInternetConnection() async {
    return await _connectionChecker.hasConnection;
  }

  // Check connectivity status
  Future<ConnectivityResult> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  // Request required permissions
  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  // Stream of connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  // Check if all required permissions are granted
  Future<bool> checkPermissions() async {
    bool locationGranted = await Permission.location.isGranted;
    bool storageGranted = await Permission.storage.isGranted;

    return locationGranted && storageGranted;
  }

  // Check specific permission
  Future<bool> checkSpecificPermission(Permission permission) async {
    return await permission.isGranted;
  }

  // Request specific permission
  Future<bool> requestSpecificPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    return status.isGranted;
  }
}

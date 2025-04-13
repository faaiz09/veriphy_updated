// lib/screens/network_screen.dart
// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rm_veriphy/services/connectivity_service.dart';

class NetworkScreen extends StatefulWidget {
  final Widget child;

  const NetworkScreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _NetworkScreenState createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _connectivityService.hasInternetConnection(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return widget.child;
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/page_down.json',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          },
                          child: const Text('Retry'),
                        ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

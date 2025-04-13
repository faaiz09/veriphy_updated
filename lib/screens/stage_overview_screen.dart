// lib/screens/stage_overview_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/stage_provider.dart';
import 'package:rm_veriphy/widgets/stage/stage_overview_dashboard.dart';

class StageOverviewScreen extends StatelessWidget {
  const StageOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stage Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<StageProvider>().loadStageData();
            },
          ),
        ],
      ),
      body: const StageOverviewDashboard(),
    );
  }
}
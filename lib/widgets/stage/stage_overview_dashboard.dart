// lib/widgets/stage/stage_overview_dashboard.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_veriphy/providers/stage_provider.dart';
// import 'package:rm_veriphy/models/stage/stage_data.dart';
import 'package:rm_veriphy/widgets/stage/stage_chart.dart';
import 'package:rm_veriphy/widgets/stage/stage_summary_card.dart';

class StageOverviewDashboard extends StatefulWidget {
  const StageOverviewDashboard({super.key});

  @override
  State<StageOverviewDashboard> createState() => _StageOverviewDashboardState();
}

class _StageOverviewDashboardState extends State<StageOverviewDashboard> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      context.read<StageProvider>().loadStageData();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StageProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${provider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadStageData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.stageData == null) {
          return const Center(
            child: Text('No stage data available'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stage Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: StageChart(stageData: provider.stageData!),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StageSummaryCard(
                    title: 'JumpStart',
                    count: provider.stageData!.jumpStart,
                    color: Colors.blue,
                    icon: Icons.rocket_launch,
                  ),
                  StageSummaryCard(
                    title: 'In Progress',
                    count: provider.stageData!.inProgress,
                    color: Colors.orange,
                    icon: Icons.trending_up,
                  ),
                  StageSummaryCard(
                    title: 'Review',
                    count: provider.stageData!.review,
                    color: Colors.purple,
                    icon: Icons.rate_review,
                  ),
                  StageSummaryCard(
                    title: 'Approved',
                    count: provider.stageData!.approved,
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                  StageSummaryCard(
                    title: 'Sign & Pay',
                    count: provider.stageData!.signAndPay,
                    color: Colors.red,
                    icon: Icons.paid,
                  ),
                  StageSummaryCard(
                    title: 'Completed',
                    count: provider.stageData!.completed,
                    color: Colors.teal,
                    icon: Icons.task_alt,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
